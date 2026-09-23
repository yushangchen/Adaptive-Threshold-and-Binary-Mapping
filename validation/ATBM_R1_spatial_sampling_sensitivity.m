%% ATBM_R1_spatial_sampling_sensitivity.m
% =========================================================================
% AIAA Journal R1 validation
% Reviewer 1 - Major Comment:
%
% "The spatial resolution of spatio-temporal pressure-state map is
% relatively low. Have the authors estimated the effects of spatial
% resolution on characterizing the transitional flow?"
%
% PURPOSE
%   Quantify the sensitivity of the Reynolds-number-dependent AT-BM
%   characterization to pressure-tap spatial sampling.
%
% PRIMARY TEST (always available)
%   Controlled spatial subsampling of the manuscript 12-tap configuration:
%
%       Full configuration : 12 taps = +/-90 and +/-110 deg at z/D=1,2,3.5
%       Reduced set A      :  6 taps = +/-90 deg only
%       Reduced set B      :  6 taps = +/-110 deg only
%
%   All configurations use the SAME reviewed tap-wise Tbasic thresholds.
%   The comparison therefore changes only the spatial sampling, not the
%   threshold definition.
%
% OPTIONAL HIGHER-RESOLUTION TEST
%   If the six +/-70-deg pressure matrices AND a six-element vector named
%   Tbasic70 are present in the workspace, the script also compares:
%
%       18 taps (+/-70, +/-90, +/-110) versus the manuscript 12 taps.
%
%   Tbasic70 MUST contain reviewed operational thresholds in this order:
%
%       [ +70_1D, -70_1D, +70_2D, -70_2D, +70_3.5D, -70_3.5D ]
%
%   The script intentionally does NOT invent these six thresholds.
%
% REQUIRED WORKSPACE MATRICES
%   Each matrix must be [120000 x 49] (or generally [Nsample x Nre]):
%
%       Cpp90_1D      Cpn90_1D      Cpp110_1D      Cpn110_1D
%       Cpp90_2D      Cpn90_2D      Cpp110_2D      Cpn110_2D
%       Cpp90_3_5D    Cpn90_3_5D    Cpp110_3_5D    Cpn110_3_5D
%
% OPTIONAL +/-70-DEG MATRICES
%
%       Cpp70_1D      Cpn70_1D
%       Cpp70_2D      Cpn70_2D
%       Cpp70_3_5D    Cpn70_3_5D
%
% OPTIONAL REYNOLDS-NUMBER VECTOR
%       Re : 1 x Nre or Nre x 1
%
% REVIEWED 12-TAP Tbasic VALUES USED HERE
%   z/D = 1:
%       +90  -1.025
%       -90  -0.975
%       +110 -0.925
%       -110 -0.875
%
%   z/D = 2:
%       +90  -0.975
%       -90  -0.975
%       +110 -0.875
%       -110 -0.825
%
%   z/D = 3.5:
%       +90  -1.225
%       -90  -1.225
%       +110 -1.075
%       -110 -1.175
%
% METRICS COMPARED
%   1. Normalized active-tap fraction:
%
%          f_active = < N_active(t) / N_taps >_t
%
%      This is directly comparable between different tap counts.
%
%   2. Height-wise state-1 occupancy at z/D = 1, 2, 3.5.
%
%   3. Side-asymmetry index (SAI), using the manuscript definition:
%
%          SAI = < (N+ - N-) / (N+ + N-) >_t
%
%      Zero contribution is assigned when N+ + N- = 0.
%
% AGREEMENT STATISTICS
%   - Pearson correlation coefficient r
%   - mean absolute error (MAE)
%   - root-mean-square error (RMSE)
%   - maximum absolute difference
%
% IMPORTANT INTERPRETATION
%   The 12-vs-6 analysis is a controlled degradation / subsampling test.
%   It estimates how strongly the principal transition metrics depend on
%   the number and azimuthal selection of taps already used in the paper.
%
%   It does NOT prove that the 12-tap array resolves every local flow
%   structure. The optional 18-vs-12 analysis provides the stronger direct
%   check when reviewed +/-70-deg operational thresholds are available.
%
% OUTPUTS
%   R1_spatial_sampling_sensitivity/
%       R1_spatial_sampling_metrics.csv
%       R1_spatial_sampling_agreement.csv
%       R1_spatial_sampling_reviewer_summary.txt
%       R1_spatial_sampling_active_fraction.pdf/png
%       R1_spatial_sampling_height_occupancy.pdf/png
%       R1_spatial_sampling_SAI.pdf/png
%       R1_spatial_sampling_results.mat
%
% =========================================================================

