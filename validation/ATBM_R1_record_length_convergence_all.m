%% ATBM_R1_record_length_convergence_all.m
% =========================================================================
% AIAA Journal R1 validation
% Reviewer 1 - Major Comment 1
%
% PURPOSE
%   Verify whether the 120-s pressure record is sufficiently long for
%   convergence of the Cp probability-density function (PDF) used by AT-BM.
%
% DATA STRUCTURE EXPECTED IN WORKSPACE
%   Each variable below must be [120000 x 49]:
%
%   Cpp90_1D      Cpn90_1D      Cpp110_1D      Cpn110_1D
%   Cpp90_2D      Cpn90_2D      Cpp110_2D      Cpn110_2D
%   Cpp90_3_5D    Cpn90_3_5D    Cpp110_3_5D    Cpn110_3_5D
%
%   Rows    = time samples (Fs = 1000 Hz, 120 s)
%   Columns = Reynolds-number cases (49 cases)
%
% OPTIONAL
%   If a vector named Re exists in the workspace and contains 49 values,
%   it will be used in tables and figure labels. Otherwise, case indices
%   1...49 are used.
%
% WHAT THIS SCRIPT DOES
%   1. Builds CpAll = [120000 x 12 x 49].
%   2. Uses the complete 120-s PDF as the reference PDF for each tap/case.
%   3. Recomputes PDFs from contiguous time windows of
%      10, 20, 30, 60, 90, and 120 s.
%   4. Quantifies convergence using:
%         - Total Variation Distance (TVD)
%         - Jensen-Shannon Divergence (JSD)
%         - dominant PDF-peak location difference
%   5. Performs an independent 60-s split-half test:
%         0-60 s versus 60-120 s
%   6. Summarizes all 49 x 12 = 588 tap-condition combinations.
%   7. Automatically identifies the worst-converged 60-s cases.
%   8. Exports CSV, MAT, PDF and PNG results.
%
% IMPORTANT SCIENTIFIC POINT
%   Shorter records are taken as CONTIGUOUS windows. Samples are not
%   randomly shuffled, so temporal intermittency and persistence are retained.
%
% NOMINAL PDF SETTINGS
%   Histogram bin width = 0.025 Cp
%   Moving-average smoothing = 3 bins
%   These match the manuscript methodology.
%
% NOTE ABOUT THRESHOLDS
%   This script validates convergence of the PDFs themselves. It is intended
%   to be used together with the existing AT-BM threshold-repeatability /
%   SR-VR / bin-width sensitivity analyses already in the repository.
%   The script deliberately does NOT introduce a second, independent
%   threshold-extraction algorithm that could differ from the manuscript
%   implementation.
%
% =========================================================================

%% 0. USER SETTINGS
Fs = 1000;                              % Hz
durations = [10 20 30 60 90 120];     % seconds
binWidth = 0.025;                       % Cp
smoothBins = 3;                         % bins
maxWindowsPerDuration = 20;             % contiguous windows
targetDurationForRanking = 60;          % worst-case ranking at 60 s
nWorstToPlot = 6;                       % number of worst cases to plot

outRoot = 'R1_record_length_convergence';

if ~exist(outRoot,'dir')
    mkdir(outRoot);
end

%% 1. CHECK REQUIRED VARIABLES
requiredVars = { ...
    'Cpp90_1D','Cpn90_1D','Cpp110_1D','Cpn110_1D', ...
    'Cpp90_2D','Cpn90_2D','Cpp110_2D','Cpn110_2D', ...
    'Cpp90_3_5D','Cpn90_3_5D','Cpp110_3_5D','Cpn110_3_5D'};

missingVars = {};
for i = 1:numel(requiredVars)
    if ~evalin('base',sprintf('exist(''%s'',''var'')',requiredVars{i}))
        missingVars{end+1} = requiredVars{i}; %#ok<SAGROW>
    end
end

if ~isempty(missingVars)
    fprintf('\nMissing variables:\n');
    fprintf('  %s\n',missingVars{:});
    error('Load all 12 Cp matrices before running this script.');
