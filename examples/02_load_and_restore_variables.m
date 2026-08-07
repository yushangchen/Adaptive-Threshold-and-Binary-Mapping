setup;
D = atbm.loadDataset(fullfile('data','processed','ATBM_dataset.mat'));
atbm.exportLegacyVariables(D);

% Original variable-based analysis is now available.
seg = Cpp90_2D(:,25);
result = atbm.extractAT(seg);
disp(result)
