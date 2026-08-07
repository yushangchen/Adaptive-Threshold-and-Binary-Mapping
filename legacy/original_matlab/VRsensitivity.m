%% ===================== VR sensitivity: ALL 18 taps × 49 Re =====================
% OUTPUTS:
%   (1) SummaryByVR: total counts across all taps & Re for each VR_thr
%   (2) TapDistribution: per-tap counts (mode1/mode2/mode0) for each VR_thr
%
% MODE definition (matches your main code):
%   mode=1 : bimodal-separated -> two thresholds (TL/TR) [useTwo == true]
%   mode=2 : bimodal-overlapped -> single valley threshold (Tv) [useTwo == false]
%   mode=0 : <2 peaks detected -> treat as unimodal / not-bimodal
%
% REQUIRE:
%   - alldata: 1x18 cell, each cell is [Ntime x 49]
%   - tapNames: 1x18 cellstr (optional, for nicer tables)

%% -------- USER SETTINGS --------
VR_thr_list = [0.6 0.7 0.8];  % the VR thresholds to compare
SR_thr      = 1.5;            % same as your code
binWidth    = 0.05;           % choose ONE standard binwidth for this VR study
support     = [-3.4 0];       % same as your code edges range
smoothWin   = 1;              % keep 1 to avoid adding extra smoothing assumptions

minProm     = 0.05;           % same as your code
minDistBin  = 3;              % same as your code (in BIN COUNT)
% -------------------------------

nTap = numel(alldata);
nVR  = numel(VR_thr_list);

% detect nRe (should be 49)
nRe = size(alldata{1}, 2);

% modeCube: [tap x Re x VR]
modeCube = nan(nTap, nRe, nVR);

% also store SR and valleyRatio if you want to inspect later
SRcube = nan(nTap, nRe, nVR);
VRcube = nan(nTap, nRe, nVR); % valleyRatio

% common histogram grid (fixed support + fixed binwidth)
edges   = support(1):binWidth:support(2);
centers = edges(1:end-1) + diff(edges(1:2))/2;
x = centers(:);
dx = x(2)-x(1);

%% ===================== MAIN LOOP =====================
for itap = 1:nTap
    dataloc = alldata{itap};   % [Ntime x nRe]

    for iRe = 1:nRe
        seg = dataloc(:, iRe);
        seg = seg(:);
        seg = seg(~isnan(seg));

        % PDF (Normalization='probability' exactly like your code)
        y = histcounts(seg, edges, 'Normalization','probability')';
        if smoothWin > 1
            y = movmean(y, smoothWin);
        end

        % peaks on histogram
        [pks, locs] = findpeaks(y, 'MinPeakProminence', max(y)*minProm, ...
                                   'MinPeakDistance',  minDistBin);

        if numel(locs) < 2
            % not bimodal (or detection failed) -> mode=0 for ALL VR_thr
            modeCube(itap, iRe, :) = 0;
            continue;
        end

        % pick two highest peaks, sort left/right by index
        [~,ord] = maxk(pks,2);
        locs2 = sort(locs(ord));
        iL = locs2(1); iR = locs2(2);

        yL = y(iL); yR = y(iR);

        % valley between peaks (discrete + quadratic refine like your code)
        [valY, rel] = min(y(iL:iR));
        kv = iL + rel - 1;
        valX = x(kv);

        if kv>1 && kv<numel(x)
            idx3 = (kv-1):(kv+1);
            p = polyfit(x(idx3), y(idx3), 2);
            if p(1)>0
                xv = -p(2)/(2*p(1));
                if xv>=x(idx3(1)) && xv<=x(idx3(3))
                    valX = xv;
                    valY = polyval(p, xv);
                end
            end
        end

        valleyRatio = valY / min(yL, yR);   % SAME as your code

        % SR (FWHM-based) - same as your code
        SR = calcSR_FWHM_inline(x, y, iL, iR);

        % fill SR/VR (same for all VR_thr, decision differs only by VR_thr)
        for iv = 1:nVR
            SRcube(itap, iRe, iv) = SR;
            VRcube(itap, iRe, iv) = valleyRatio;

            useTwo = (SR >= SR_thr) && (valleyRatio <= VR_thr_list(iv));
            if useTwo
                modeCube(itap, iRe, iv) = 1;
            else
                modeCube(itap, iRe, iv) = 2;
            end
        end
    end
end

%% ===================== SUMMARY BY VR (TOTAL) [MATLAB-compatible] =====================
% Make NaNs not count in comparisons
isM1 = (modeCube == 1); isM1(isnan(modeCube)) = false;
isM2 = (modeCube == 2); isM2(isnan(modeCube)) = false;
isM0 = (modeCube == 0); isM0(isnan(modeCube)) = false;
isNa = isnan(modeCube);

