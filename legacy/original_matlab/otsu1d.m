function [T, info] = otsu1d(x, varargin)
% OTSU1D  Otsu's threshold for arbitrary 1-D data (two-class)
% [T, info] = otsu1d(x, 'NumBins', L, 'Range', [a b], 'Smooth', s)
%
% x        : numeric vector
% T        : threshold on the same scale as x
% info     : struct with fields:
%            .counts, .edges, .centers, .p, .w0, .mu_k, .muT, .sigmaB2, .kstar
%
% Options:
%  'NumBins' (default: round(sqrt(numel(x))))  number of histogram bins
%  'Range'   (default: [min(x) max(x)])       histogram range
%  'Smooth'  (default: 0)                      Gaussian smoothing (std in bins)

x = x(:);
x = x(isfinite(x));
if isempty(x)
    T = NaN; info = struct(); return;
end

p = inputParser;
p.addParameter('NumBins', max(16, round(sqrt(numel(x)))), @(v)isnumeric(v)&&isscalar(v)&&v>=2);
p.addParameter('Range', [min(x) max(x)], @(v)isnumeric(v)&&numel(v)==2 && v(1)<v(2));
p.addParameter('Smooth', 0, @(v)isnumeric(v)&&isscalar(v)&&v>=0);
p.parse(varargin{:});
L = p.Results.NumBins; rngH = p.Results.Range; sm = p.Results.Smooth;

% histogram
[counts, edges] = histcounts(x, L, 'BinLimits', rngH);
% optional smoothing on counts
if sm>0
    % discrete Gaussian kernel (truncate at 3*sigma)
    r = ceil(3*sm);
    g = exp(-(-r:r).^2/(2*sm^2)); g = g/sum(g);
    counts = conv(counts, g, 'same');
end
n = sum(counts);
if n==0
    T = mean(rngH); info = struct(); return;
end
p_i = counts / n;
centers = 0.5*(edges(1:end-1) + edges(2:end));

% cumulative sums
w0 = cumsum(p_i);
mu_k = cumsum(p_i .* centers);
muT  = mu_k(end);

% between-class variance; avoid div by zero at boundaries
w1 = 1 - w0;
valid = (w0>0) & (w1>0);
sigmaB2 = -inf(size(w0));
sigmaB2(valid) = (muT*w0(valid) - mu_k(valid)).^2 ./ (w0(valid).*w1(valid));

% best k (ignore last bin edge because threshold lies between bins)
[~, kstar] = max(sigmaB2(1:end-1));

% convert k* to threshold on x-scale: middle between edges(k*+1) and edges(k*+2)
T = (edges(kstar+1) + edges(kstar+2))/2;

if nargout>1
    info = struct('counts',counts,'edges',edges,'centers',centers,'p',p_i, ...
                  'w0',w0,'mu_k',mu_k,'muT',muT,'sigmaB2',sigmaB2,'kstar',kstar);
end
end
