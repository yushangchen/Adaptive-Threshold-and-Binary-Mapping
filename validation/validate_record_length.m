cfg=atbm.defaultConfig(); rng(cfg.randomSeed);
x=[-1.75+0.14*randn(60000,1);-0.65+0.13*randn(60000,1)];
N=numel(x); rows=cell(numel(cfg.recordFractions),7);
for i=1:numel(cfg.recordFractions)
 f=cfg.recordFractions(i); n=floor(f*N);
 a=atbm.analyzeLocalSignal(x(1:n),cfg);
 rows(i,:)={f,n,a.classification.type,a.classification.SR, ...
  a.classification.VR,a.candidates.TL,a.candidates.TR};
end
T=cell2table(rows,"VariableNames",["Fraction","NSamples","Morphology", ...
 "SR","VR","TL","TR"]);
disp(T); writetable(T,"results/validation_record_length.csv");
