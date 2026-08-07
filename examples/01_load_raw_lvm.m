setup;
rawFolder = "I:\\your_path\\AR4\\原始訊號";
outFile = fullfile('data','processed','ATBM_dataset.mat');
D = atbm.loadLVMFolder(rawFolder,'SaveTo',outFile);