end

%% 2. LOAD VARIABLES FROM BASE WORKSPACE
Cpp90_1D   = evalin('base','Cpp90_1D');
Cpn90_1D   = evalin('base','Cpn90_1D');
Cpp110_1D  = evalin('base','Cpp110_1D');
Cpn110_1D  = evalin('base','Cpn110_1D');

Cpp90_2D   = evalin('base','Cpp90_2D');
Cpn90_2D   = evalin('base','Cpn90_2D');
Cpp110_2D  = evalin('base','Cpp110_2D');
Cpn110_2D  = evalin('base','Cpn110_2D');

Cpp90_3_5D  = evalin('base','Cpp90_3_5D');
Cpn90_3_5D  = evalin('base','Cpn90_3_5D');
Cpp110_3_5D = evalin('base','Cpp110_3_5D');
Cpn110_3_5D = evalin('base','Cpn110_3_5D');

dataCell = { ...
    Cpp90_1D, Cpn90_1D, Cpp110_1D, Cpn110_1D, ...
    Cpp90_2D, Cpn90_2D, Cpp110_2D, Cpn110_2D, ...
    Cpp90_3_5D, Cpn90_3_5D, Cpp110_3_5D, Cpn110_3_5D};

tapNames = [ ...
    "+90°  z/D=1", "-90°  z/D=1", "+110° z/D=1", "-110° z/D=1", ...
    "+90°  z/D=2", "-90°  z/D=2", "+110° z/D=2", "-110° z/D=2", ...
    "+90°  z/D=3.5", "-90°  z/D=3.5", "+110° z/D=3.5", "-110° z/D=3.5"];

tapShort = [ ...
    "p90_1D","n90_1D","p110_1D","n110_1D", ...
    "p90_2D","n90_2D","p110_2D","n110_2D", ...
    "p90_3p5D","n90_3p5D","p110_3p5D","n110_3p5D"];

%% 3. VERIFY DIMENSIONS
[nSample,nRe] = size(dataCell{1});
nTap = numel(dataCell);

for j = 1:nTap
    if ~isequal(size(dataCell{j}),[nSample nRe])
        error('%s has size %s; expected %d x %d.', ...
            requiredVars{j},mat2str(size(dataCell{j})),nSample,nRe);
    end
end

recordLength = nSample/Fs;

fprintf('\n============================================================\n');
fprintf('AT-BM R1: record-length convergence\n');
fprintf('============================================================\n');
fprintf('Samples / record : %d\n',nSample);
fprintf('Sampling rate    : %.1f Hz\n',Fs);
fprintf('Record duration  : %.1f s\n',recordLength);
fprintf('Pressure taps    : %d\n',nTap);
fprintf('Re cases         : %d\n',nRe);
fprintf('Tap-Re pairs     : %d\n',nTap*nRe);
fprintf('============================================================\n\n');

if abs(recordLength-120) > 1/Fs
    warning('Record duration is %.3f s, not exactly 120 s.',recordLength);
end

durations = durations(durations <= recordLength + 1e-12);

%% 4. REYNOLDS-NUMBER LABELS
hasRe = evalin('base','exist(''Re'',''var'')') ~= 0;

if hasRe
    ReInput = evalin('base','Re');
    ReInput = ReInput(:)';
    if numel(ReInput) == nRe
        ReValues = ReInput;
    else
        warning('Workspace Re has %d values, but data contain %d cases. Using case index.', ...
            numel(ReInput),nRe);
        ReValues = 1:nRe;
        hasRe = false;
    end
else
    ReValues = 1:nRe;
end

%% 5. BUILD 3-D ARRAY: [time x tap x Re]
CpAll = nan(nSample,nTap,nRe);

for j = 1:nTap
    CpAll(:,j,:) = reshape(double(dataCell{j}),nSample,1,nRe);
end

clear dataCell
fprintf('CpAll assembled: %d x %d x %d\n\n',size(CpAll));