%% 0. USER SETTINGS

outDir = 'R1_spatial_sampling_sensitivity';

if ~exist(outDir,'dir')
    mkdir(outDir);
end

% Reviewed manuscript Tbasic thresholds, in the manuscript 12-bit order.
Tbasic12 = [ ...
    -1.025;  ... % +90,  z/D=1
    -0.975;  ... % -90,  z/D=1
    -0.925;  ... % +110, z/D=1
    -0.875;  ... % -110, z/D=1
    -0.975;  ... % +90,  z/D=2
    -0.975;  ... % -90,  z/D=2
    -0.875;  ... % +110, z/D=2
    -0.825;  ... % -110, z/D=2
    -1.225;  ... % +90,  z/D=3.5
    -1.225;  ... % -90,  z/D=3.5
    -1.075;  ... % +110, z/D=3.5
    -1.175];     % -110, z/D=3.5

tapNames12 = [ ...
    "+90 z/D=1", "-90 z/D=1", "+110 z/D=1", "-110 z/D=1", ...
    "+90 z/D=2", "-90 z/D=2", "+110 z/D=2", "-110 z/D=2", ...
    "+90 z/D=3.5", "-90 z/D=3.5", "+110 z/D=3.5", "-110 z/D=3.5"];

%% 1. CHECK REQUIRED 12-TAP VARIABLES

required12 = { ...
    'Cpp90_1D','Cpn90_1D','Cpp110_1D','Cpn110_1D', ...
    'Cpp90_2D','Cpn90_2D','Cpp110_2D','Cpn110_2D', ...
    'Cpp90_3_5D','Cpn90_3_5D','Cpp110_3_5D','Cpn110_3_5D'};

missing12 = {};

for k = 1:numel(required12)
    if ~evalin('base',sprintf('exist(''%s'',''var'')',required12{k}))
        missing12{end+1} = required12{k}; %#ok<SAGROW>
    end
end

if ~isempty(missing12)
    fprintf('\nMissing required pressure matrices:\n');
    fprintf('  %s\n',missing12{:});
    error('Load all 12 manuscript pressure matrices before running this script.');
end

%% 2. READ REQUIRED DATA FROM BASE WORKSPACE

D12 = { ...
    evalin('base','Cpp90_1D'), ...
    evalin('base','Cpn90_1D'), ...
    evalin('base','Cpp110_1D'), ...
    evalin('base','Cpn110_1D'), ...
    evalin('base','Cpp90_2D'), ...
    evalin('base','Cpn90_2D'), ...
    evalin('base','Cpp110_2D'), ...
    evalin('base','Cpn110_2D'), ...
    evalin('base','Cpp90_3_5D'), ...
    evalin('base','Cpn90_3_5D'), ...
    evalin('base','Cpp110_3_5D'), ...
    evalin('base','Cpn110_3_5D')};

[nSample,nRe] = size(D12{1});

for j = 1:12
    if ~isequal(size(D12{j}),[nSample nRe])
        error('%s has size %s; expected %d x %d.', ...
            required12{j},mat2str(size(D12{j})),nSample,nRe);
    end
end

%% 3. REYNOLDS-NUMBER VECTOR

hasRe = evalin('base','exist(''Re'',''var'')') ~= 0;

if hasRe
    ReValues = double(evalin('base','Re'));
    ReValues = ReValues(:);

    if numel(ReValues) ~= nRe
        warning(['Workspace variable Re has %d values, while the pressure ' ...
                 'matrices have %d cases. Case index will be used instead.'], ...
                 numel(ReValues),nRe);
        ReValues = (1:nRe)';
        hasRe = false;
    end
else
    ReValues = (1:nRe)';
end

%% 4. OPTIONAL +/-70-DEG HIGHER-RESOLUTION CHECK

