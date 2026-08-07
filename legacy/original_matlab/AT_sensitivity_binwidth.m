%% Appendix A - Sensitivity test (3-panel figure)  [SINGLE SCRIPT, no extra files]
% (a) Unimodal: TL/TR vs bin width + ±5%/±10% IQR bands
% (b) Bimodal-separated: TL/TR vs bin width + ±5%/±10% IQR bands
% (c) Bimodal-overlapped: Tv vs bin width + ±5%/±10% IQR bands
%
% Key fixes in this version:
% 1) refIdx is defined ONCE (and correctly points to ΔCp=0.04 when binWidths=[0.02 0.03 0.04 0.05 0.06])
% 2) Overlapped (c) uses:
%    - reference peak indices from ref binwidth
%    - a COMMON x-grid (xr) via interpolation for all binwidths
%    - ROBUST valley estimator (windowed minimum + centroid) to suppress 1-bin artifacts
%    - MinPeakDistance in (c) tied to Cp-scale (converted to bin count at ref binwidth)
%
% This keeps the core AT logic consistent with your main code:
% - PDF from histcounts(...,'Normalization','probability')
% - dist2line is point-to-line distance
% - peak picking uses prominence & bin-distance
% - valley is discrete min + quadratic refine (kept), but valley LOCATION is stabilized in (c)

%% -------------------- USER INPUTS --------------------
binWidths = [0.02 0.03 0.04 0.05 0.06];   % ΔCp set
refIdx    = 3;                            % <-- ΔCp = 0.04 is the 3rd element here
smoothWin = 2;                            % 1 = no smoothing (fairness); you may use 3~7 if needed

% --- Threshold admissibility (same as your paper code) ---
SR_thr = 1.5;
VR_thr = 0.80;                            % valleyRatio threshold (smaller => deeper valley)

% --- Select representative signals (replace as needed) ---
Cp_uni = Cpp90_2D(:,7);
Cp_sep = Cpp90_2D(:,25);
Cp_ovl = Cpp110_1D(:,35);

%% -------------------- PREP DATA --------------------
Cp_uni = Cp_uni(:); Cp_uni = Cp_uni(~isnan(Cp_uni));
Cp_sep = Cp_sep(:); Cp_sep = Cp_sep(~isnan(Cp_sep));
Cp_ovl = Cp_ovl(:); Cp_ovl = Cp_ovl(~isnan(Cp_ovl));

supportPad = 0.0;
support_uni = [min(Cp_uni)-supportPad, max(Cp_uni)+supportPad];
support_sep = [min(Cp_sep)-supportPad, max(Cp_sep)+supportPad];
support_ovl = [min(Cp_ovl)-supportPad, max(Cp_ovl)+supportPad];

IQR_uni = iqr(Cp_uni);
IQR_sep = iqr(Cp_sep);
IQR_ovl = iqr(Cp_ovl);

%% -------------------- STORAGE --------------------
TL_uni = nan(size(binWidths)); TR_uni = nan(size(binWidths)); mode_uni = nan(size(binWidths));
TL_sep = nan(size(binWidths)); TR_sep = nan(size(binWidths)); mode_sep = nan(size(binWidths));
Tv_ovl = nan(size(binWidths));                 mode_ovl = nan(size(binWidths));

SR_sep = nan(size(binWidths)); valleyRatio_sep = nan(size(binWidths));
SR_ovl = nan(size(binWidths)); valleyRatio_ovl = nan(size(binWidths));

%% -------------------- COMMON SETTINGS (match your main code) --------------------
dist2line = @(x1,y1,x2,y2,xq,yq) ...
    abs((y2-y1).*xq - (x2-x1).*yq + (x2*y1 - y2*x1)) ./ hypot(y2-y1, x2-x1);

minProm    = 0.05;   % for (a)(b): same as your main code
minDistBin = 3;      % minimum peak distance in BIN COUNT (same as your main code)

