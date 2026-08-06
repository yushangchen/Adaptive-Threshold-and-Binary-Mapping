cfg=atbm.defaultConfig(); rng(cfg.randomSeed);
x=[-1.8+0.11*randn(30000,1);-0.65+0.12*randn(30000,1)];
rows={}; q=0;
for bw=cfg.binWidthCandidates
 for sm=cfg.smoothSpanCandidates
  q=q+1; c=cfg; c.binWidth=bw; c.smoothSpan=sm;
  a=atbm.analyzeLocalSignal(x,c);
  rows(q,:)={bw,sm,a.classification.type,a.classification.SR, ...
   a.classification.VR,a.candidates.TL,a.candidates.TR,a.candidates.Tv};
 end
end
T=cell2table(rows,"VariableNames",["BinWidth","SmoothSpan","Morphology", ...
 "SR","VR","TL","TR","Tv"]);
disp(T); writetable(T,"results/validation_binwidth_smoothing.csv");