optional70 = { ...
    'Cpp70_1D','Cpn70_1D', ...
    'Cpp70_2D','Cpn70_2D', ...
    'Cpp70_3_5D','Cpn70_3_5D'};

have70data = true;

for k = 1:numel(optional70)
    if ~evalin('base',sprintf('exist(''%s'',''var'')',optional70{k}))
        have70data = false;
    end
end

haveT70 = evalin('base','exist(''Tbasic70'',''var'')') ~= 0;
use18 = false;

if have70data && haveT70

    Tbasic70 = double(evalin('base','Tbasic70'));
    Tbasic70 = Tbasic70(:);

    if numel(Tbasic70) ~= 6 || any(~isfinite(Tbasic70))
        warning(['Tbasic70 exists but must contain exactly six finite values:\n' ...
                 '[+70_1D -70_1D +70_2D -70_2D +70_3.5D -70_3.5D].\n' ...
                 'The optional 18-tap comparison will be skipped.']);
    else
        use18 = true;

        D70 = { ...
            evalin('base','Cpp70_1D'), ...
            evalin('base','Cpn70_1D'), ...
            evalin('base','Cpp70_2D'), ...
            evalin('base','Cpn70_2D'), ...
            evalin('base','Cpp70_3_5D'), ...
            evalin('base','Cpn70_3_5D')};

        for j = 1:6
            if ~isequal(size(D70{j}),[nSample nRe])
                error('%s has size %s; expected %d x %d.', ...
                    optional70{j},mat2str(size(D70{j})),nSample,nRe);
            end
        end
    end
end

%% 5. DEFINE SUBSAMPLING CONFIGURATIONS

% Manuscript ordering:
%  1 +90_1D
%  2 -90_1D
%  3 +110_1D
%  4 -110_1D
%  5 +90_2D
%  6 -90_2D
%  7 +110_2D
%  8 -110_2D
%  9 +90_3.5D
% 10 -90_3.5D
% 11 +110_3.5D
% 12 -110_3.5D

idx90  = [1 2 5 6 9 10];
idx110 = [3 4 7 8 11 12];

% Height groups in the full 12-tap set
heightGroups12 = {1:4,5:8,9:12};

% Height groups after selecting only +/-90 or only +/-110
heightGroups6 = {1:2,3:4,5:6};

% Positive/negative side indices for SAI
pos12 = [1 3 5 7 9 11];
neg12 = [2 4 6 8 10 12];

pos6 = [1 3 5];
neg6 = [2 4 6];

%% 6. PREALLOCATE METRICS

active12  = nan(nRe,1);
active90  = nan(nRe,1);
active110 = nan(nRe,1);

occ12  = nan(nRe,3);
occ90  = nan(nRe,3);
occ110 = nan(nRe,3);

SAI12  = nan(nRe,1);
SAI90  = nan(nRe,1);
SAI110 = nan(nRe,1);

if use18
    active18 = nan(nRe,1);
    occ18 = nan(nRe,3);
    SAI18 = nan(nRe,1);
end

%% 7. RUN ALL REYNOLDS-NUMBER CASES

fprintf('\n============================================================\n');
fprintf('AT-BM spatial-sampling sensitivity\n');
fprintf('============================================================\n');
fprintf('Samples per case : %d\n',nSample);
fprintf('Re cases         : %d\n',nRe);
fprintf('Primary test     : 12 taps vs two independent 6-tap subsets\n');

if use18
    fprintf('Optional test    : 18 taps vs 12 taps ENABLED\n');
else
    fprintf('Optional test    : 18 taps vs 12 taps not run\n');

    if have70data && ~haveT70
        fprintf(['Reason           : +/-70 data detected, but Tbasic70 was not found.\n' ...
                 '                   No +/-70 thresholds were invented.\n']);
    elseif ~have70data
        fprintf('Reason           : complete +/-70 data matrices were not detected.\n');
    end
end

fprintf('============================================================\n\n');