%% ========================================================================
% (a) UNIMODAL  +  (b) BIMODAL-SEPARATED  (loop over binWidths)
% ========================================================================
for k = 1:numel(binWidths)
    bw = binWidths(k);

    % ---------- (a) UNIMODAL (force unimodal extraction) ----------
    [x, y] = makePDF_prob(Cp_uni, bw, support_uni, smoothWin);
    [~, ip] = max(y);
    xP = x(ip); yP = y(ip);

    % left knee (endpoint -> peak)
    idL = 1:ip;
    DL = dist2line(x(idL(1)),y(idL(1)), xP,yP, x(idL),y(idL));
    [~, kL] = max(DL);
    TL_uni(k) = x(idL(kL));

    % right knee (peak -> endpoint)
    idR = ip:numel(x);
    DR = dist2line(xP,yP, x(idR(end)),y(idR(end)), x(idR),y(idR));
    [~, kR] = max(DR);
    TR_uni(k) = x(idR(kR));

    mode_uni(k) = 0;

    % ---------- (b) BIMODAL-sep (apply your SR/valleyRatio gate) ----------
    [x, y] = makePDF_prob(Cp_sep, bw, support_sep, smoothWin);

    [pks, locs] = findpeaks(y, 'MinPeakProminence', max(y)*minProm, ...
                               'MinPeakDistance',  minDistBin);

    if numel(locs) < 2
        % fallback: treat as unimodal
        [~, ip] = max(y);
        xP = x(ip); yP = y(ip);
        idL = 1:ip; DL = dist2line(x(idL(1)),y(idL(1)), xP,yP, x(idL),y(idL));
        [~, kL] = max(DL); TL_sep(k) = x(idL(kL));
        idR = ip:numel(x); DR = dist2line(xP,yP, x(idR(end)),y(idR(end)), x(idR),y(idR));
        [~, kR] = max(DR); TR_sep(k) = x(idR(kR));
        mode_sep(k) = 0;
        SR_sep(k) = NaN; valleyRatio_sep(k) = NaN;
    else
        % take 2 highest peaks, sort by x-index
        [~, ord] = maxk(pks, 2);
        locs2 = sort(locs(ord));
        iLpk = locs2(1); iRpk = locs2(2);
        xLpk = x(iLpk); yLpk = y(iLpk);
        xRpk = x(iRpk); yRpk = y(iRpk);

        % valley (discrete + quadratic refine)
        [valY, rel] = min(y(iLpk:iRpk));
        kv = iLpk + rel - 1;
        valX = x(kv);

        if kv > 1 && kv < numel(x)
            idx3 = (kv-1):(kv+1);
            p = polyfit(x(idx3), y(idx3), 2);
            if p(1) > 0
                xv = -p(2)/(2*p(1));
                if xv >= x(idx3(1)) && xv <= x(idx3(3))
                    valX = xv;
                    valY = polyval(p, xv);
                end
            end
        end

        valleyRatio = valY / min(yLpk, yRpk); % same as your code
        [SR, ~] = calcSR_FWHM(x, y, iLpk, iRpk);

        SR_sep(k) = SR;
        valleyRatio_sep(k) = valleyRatio;

        useTwo = (SR >= SR_thr) && (valleyRatio <= VR_thr);

        if useTwo
            % TL: max dist to chord (valley <-> left peak), exclude endpoints
            idL = iLpk:kv; if xLpk > valX, idL = kv:iLpk; end
            xLs = x(idL); yLs = y(idL);
            DL = dist2line(valX,valY, xLpk,yLpk, xLs,yLs);
            if numel(DL) >= 3, DL([1 end]) = -Inf; end
            [~, kL] = max(DL);
            TL_sep(k) = xLs(kL);

            % TR: max dist to chord (valley <-> right peak), exclude endpoints
            idR = kv:iRpk; if valX > xRpk, idR = iRpk:kv; end
            xRs = x(idR); yRs = y(idR);
            DR = dist2line(valX,valY, xRpk,yRpk, xRs,yRs);
            if numel(DR) >= 3, DR([1 end]) = -Inf; end
            [~, kR] = max(DR);
            TR_sep(k) = xRs(kR);

            mode_sep(k) = 1; % bimodal-separated
        else
            % overlapped-like -> do not report TL/TR here
            TL_sep(k) = NaN;
            TR_sep(k) = NaN;
            mode_sep(k) = 2;
        end
    end
end

%% ========================================================================
% (c) BIMODAL-OVERLAPPED: Tv vs bin width  (RUN ONCE OUTSIDE the loop)
% Stabilized by:
%  - reference peaks at ref binwidth
%  - common x-grid (xr) = ref centers
%  - robust valley estimator (windowed min + centroid)
% ========================================================================
minProm_ovl  = 0.02;
smoothWin_ovl = 7;

bw_ref = binWidths(refIdx);
[xr, yr] = makePDF_prob(Cp_ovl, bw_ref, support_ovl, smoothWin_ovl);

% IMPORTANT: MinPeakDistance tied to Cp-scale (convert to bin count at ref)
minPeakDistCp = 0.12;                      % <-- adjust if needed (0.08~0.15)
minDistBin_ovl = max(2, round(minPeakDistCp / bw_ref));

[pksr, locsr] = findpeaks(yr, 'MinPeakProminence', max(yr)*minProm_ovl, ...
                              'MinPeakDistance',  minDistBin_ovl);
if numel(locsr) < 2
    error('Overlapped ref: <2 peaks at ref binWidth. Change Cp_ovl or relax minProm_ovl/minDist settings.');
end

% take two highest peaks at reference -> lock their INDICES on xr
[~, ord] = maxk(pksr, 2);
locs2r = sort(locsr(ord));
iL_ref = locs2r(1);
iR_ref = locs2r(2);

% robust valley neighborhood half-width (in bins on xr)
mVal = 2;   % 2~3 recommended

for kk = 1:numel(binWidths)
    bw = binWidths(kk);

    [x, y] = makePDF_prob(Cp_ovl, bw, support_ovl, smoothWin_ovl);

    % interpolate to reference grid (common x-grid)
    yI = interp1(x, y, xr, 'linear', 0);

    if iL_ref >= iR_ref-2
        Tv_ovl(kk) = xr(round((iL_ref+iR_ref)/2));
        mode_ovl(kk) = 0;
        continue;
    end

    % ---- robust valley: windowed minimum + centroid (suppresses 1-bin artifacts) ----
    segY = yI(iL_ref:iR_ref);
    [~, rel0] = min(segY);
    kv0 = iL_ref + rel0 - 1;

    k1 = max(kv0-mVal, iL_ref);
    k2 = min(kv0+mVal, iR_ref);

    localY = yI(k1:k2);
    % weights emphasize deeper bins but avoid zero
    w = (max(localY) - localY) + 1e-12;   % deeper => larger weight
    x_local = xr(k1:k2);
    valX = sum(x_local(:).*w(:)) / sum(w(:));

    % quadratic refine around nearest grid point (optional, keep consistent with your style)
    [~, kv] = min(abs(xr - valX));
    if kv > 1 && kv < numel(xr)
        idx3 = (kv-1):(kv+1);
        p = polyfit(xr(idx3), yI(idx3), 2);
        if p(1) > 0
            xv = -p(2)/(2*p(1));
            if xv >= xr(idx3(1)) && xv <= xr(idx3(3))
                valX = xv;
            end
        end
    end

    Tv_ovl(kk) = valX;
    mode_ovl(kk) = 2;
