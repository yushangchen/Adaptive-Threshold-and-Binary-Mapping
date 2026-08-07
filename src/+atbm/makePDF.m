function [x, y, edges] = makePDF(Cp, binWidth, support, smoothWin)
%MAKEPDF Probability-normalized histogram used by the original AT scripts.

cfg = atbm.defaultConfig();
if nargin < 2 || isempty(binWidth), binWidth = cfg.hist.binWidth; end
if nargin < 3 || isempty(support), support = cfg.hist.support; end
if nargin < 4 || isempty(smoothWin), smoothWin = cfg.hist.smoothWin; end

Cp = Cp(:);
Cp = Cp(isfinite(Cp));
if isempty(Cp)
    error('ATBM:EmptySignal', 'Cp contains no finite samples.');
end

lo = support(1);
hi = support(2);
if ~(isfinite(lo) && isfinite(hi) && hi > lo)
    error('ATBM:InvalidSupport', 'support must be [lower upper].');
end
edges = lo:binWidth:hi;
if edges(end) < hi
    edges = [edges, hi];
end
x = edges(1:end-1) + diff(edges)/2;
y = histcounts(Cp, edges, 'Normalization','probability').';
x = x(:);
if smoothWin > 1
    y = movmean(y, smoothWin);
end
end