for r = 1:nRe

    fprintf('Processing Re case %2d / %2d\n',r,nRe);

    %% 7.1 Assemble 12-tap pressure matrix
    Cp12 = zeros(nSample,12);

    for j = 1:12
        Cp12(:,j) = double(D12{j}(:,r));
    end

    %% 7.2 Manuscript 12-tap binary map
    B12 = Cp12 < reshape(Tbasic12,1,12);

    %% 7.3 Controlled reduced spatial samplings
    B90  = B12(:,idx90);
    B110 = B12(:,idx110);

    %% 7.4 Metrics
    [active12(r),occ12(r,:),SAI12(r)] = ...
        localMetrics(B12,heightGroups12,pos12,neg12);

    [active90(r),occ90(r,:),SAI90(r)] = ...
        localMetrics(B90,heightGroups6,pos6,neg6);

    [active110(r),occ110(r,:),SAI110(r)] = ...
        localMetrics(B110,heightGroups6,pos6,neg6);

    %% 7.5 Optional 18-tap comparison
    if use18

        % 18-tap order:
        % z/D=1:   +70 -70 +90 -90 +110 -110
        % z/D=2:   +70 -70 +90 -90 +110 -110
        % z/D=3.5: +70 -70 +90 -90 +110 -110

        Cp18 = [ ...
            double(D70{1}(:,r)), double(D70{2}(:,r)), ...
            double(D12{1}(:,r)), double(D12{2}(:,r)), ...
            double(D12{3}(:,r)), double(D12{4}(:,r)), ...
            double(D70{3}(:,r)), double(D70{4}(:,r)), ...
            double(D12{5}(:,r)), double(D12{6}(:,r)), ...
            double(D12{7}(:,r)), double(D12{8}(:,r)), ...
            double(D70{5}(:,r)), double(D70{6}(:,r)), ...
            double(D12{9}(:,r)), double(D12{10}(:,r)), ...
            double(D12{11}(:,r)), double(D12{12}(:,r))];

        T18 = [ ...
            Tbasic70(1); Tbasic70(2); ...
            Tbasic12(1); Tbasic12(2); Tbasic12(3); Tbasic12(4); ...
            Tbasic70(3); Tbasic70(4); ...
            Tbasic12(5); Tbasic12(6); Tbasic12(7); Tbasic12(8); ...
            Tbasic70(5); Tbasic70(6); ...
            Tbasic12(9); Tbasic12(10); Tbasic12(11); Tbasic12(12)];

        B18 = Cp18 < reshape(T18,1,18);

        heightGroups18 = {1:6,7:12,13:18};

        pos18 = [1 3 5 7 9 11 13 15 17];
        neg18 = [2 4 6 8 10 12 14 16 18];

        [active18(r),occ18(r,:),SAI18(r)] = ...
            localMetrics(B18,heightGroups18,pos18,neg18);
    end
end

%% 8. BUILD MAIN METRICS TABLE

metricsTable = table( ...
    (1:nRe)',ReValues, ...
    active12,active90,active110, ...
    occ12(:,1),occ12(:,2),occ12(:,3), ...
    occ90(:,1),occ90(:,2),occ90(:,3), ...
    occ110(:,1),occ110(:,2),occ110(:,3), ...
    SAI12,SAI90,SAI110, ...
    'VariableNames',{ ...
    'ReCase','Re', ...
    'ActiveFraction_12tap','ActiveFraction_6tap_90','ActiveFraction_6tap_110', ...
    'Occ1D_12tap','Occ2D_12tap','Occ3p5D_12tap', ...
    'Occ1D_6tap_90','Occ2D_6tap_90','Occ3p5D_6tap_90', ...
    'Occ1D_6tap_110','Occ2D_6tap_110','Occ3p5D_6tap_110', ...
    'SAI_12tap','SAI_6tap_90','SAI_6tap_110'});

if use18
    metricsTable.ActiveFraction_18tap = active18;
    metricsTable.Occ1D_18tap = occ18(:,1);
    metricsTable.Occ2D_18tap = occ18(:,2);
    metricsTable.Occ3p5D_18tap = occ18(:,3);
    metricsTable.SAI_18tap = SAI18;
end

writetable(metricsTable, ...
    fullfile(outDir,'R1_spatial_sampling_metrics.csv'));

%% 9. AGREEMENT STATISTICS

agreementRows = {};

% 12-tap reference versus +/-90 subset
agreementRows = [agreementRows; ...
    localAgreementRows("12 tap vs 6 tap (+/-90)", ...
    active12,active90,occ12,occ90,SAI12,SAI90)];

