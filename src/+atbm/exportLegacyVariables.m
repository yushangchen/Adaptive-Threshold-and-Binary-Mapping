function vars = exportLegacyVariables(D, targetWorkspace)
%EXPORTLEGACYVARIABLES Restore original variable names for legacy scripts.
%
% atbm.exportLegacyVariables(D) writes variables to the calling workspace.
% vars = atbm.exportLegacyVariables(D) also returns them as a structure.

if nargin < 2 || isempty(targetWorkspace)
    targetWorkspace = 'caller';
end
D = atbm.standardizeDataset(D);
vars = struct();

names = fieldnames(D.Cp);
for k = 1:numel(names)
    vars.(names{k}) = D.Cp.(names{k});
end
vars.alldata = D.alldata;
vars.tapNames = D.tapNames;
vars.Re = D.Re;
vars.R = D.R;
vars.t = D.t;
vars.tt = D.t;
vars.Fs = D.Fs;
vars.fs = D.Fs;
vars.dia = atbm.defaultConfig().diameter;
vars.abc = D.nCases;
vars.rawdata = D.nSamples;
vars.degree = 70:20:110;
vars.ndegree = -110:20:-70;
vars.T = 1/D.Fs;
vars.n = D.nSamples;
vars.dF = D.Fs/D.nSamples;
vars.freq = (0:floor(D.nSamples/2)-1).*vars.dF;
vars.edges = -3.4:0.05:0;
vars.centers = vars.edges(1:end-1) + diff(vars.edges(1:2))/2;

optional = {'V_pitot','density','temperatureC','pitotPressure', ...
    'ReInstantaneous','tByCase','sourceFiles'};
for k = 1:numel(optional)
    if isfield(D, optional{k})
        vars.(optional{k}) = D.(optional{k});
    end
end
if isfield(D,'density'), vars.dns = D.density; end
if isfield(D,'temperatureC'), vars.temp = D.temperatureC; end

varNames = fieldnames(vars);
for k = 1:numel(varNames)
    assignin(targetWorkspace, varNames{k}, vars.(varNames{k}));
end
fprintf('Exported %d AT-BM variables to the %s workspace.\n', ...
    numel(varNames), targetWorkspace);
end