end

%% -------------------- REFERENCE + IQR BANDS --------------------
TL_uni_ref = TL_uni(refIdx); TR_uni_ref = TR_uni(refIdx);
TL_sep_ref = TL_sep(refIdx); TR_sep_ref = TR_sep(refIdx);
Tv_ovl_ref = Tv_ovl(refIdx);

%% -------------------- PLOT --------------------
figure('Color','w','Position',[100 100 1300 520]);
tiledlayout(1,3,'Padding','compact','TileSpacing','compact');

% (a) Unimodal
nexttile; hold on; grid on; box on;
plot(binWidths, TL_uni, '-o', 'LineWidth', 1.8, 'DisplayName','TL');
plot(binWidths, TR_uni, '--s', 'LineWidth', 1.8, 'DisplayName','TR');
drawIQRbands(TL_uni_ref, IQR_uni);
drawIQRbands(TR_uni_ref, IQR_uni);
title('(a) Unimodal','FontWeight','bold');
xlabel('Bin width \Delta C_p'); ylabel('Threshold value');
legend('Location','best');

% (b) Bimodal-separated
nexttile; hold on; grid on; box on;
plot(binWidths, TL_sep, '-o', 'LineWidth', 1.8, 'DisplayName','TL');
plot(binWidths, TR_sep, '--s', 'LineWidth', 1.8, 'DisplayName','TR');
if ~isnan(TL_sep_ref), drawIQRbands(TL_sep_ref, IQR_sep); end
if ~isnan(TR_sep_ref), drawIQRbands(TR_sep_ref, IQR_sep); end
title('(b) Bimodal-separated','FontWeight','bold');
xlabel('Bin width \Delta C_p'); ylabel('Threshold value');
legend('Location','best');

% annotate mode changes
for k = 1:numel(binWidths)
    if mode_sep(k) ~= 1
        ytxt = nanmean([TL_sep_ref TR_sep_ref]);
        if isnan(ytxt), ytxt = nanmean([TL_uni_ref TR_uni_ref]); end
        text(binWidths(k), ytxt, sprintf('mode=%d', mode_sep(k)), ...
            'FontSize',9, 'HorizontalAlignment','center');
    end
end

% (c) Bimodal-overlapped
nexttile; hold on; grid on; box on;
plot(binWidths, Tv_ovl, '-d', 'LineWidth', 1.8, 'DisplayName','T_v (valley)');
drawIQRbands(Tv_ovl_ref, IQR_ovl);
title('(c) Bimodal-overlapped','FontWeight','bold');
xlabel('Bin width \Delta C_p'); ylabel('Threshold value');
legend('Location','best');

sgtitle('Appendix A: Sensitivity of AT thresholds to bin width','FontWeight','bold');

%% -------------------- OPTIONAL: PRINT DIAGNOSTICS --------------------
disp('--- Unimodal thresholds ---');
disp(table(binWidths(:), TL_uni(:), TR_uni(:), 'VariableNames',{'binWidth','TL','TR'}));

disp('--- Bimodal-separated diagnostics (Cp_sep) ---');
disp(table(binWidths(:), mode_sep(:), SR_sep(:), valleyRatio_sep(:), TL_sep(:), TR_sep(:), ...
    'VariableNames',{'binWidth','mode','SR','valleyRatio','TL','TR'}));

disp('--- Bimodal-overlapped diagnostics (Cp_ovl) ---');
disp(table(binWidths(:), mode_ovl(:), Tv_ovl(:), 'VariableNames',{'binWidth','mode','Tv'}));



%% ========================================================================
% 4.1.2 SR/VR cutoff sensitivity
% This section tests whether the bimodal-separated / overlapped decision
% is controlled by the exact SR_thr and VR_thr values.
%
% It keeps your representative variables:
% Cp_sep = Cpp90_2D(:,25);
% Cp_ovl = Cpp110_1D(:,35);
%
% Mode code:
% 0 = unimodal
% 1 = bimodal-separated
% 2 = bimodal-overlapped
%% ========================================================================

% --- relaxed / nominal / strict criteria ---
SR_set = SR_thr * [0.8 1.0 1.2];
VR_set = VR_thr * [0.8 1.0 1.2];

% Use reference bin width from your original setting
bw_ref = binWidths(refIdx);

% Storage
modeMap_sep = nan(numel(SR_set), numel(VR_set));
TLmap_sep   = nan(numel(SR_set), numel(VR_set));
TRmap_sep   = nan(numel(SR_set), numel(VR_set));
Tvmap_sep   = nan(numel(SR_set), numel(VR_set));
SRval_sep   = nan(numel(SR_set), numel(VR_set));
VRval_sep   = nan(numel(SR_set), numel(VR_set));

modeMap_ovl = nan(numel(SR_set), numel(VR_set));
TLmap_ovl   = nan(numel(SR_set), numel(VR_set));
TRmap_ovl   = nan(numel(SR_set), numel(VR_set));
Tvmap_ovl   = nan(numel(SR_set), numel(VR_set));
SRval_ovl   = nan(numel(SR_set), numel(VR_set));
VRval_ovl   = nan(numel(SR_set), numel(VR_set));

