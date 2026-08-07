function out = runATBM(D, thresholdSource, varargin)
%RUNATBM Run baseline 12-tap binary mapping for every Reynolds-number case.

cfg = atbm.defaultConfig();
p = inputParser;
p.addRequired('D');
p.addRequired('thresholdSource');
p.addParameter('TopK',cfg.topK,@isnumeric);
p.addParameter('StoreStateSeries',false,@islogical);
p.parse(D,thresholdSource,varargin{:});
D = atbm.standardizeDataset(D);
[thresholdTable,T] = atbm.loadOperationalThresholds(thresholdSource);
[CpBM,tapTableBM] = atbm.selectBMTaps(D);

if height(thresholdTable)~=size(CpBM,2)
    error('ATBM:ThresholdTapCount','Threshold table must contain 12 BM taps.');
end

nCases = D.nCases;
nTaps = size(CpBM,2);
hist4096 = zeros(2^nTaps,nCases);
pdf4096 = hist4096;
meanActiveCount = nan(1,nCases);
tapOccupancy = nan(nTaps,nCases);
topState = cell(1,nCases);
topFraction = cell(1,nCases);
topBits = cell(1,nCases);
if p.Results.StoreStateSeries
    stateSeries = cell(1,nCases);
else
    stateSeries = {};
end

for iRe=1:nCases
    CpCase = CpBM(:,:,iRe);
    index = atbm.binaryMap(CpCase,T.Tbasic);
    stats = atbm.patternStatistics(index,p.Results.TopK,cfg.row1IsMSB);
    hist4096(:,iRe)=stats.histogram;
    pdf4096(:,iRe)=stats.probability;
    meanActiveCount(iRe)=mean(sum(index,2));
    tapOccupancy(:,iRe)=mean(index,1).';
    topState{iRe}=stats.topState;
    topFraction{iRe}=stats.topFraction;
    topBits{iRe}=stats.topBits;
    if p.Results.StoreStateSeries
        stateSeries{iRe}=stats.state;
    end
end

out = struct();
out.Re=D.Re;
out.R=D.R;
out.thresholdTable=thresholdTable;
out.tapTable=tapTableBM;
out.hist4096=hist4096;
out.pdf4096=pdf4096;
out.meanActiveCount=meanActiveCount;
out.tapOccupancy=tapOccupancy;
out.topState=topState;
out.topFraction=topFraction;
out.topBits=topBits;
out.stateSeries=stateSeries;
out.method="Tbasic baseline-departure mapping";
out.stateDefinition="state 1 when Cp < Tbasic";
end
