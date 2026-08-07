function out = run_baseline_mapping(dataSource)
%RUN_BASELINE_MAPPING Run 12-tap Tbasic mapping over all cases.
setup;
D = atbm.loadDataset(dataSource);
thresholdFile = fullfile('config','operational_thresholds_baseline_v3.csv');
out = atbm.runATBM(D,thresholdFile);
if ~isfolder('results'), mkdir('results'); end
save(fullfile('results','ATBM_results.mat'),'out','-v7.3');
end
