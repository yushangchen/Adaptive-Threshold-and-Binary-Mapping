function cls=classifyPDF(pdfOut,cfg)
x=pdfOut.centers; f=pdfOut.density;
[pks,locs]=findpeaks(f,"MinPeakProminence",cfg.minPeakProminenceFraction*max(f), ...
 "MinPeakDistance",cfg.minPeakDistanceBins);
cls=struct("type","unimodal","peakIndices",locs(:)',"peakLocations",x(locs)', ...
 "peakHeights",pks(:)',"valleyIndex",NaN,"valleyLocation",NaN, ...
 "SR",NaN,"VR",NaN,"FWHM",[NaN NaN]);
if numel(locs)<2, return; end
[~,ord]=sort(pks,"descend"); keep=ord(1:2); locs=locs(keep); pks=pks(keep);
[locs,ordx]=sort(locs); pks=pks(ordx);
[valleyHeight,rel]=min(f(locs(1):locs(2))); iv=locs(1)+rel-1;
w1=atbm.peakFWHM(x,f,locs(1)); w2=atbm.peakFWHM(x,f,locs(2));
SR=abs(x(locs(2))-x(locs(1)))/mean([w1 w2]);
VR=valleyHeight/max(min(pks),eps);
cls.peakIndices=locs; cls.peakLocations=x(locs)'; cls.peakHeights=pks(:)';
cls.valleyIndex=iv; cls.valleyLocation=x(iv); cls.SR=SR; cls.VR=VR; cls.FWHM=[w1 w2];
if SR>=cfg.SRThreshold && VR<=cfg.VRThreshold
 cls.type="bimodal-separated";
else
 cls.type="bimodal-overlapped";
end
end
