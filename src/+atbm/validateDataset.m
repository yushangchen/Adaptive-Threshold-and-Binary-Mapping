function report = validateDataset(D)
%VALIDATEDATASET Summarize dimensions, NaNs, Reynolds-number order, and ranges.

D = atbm.standardizeDataset(D);
minCp = nan(D.nTaps,1);
maxCp = nan(D.nTaps,1);
meanCp = nan(D.nTaps,1);
nanFraction = nan(D.nTaps,1);
for k = 1:D.nTaps
    X = D.alldata{k};
    minCp(k) = min(X,[],'all','omitnan');
    maxCp(k) = max(X,[],'all','omitnan');
    meanCp(k) = mean(X,'all','omitnan');
    nanFraction(k) = mean(isnan(X),'all');
end
TapSummary = table(string(D.tapNames(:)),minCp,maxCp,meanCp,nanFraction, ...
    'VariableNames',{'TapName','MinimumCp','MaximumCp','MeanCp','NaNFraction'});

report = struct();
report.nSamples = D.nSamples;
report.nCases = D.nCases;
report.nTaps = D.nTaps;
report.Fs = D.Fs;
report.Re = D.Re;
report.ReIsNondecreasing = all(diff(D.Re)>=0 | isnan(diff(D.Re)));
report.TapSummary = TapSummary;

fprintf('AT-BM dataset: %d samples x %d cases x %d AT taps\n', ...
    D.nSamples,D.nCases,D.nTaps);
fprintf('Sampling frequency: %.6g Hz\n',D.Fs);
if report.ReIsNondecreasing
    fprintf('Reynolds-number order is nondecreasing.\n');
else
    warning('ATBM:ReOrder', ...
        'Reynolds numbers are not nondecreasing. Verify the .lvm filename order.');
end
disp(TapSummary);
end
