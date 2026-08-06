setup;
assert(isfile("results/ATBM_results.mat"), ...
 "Run AT-BM and save results/ATBM_results.mat first.");
S=load("results/ATBM_results.mat");
run("scripts/plot_Fig05_workflow.m");
run("scripts/plot_Fig06_threshold_examples.m");
run("scripts/plot_Fig07_binary_mapping.m");
run("scripts/plot_Fig08_operational_hierarchy.m");
run("scripts/plot_Fig09_12_representative_maps.m");
run("scripts/plot_Fig13_full_Re_statistics.m");
run("scripts/plot_Fig14_hierarchical_map.m");