%% 6. PREALLOCATE RESULTS
% One row for every Re / tap / duration / window.
rowRe        = [];
rowTap       = [];
rowDuration  = [];
rowWindow    = [];
rowTstart    = [];
rowTend      = [];
rowN         = [];
rowTVD       = [];
rowJSD       = [];
rowPeakShift = [];

% Full-record reference information.
refPeakCp = nan(nTap,nRe);
refIQR    = nan(nTap,nRe);

% Store reference grids/PDFs for later worst-case plots.
refEdges   = cell(nTap,nRe);
refCenters = cell(nTap,nRe);
refPMF     = cell(nTap,nRe);

%% 7. MAIN ANALYSIS
fprintf('Running all %d tap-Re combinations...\n',nTap*nRe);

counter = 0;

for r = 1:nRe

    fprintf('  Re case %2d / %2d\n',r,nRe);

    for j = 1:nTap

        xFull = CpAll(:,j,r);
        xFull = xFull(:);

        finiteFull = xFull(isfinite(xFull));
        if numel(finiteFull) < 100
            warning('Too few finite samples: Re case %d, tap %d.',r,j);
            continue;
        end

        %% 7.1 Fixed histogram grid derived from full record
        xmin = min(finiteFull);
        xmax = max(finiteFull);

        leftEdge  = floor(xmin/binWidth)*binWidth - binWidth;
        rightEdge = ceil(xmax/binWidth)*binWidth + binWidth;

        edges = leftEdge:binWidth:rightEdge;

        if numel(edges) < 3
            edges = linspace(xmin-binWidth,xmax+binWidth,4);
        end

        centers = edges(1:end-1) + diff(edges)/2;

        %% 7.2 Full-record reference PDF
        q = histcounts(finiteFull,edges,'Normalization','probability');
        q = localSmoothNormalize(q,smoothBins);

        [~,iPeak] = max(q);
        peakCpFull = centers(iPeak);

        refPeakCp(j,r) = peakCpFull;
        refIQR(j,r) = iqr(finiteFull);
        refEdges{j,r} = edges;
        refCenters{j,r} = centers;
        refPMF{j,r} = q;

        %% 7.3 Record-length windows
        for d = durations

            nSeg = min(round(d*Fs),nSample);
            maxStart = nSample-nSeg+1;

            if maxStart <= 1
                starts = 1;
            else
                % Evenly spread contiguous windows across the full record.
                % These are dispersion samples, not independent replicates.
                nWin = min(maxWindowsPerDuration,maxStart);
                starts = unique(round(linspace(1,maxStart,nWin)));
            end

            for w = 1:numel(starts)

                i1 = starts(w);
                i2 = i1+nSeg-1;

                x = xFull(i1:i2);
                x = x(isfinite(x));

                p = histcounts(x,edges,'Normalization','probability');
                p = localSmoothNormalize(p,smoothBins);

                tvd = localTVD(p,q);
                jsd = localJSD(p,q);

                [~,ip] = max(p);
                peakCp = centers(ip);
                peakShift = abs(peakCp-peakCpFull);

                counter = counter+1;

                rowRe(counter,1)        = r;
                rowTap(counter,1)       = j;
                rowDuration(counter,1)  = d;
                rowWindow(counter,1)    = w;
                rowTstart(counter,1)    = (i1-1)/Fs;
                rowTend(counter,1)      = i2/Fs;
                rowN(counter,1)         = numel(x);
                rowTVD(counter,1)       = tvd;
                rowJSD(counter,1)       = jsd;
                rowPeakShift(counter,1) = peakShift;
            end
        end
    end
end

%% 8. MASTER WINDOW TABLE
ReNumeric = ReValues(rowRe).';

windowTable = table( ...
    rowRe,rowTap,tapShort(rowTap).',ReNumeric,rowDuration,rowWindow, ...
    rowTstart,rowTend,rowN,rowTVD,rowJSD,rowPeakShift, ...
    'VariableNames',{ ...
    'ReCase','TapIndex','TapName','ReValue','Duration_s','WindowIndex', ...
    'TimeStart_s','TimeEnd_s','Nfinite','TVD','JSD','PeakShift_Cp'});

