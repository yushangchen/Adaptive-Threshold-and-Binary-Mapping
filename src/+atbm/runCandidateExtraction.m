function out = runCandidateExtraction(D, cfg)
%RUNCANDIDATEEXTRACTION Extract AT results for all 18 taps and cases.

if nargin < 2 || isempty(cfg), cfg = atbm.defaultConfig(); end
D = atbm.standardizeDataset(D);
nTap = numel(D.tapNames);
nRe = D.nCases;

TL = nan(nRe,nTap); TR = TL; Tv = TL; SR = TL; VR = TL; mode = TL;
morphology = strings(nRe,nTap);
records = cell(nRe,nTap);

for itap = 1:nTap
    X = D.alldata{itap};
    for iRe = 1:nRe
        r = atbm.extractAT(X(:,iRe), ...
            'BinWidth',cfg.hist.binWidth, ...
            'Support',cfg.hist.support, ...
            'SmoothWin',cfg.hist.smoothWin, ...
            'MinPromRatio',cfg.AT.minPromRatio, ...
            'MinDistBin',cfg.AT.minDistBin, ...
            'SRThreshold',cfg.AT.SRThreshold, ...
            'VRThreshold',cfg.AT.VRThreshold);
        TL(iRe,itap)=r.TL; TR(iRe,itap)=r.TR; Tv(iRe,itap)=r.Tv;
        SR(iRe,itap)=r.SR; VR(iRe,itap)=r.valleyRatio;
        mode(iRe,itap)=r.mode; morphology(iRe,itap)=r.morphology;
        records{iRe,itap}=r;
    end
end

[reIdx,tapIdx] = ndgrid((1:nRe).',(1:nTap).');
ReValue = repmat(D.Re(:),1,nTap);
TapName = repmat(string(D.tapNames),nRe,1);

tbl = table(reIdx(:),ReValue(:),tapIdx(:),TapName(:),mode(:), ...
    morphology(:),TL(:),TR(:),Tv(:),SR(:),VR(:), ...
    'VariableNames',{'ReIndex','Re','TapIndex','TapName','Mode', ...
    'Morphology','TL','TR','Tv','SR','VR'});

out = struct('TL',TL,'TR',TR,'Tv',Tv,'SR',SR,'VR',VR, ...
    'mode',mode,'morphology',morphology,'records',{records},'table',tbl);
end
