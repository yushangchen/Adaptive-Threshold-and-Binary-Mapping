function level = hierarchyMap(Cp, Tbasic, Tmod, Tcore)
%HIERARCHYMAP Construct pressure levels 0-3 from supplied tap thresholds.
%
% Level 0: Cp >= Tbasic
% Level 1: Tmod <= Cp < Tbasic
% Level 2: Tcore <= Cp < Tmod
% Level 3: Cp < Tcore

nTaps = size(Cp,2);
Tbasic = expandThreshold(Tbasic,nTaps,'Tbasic');
Tmod = expandThreshold(Tmod,nTaps,'Tmod');
Tcore = expandThreshold(Tcore,nTaps,'Tcore');

for k = 1:nTaps
    vals = [Tbasic(k),Tmod(k),Tcore(k)];
    vals = vals(isfinite(vals));
    if numel(vals)>=2 && any(diff(vals)>=0)
        error('ATBM:ThresholdOrder', ...
            'Thresholds must satisfy Tcore < Tmod < Tbasic for tap %d.',k);
    end
end

level = nan(size(Cp));
for k = 1:nTaps
    if ~isfinite(Tbasic(k)), continue; end
    level(:,k) = 0;
    level(Cp(:,k)<Tbasic(k),k) = 1;
    if isfinite(Tmod(k))
        level(Cp(:,k)<Tmod(k),k) = 2;
    end
    if isfinite(Tcore(k))
        level(Cp(:,k)<Tcore(k),k) = 3;
    end
end
end

function T = expandThreshold(T,nTaps,name)
if isempty(T), T=nan(nTaps,1); end
T=T(:);
if numel(T)~=nTaps
    error('ATBM:ThresholdSize','%s must contain one value per tap.',name);
end
end
