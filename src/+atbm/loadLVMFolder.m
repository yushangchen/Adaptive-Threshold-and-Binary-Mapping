function D = loadLVMFolder(rawFolder, varargin)
%LOADLVMFOLDER Load and calibrate the original AR4 .lvm measurements.
%
% D = atbm.loadLVMFolder(rawFolder)
% D = atbm.loadLVMFolder(rawFolder, 'SaveTo', 'ATBM_dataset.mat')

p = inputParser;
p.addRequired('rawFolder', @(x)ischar(x) || isstring(x));
p.addParameter('Config', atbm.defaultConfig(), @isstruct);
p.addParameter('CalibrationTable', atbm.defaultCalibrationTable(), @istable);
p.addParameter('ExpectedCases', [], @(x)isnumeric(x) && (isempty(x) || isscalar(x)));
p.addParameter('SaveTo', '', @(x)ischar(x) || isstring(x));
p.addParameter('StrictSampleCount', false, @(x)islogical(x) || isnumeric(x));
p.parse(rawFolder, varargin{:});

cfg = p.Results.Config;
calibration = p.Results.CalibrationTable;
rawFolder = char(rawFolder);

if ~isfolder(rawFolder)
    error('ATBM:FolderNotFound', 'Raw-data folder not found: %s', rawFolder);
end

files = dir(fullfile(rawFolder, cfg.filePattern));
if isempty(files)
    error('ATBM:NoRawFiles', 'No files matching %s were found in %s.', ...
        cfg.filePattern, rawFolder);
end
[~, order] = sort({files.name});
files = files(order);

nCases = numel(files);
expectedCases = p.Results.ExpectedCases;
if isempty(expectedCases)
    expectedCases = cfg.expectedCases;
end
if ~isempty(expectedCases) && nCases ~= expectedCases
    warning('ATBM:CaseCount', ...
        'Found %d files; the original dataset used %d cases.', nCases, expectedCases);
end

first = atbm.readNumericLVM(fullfile(files(1).folder, files(1).name));
if size(first,2) < max(calibration.Channel)
    error('ATBM:ColumnCount', 'Raw files require at least %d columns.', ...
        max(calibration.Channel));
end
nSamples = size(first,1);

D = struct();
D.Cp = struct();
for k = 1:height(calibration)
    D.Cp.(char(calibration.VariableName(k))) = nan(nSamples, nCases);
end
D.tByCase = nan(nSamples, nCases);
D.temperatureC = nan(nSamples, nCases);
D.density = nan(nSamples, nCases);
D.pitotPressure = nan(nSamples, nCases);
D.V_pitot = nan(nSamples, nCases);
D.ReInstantaneous = nan(nSamples, nCases);
D.Re = nan(1, nCases);
D.sourceFiles = strings(1, nCases);

for iCase = 1:nCases
    filePath = fullfile(files(iCase).folder, files(iCase).name);
    A = atbm.readNumericLVM(filePath);

    if size(A,1) ~= nSamples
        if p.Results.StrictSampleCount
            error('ATBM:SampleCount', ...
                'File %s has %d samples; expected %d.', ...
                files(iCase).name, size(A,1), nSamples);
        else
            error('ATBM:SampleCount', ...
                ['All cases must have the same sample count for the standardized ' ...
                 'matrix format. File %s has %d samples; expected %d.'], ...
                files(iCase).name, size(A,1), nSamples);
        end
    end
    if size(A,2) < max(calibration.Channel)
        error('ATBM:ColumnCount', 'File %s has only %d columns.', ...
            files(iCase).name, size(A,2));
    end

    t = A(:, cfg.timeColumn);
    temperatureC = A(:, cfg.temperature.column) .* cfg.temperature.scale;
    temperatureK = temperatureC + 273.15;
    density = cfg.atmosphericPressure ./ temperatureK ./ cfg.airGasConstant;
    pitotPressure = cfg.pitot.slope .* A(:, cfg.pitot.column) + cfg.pitot.offset;

    if any(pitotPressure <= 0)
        warning('ATBM:NonpositivePitot', ...
            'Nonpositive calibrated pitot pressure in %s; affected values become NaN.', ...
            files(iCase).name);
    end

    V = nan(size(pitotPressure));
    validPitot = pitotPressure > 0 & density > 0;
    V(validPitot) = sqrt(2 .* pitotPressure(validPitot) ./ density(validPitot));

    for iCal = 1:height(calibration)
        pressure = calibration.Slope(iCal) .* A(:,calibration.Channel(iCal)) ...
            + calibration.Offset(iCal);
        Cp = pressure ./ pitotPressure;
        Cp(~isfinite(Cp)) = NaN;
        fieldName = char(calibration.VariableName(iCal));
        X = D.Cp.(fieldName);
        X(:,iCase) = Cp;
        D.Cp.(fieldName) = X;
    end

    mu = cfg.sutherlandFactor .* sqrt(temperatureK) ./ ...
        (cfg.sutherlandConstant ./ temperatureK + 1);
    ReInstantaneous = density .* V .* cfg.diameter ./ mu;

    D.tByCase(:,iCase) = t;
    D.temperatureC(:,iCase) = temperatureC;
    D.density(:,iCase) = density;
    D.pitotPressure(:,iCase) = pitotPressure;
    D.V_pitot(:,iCase) = V;
    D.ReInstantaneous(:,iCase) = ReInstantaneous;
    D.Re(iCase) = mean(ReInstantaneous, 'omitnan');
    D.sourceFiles(iCase) = string(files(iCase).name);
end

D.t = D.tByCase(:,1);
if numel(D.t) > 1
    dt = median(diff(D.t), 'omitnan');
    if isfinite(dt) && dt > 0
        D.Fs = 1/dt;
    else
        D.Fs = cfg.Fs;
    end
else
    D.Fs = cfg.Fs;
end
D.R = round(D.Re ./ 1e5, 2);
D.tapTable = atbm.defaultTapTable();
D.calibrationTable = calibration;
D.config = cfg;
D.meta = struct();
D.meta.rawFolder = string(rawFolder);
D.meta.sourceFiles = D.sourceFiles;
D.meta.created = string(datetime('now','Format','yyyy-MM-dd HH:mm:ss'));
D.meta.notes = "Calibrated using constants reconstructed from newatbm.m";
D = atbm.standardizeDataset(D);

saveTo = char(p.Results.SaveTo);
if ~isempty(saveTo)
    saveFolder = fileparts(saveTo);
    if ~isempty(saveFolder) && ~isfolder(saveFolder)
        mkdir(saveFolder);
    end
    save(saveTo, 'D', '-v7.3');
    fprintf('Saved standardized AT-BM dataset: %s\n', saveTo);
end
end
