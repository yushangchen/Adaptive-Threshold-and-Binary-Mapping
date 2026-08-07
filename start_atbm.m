function D = start_atbm(dataSource)
%START_ATBM Load AT-BM data and restore the original MATLAB variables.
%
%   D = start_atbm(rawFolder)
%       Reads the original .lvm files, creates the standardized dataset,
%       saves it to data/processed/ATBM_dataset.mat, and exports the familiar
%       variables (Cpp90_2D, alldata, Re, t, ...) to the base workspace.
%
%   D = start_atbm(matFile)
%       Loads a standardized or legacy MAT file and exports the same variables.
%
%   D = start_atbm()
%       Loads data/processed/ATBM_dataset.mat.

repoRoot = setup();
defaultMat = fullfile(repoRoot, 'data', 'processed', 'ATBM_dataset.mat');

if nargin < 1 || isempty(dataSource)
    if ~isfile(defaultMat)
        error('ATBM:DefaultDatasetMissing', ...
            ['The default dataset does not exist: %s\n' ...
             'Run start_atbm(rawFolder) once, or pass an existing MAT file.'], ...
            defaultMat);
    end
    dataSource = defaultMat;
end

if isfolder(dataSource)
    D = atbm.loadLVMFolder(dataSource, 'SaveTo', defaultMat);
else
    D = atbm.loadDataset(dataSource);
end

atbm.exportLegacyVariables(D, 'base');
assignin('base', 'D', D);

fprintf('AT-BM data are ready in the base workspace.\n');
fprintf('Standard structure: D\n');
fprintf('Examples: Cpp90_2D(:,25), alldata{8}(:,25), Re(25)\n');
end
