cfg=atbm.defaultConfig(); rng(cfg.randomSeed);
signals={-0.8+0.12*randn(50000,1), ...
 [-1.9+0.08*randn(25000,1);-0.6+0.08*randn(25000,1)], ...
 [-1.25+0.24*randn(26000,1);-0.90+0.24*randn(24000,1)]};
name=["unimodal","separated","overlapped"]; rows=cell(3,6);
for i=1:3
 a=atbm.analyzeLocalSignal(signals{i},cfg);
 rows(i,:)={name(i),a.classification.type,a.classification.SR, ...
  a.classification.VR,a.candidates.TL,a.candidates.TR};
end
T=cell2table(rows,"VariableNames",["Expected","Observed","SR","VR","TL","TR"]);
disp(T); writetable(T,"results/validation_synthetic_morphologies.csv");