writetable(windowTable,fullfile(outRoot,'R1_all_window_metrics.csv'));

%% 9. GLOBAL SUMMARY BY DURATION
summaryRows = [];

for id = 1:numel(durations)
    d = durations(id);

    idx = windowTable.Duration_s == d;

    tv = windowTable.TVD(idx);
    js = windowTable.JSD(idx);
    ps = windowTable.PeakShift_Cp(idx);

    summaryRows = [summaryRows; ...
        d, sum(idx), ...
        median(tv,'omitnan'), prctile(tv,25), prctile(tv,75), ...
        prctile(tv,95), max(tv), ...
        median(js,'omitnan'), prctile(js,25), prctile(js,75), ...
        prctile(js,95), max(js), ...
        median(ps,'omitnan'), prctile(ps,95), max(ps)]; %#ok<AGROW>
end

globalSummary = array2table(summaryRows,'VariableNames',{ ...
    'Duration_s','Nwindows', ...
    'TVD_median','TVD_Q25','TVD_Q75','TVD_P95','TVD_max', ...
    'JSD_median','JSD_Q25','JSD_Q75','JSD_P95','JSD_max', ...
    'PeakShift_median_Cp','PeakShift_P95_Cp','PeakShift_max_Cp'});

writetable(globalSummary,fullfile(outRoot,'R1_global_summary_by_duration.csv'));

fprintf('\nGLOBAL SUMMARY\n');
disp(globalSummary);

%% 10. SUMMARY PER TAP-RE PAIR
% Median across contiguous windows at each duration.
pairRows = [];

for r = 1:nRe
    for j = 1:nTap
        for d = durations

            idx = windowTable.ReCase == r & ...
                  windowTable.TapIndex == j & ...
                  windowTable.Duration_s == d;

            tv = windowTable.TVD(idx);
            js = windowTable.JSD(idx);
            ps = windowTable.PeakShift_Cp(idx);

            if isempty(tv)
                continue;
            end

            pairRows = [pairRows; ...
                r,j,ReValues(r),d,numel(tv), ...
                median(tv,'omitnan'),prctile(tv,95), ...
                median(js,'omitnan'),prctile(js,95), ...
                median(ps,'omitnan'),prctile(ps,95)]; %#ok<AGROW>
        end
    end
end

pairSummary = array2table(pairRows,'VariableNames',{ ...
    'ReCase','TapIndex','ReValue','Duration_s','Nwindows', ...
    'TVD_median','TVD_P95','JSD_median','JSD_P95', ...
    'PeakShift_median_Cp','PeakShift_P95_Cp'});

pairSummary.TapName = tapShort(pairSummary.TapIndex).';
pairSummary = movevars(pairSummary,'TapName','After','TapIndex');

writetable(pairSummary,fullfile(outRoot,'R1_summary_by_tap_Re_duration.csv'));

%% 11. INDEPENDENT 60-s SPLIT-HALF TEST
nHalf = round(60*Fs);

splitRe = [];
splitTap = [];
splitTVD = [];
splitJSD = [];
splitPeak = [];

cc = 0;

