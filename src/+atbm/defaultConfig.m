function cfg = defaultConfig()
cfg.Fs=1000; cfg.recordDuration=120;
cfg.cpRange=[-3.5 0]; cfg.binWidth=0.025; cfg.smoothSpan=3;
cfg.minPeakProminenceFraction=0.03; cfg.minPeakDistanceBins=4;
cfg.SRThreshold=1.5; cfg.VRThreshold=0.8;
cfg.thresholdClusterCount=3; cfg.randomSeed=42;
cfg.bootstrapReplicates=500; cfg.bootstrapBlockLength=1000;
cfg.recordFractions=[0.25 0.50 0.75 1.00];
cfg.binWidthCandidates=[0.0125 0.025 0.05];
cfg.smoothSpanCandidates=[1 3 5 7];
cfg.thresholdPerturbations=[-0.10 -0.05 0 0.05 0.10];
cfg.representative.Tbasic=-0.975;
cfg.representative.Tmod=-1.975;
cfg.representative.Tcore=-2.475;
cfg.operationalThresholds=table();
end
