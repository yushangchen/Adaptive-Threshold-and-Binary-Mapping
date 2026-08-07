function out = validate_representative_sensitivity(D)
%VALIDATE_REPRESENTATIVE_SENSITIVITY
% Measured-data bin-width, SR/VR, and bootstrap analyses reconstructed from
% AT_sensitivity_binwidth.m.

D=atbm.standardizeDataset(D);
cfg=atbm.defaultConfig();
V=cfg.validation;
binWidths=V.binWidths;
refIdx=V.referenceBinIndex;
SR_thr=cfg.AT.SRThreshold;
VR_thr=cfg.AT.VRThreshold;

Cp_uni=atbm.getTap(D,V.unimodal.tapName,V.unimodal.caseIdx);
Cp_sep=atbm.getTap(D,V.separated.tapName,V.separated.caseIdx);
Cp_ovl=atbm.getTap(D,V.overlapped.tapName,V.overlapped.caseIdx);
Cp_uni=Cp_uni(isfinite(Cp_uni)); Cp_sep=Cp_sep(isfinite(Cp_sep)); Cp_ovl=Cp_ovl(isfinite(Cp_ovl));
support_uni=[min(Cp_uni) max(Cp_uni)];
support_sep=[min(Cp_sep) max(Cp_sep)];
support_ovl=[min(Cp_ovl) max(Cp_ovl)];
IQR_uni=iqr(Cp_uni); IQR_sep=iqr(Cp_sep); IQR_ovl=iqr(Cp_ovl);

TL_uni=nan(size(binWidths)); TR_uni=TL_uni; mode_uni=TL_uni;
TL_sep=TL_uni; TR_sep=TL_uni; mode_sep=TL_uni;
Tv_ovl=TL_uni; mode_ovl=TL_uni;

for k=1:numel(binWidths)
    r=atbm.extractAT(Cp_uni,'BinWidth',binWidths(k),'Support',support_uni, ...
        'SmoothWin',V.representativeSmoothWin);
    TL_uni(k)=r.TL; TR_uni(k)=r.TR; mode_uni(k)=r.mode;

    r=atbm.extractAT(Cp_sep,'BinWidth',binWidths(k),'Support',support_sep, ...
        'SmoothWin',V.representativeSmoothWin);
    TL_sep(k)=r.TL; TR_sep(k)=r.TR; mode_sep(k)=r.mode;

    minDist=max(2,round(V.overlappedMinPeakDistanceCp/binWidths(k)));
    r=atbm.extractAT(Cp_ovl,'BinWidth',binWidths(k),'Support',support_ovl, ...
        'SmoothWin',V.overlappedSmoothWin, ...
        'MinPromRatio',V.overlappedMinPromRatio,'MinDistBin',minDist);
    Tv_ovl(k)=r.Tv; mode_ovl(k)=r.mode;
end
binWidthTable=table(binWidths(:),TL_uni(:),TR_uni(:),mode_uni(:), ...
    TL_sep(:),TR_sep(:),mode_sep(:),Tv_ovl(:),mode_ovl(:), ...
    'VariableNames',{'BinWidth','TL_unimodal','TR_unimodal','Mode_unimodal', ...
    'TL_separated','TR_separated','Mode_separated','Tv_overlapped','Mode_overlapped'});

SR_set=SR_thr*[0.8 1 1.2];
VR_set=VR_thr*[0.8 1 1.2];
modeMap_sep=nan(numel(SR_set),numel(VR_set));
modeMap_ovl=modeMap_sep;
bw_ref=binWidths(refIdx);
for ii=1:numel(SR_set)
    for jj=1:numel(VR_set)
        r=atbm.extractAT(Cp_sep,'BinWidth',bw_ref,'Support',support_sep, ...
            'SmoothWin',V.representativeSmoothWin,'SRThreshold',SR_set(ii),'VRThreshold',VR_set(jj));
        modeMap_sep(ii,jj)=r.mode;
        minDist=max(2,round(V.overlappedMinPeakDistanceCp/bw_ref));
        r=atbm.extractAT(Cp_ovl,'BinWidth',bw_ref,'Support',support_ovl, ...
            'SmoothWin',V.overlappedSmoothWin,'MinPromRatio',V.overlappedMinPromRatio, ...
            'MinDistBin',minDist,'SRThreshold',SR_set(ii),'VRThreshold',VR_set(jj));
        modeMap_ovl(ii,jj)=r.mode;
    end
end

