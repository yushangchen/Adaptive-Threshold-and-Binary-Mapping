function out = run_original_AT_sensitivity(D)
%RUN_ORIGINAL_AT_SENSITIVITY Execute the supplied AT_sensitivity_binwidth.m.
%
% The script is run after restoring the original workspace variables, so its
% bin-width, SR/VR, and bootstrap figures retain the author's original logic.

repoRoot = setup();
D = atbm.standardizeDataset(D);
atbm.exportLegacyVariables(D);
scriptPath = fullfile(repoRoot,'legacy','original_matlab','AT_sensitivity_binwidth.m');
run(scriptPath);

out = struct();
keep = {'binWidths','TL_uni','TR_uni','mode_uni','TL_sep','TR_sep','mode_sep', ...
    'Tv_ovl','mode_ovl','SR_set','VR_set','modeMap_sep','modeMap_ovl', ...
    'TL_uni_boot','TR_uni_boot','mode_uni_boot','TL_sep_boot','TR_sep_boot', ...
    'mode_sep_boot','Tv_ovl_boot','mode_ovl_boot'};
for k = 1:numel(keep)
    if exist(keep{k},'var')
        out.(keep{k}) = eval(keep{k});
    end
end
end