if nSample >= 2*nHalf

    for r = 1:nRe
        for j = 1:nTap

            xFull = CpAll(:,j,r);
            edges = refEdges{j,r};
            centers = refCenters{j,r};

            if isempty(edges)
                continue;
            end

            x1 = xFull(1:nHalf);
            x2 = xFull(nHalf+1:2*nHalf);

            x1 = x1(isfinite(x1));
            x2 = x2(isfinite(x2));

            p1 = histcounts(x1,edges,'Normalization','probability');
            p2 = histcounts(x2,edges,'Normalization','probability');

            p1 = localSmoothNormalize(p1,smoothBins);
            p2 = localSmoothNormalize(p2,smoothBins);

            [~,i1] = max(p1);
            [~,i2] = max(p2);

            cc = cc+1;

            splitRe(cc,1) = r;
            splitTap(cc,1) = j;
            splitTVD(cc,1) = localTVD(p1,p2);
            splitJSD(cc,1) = localJSD(p1,p2);
            splitPeak(cc,1) = abs(centers(i1)-centers(i2));
        end
    end

    splitTable = table( ...
        splitRe,splitTap,tapShort(splitTap).',ReValues(splitRe).', ...
        splitTVD,splitJSD,splitPeak, ...
        'VariableNames',{ ...
        'ReCase','TapIndex','TapName','ReValue', ...
        'TVD_60s_half1_vs_half2', ...
        'JSD_60s_half1_vs_half2', ...
        'PeakShift_60s_half1_vs_half2_Cp'});

    writetable(splitTable,fullfile(outRoot,'R1_split_half_60s.csv'));

    fprintf('\n60-s SPLIT-HALF TEST, ALL %d TAP-Re PAIRS\n',height(splitTable));
    fprintf('Median TVD  = %.6f\n',median(splitTable.TVD_60s_half1_vs_half2,'omitnan'));
    fprintf('95th TVD    = %.6f\n',prctile(splitTable.TVD_60s_half1_vs_half2,95));
    fprintf('Max TVD     = %.6f\n',max(splitTable.TVD_60s_half1_vs_half2));
    fprintf('Median JSD  = %.6g\n',median(splitTable.JSD_60s_half1_vs_half2,'omitnan'));
    fprintf('95th JSD    = %.6g\n',prctile(splitTable.JSD_60s_half1_vs_half2,95));
    fprintf('Max JSD     = %.6g\n',max(splitTable.JSD_60s_half1_vs_half2));
else
    splitTable = table();
end

%% 12. FIGURE: GLOBAL CONVERGENCE
fig = figure('Color','w','Position',[100 80 900 780]);

subplot(3,1,1)
errorbar( ...
    globalSummary.Duration_s, ...
    globalSummary.TVD_median, ...
    globalSummary.TVD_median-globalSummary.TVD_Q25, ...
    globalSummary.TVD_Q75-globalSummary.TVD_median, ...
    'o-','LineWidth',1.5,'MarkerSize',6);
grid on
xlabel('Record length, T_s (s)')
ylabel('Total-variation distance')
title(sprintf('PDF record-length convergence across %d tap-Re combinations',nTap*nRe))

subplot(3,1,2)
errorbar( ...
    globalSummary.Duration_s, ...
    globalSummary.JSD_median, ...
    globalSummary.JSD_median-globalSummary.JSD_Q25, ...
    globalSummary.JSD_Q75-globalSummary.JSD_median, ...
    'o-','LineWidth',1.5,'MarkerSize',6);
grid on
xlabel('Record length, T_s (s)')
ylabel('Jensen-Shannon divergence')

subplot(3,1,3)
plot( ...
    globalSummary.Duration_s, ...
    globalSummary.PeakShift_median_Cp, ...
    'o-','LineWidth',1.5,'MarkerSize',6);
hold on
plot( ...
    globalSummary.Duration_s, ...
    globalSummary.PeakShift_P95_Cp, ...
    's--','LineWidth',1.2,'MarkerSize',5);
grid on
xlabel('Record length, T_s (s)')
ylabel('|Delta C_p| of dominant PDF peak')
legend('Median','95th percentile','Location','best')

exportgraphics(fig,fullfile(outRoot,'R1_global_record_length_convergence.pdf'), ...
    'ContentType','vector');
exportgraphics(fig,fullfile(outRoot,'R1_global_record_length_convergence.png'), ...
    'Resolution',400);

%% 13. RANK WORST CASES AT TARGET DURATION
idxTarget = pairSummary.Duration_s == targetDurationForRanking;
targetTable = pairSummary(idxTarget,:);

targetTable = sortrows(targetTable,'JSD_P95','descend');

nWorst = min(nWorstToPlot,height(targetTable));
worstTable = targetTable(1:nWorst,:);

writetable(worstTable,fullfile(outRoot, ...
    sprintf('R1_worst_%ds_cases.csv',targetDurationForRanking)));

fprintf('\nWORST %d CASES AT %g s BASED ON P95 JSD\n',nWorst,targetDurationForRanking);
disp(worstTable);

