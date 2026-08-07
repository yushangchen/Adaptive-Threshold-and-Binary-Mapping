function repoRoot = setup()
%SETUP Add the reconstructed AT-BM repository to the MATLAB path.
%
%   setup
%   repoRoot = setup

repoRoot = fileparts(mfilename('fullpath'));
addpath(fullfile(repoRoot, 'src'));
addpath(fullfile(repoRoot, 'scripts'));
addpath(fullfile(repoRoot, 'scripts', 'figures'));
addpath(fullfile(repoRoot, 'scripts', 'workflows'));
addpath(fullfile(repoRoot, 'validation'));
addpath(fullfile(repoRoot, 'validation', 'experimental'));
addpath(fullfile(repoRoot, 'examples'));

fprintf('AT-BM repository configured: %s\n', repoRoot);
end
