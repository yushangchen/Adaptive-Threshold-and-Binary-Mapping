function outputs = run_experimental_validation(dataSource)
%RUN_EXPERIMENTAL_VALIDATION Run the author's measured-data validation scripts.
%
% This entry point restores the original variable names and executes the
% supplied AT_sensitivity_binwidth.m and VRsensitivity.m without replacing
% their scientific logic.

setup;
D = atbm.loadDataset(dataSource);
outputs = struct();
outputs.representative = run_original_AT_sensitivity(D);
outputs.vrAllTaps = run_original_VR_sensitivity(D);

resultDir = fullfile('results','validation');
if ~isfolder(resultDir), mkdir(resultDir); end
save(fullfile(resultDir,'experimental_validation.mat'),'outputs','-v7.3');
disp('EXPERIMENTAL AT-BM VALIDATION COMPLETED');
end