% 12-tap reference versus +/-110 subset
agreementRows = [agreementRows; ...
    localAgreementRows("12 tap vs 6 tap (+/-110)", ...
    active12,active110,occ12,occ110,SAI12,SAI110)];

% Optional: direct higher-resolution comparison
if use18
    agreementRows = [agreementRows; ...
        localAgreementRows("18 tap vs 12 tap", ...
        active18,active12,occ18,occ12,SAI18,SAI12)];
end

agreementTable = cell2table(agreementRows, ...
    'VariableNames',{'Comparison','Metric','R','MAE','RMSE','MaxAbsDifference'});

writetable(agreementTable, ...
    fullfile(outDir,'R1_spatial_sampling_agreement.csv'));

fprintf('\nAGREEMENT SUMMARY\n');
disp(agreementTable);

%% 10. FIGURE 1 - NORMALIZED ACTIVE-TAP FRACTION (MARKER-ONLY)

f1 = figure('Color','w','Position',[100 100 950 600]);

plot(ReValues,active12,'o', ...
    'LineStyle','none','LineWidth',1.4,'MarkerSize',6);
hold on
plot(ReValues,active90,'s', ...
    'LineStyle','none','LineWidth',1.2,'MarkerSize',6);
plot(ReValues,active110,'^', ...
    'LineStyle','none','LineWidth',1.2,'MarkerSize',6);

if use18
    plot(ReValues,active18,'d', ...
        'LineStyle','none','LineWidth',1.2,'MarkerSize',6);
    legend('12 taps','6 taps: +/-90°','6 taps: +/-110°','18 taps', ...
        'Location','best');
else
    legend('12 taps','6 taps: +/-90°','6 taps: +/-110°', ...
        'Location','best');
end

grid on
box on
xlabel('Reynolds number')
ylabel('Mean active-tap fraction')
title('Spatial-sampling sensitivity of global low-C_p occupancy')

exportgraphics(f1, ...
    fullfile(outDir,'R1_spatial_sampling_active_fraction.pdf'), ...
    'ContentType','vector');

exportgraphics(f1, ...
    fullfile(outDir,'R1_spatial_sampling_active_fraction.png'), ...
    'Resolution',400);

%% 11. FIGURE 2 - HEIGHT-WISE OCCUPANCY (MARKER-ONLY)

f2 = figure('Color','w','Position',[100 80 950 850]);

heightLabels = {'z/D = 1','z/D = 2','z/D = 3.5'};

