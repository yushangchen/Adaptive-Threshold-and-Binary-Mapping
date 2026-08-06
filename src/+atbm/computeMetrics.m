function m = computeMetrics(B,tapTable)
%COMPUTEMETRICS Compute AT-BM occupancy, pattern, and side-bias metrics.
%
% The primary SAI follows the manuscript definition. At each sample,
%
%   s(t) = [Nplus(t)-Nminus(t)]/[Nplus(t)+Nminus(t)],
%
% with s(t)=0 when no tap is active. The reported SAI is mean_t[s(t)].
%
% For comparison, SAIAggregateOccupancy stores the separately normalized
% complete-record count difference. This diagnostic is generally not equal
% to the manuscript SAI.

B = logical(B);
assert(size(B,2)==height(tapTable),"ATBM:TapMismatch", ...
    "Map columns must match taps.");

m.activeTapCountInstantaneous = sum(B,2);
m.meanActiveTapCount = mean(m.activeTapCountInstantaneous);
m.tapOccupancy = mean(B,1);

groups = unique(tapTable.HeightGroup,"stable");
m.heightGroups = groups(:)';
m.heightOccupancy = nan(1,numel(groups));
for k = 1:numel(groups)
    idx = tapTable.HeightGroup==groups(k);
    m.heightOccupancy(k) = mean(B(:,idx),"all");
end

m.patternID = atbm.encodePatterns(B,tapTable.BitIndex);
[u,~,ic] = unique(m.patternID);
count = accumarray(ic,1);
[count,ord] = sort(count,"descend");
u = u(ord);
m.patternTable = table(u,count,count/size(B,1), ...
    "VariableNames",["PatternID","Count","Probability"]);

Nplus = sum(B(:,tapTable.Side>0),2);
Nminus = sum(B(:,tapTable.Side<0),2);
instantaneousDenominator = Nplus+Nminus;
s = zeros(size(instantaneousDenominator));
active = instantaneousDenominator>0;
s(active) = (Nplus(active)-Nminus(active))./instantaneousDenominator(active);

% Primary manuscript definition.
m.SAIInstantaneous = s;
m.SAI = mean(s);
m.meanAbsoluteInstantaneousSAI = mean(abs(s));

% Separate complete-record occupancy-weighted diagnostic.
m.NplusTotal = sum(Nplus);
m.NminusTotal = sum(Nminus);
aggregateDenominator = m.NplusTotal + m.NminusTotal;
if aggregateDenominator==0
    m.SAIAggregateOccupancy = 0;
else
    m.SAIAggregateOccupancy = ...
        (m.NplusTotal-m.NminusTotal)/aggregateDenominator;
end
end