%% 14. FIGURES: WORST-CASE PDF CONVERGENCE
worstDir = fullfile(outRoot,'worst_case_PDFs');
if ~exist(worstDir,'dir')
    mkdir(worstDir);
end

for iw = 1:nWorst

    r = worstTable.ReCase(iw);
    j = worstTable.TapIndex(iw);

    edges = refEdges{j,r};
    centers = refCenters{j,r};
    xFull = CpAll(:,j,r);

    f = figure('Color','w','Position',[100 100 900 600]);
    hold on

    leg = strings(0);

    for d = durations

        nSeg = min(round(d*Fs),nSample);
        maxStart = nSample-nSeg+1;

        if maxStart <= 1
            starts = 1;
        else
            nWin = min(maxWindowsPerDuration,maxStart);
            starts = unique(round(linspace(1,maxStart,nWin)));
        end

        P = nan(numel(starts),numel(centers));

        for w = 1:numel(starts)
            i1 = starts(w);
            i2 = i1+nSeg-1;

            x = xFull(i1:i2);
            x = x(isfinite(x));

            p = histcounts(x,edges,'Normalization','probability');
            P(w,:) = localSmoothNormalize(p,smoothBins);
        end

        plot(centers,mean(P,1,'omitnan'),'LineWidth',1.3);
        leg(end+1) = sprintf('%g s',d); %#ok<SAGROW>
    end

    grid on
    box on
    xlabel('C_p')
    ylabel('Probability per bin')

    if hasRe
        title(sprintf('PDF convergence: Re = %.5g, %s', ...
            ReValues(r),tapNames(j)));
    else
        title(sprintf('PDF convergence: Re case %d, %s', ...
            r,tapNames(j)));
    end

    legend(leg,'Location','best')

    fileStem = sprintf('worst_%02d_ReCase%02d_%s', ...
        iw,r,tapShort(j));

    exportgraphics(f,fullfile(worstDir,[fileStem '.pdf']), ...
        'ContentType','vector');
    exportgraphics(f,fullfile(worstDir,[fileStem '.png']), ...
        'Resolution',400);

    close(f)
end

%% 15. FIGURE: DISTRIBUTION OF 60-s CONVERGENCE OVER ALL 588 PAIRS
idx60 = pairSummary.Duration_s == targetDurationForRanking;
T60 = pairSummary(idx60,:);

fig60 = figure('Color','w','Position',[100 100 900 650]);

subplot(2,1,1)
histogram(T60.TVD_median,25)
grid on
xlabel(sprintf('Median TVD at %g s',targetDurationForRanking))
ylabel('Tap-Re combinations')
title(sprintf('Distribution across all %d tap-Re combinations',height(T60)))

subplot(2,1,2)
histogram(T60.JSD_median,25)
grid on
xlabel(sprintf('Median JSD at %g s',targetDurationForRanking))
ylabel('Tap-Re combinations')

exportgraphics(fig60,fullfile(outRoot,'R1_60s_metric_distributions.pdf'), ...
    'ContentType','vector');
exportgraphics(fig60,fullfile(outRoot,'R1_60s_metric_distributions.png'), ...
    'Resolution',400);

%% 16. CREATE A COMPACT REVIEWER-READY SUMMARY
% These are descriptive results only. No arbitrary pass/fail criterion is
% imposed; the observed convergence trend should be reported quantitatively.

idx60g = globalSummary.Duration_s == 60;
idx90g = globalSummary.Duration_s == 90;

reviewerMetric = strings(0,1);
reviewerValue = nan(0,1);

if any(idx60g)
    reviewerMetric(end+1) = "60 s median TVD";
    reviewerValue(end+1) = globalSummary.TVD_median(idx60g);

    reviewerMetric(end+1) = "60 s P95 TVD";
    reviewerValue(end+1) = globalSummary.TVD_P95(idx60g);

    reviewerMetric(end+1) = "60 s median JSD";
    reviewerValue(end+1) = globalSummary.JSD_median(idx60g);

    reviewerMetric(end+1) = "60 s P95 JSD";
    reviewerValue(end+1) = globalSummary.JSD_P95(idx60g);

    reviewerMetric(end+1) = "60 s P95 dominant-peak shift";
    reviewerValue(end+1) = globalSummary.PeakShift_P95_Cp(idx60g);
