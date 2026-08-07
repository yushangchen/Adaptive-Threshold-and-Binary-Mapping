function out = validate_vr_all_taps(D)
%VALIDATE_VR_ALL_TAPS Reconstruct VRsensitivity.m for all 18 taps and cases.

D=atbm.standardizeDataset(D);
cfg=atbm.defaultConfig();
VRList=[0.6 0.7 0.8];
SRThreshold=1.5;
binWidth=0.05;
support=[-3.4 0];
smoothWin=1;
minProm=0.05;
minDistBin=3;
nTap=numel(D.alldata);
nRe=D.nCases;
modeCube=nan(nTap,nRe,numel(VRList));
SRcube=nan(size(modeCube));
VRcube=nan(size(modeCube));

for itap=1:nTap
    for iRe=1:nRe
        seg=D.alldata{itap}(:,iRe);
        for iv=1:numel(VRList)
            r=atbm.extractAT(seg,'BinWidth',binWidth,'Support',support, ...
                'SmoothWin',smoothWin,'MinPromRatio',minProm,'MinDistBin',minDistBin, ...
                'SRThreshold',SRThreshold,'VRThreshold',VRList(iv));
            modeCube(itap,iRe,iv)=r.mode;
            SRcube(itap,iRe,iv)=r.SR;
            VRcube(itap,iRe,iv)=r.valleyRatio;
        end
    end
end

Total_mode1=squeeze(sum(sum(modeCube==1,1),2));
Total_mode2=squeeze(sum(sum(modeCube==2,1),2));
Total_mode0=squeeze(sum(sum(modeCube==0,1),2));
Total_nan=squeeze(sum(sum(isnan(modeCube),1),2));
SummaryByVR=table(VRList(:),Total_mode1(:),Total_mode2(:),Total_mode0(:),Total_nan(:), ...
    'VariableNames',{'VRThreshold','Separated','Overlapped','Unimodal','NaNCount'});

TapDistribution=table((1:nTap).',string(D.tapNames(:)), ...
    'VariableNames',{'TapIndex','TapName'});
for iv=1:numel(VRList)
    tag=strrep(sprintf('VR%.2f',VRList(iv)),'.','p');
    TapDistribution.(['Separated_' tag])=sum(modeCube(:,:,iv)==1,2);
    TapDistribution.(['Overlapped_' tag])=sum(modeCube(:,:,iv)==2,2);
    TapDistribution.(['Unimodal_' tag])=sum(modeCube(:,:,iv)==0,2);
end
out=struct('VRThresholds',VRList,'modeCube',modeCube,'SRcube',SRcube, ...
    'VRcube',VRcube,'SummaryByVR',SummaryByVR,'TapDistribution',TapDistribution);
resultDir=fullfile('results','validation'); if ~isfolder(resultDir),mkdir(resultDir);end
writetable(SummaryByVR,fullfile(resultDir,'vr_all_taps_summary.csv'));
writetable(TapDistribution,fullfile(resultDir,'vr_all_taps_distribution.csv'));
disp(SummaryByVR);
end