for ii = 1:numel(SR_set)
    for jj = 1:numel(VR_set)

        % ----- Bimodal-separated representative signal -----
        Rsep = extractAT_general( ...
            Cp_sep, bw_ref, support_sep, smoothWin, ...
            minProm, minDistBin, SR_set(ii), VR_set(jj));

        modeMap_sep(ii,jj) = Rsep.mode;
        TLmap_sep(ii,jj)   = Rsep.TL;
        TRmap_sep(ii,jj)   = Rsep.TR;
        Tvmap_sep(ii,jj)   = Rsep.Tv;
        SRval_sep(ii,jj)   = Rsep.SR;
        VRval_sep(ii,jj)   = Rsep.valleyRatio;

        % ----- Bimodal-overlapped representative signal -----
        % For fairness, use the same general AT decision here.
        % The special robust Tv estimator in your original section is still
        % used for the main bin-width figure.
        Rovl = extractAT_general( ...
            Cp_ovl, bw_ref, support_ovl, smoothWin_ovl, ...
            minProm_ovl, minDistBin_ovl, SR_set(ii), VR_set(jj));

        modeMap_ovl(ii,jj) = Rovl.mode;
        TLmap_ovl(ii,jj)   = Rovl.TL;
        TRmap_ovl(ii,jj)   = Rovl.TR;
        Tvmap_ovl(ii,jj)   = Rovl.Tv;
        SRval_ovl(ii,jj)   = Rovl.SR;
        VRval_ovl(ii,jj)   = Rovl.valleyRatio;
    end
end

%% -------------------- PLOT SR/VR SENSITIVITY --------------------
figure('Color','w','Position',[100 100 1100 450]);
tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

% ----- Cp_sep -----
nexttile; hold on; box on;
imagesc(VR_set, SR_set, modeMap_sep);
set(gca,'YDir','normal');
xlabel('VR cutoff');
ylabel('SR cutoff');
title('(a) Bimodal-separated case','FontWeight','bold');
caxis([0 2]);
cb = colorbar;
cb.Ticks = [0 1 2];
cb.TickLabels = {'Unimodal','Separated','Overlapped'};

plot(VR_thr, SR_thr, 'kp', 'MarkerSize', 12, ...
    'MarkerFaceColor','w', 'LineWidth',1.2);

for ii = 1:numel(SR_set)
    for jj = 1:numel(VR_set)
        text(VR_set(jj), SR_set(ii), num2str(modeMap_sep(ii,jj)), ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle', ...
            'FontWeight','bold', ...
            'Color','k');
    end
end

% ----- Cp_ovl -----
nexttile; hold on; box on;
imagesc(VR_set, SR_set, modeMap_ovl);
set(gca,'YDir','normal');
xlabel('VR cutoff');
ylabel('SR cutoff');
title('(b) Bimodal-overlapped case','FontWeight','bold');
caxis([0 2]);
cb = colorbar;
cb.Ticks = [0 1 2];
cb.TickLabels = {'Unimodal','Separated','Overlapped'};

plot(VR_thr, SR_thr, 'kp', 'MarkerSize', 12, ...
    'MarkerFaceColor','w', 'LineWidth',1.2);

for ii = 1:numel(SR_set)
    for jj = 1:numel(VR_set)
        text(VR_set(jj), SR_set(ii), num2str(modeMap_ovl(ii,jj)), ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle', ...
            'FontWeight','bold', ...
            'Color','k');
    end
end

sgtitle('Sensitivity of PDF modality decision to SR/VR criteria', ...
    'FontWeight','bold');

%% -------------------- PRINT SR/VR DIAGNOSTICS --------------------
disp('--- SR/VR cutoff sensitivity: Cp_sep ---');
disp('Mode code: 0 = unimodal, 1 = bimodal-separated, 2 = bimodal-overlapped');
for ii = 1:numel(SR_set)
    for jj = 1:numel(VR_set)
        fprintf('Cp_sep | SRcut=%.3f, VRcut=%.3f -> mode=%d, SR=%.3f, VR=%.3f, TL=%.4f, TR=%.4f, Tv=%.4f\n', ...
            SR_set(ii), VR_set(jj), modeMap_sep(ii,jj), ...
            SRval_sep(ii,jj), VRval_sep(ii,jj), ...
            TLmap_sep(ii,jj), TRmap_sep(ii,jj), Tvmap_sep(ii,jj));
    end
end

disp('--- SR/VR cutoff sensitivity: Cp_ovl ---');
disp('Mode code: 0 = unimodal, 1 = bimodal-separated, 2 = bimodal-overlapped');
for ii = 1:numel(SR_set)
    for jj = 1:numel(VR_set)
        fprintf('Cp_ovl | SRcut=%.3f, VRcut=%.3f -> mode=%d, SR=%.3f, VR=%.3f, TL=%.4f, TR=%.4f, Tv=%.4f\n', ...
            SR_set(ii), VR_set(jj), modeMap_ovl(ii,jj), ...
            SRval_ovl(ii,jj), VRval_ovl(ii,jj), ...
            TLmap_ovl(ii,jj), TRmap_ovl(ii,jj), Tvmap_ovl(ii,jj));
    end
end

