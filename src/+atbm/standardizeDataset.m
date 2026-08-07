function D = standardizeDataset(inputData)
%STANDARDIZEDATASET Convert supported data layouts into the AT-BM D structure.

if ischar(inputData) || isstring(inputData)
    loaded = load(char(inputData));
    if isfield(loaded, 'D')
        inputData = loaded.D;
    else
        inputData = loaded;
    end
end

if ~isstruct(inputData)
    error('ATBM:InvalidDataset', 'Dataset input must be a structure or MAT filename.');
end
D = inputData;
tapTable = atbm.defaultTapTable();
tapNames = cellstr(tapTable.VariableName);

if ~isfield(D, 'Cp') || ~isstruct(D.Cp)
    D.Cp = struct();
    foundLegacy = true;
    for k = 1:numel(tapNames)
        name = tapNames{k};
        if isfield(inputData, name)
            D.Cp.(name) = inputData.(name);
        else
            foundLegacy = false;
        end
    end
    baseNames = {'Cpb_1D','Cpb_2D','Cpb_3_5D'};
    for k = 1:numel(baseNames)
        if isfield(inputData, baseNames{k})
            D.Cp.(baseNames{k}) = inputData.(baseNames{k});
        end
    end

    if ~foundLegacy && isfield(inputData, 'Cp') && isnumeric(inputData.Cp)
        CpArray = inputData.Cp;
        if ndims(CpArray) ~= 3
            error('ATBM:InvalidCpArray', 'Numeric Cp must be nSamples x nTaps x nCases.');
        end
        if isfield(inputData, 'tapTable')
            oldTable = inputData.tapTable;
            nameVar = intersect(oldTable.Properties.VariableNames, ...
                {'VariableName','Name','TapName'}, 'stable');
            if isempty(nameVar)
                error('ATBM:TapNamesMissing', 'tapTable does not contain tap names.');
            end
            oldNames = string(oldTable.(nameVar{1}));
        else
            error('ATBM:TapTableMissing', 'Numeric Cp input requires tapTable.');
        end
        for k = 1:numel(oldNames)
            D.Cp.(char(oldNames(k))) = squeeze(CpArray(:,k,:));
        end
    end
end

missing = tapNames(~isfield(D.Cp, tapNames));
if ~isempty(missing)
    error('ATBM:MissingTapVariables', ...
        'Dataset is missing required pressure variables: %s', strjoin(missing, ', '));
end

nSamples = [];
nCases = [];
for k = 1:numel(tapNames)
    X = D.Cp.(tapNames{k});
    if ~isnumeric(X) || ndims(X) ~= 2
        error('ATBM:InvalidTapMatrix', '%s must be a 2-D numeric matrix.', tapNames{k});
    end
    if isempty(nSamples)
        [nSamples,nCases] = size(X);
    elseif ~isequal(size(X), [nSamples,nCases])
        error('ATBM:TapSizeMismatch', 'All tap matrices must have equal size.');
    end
end

D.tapTable = tapTable;
D.tapNames = tapNames;
D.alldata = cell(1, numel(tapNames));
for k = 1:numel(tapNames)
    D.alldata{k} = D.Cp.(tapNames{k});
end

copyFields = {'Re','R','t','Fs','V_pitot','density','temperatureC', ...
    'pitotPressure','ReInstantaneous','tByCase','sourceFiles','meta','config', ...
    'calibrationTable'};
for k = 1:numel(copyFields)
    field = copyFields{k};
    if ~isfield(D, field) && isfield(inputData, field)
        D.(field) = inputData.(field);
    end
end

if ~isfield(D,'Re') || isempty(D.Re)
    D.Re = nan(1,nCases);
end
D.Re = reshape(D.Re,1,[]);
if numel(D.Re) ~= nCases
    error('ATBM:ReSizeMismatch', 'Re must contain one value per case.');
end
if ~isfield(D,'R') || numel(D.R) ~= nCases
    D.R = round(D.Re/1e5,2);
end
if ~isfield(D,'Fs') || isempty(D.Fs)
    D.Fs = atbm.defaultConfig().Fs;
end
if ~isfield(D,'t') || numel(D.t) ~= nSamples
    D.t = (0:nSamples-1).' / D.Fs;
end
D.nSamples = nSamples;
D.nCases = nCases;
D.nTaps = numel(tapNames);
end
