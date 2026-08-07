function stats = patternStatistics(index, topK, row1IsMSB)
%PATTERNSTATISTICS Histogram and top patterns for a binary map.

if nargin < 2 || isempty(topK), topK = 6; end
if nargin < 3, row1IsMSB = true; end
[state,~] = atbm.encodePatterns(index,row1IsMSB);
nTaps = size(index,2);
nbin = 2^nTaps;
histogram = accumarray(double(state)+1,1,[nbin,1],@sum,0);
probability = histogram/size(index,1);
K = min(topK,nnz(histogram));
if K==0
    topCount=[]; topState=[];
else
    [topCount,ridx] = maxk(histogram,K);
    topState = ridx-1;
end
stats = struct();
stats.histogram = histogram;
stats.probability = probability;
stats.topState = topState;
stats.topCount = topCount;
stats.topFraction = topCount/size(index,1);
stats.topBits = atbm.decodePatterns(topState,nTaps,row1IsMSB);
stats.state = state;
end