% %% ========================================================================
% % 4.1.3 Time-window repeatability
% % This section tests whether AT-derived thresholds are stable when the
% % pressure record is divided into independent time windows.
% %
% % Representative signals:
% % Cp_uni, Cp_sep, Cp_ovl
% %% ========================================================================
% 
% Fs = 1000;                 % sampling frequency [Hz]
% winSec = 20;               % 30 s window
% winN = Fs * winSec;
% 
% % Use reference bin width and nominal criteria
% bw_ref = binWidths(refIdx);
% 
% % --------- prepare cases ---------
% caseName = {'Unimodal', 'Bimodal-separated', 'Bimodal-overlapped'};
% caseCp   = {Cp_uni, Cp_sep, Cp_ovl};
% caseSup  = {support_uni, support_sep, support_ovl};
% caseSmooth = [smoothWin, smoothWin, smoothWin_ovl];
% caseProm   = [minProm, minProm, minProm_ovl];
% caseDist   = [minDistBin, minDistBin, minDistBin_ovl];
% 
% % Storage as structure
% winResult = struct();
% 
% for cc = 1:3
% 
%     Cp_now = caseCp{cc};
%     support_now = caseSup{cc};
% 
%     N = numel(Cp_now);
%     nWin = floor(N / winN);
% 
%     TL_w = nan(nWin,1);
%     TR_w = nan(nWin,1);
%     Tv_w = nan(nWin,1);
%     mode_w = nan(nWin,1);
%     SR_w = nan(nWin,1);
%     VR_w = nan(nWin,1);
% 
%     % full-record reference
%     Rfull = extractAT_general( ...
%         Cp_now, bw_ref, support_now, caseSmooth(cc), ...
%         caseProm(cc), caseDist(cc), SR_thr, VR_thr);
% 
%     for ww = 1:nWin
% 
%         idx1 = (ww-1)*winN + 1;
%         idx2 = ww*winN;
% 
%         Cp_win = Cp_now(idx1:idx2);
% 
%         Rw = extractAT_general( ...
%             Cp_win, bw_ref, support_now, caseSmooth(cc), ...
%             caseProm(cc), caseDist(cc), SR_thr, VR_thr);
% 
%         TL_w(ww) = Rw.TL;
%         TR_w(ww) = Rw.TR;
%         Tv_w(ww) = Rw.Tv;
%         mode_w(ww) = Rw.mode;
%         SR_w(ww) = Rw.SR;
%         VR_w(ww) = Rw.valleyRatio;
%     end
% 
%     winResult(cc).name = caseName{cc};
%     winResult(cc).TL = TL_w;
%     winResult(cc).TR = TR_w;
%     winResult(cc).Tv = Tv_w;
%     winResult(cc).mode = mode_w;
%     winResult(cc).SR = SR_w;
%     winResult(cc).VR = VR_w;
% 
%     winResult(cc).TL_full = Rfull.TL;
%     winResult(cc).TR_full = Rfull.TR;
%     winResult(cc).Tv_full = Rfull.Tv;
%     winResult(cc).mode_full = Rfull.mode;
%     winResult(cc).SR_full = Rfull.SR;
%     winResult(cc).VR_full = Rfull.valleyRatio;
% end
% 
% %% -------------------- PLOT TIME-WINDOW REPEATABILITY --------------------
% figure('Color','w','Position',[100 100 1300 480]);
% tiledlayout(1,3,'Padding','compact','TileSpacing','compact');
% 
% for cc = 1:3
% 
%     nexttile; hold on; grid on; box on;
% 
%     nWin = numel(winResult(cc).mode);
%     xw = 1:nWin;
% 
%     switch cc
%         case 1
%             % Unimodal: TL/TR
%             plot(xw, winResult(cc).TL, '-o', 'LineWidth', 1.8, ...
%                 'DisplayName','T_L windows');
%             plot(xw, winResult(cc).TR, '--s', 'LineWidth', 1.8, ...
%                 'DisplayName','T_R windows');
% 
%             yline(winResult(cc).TL_full, '-', 'T_L full', ...
%                 'LineWidth',1.2, 'HandleVisibility','off');
%             yline(winResult(cc).TR_full, '--', 'T_R full', ...
%                 'LineWidth',1.2, 'HandleVisibility','off');
% 
%         case 2
%             % Bimodal-separated: TL/TR
%             plot(xw, winResult(cc).TL, '-o', 'LineWidth', 1.8, ...
%                 'DisplayName','T_L windows');
%             plot(xw, winResult(cc).TR, '--s', 'LineWidth', 1.8, ...
%                 'DisplayName','T_R windows');
% 
%             yline(winResult(cc).TL_full, '-', 'T_L full', ...
%                 'LineWidth',1.2, 'HandleVisibility','off');
%             yline(winResult(cc).TR_full, '--', 'T_R full', ...
%                 'LineWidth',1.2, 'HandleVisibility','off');
% 
%         case 3
%             % Bimodal-overlapped: Tv
%             plot(xw, winResult(cc).Tv, '-d', 'LineWidth', 1.8, ...
%                 'DisplayName','T_v windows');
% 
%             yline(winResult(cc).Tv_full, '-', 'T_v full', ...
%                 'LineWidth',1.2, 'HandleVisibility','off');
%     end
% 
%     xlabel(sprintf('Window index (%d s)', winSec));
%     ylabel('Threshold value');
%     title(sprintf('(%c) %s', char('a'+cc-1), winResult(cc).name), ...
%         'FontWeight','bold');
%     legend('Location','best');
% end
% 
% sgtitle('Time-window repeatability of AT-derived thresholds', ...
%     'FontWeight','bold');
% 
% %% -------------------- PRINT TIME-WINDOW DIAGNOSTICS --------------------
% for cc = 1:3
% 
%     fprintf('\n--- Time-window repeatability: %s ---\n', winResult(cc).name);
%     fprintf('Full record: mode=%d, TL=%.4f, TR=%.4f, Tv=%.4f, SR=%.3f, VR=%.3f\n', ...
%         winResult(cc).mode_full, winResult(cc).TL_full, ...
%         winResult(cc).TR_full, winResult(cc).Tv_full, ...
%         winResult(cc).SR_full, winResult(cc).VR_full);
% 
%     T_win = table( ...
%         (1:numel(winResult(cc).mode))', ...
%         winResult(cc).mode(:), ...
%         winResult(cc).SR(:), ...
%         winResult(cc).VR(:), ...
%         winResult(cc).TL(:), ...
%         winResult(cc).TR(:), ...
%         winResult(cc).Tv(:), ...
%         'VariableNames', {'window','mode','SR','VR','TL','TR','Tv'} );
% 
%     disp(T_win);
% 
%     fprintf('TL mean/std = %.4f / %.4f\n', ...
%         mean(winResult(cc).TL,'omitnan'), std(winResult(cc).TL,'omitnan'));
%     fprintf('TR mean/std = %.4f / %.4f\n', ...
%         mean(winResult(cc).TR,'omitnan'), std(winResult(cc).TR,'omitnan'));
%     fprintf('Tv mean/std = %.4f / %.4f\n', ...
%         mean(winResult(cc).Tv,'omitnan'), std(winResult(cc).Tv,'omitnan'));
% end

