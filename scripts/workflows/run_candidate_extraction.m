function candidates = run_candidate_extraction(dataSource)
%RUN_CANDIDATE_EXTRACTION Extract TL/TR/Tv/SR/VR for all taps and cases.
setup;
D = atbm.loadDataset(dataSource);
candidates = atbm.runCandidateExtraction(D,atbm.defaultConfig());
if ~isfolder('results'), mkdir('results'); end
writetable(candidates.table,fullfile('results','AT_candidates.csv'));
save(fullfile('results','AT_candidates.mat'),'candidates','-v7.3');
end
