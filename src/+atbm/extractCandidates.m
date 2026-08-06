function c=extractCandidates(pdfOut,cls)
x=pdfOut.centers; f=pdfOut.density;
c=struct("TL",NaN,"TR",NaN,"Tv",NaN,"Morphology",cls.type);
switch cls.type
 case "unimodal"
  [~,ip]=max(f);
  if ip>=3, c.TL=atbm.chordKnee(x(1:ip),f(1:ip)); end
  if numel(x)-ip+1>=3, c.TR=atbm.chordKnee(x(ip:end),f(ip:end)); end
 case "bimodal-separated"
  i1=cls.peakIndices(1); iv=cls.valleyIndex; i2=cls.peakIndices(2);
  if iv-i1+1>=3, c.TL=atbm.chordKnee(x(i1:iv),f(i1:iv)); end
  if i2-iv+1>=3, c.TR=atbm.chordKnee(x(iv:i2),f(iv:i2)); end
 case "bimodal-overlapped"
  c.Tv=cls.valleyLocation;
 otherwise
  error("ATBM:UnknownMorphology","Unknown PDF morphology.");
end
end
