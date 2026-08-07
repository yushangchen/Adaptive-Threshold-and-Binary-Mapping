function out = run_original_VR_sensitivity(D)
%RUN_ORIGINAL_VR_SENSITIVITY Execute the supplied VRsensitivity.m.

repoRoot = setup();
D = atbm.standardizeDataset(D);
atbm.exportLegacyVariables(D);
scriptPath = fullfile(repoRoot,'legacy','original_matlab','VRsensitivity.m');
run(scriptPath);

out = struct();
keep = {'VR_thr_list','SR_thr','modeCube','SRcube','VRcube', ...
    'SummaryByVR','TapDistribution'};
for k = 1:numel(keep)
    if exist(keep{k},'var')
        out.(keep{k}) = eval(keep{k});
    end
end
end
