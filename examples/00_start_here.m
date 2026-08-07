% First use: pass the folder containing the original .lvm files.
D = start_atbm("I:\\your_path\\AR4\\原始訊號");

% Later sessions can load the standardized file directly:
% D = start_atbm();

% Familiar original variables are available in the base workspace.
seg = Cpp90_2D(:,25);
result = atbm.extractAT(seg);