for h = 1:3

    subplot(3,1,h)

    plot(ReValues,occ12(:,h),'o', ...
        'LineStyle','none','LineWidth',1.3,'MarkerSize',5);
    hold on
    plot(ReValues,occ90(:,h),'s', ...
        'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
    plot(ReValues,occ110(:,h),'^', ...
        'LineStyle','none','LineWidth',1.1,'MarkerSize',5);

    if use18
        plot(ReValues,occ18(:,h),'d', ...
            'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
    end

    grid on
    box on
    ylabel('State-1 occupancy')
    title(heightLabels{h})

    if h == 3
        xlabel('Reynolds number')
    end
end

if use18
    legend('12 taps','6 taps: +/-90°','6 taps: +/-110°','18 taps', ...
        'Location','best');
else
    legend('12 taps','6 taps: +/-90°','6 taps: +/-110°', ...
        'Location','best');
end

exportgraphics(f2, ...
    fullfile(outDir,'R1_spatial_sampling_height_occupancy.pdf'), ...
    'ContentType','vector');

exportgraphics(f2, ...
    fullfile(outDir,'R1_spatial_sampling_height_occupancy.png'), ...
    'Resolution',400);

%% 12. FIGURE 3 - SIDE-ASYMMETRY INDEX (MARKER-ONLY)

f3 = figure('Color','w','Position',[100 100 950 600]);

plot(ReValues,SAI12,'o', ...
    'LineStyle','none','LineWidth',1.3,'MarkerSize',5);
hold on
plot(ReValues,SAI90,'s', ...
    'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
plot(ReValues,SAI110,'^', ...
    'LineStyle','none','LineWidth',1.1,'MarkerSize',5);

if use18
    plot(ReValues,SAI18,'d', ...
        'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
    legend('12 taps','6 taps: +/-90°','6 taps: +/-110°','18 taps', ...
        'Location','best');
else
    legend('12 taps','6 taps: +/-90°','6 taps: +/-110°', ...
        'Location','best');
end

yline(0,'-','HandleVisibility','off');
grid on
box on
xlabel('Reynolds number')
ylabel('Side-asymmetry index, SAI')
title('Spatial-sampling sensitivity of record-averaged side asymmetry')

exportgraphics(f3, ...
    fullfile(outDir,'R1_spatial_sampling_SAI.pdf'), ...
    'ContentType','vector');

exportgraphics(f3, ...
    fullfile(outDir,'R1_spatial_sampling_SAI.png'), ...
    'Resolution',400);

%% 13. FIGURE 4 - ABSOLUTE DEVIATION FROM 12-TAP REFERENCE (MARKER-ONLY)

f4 = figure('Color','w','Position',[100 100 950 750]);

subplot(3,1,1)
plot(ReValues,abs(active90-active12),'s', ...
    'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
hold on
plot(ReValues,abs(active110-active12),'^', ...
    'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
if use18
    plot(ReValues,abs(active18-active12),'d', ...
        'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
end
grid on
ylabel('|Delta active fraction|')
title('Difference relative to the manuscript 12-tap characterization')

subplot(3,1,2)

heightDev90 = mean(abs(occ90-occ12),2);
heightDev110 = mean(abs(occ110-occ12),2);

plot(ReValues,heightDev90,'s', ...
    'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
hold on
plot(ReValues,heightDev110,'^', ...
    'LineStyle','none','LineWidth',1.1,'MarkerSize',5);

if use18
    heightDev18 = mean(abs(occ18-occ12),2);
    plot(ReValues,heightDev18,'d', ...
        'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
end

grid on
ylabel('Mean |Delta occupancy|')

subplot(3,1,3)
plot(ReValues,abs(SAI90-SAI12),'s', ...
    'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
hold on
plot(ReValues,abs(SAI110-SAI12),'^', ...
    'LineStyle','none','LineWidth',1.1,'MarkerSize',5);

if use18
    plot(ReValues,abs(SAI18-SAI12),'d', ...
        'LineStyle','none','LineWidth',1.1,'MarkerSize',5);
end

grid on
xlabel('Reynolds number')
ylabel('|Delta SAI|')

if use18
    legend('6 taps: +/-90°','6 taps: +/-110°','18 taps', ...
        'Location','best');
else
    legend('6 taps: +/-90°','6 taps: +/-110°', ...
        'Location','best');
end

exportgraphics(f4, ...
    fullfile(outDir,'R1_spatial_sampling_deviation.pdf'), ...
    'ContentType','vector');

exportgraphics(f4, ...
    fullfile(outDir,'R1_spatial_sampling_deviation.png'), ...
    'Resolution',400);

%% 14. WRITE REVIEWER-READY TEXT SUMMARY

summaryFile = fullfile(outDir,'R1_spatial_sampling_reviewer_summary.txt');
fid = fopen(summaryFile,'w');

fprintf(fid,'AT-BM spatial-sampling sensitivity summary\n');
fprintf(fid,'=========================================\n\n');
fprintf(fid,'Dataset: %d Reynolds-number cases, %d samples per case.\n\n', ...
    nRe,nSample);

fprintf(fid,'Controlled subsampling tests:\n');
fprintf(fid,'  Full manuscript configuration: 12 taps (+/-90 and +/-110 deg)\n');
fprintf(fid,'  Reduced configuration A:       6 taps (+/-90 deg only)\n');
fprintf(fid,'  Reduced configuration B:       6 taps (+/-110 deg only)\n\n');

for i = 1:height(agreementTable)
    fprintf(fid,'%s | %s\n', ...
        agreementTable.Comparison{i}, ...
        agreementTable.Metric{i});
    fprintf(fid,'  r = %.6f\n',agreementTable.R(i));
    fprintf(fid,'  MAE = %.6f\n',agreementTable.MAE(i));
    fprintf(fid,'  RMSE = %.6f\n',agreementTable.RMSE(i));
    fprintf(fid,'  Max absolute difference = %.6f\n\n', ...
        agreementTable.MaxAbsDifference(i));
end

if use18
    fprintf(fid,['The optional higher-resolution 18-tap comparison was run using ' ...
                 'reviewed +/-70-deg operational thresholds supplied in Tbasic70.\n\n']);
else
    fprintf(fid,['The optional 18-tap comparison was not run because complete reviewed ' ...
                 '+/-70-deg operational thresholds were not supplied. No thresholds ' ...
                 'were inferred or invented by this script.\n\n']);
end

fprintf(fid,['Interpretation: The controlled subsampling analysis estimates how ' ...
             'sensitive the principal Reynolds-number-dependent pressure-state ' ...
             'metrics are to a reduction in tap density. Agreement should be ' ...
             'discussed using the reported correlations and absolute deviations. ' ...
             'This test does not imply that the 12-tap array resolves every local ' ...
             'instantaneous flow feature.\n']);

fclose(fid);

%% 15. SAVE RESULTS

save(fullfile(outDir,'R1_spatial_sampling_results.mat'), ...
    'ReValues','Tbasic12','tapNames12', ...
    'active12','active90','active110', ...
    'occ12','occ90','occ110', ...
    'SAI12','SAI90','SAI110', ...
    'metricsTable','agreementTable','use18', ...
    '-v7.3');

if use18
    save(fullfile(outDir,'R1_spatial_sampling_results.mat'), ...
        'active18','occ18','SAI18','Tbasic70', ...
        '-append');
end

fprintf('\n============================================================\n');
fprintf('SPATIAL-SAMPLING ANALYSIS COMPLETE\n');
fprintf('Output folder:\n  %s\n',fullfile(pwd,outDir));
fprintf('============================================================\n');

%% ========================================================================
% LOCAL FUNCTIONS
% =========================================================================

function [activeFraction,heightOcc,SAI] = ...
    localMetrics(B,heightGroups,posIdx,negIdx)

    % B is [Nsample x Ntap] logical.

    % Mean normalized number of active taps.
    activeFraction = mean(sum(B,2)/size(B,2),'omitnan');

    % Height-wise occupancy.
    heightOcc = nan(1,numel(heightGroups));

    for h = 1:numel(heightGroups)
        Bh = B(:,heightGroups{h});
        heightOcc(h) = mean(Bh(:),'omitnan');
    end

    % Side-asymmetry index using manuscript definition.
    Nplus = sum(B(:,posIdx),2);
    Nminus = sum(B(:,negIdx),2);

    den = Nplus + Nminus;
    inst = zeros(size(den));

    idx = den > 0;
    inst(idx) = (Nplus(idx)-Nminus(idx))./den(idx);

    SAI = mean(inst,'omitnan');
end

function rows = localAgreementRows(label,activeRef,activeTest,occRef,occTest,SAIRef,SAITest)

    rows = cell(3,6);

    [r,mae,rmse,mx] = localAgreement(activeRef,activeTest);
    rows(1,:) = {char(label),'Active fraction',r,mae,rmse,mx};

    % Pool the three height-wise occupancy curves because all values have
    % the same physical meaning and scale.
    [r,mae,rmse,mx] = localAgreement(occRef(:),occTest(:));
    rows(2,:) = {char(label),'Height-wise occupancy',r,mae,rmse,mx};

    [r,mae,rmse,mx] = localAgreement(SAIRef,SAITest);
    rows(3,:) = {char(label),'SAI',r,mae,rmse,mx};
end

function [r,mae,rmse,mx] = localAgreement(x,y)

    x = double(x(:));
    y = double(y(:));

    idx = isfinite(x) & isfinite(y);
    x = x(idx);
    y = y(idx);

    if isempty(x)
        r = NaN;
        mae = NaN;
        rmse = NaN;
        mx = NaN;
        return;
    end

    d = y-x;

    mae = mean(abs(d));
    rmse = sqrt(mean(d.^2));
    mx = max(abs(d));

    if numel(x) >= 2 && std(x) > 0 && std(y) > 0
        C = corrcoef(x,y);
        r = C(1,2);
    else
        r = NaN;
    end
end