%% ========================================================================
% 4.1.3 Bootstrap repeatability of AT-derived thresholds
% This test evaluates sampling robustness, not temporal stationarity.
%
% Each bootstrap realization randomly resamples a fraction of the full record
% and recomputes AT-derived thresholds.
%
% Representative signals:
% (a) Cp_uni : unimodal
% (b) Cp_sep : bimodal-separated
% (c) Cp_ovl : bimodal-overlapped
%% ========================================================================

rng(1);                         % fixed seed for reproducibility
nBoot = 200;                    % number of bootstrap realizations
sampleFrac = 0.80;              % use 80% of samples each time
bw_ref = binWidths(refIdx);     % reference bin width

% Storage
TL_uni_boot = nan(nBoot,1);
TR_uni_boot = nan(nBoot,1);
mode_uni_boot = nan(nBoot,1);

TL_sep_boot = nan(nBoot,1);
TR_sep_boot = nan(nBoot,1);
Tv_sep_boot = nan(nBoot,1);
mode_sep_boot = nan(nBoot,1);

Tv_ovl_boot = nan(nBoot,1);
mode_ovl_boot = nan(nBoot,1);

%% -------------------- Full-record references --------------------

% Unimodal full-record reference
R_uni_full = extractAT_general( ...
    Cp_uni, bw_ref, support_uni, smoothWin, ...
    minProm, minDistBin, SR_thr, VR_thr);

% Bimodal-separated full-record reference
R_sep_full = extractAT_general( ...
    Cp_sep, bw_ref, support_sep, smoothWin, ...
    minProm, minDistBin, SR_thr, VR_thr);

% Bimodal-overlapped full-record reference
R_ovl_full = extractAT_general( ...
    Cp_ovl, bw_ref, support_ovl, smoothWin_ovl, ...
    minProm_ovl, minDistBin_ovl, SR_thr, VR_thr);

%% -------------------- Bootstrap loop --------------------

for bb = 1:nBoot

    % ===== Unimodal =====
    N = numel(Cp_uni);
    idx = randsample(N, round(sampleFrac*N), true);
    Cp_b = Cp_uni(idx);

    Rb = extractAT_general( ...
        Cp_b, bw_ref, support_uni, smoothWin, ...
        minProm, minDistBin, SR_thr, VR_thr);

    TL_uni_boot(bb) = Rb.TL;
    TR_uni_boot(bb) = Rb.TR;
    mode_uni_boot(bb) = Rb.mode;

    % ===== Bimodal-separated =====
    N = numel(Cp_sep);
    idx = randsample(N, round(sampleFrac*N), true);
    Cp_b = Cp_sep(idx);

    Rb = extractAT_general( ...
        Cp_b, bw_ref, support_sep, smoothWin, ...
        minProm, minDistBin, SR_thr, VR_thr);

    TL_sep_boot(bb) = Rb.TL;
    TR_sep_boot(bb) = Rb.TR;
    Tv_sep_boot(bb) = Rb.Tv;
    mode_sep_boot(bb) = Rb.mode;

    % ===== Bimodal-overlapped =====
    N = numel(Cp_ovl);
    idx = randsample(N, round(sampleFrac*N), true);
    Cp_b = Cp_ovl(idx);

    Rb = extractAT_general( ...
        Cp_b, bw_ref, support_ovl, smoothWin_ovl, ...
        minProm_ovl, minDistBin_ovl, SR_thr, VR_thr);

    Tv_ovl_boot(bb) = Rb.Tv;
    mode_ovl_boot(bb) = Rb.mode;
end

%% -------------------- Better bootstrap plot: normalized deviation --------------------
% Plot normalized deviation from the full-record threshold:
%   dT_norm = 100 * (T_boot - T_full) / IQR
%
% This avoids the poor visualization caused by plotting TL and TR absolute
% values on the same y-axis.

figure('Color','w','Position',[100 100 1350 460]);
tiledlayout(1,3,'Padding','compact','TileSpacing','compact');

markerAlpha = 0.25;
jitterAmp = 0.10;

%% ============================================================
% (a) Unimodal
%% ============================================================
nexttile; hold on; box on; grid on;

% Keep expected-mode realizations
idx_uni = (mode_uni_boot == 0);

dTL_uni = 100 * (TL_uni_boot(idx_uni) - R_uni_full.TL) / IQR_uni;
dTR_uni = 100 * (TR_uni_boot(idx_uni) - R_uni_full.TR) / IQR_uni;

% jittered scatter
x1 = 1 + jitterAmp*(rand(size(dTL_uni))-0.5);
x2 = 2 + jitterAmp*(rand(size(dTR_uni))-0.5);

scatter(x1, dTL_uni, 18, 'filled', ...
    'MarkerFaceAlpha',markerAlpha, 'MarkerEdgeAlpha',markerAlpha);