rng(V.randomSeed);
nBoot=V.bootstrapCount;
sampleFrac=V.bootstrapFraction;
boot=table((1:nBoot).','VariableNames',{'BootstrapIndex'});
boot.TL_unimodal=nan(nBoot,1); boot.TR_unimodal=nan(nBoot,1); boot.Mode_unimodal=nan(nBoot,1);
boot.TL_separated=nan(nBoot,1); boot.TR_separated=nan(nBoot,1); boot.Mode_separated=nan(nBoot,1);
boot.Tv_overlapped=nan(nBoot,1); boot.Mode_overlapped=nan(nBoot,1);
minDistOvl=max(2,round(V.overlappedMinPeakDistanceCp/bw_ref));
for b=1:nBoot
    xb=Cp_uni(randi(numel(Cp_uni),round(sampleFrac*numel(Cp_uni)),1));
    r=atbm.extractAT(xb,'BinWidth',bw_ref,'Support',support_uni,'SmoothWin',V.representativeSmoothWin);
    boot.TL_unimodal(b)=r.TL; boot.TR_unimodal(b)=r.TR; boot.Mode_unimodal(b)=r.mode;
    xb=Cp_sep(randi(numel(Cp_sep),round(sampleFrac*numel(Cp_sep)),1));
    r=atbm.extractAT(xb,'BinWidth',bw_ref,'Support',support_sep,'SmoothWin',V.representativeSmoothWin);
    boot.TL_separated(b)=r.TL; boot.TR_separated(b)=r.TR; boot.Mode_separated(b)=r.mode;
    xb=Cp_ovl(randi(numel(Cp_ovl),round(sampleFrac*numel(Cp_ovl)),1));
    r=atbm.extractAT(xb,'BinWidth',bw_ref,'Support',support_ovl,'SmoothWin',V.overlappedSmoothWin, ...
        'MinPromRatio',V.overlappedMinPromRatio,'MinDistBin',minDistOvl);
    boot.Tv_overlapped(b)=r.Tv; boot.Mode_overlapped(b)=r.mode;
end

% Full-record references and normalized deviations
rUni=atbm.extractAT(Cp_uni,'BinWidth',bw_ref,'Support',support_uni,'SmoothWin',V.representativeSmoothWin);
rSep=atbm.extractAT(Cp_sep,'BinWidth',bw_ref,'Support',support_sep,'SmoothWin',V.representativeSmoothWin);
rOvl=atbm.extractAT(Cp_ovl,'BinWidth',bw_ref,'Support',support_ovl,'SmoothWin',V.overlappedSmoothWin, ...
    'MinPromRatio',V.overlappedMinPromRatio,'MinDistBin',minDistOvl);
boot.dTL_unimodal_pctIQR=100*(boot.TL_unimodal-rUni.TL)/IQR_uni;
boot.dTR_unimodal_pctIQR=100*(boot.TR_unimodal-rUni.TR)/IQR_uni;
boot.dTL_separated_pctIQR=100*(boot.TL_separated-rSep.TL)/IQR_sep;
boot.dTR_separated_pctIQR=100*(boot.TR_separated-rSep.TR)/IQR_sep;
boot.dTv_overlapped_pctIQR=100*(boot.Tv_overlapped-rOvl.Tv)/IQR_ovl;

out=struct('binWidthTable',binWidthTable,'SRSet',SR_set,'VRSet',VR_set, ...
    'modeMapSeparated',modeMap_sep,'modeMapOverlapped',modeMap_ovl, ...
    'bootstrapTable',boot,'references',struct('unimodal',rUni,'separated',rSep,'overlapped',rOvl));

resultDir=fullfile('results','validation'); if ~isfolder(resultDir),mkdir(resultDir);end
writetable(binWidthTable,fullfile(resultDir,'representative_binwidth.csv'));
writetable(boot,fullfile(resultDir,'representative_bootstrap.csv'));

figureDir=fullfile('figures','validation'); if ~isfolder(figureDir),mkdir(figureDir);end
f=figure('Color','w','Position',[100 100 1300 520]); tiledlayout(1,3,'Padding','compact','TileSpacing','compact');
nexttile; plot(binWidths,TL_uni,'-o',binWidths,TR_uni,'--s','LineWidth',1.8); grid on; box on; title('(a) Unimodal'); xlabel('Bin width \Delta C_p'); ylabel('Threshold'); legend('T_L','T_R');
nexttile; plot(binWidths,TL_sep,'-o',binWidths,TR_sep,'--s','LineWidth',1.8); grid on; box on; title('(b) Bimodal-separated'); xlabel('Bin width \Delta C_p'); ylabel('Threshold'); legend('T_L','T_R');
nexttile; plot(binWidths,Tv_ovl,'-d','LineWidth',1.8); grid on; box on; title('(c) Bimodal-overlapped'); xlabel('Bin width \Delta C_p'); ylabel('T_v');
exportgraphics(f,fullfile(figureDir,'validation_binwidth.png'),'Resolution',300);

f=figure('Color','w','Position',[100 100 1100 450]); tiledlayout(1,2,'Padding','compact','TileSpacing','compact');
nexttile; imagesc(VR_set,SR_set,modeMap_sep); set(gca,'YDir','normal'); caxis([0 2]); colorbar; xlabel('VR cutoff'); ylabel('SR cutoff'); title('(a) Separated case');
nexttile; imagesc(VR_set,SR_set,modeMap_ovl); set(gca,'YDir','normal'); caxis([0 2]); colorbar; xlabel('VR cutoff'); ylabel('SR cutoff'); title('(b) Overlapped case');
exportgraphics(f,fullfile(figureDir,'validation_sr_vr.png'),'Resolution',300);
end