% sum over tap (dim1) and Re (dim2), keep VR (dim3)
Total_mode1 = squeeze(sum(sum(isM1, 1), 2));
Total_mode2 = squeeze(sum(sum(isM2, 1), 2));
Total_mode0 = squeeze(sum(sum(isM0, 1), 2));
Total_nan   = squeeze(sum(sum(isNa, 1), 2));

SummaryByVR = table(VR_thr_list(:), Total_mode1(:), Total_mode2(:), Total_mode0(:), Total_nan(:), ...
    'VariableNames', {'VR_thr','Total_mode1_TL_TR','Total_mode2_Tv','Total_mode0_unimodal','Total_nan'});

disp('=== Summary across ALL taps × Re ===');
disp(SummaryByVR);


%% ===================== PER-TAP DISTRIBUTION TABLE =====================
% Build a wide table:
%   columns like: m1_VR0p60, m2_VR0p60, m0_VR0p60, m1_VR0p70, ...
tapLabel = (1:nTap).';
if exist('tapNames','var') && numel(tapNames)==nTap
    TapName = string(tapNames(:));
else
    TapName = "Tap" + string(tapLabel);
end

TapDistribution = table(tapLabel, TapName, 'VariableNames',{'TapIdx','TapName'});

for iv = 1:nVR
    vr = VR_thr_list(iv);
    col_m1 = sum(modeCube(:,:,iv)==1, 2); col_m1 = col_m1(:);
    col_m2 = sum(modeCube(:,:,iv)==2, 2); col_m2 = col_m2(:);
    col_m0 = sum(modeCube(:,:,iv)==0, 2); col_m0 = col_m0(:);

    % column names without dot (MATLAB table varname)
    tag = strrep(sprintf('VR%.2f', vr), '.', 'p');  % e.g. VR0p60
    TapDistribution.(['m1_' tag]) = col_m1;
    TapDistribution.(['m2_' tag]) = col_m2;
    TapDistribution.(['m0_' tag]) = col_m0;
end

disp('=== Per-tap distribution (counts across 49 Re) ===');
disp(TapDistribution);

%% ===================== OPTIONAL: "flip" diagnostics =====================
% Which (tap,Re) change classification between VR=0.6 and VR=0.8?
if nVR >= 2
    ivA = 1;
    ivB = nVR;
    flipMask = modeCube(:,:,ivA) ~= modeCube(:,:,ivB);
    [tapFlip, reFlip] = find(flipMask);

    fprintf('Flip count between VR=%.2f and VR=%.2f: %d cases\n', ...
        VR_thr_list(ivA), VR_thr_list(ivB), numel(tapFlip));

    % show first 30 flips
    nShow = min(30, numel(tapFlip));
    if nShow > 0
        fprintf('First %d flips (TapIdx, ReIdx, mode@VR%.2f -> mode@VR%.2f):\n', ...
            nShow, VR_thr_list(ivA), VR_thr_list(ivB));
        for k = 1:nShow
            t = tapFlip(k); r = reFlip(k);
            fprintf('  (%2d, %2d): %d -> %d\n', t, r, modeCube(t,r,ivA), modeCube(t,r,ivB));
        end
    end
end

%% ===================== INLINE HELPER (NO extra files) =====================
function SR = calcSR_FWHM_inline(x, y, iLpk, iRpk)
% SR = peak separation / mean FWHM, identical logic to your main code
    dx = x(2)-x(1);

    yLpk = y(iLpk);
    yRpk = y(iRpk);

    halfL = 0.5*yLpk;
    halfR = 0.5*yRpk;

    % left peak FWHM
    iLL = find(y(1:iLpk) < halfL, 1, 'last');
    if ~isempty(iLL) && iLL<iLpk
        xLL = interp1(y(iLL:iLL+1), x(iLL:iLL+1), halfL);
    else
        xLL = x(1);
    end
    iLR = find(y(iLpk:end) < halfL, 1, 'first');
    if ~isempty(iLR)
        iLR = iLpk + iLR - 1;
        xLR = interp1(y(iLR-1:iLR), x(iLR-1:iLR), halfL);
    else
        xLR = x(end);
    end
    FWHM_L = max(0, xLR - xLL);

    % right peak FWHM
    iRL = find(y(1:iRpk) < halfR, 1, 'last');
    if ~isempty(iRL) && iRL<iRpk
        xRL = interp1(y(iRL:iRL+1), x(iRL:iRL+1), halfR);
    else
        xRL = x(1);
    end
    iRR = find(y(iRpk:end) < halfR, 1, 'first');
    if ~isempty(iRR)
        iRR = iRpk + iRR - 1;
        xRR = interp1(y(iRR-1:iRR), x(iRR-1:iRR), halfR);
    else
        xRR = x(end);
    end
    FWHM_R = max(0, xRR - xRL);

    meanFWHM = max(dx, mean([FWHM_L, FWHM_R]));
    peakSep  = x(iRpk) - x(iLpk);
    SR = peakSep / meanFWHM;
end
