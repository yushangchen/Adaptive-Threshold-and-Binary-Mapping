function D = prepare_dataset_from_lvm(rawFolder, outputFile)
%PREPARE_DATASET_FROM_LVM Create the standardized ATBM_dataset.mat file.
setup;
if nargin < 2 || isempty(outputFile)
    outputFile = fullfile('data','processed','ATBM_dataset.mat');
end
D = atbm.loadLVMFolder(rawFolder,'SaveTo',outputFile);
end