scatter(x2, dTR_uni, 18, 'filled', ...
    'MarkerFaceAlpha',markerAlpha, 'MarkerEdgeAlpha',markerAlpha);

% boxchart
boxchart(ones(size(dTL_uni)), dTL_uni, 'BoxWidth',0.35);
boxchart(2*ones(size(dTR_uni)), dTR_uni, 'BoxWidth',0.35);

% full-record reference = zero deviation
yline(0, 'k-', 'LineWidth',1.2, 'DisplayName','Full-record threshold');

xlim([0.5 2.5]);
xticks([1 2]);
xticklabels({'T_L','T_R'});
ylabel('Normalized deviation (% IQR)');
title(sprintf('(a) Unimodal, retained %d/%d', sum(idx_uni), numel(mode_uni_boot)), ...
    'FontWeight','bold');

% symmetric y-axis
yy = [dTL_uni(:); dTR_uni(:)];
yl = prctile(yy,[1 99]);
ymax = max(abs(yl));
if ymax == 0 || isnan(ymax)
    ymax = 1;
end
ylim([-3 3])

%% ============================================================
% (b) Bimodal-separated
%% ============================================================
nexttile; hold on; box on; grid on;

% Keep expected-mode realizations
idx_sep = (mode_sep_boot == 1);

dTL_sep = 100 * (TL_sep_boot(idx_sep) - R_sep_full.TL) / IQR_sep;
dTR_sep = 100 * (TR_sep_boot(idx_sep) - R_sep_full.TR) / IQR_sep;

x1 = 1 + jitterAmp*(rand(size(dTL_sep))-0.5);
x2 = 2 + jitterAmp*(rand(size(dTR_sep))-0.5);

scatter(x1, dTL_sep, 18, 'filled', ...
    'MarkerFaceAlpha',markerAlpha, 'MarkerEdgeAlpha',markerAlpha);
scatter(x2, dTR_sep, 18, 'filled', ...
    'MarkerFaceAlpha',markerAlpha, 'MarkerEdgeAlpha',markerAlpha);

boxchart(ones(size(dTL_sep)), dTL_sep, 'BoxWidth',0.35);
boxchart(2*ones(size(dTR_sep)), dTR_sep, 'BoxWidth',0.35);

yline(0, 'k-', 'LineWidth',1.2);

xlim([0.5 2.5]);
xticks([1 2]);
xticklabels({'T_L','T_R'});
ylabel('Normalized deviation (% IQR)');
title(sprintf('(b) Bimodal-separated, retained %d/%d', sum(idx_sep), numel(mode_sep_boot)), ...
    'FontWeight','bold');

yy = [dTL_sep(:); dTR_sep(:)];
yl = prctile(yy,[1 99]);
ymax = max(abs(yl));
if ymax == 0 || isnan(ymax)
    ymax = 1;
end
ylim([-3 3])

%% ============================================================
% (c) Bimodal-overlapped
%% ============================================================
nexttile; hold on; box on; grid on;

% Keep expected-mode realizations
idx_ovl = (mode_ovl_boot == 2);

dTv_ovl = 100 * (Tv_ovl_boot(idx_ovl) - R_ovl_full.Tv) / IQR_ovl;

x1 = 1 + jitterAmp*(rand(size(dTv_ovl))-0.5);

scatter(x1, dTv_ovl, 18, 'filled', ...
    'MarkerFaceAlpha',markerAlpha, 'MarkerEdgeAlpha',markerAlpha);

boxchart(ones(size(dTv_ovl)), dTv_ovl, 'BoxWidth',0.35);

yline(0, 'k-', 'LineWidth',1.2);

xlim([0.5 1.5]);
xticks(1);
xticklabels({'T_v'});
ylabel('Normalized deviation (% IQR)');
title(sprintf('(c) Bimodal-overlapped, retained %d/%d', sum(idx_ovl), numel(mode_ovl_boot)), ...
    'FontWeight','bold');

yy = dTv_ovl(:);
yl = prctile(yy,[1 99]);
ymax = max(abs(yl));
if ymax == 0 || isnan(ymax)
    ymax = 1;
end
ylim([-3 3])

sgtitle('Bootstrap repeatability of AT-derived thresholds', ...
    'FontWeight','bold');

%% -------------------- Print summary --------------------
fprintf('\n--- Bootstrap normalized deviation summary ---\n');

fprintf('\n(a) Unimodal\n');
fprintf('Retained mode 0: %d/%d\n', sum(idx_uni), numel(mode_uni_boot));
fprintf('dTL mean/std = %.3f / %.3f %%IQR\n', mean(dTL_uni,'omitnan'), std(dTL_uni,'omitnan'));
fprintf('dTR mean/std = %.3f / %.3f %%IQR\n', mean(dTR_uni,'omitnan'), std(dTR_uni,'omitnan'));

fprintf('\n(b) Bimodal-separated\n');
fprintf('Retained mode 1: %d/%d\n', sum(idx_sep), numel(mode_sep_boot));
fprintf('dTL mean/std = %.3f / %.3f %%IQR\n', mean(dTL_sep,'omitnan'), std(dTL_sep,'omitnan'));
fprintf('dTR mean/std = %.3f / %.3f %%IQR\n', mean(dTR_sep,'omitnan'), std(dTR_sep,'omitnan'));

fprintf('\n(c) Bimodal-overlapped\n');
fprintf('Retained mode 2: %d/%d\n', sum(idx_ovl), numel(mode_ovl_boot));
fprintf('dTv mean/std = %.3f / %.3f %%IQR\n', mean(dTv_ovl,'omitnan'), std(dTv_ovl,'omitnan'));