end

if any(idx90g)
    reviewerMetric(end+1) = "90 s median TVD";
    reviewerValue(end+1) = globalSummary.TVD_median(idx90g);

    reviewerMetric(end+1) = "90 s P95 TVD";
    reviewerValue(end+1) = globalSummary.TVD_P95(idx90g);

    reviewerMetric(end+1) = "90 s median JSD";
    reviewerValue(end+1) = globalSummary.JSD_median(idx90g);

    reviewerMetric(end+1) = "90 s P95 JSD";
    reviewerValue(end+1) = globalSummary.JSD_P95(idx90g);

    reviewerMetric(end+1) = "90 s P95 dominant-peak shift";
    reviewerValue(end+1) = globalSummary.PeakShift_P95_Cp(idx90g);
end

if ~isempty(splitTable)
    reviewerMetric(end+1) = "60 s split-half median TVD";
    reviewerValue(end+1) = median(splitTable.TVD_60s_half1_vs_half2,'omitnan');

    reviewerMetric(end+1) = "60 s split-half P95 TVD";
    reviewerValue(end+1) = prctile(splitTable.TVD_60s_half1_vs_half2,95);

    reviewerMetric(end+1) = "60 s split-half median JSD";
    reviewerValue(end+1) = median(splitTable.JSD_60s_half1_vs_half2,'omitnan');

    reviewerMetric(end+1) = "60 s split-half P95 JSD";
    reviewerValue(end+1) = prctile(splitTable.JSD_60s_half1_vs_half2,95);
end

reviewerSummary = table(reviewerMetric,reviewerValue, ...
    'VariableNames',{'Metric','Value'});

writetable(reviewerSummary,fullfile(outRoot,'R1_reviewer_ready_summary.csv'));

fprintf('\nREVIEWER-READY NUMERICAL SUMMARY\n');
disp(reviewerSummary);

%% 17. SAVE EVERYTHING
save(fullfile(outRoot,'R1_record_length_convergence_all_results.mat'), ...
    'globalSummary','pairSummary','windowTable','splitTable', ...
    'worstTable','reviewerSummary','ReValues','tapNames','tapShort', ...
    'durations','Fs','binWidth','smoothBins','-v7.3');

fprintf('\n============================================================\n');
fprintf('ANALYSIS COMPLETE\n');
fprintf('Output folder:\n  %s\n',fullfile(pwd,outRoot));
fprintf('============================================================\n');

%% ========================================================================
% LOCAL FUNCTIONS
% =========================================================================

function p = localSmoothNormalize(p,smoothBins)
    p = double(p(:)');

    if smoothBins > 1
        p = movmean(p,smoothBins,'Endpoints','shrink');
    end

    p(~isfinite(p) | p < 0) = 0;

    s = sum(p);
    if s > 0
        p = p/s;
    else
        p(:) = 0;
    end
end

function d = localTVD(p,q)
    p = p(:);
    q = q(:);

    if numel(p) ~= numel(q)
        error('TVD input vectors must have the same length.');
    end

    d = 0.5*sum(abs(p-q));
end

function d = localJSD(p,q)
    p = double(p(:));
    q = double(q(:));

    p(~isfinite(p) | p < 0) = 0;
    q(~isfinite(q) | q < 0) = 0;

    if sum(p) > 0
        p = p/sum(p);
    end

    if sum(q) > 0
        q = q/sum(q);
    end

    m = 0.5*(p+q);

    ip = p > 0 & m > 0;
    iq = q > 0 & m > 0;

    klpm = sum(p(ip).*log2(p(ip)./m(ip)));
    klqm = sum(q(iq).*log2(q(iq)./m(iq)));

    d = 0.5*klpm + 0.5*klqm;
end
