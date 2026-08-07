function cfg = defaultConfig()
%DEFAULTCONFIG Source-faithful defaults reconstructed from the original scripts.

cfg.Fs = 1000;
cfg.durationSeconds = 120;
cfg.expectedSamples = 120000;
cfg.expectedCases = 49;
cfg.diameter = 0.15;

cfg.hist.support = [-3.4, 0];
cfg.hist.binWidth = 0.05;
cfg.hist.smoothWin = 1;

cfg.AT.minPromRatio = 0.05;
cfg.AT.minDistBin = 3;
cfg.AT.SRThreshold = 1.5;
cfg.AT.VRThreshold = 0.80;

cfg.pitot.column = 2;
cfg.pitot.slope = 516.1045;
cfg.pitot.offset = 5.9067;

cfg.temperature.column = 3;
cfg.temperature.scale = 10;

cfg.timeColumn = 1;
cfg.atmosphericPressure = 100950;
cfg.airGasConstant = 287.05;
cfg.sutherlandFactor = 1.458e-6;
cfg.sutherlandConstant = 110.4;

cfg.filePattern = '*.lvm';
cfg.topK = 6;
cfg.row1IsMSB = true;

cfg.validation.binWidths = [0.02 0.03 0.04 0.05 0.06];
cfg.validation.referenceBinIndex = 3;
cfg.validation.representativeSmoothWin = 2;
cfg.validation.unimodal = struct('tapName','Cpp90_2D','caseIdx',7);
cfg.validation.separated = struct('tapName','Cpp90_2D','caseIdx',25);
cfg.validation.overlapped = struct('tapName','Cpp110_1D','caseIdx',35);
cfg.validation.figure4Overlapped = struct('tapName','Cpp70_1D','caseIdx',26);
cfg.validation.overlappedMinPromRatio = 0.02;
cfg.validation.overlappedSmoothWin = 7;
cfg.validation.overlappedMinPeakDistanceCp = 0.12;
cfg.validation.bootstrapCount = 200;
cfg.validation.bootstrapFraction = 0.80;
cfg.validation.randomSeed = 1;
end