function R = extractAT_general(Cp, bw, support, smoothWin, minProm, minDistBin, SR_thr, VR_thr)

    Cp = Cp(:);
    Cp = Cp(~isnan(Cp));

    [x, y] = makePDF_prob(Cp, bw, support, smoothWin);

    dist2line = @(x1,y1,x2,y2,xq,yq) ...
        abs((y2-y1).*xq - (x2-x1).*yq + (x2*y1 - y2*x1)) ./ hypot(y2-y1, x2-x1);

    R = struct();
    R.TL = NaN;
    R.TR = NaN;
    R.Tv = NaN;
    R.mode = NaN;   % 0 = unimodal, 1 = bimodal-separated, 2 = bimodal-overlapped
    R.SR = NaN;
    R.valleyRatio = NaN;

    if numel(x) < 5 || all(y == 0)
        return;
    end

    [pks, locs] = findpeaks(y, 'MinPeakProminence', max(y)*minProm, ...
                               'MinPeakDistance',  minDistBin);

    %% ---------- Unimodal or fallback ----------
    if numel(locs) < 2

        [~, ip] = max(y);
        xP = x(ip);
        yP = y(ip);

        % left knee
        idL = 1:ip;
        DL = dist2line(x(idL(1)),y(idL(1)), xP,yP, x(idL),y(idL));
        if numel(DL) >= 3
            DL([1 end]) = -Inf;
        end
        [~, kL] = max(DL);
        R.TL = x(idL(kL));

        % right knee
        idR = ip:numel(x);
        DR = dist2line(xP,yP, x(idR(end)),y(idR(end)), x(idR),y(idR));
        if numel(DR) >= 3
            DR([1 end]) = -Inf;
        end
        [~, kR] = max(DR);
        R.TR = x(idR(kR));

        R.mode = 0;
        return;
    end

    %% ---------- Two-peak case ----------
    [~, ord] = maxk(pks, 2);
    locs2 = sort(locs(ord));

    iLpk = locs2(1);
    iRpk = locs2(2);

    xLpk = x(iLpk);
    yLpk = y(iLpk);

    xRpk = x(iRpk);
    yRpk = y(iRpk);

    % valley between peaks
    [valY, rel] = min(y(iLpk:iRpk));
    kv = iLpk + rel - 1;
    valX = x(kv);

    % quadratic refinement
    if kv > 1 && kv < numel(x)
        idx3 = (kv-1):(kv+1);
        p = polyfit(x(idx3), y(idx3), 2);
        if p(1) > 0
            xv = -p(2)/(2*p(1));
            if xv >= x(idx3(1)) && xv <= x(idx3(3))
                valX = xv;
                valY = polyval(p, xv);
            end
        end
    end

    valleyRatio = valY / min(yLpk, yRpk);
    [SR, ~] = calcSR_FWHM(x, y, iLpk, iRpk);

    R.SR = SR;
    R.valleyRatio = valleyRatio;
    R.Tv = valX;

    useTwo = (SR >= SR_thr) && (valleyRatio <= VR_thr);

    if useTwo

        % TL: max distance to chord valley <-> left peak
        idL = iLpk:kv;
        if xLpk > valX
            idL = kv:iLpk;
        end

        xLs = x(idL);
        yLs = y(idL);
        DL = dist2line(valX,valY, xLpk,yLpk, xLs,yLs);

        if numel(DL) >= 3
            DL([1 end]) = -Inf;
        end

        [~, kL] = max(DL);
        R.TL = xLs(kL);

        % TR: max distance to chord valley <-> right peak
        idR = kv:iRpk;
        if valX > xRpk
            idR = iRpk:kv;
        end

        xRs = x(idR);
        yRs = y(idR);
        DR = dist2line(valX,valY, xRpk,yRpk, xRs,yRs);

        if numel(DR) >= 3
            DR([1 end]) = -Inf;
        end

        [~, kR] = max(DR);
        R.TR = xRs(kR);

        R.mode = 1;   % bimodal-separated

    else
        R.mode = 2;   % bimodal-overlapped
    end
end
%% ====================== INLINE HELPERS (same file) ======================
function [x, y] = makePDF_prob(Cp, binWidth, support, smoothWin)
    lo = support(1); hi = support(2);
    edges = lo:binWidth:hi;
    if edges(end) < hi, edges = [edges hi]; end
    centers = edges(1:end-1) + binWidth/2;

    y = histcounts(Cp, edges, 'Normalization','probability')';
    x = centers(:);
    if smoothWin > 1
        y = movmean(y, smoothWin);
    end
end

function drawIQRbands(Tref, IQRv)
    d5  = 0.05 * IQRv;
    d10 = 0.10 * IQRv;
    yline(Tref + d5,  ':',  'LineWidth', 1.0, 'HandleVisibility','off');
    yline(Tref - d5,  ':',  'LineWidth', 1.0, 'HandleVisibility','off');
    yline(Tref + d10, '--',  'LineWidth', 1.0, 'HandleVisibility','off');
    yline(Tref - d10, '--',  'LineWidth', 1.0, 'HandleVisibility','off');
end

function [SR, meanFWHM] = calcSR_FWHM(x, y, iLpk, iRpk)
    dx = x(2)-x(1);

    xLpk = x(iLpk); yLpk = y(iLpk);
    xRpk = x(iRpk); yRpk = y(iRpk);

    halfL = 0.5*yLpk; halfR = 0.5*yRpk;

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

    meanFWHM = max(dx, mean([FWHM_L FWHM_R]));
    peakSep  = xRpk - xLpk;
    SR = peakSep / meanFWHM;
end