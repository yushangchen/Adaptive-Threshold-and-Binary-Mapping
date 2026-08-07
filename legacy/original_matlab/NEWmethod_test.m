%% ================================================================
%  Selected three cases for Fig. 4(a-c)
%  只生成三個指定 case 的 AT schematic
%  ================================================================


baseDir = '\\diskstation\research - finite cylinder\光滑圓柱\AR4\原始訊號\newmethod\';
cd(baseDir);

alldata = { ...
    Cpp70_1D,   Cpp90_1D,   Cpp110_1D,   Cpn70_1D,   Cpn90_1D,   Cpn110_1D, ...
    Cpp70_2D,   Cpp90_2D,   Cpp110_2D,   Cpn70_2D,   Cpn90_2D,   Cpn110_2D, ...
    Cpp70_3_5D, Cpp90_3_5D, Cpp110_3_5D, Cpn70_3_5D, Cpn90_3_5D, Cpn110_3_5D};

tapNames = { ...
    'Cpp70_1D','Cpp90_1D','Cpp110_1D','Cpn70_1D','Cpn90_1D','Cpn110_1D', ...
    'Cpp70_2D','Cpp90_2D','Cpp110_2D','Cpn70_2D','Cpn90_2D','Cpn110_2D', ...
    'Cpp70_3_5D','Cpp90_3_5D','Cpp110_3_5D','Cpn70_3_5D','Cpn90_3_5D','Cpn110_3_5D'};

%% ================================================================
%  你只要改這裡
%  type 只是用來檢查你選的結果是不是符合想要的圖
%  ================================================================
selected(1).tapName = 'Cpp90_2D';
selected(1).caseIdx = 7;
selected(1).title   = '(a) Unimodal PDF';

selected(2).tapName = 'Cpp90_2D';
selected(2).caseIdx = 25;
selected(2).title   = '(b) Bimodal-separated PDF';

selected(3).tapName = 'Cpp70_1D';
selected(3).caseIdx = 26;
selected(3).title   = '(c) Bimodal-overlapped PDF';

%% ===== Settings =====
settings.edges        = -3.4:0.05:0;
settings.centers      = settings.edges(1:end-1) + diff(settings.edges(1:2))/2;
settings.minPromRatio = 0.05;
settings.minDistBin   = 3;

settings.SR_thr       = 1.5;
settings.VR_thr       = 0.80;
settings.Fs           = 1000;

%% ===== Output =====
outDir = fullfile(baseDir, 'Selected_AT_Figures');
if ~exist(outDir, 'dir'), mkdir(outDir); end

%% ===== Compute selected results =====
results = cell(1,3);

for k = 1:3
    tapIdx = find(strcmp(tapNames, selected(k).tapName), 1);

    if isempty(tapIdx)
        error('Cannot find tapName: %s', selected(k).tapName);
    end

    dataloc = alldata{tapIdx};

    seg = dataloc(:, selected(k).caseIdx);
    seg = seg(:);
    seg = seg(~isnan(seg));

    results{k} = computeATResult(seg, settings);

    fprintf('%s | idx=%02d | mode=%d\n', ...
        selected(k).tapName, selected(k).caseIdx, results{k}.mode);
end

%% ===== Plot Fig. 4 =====
f4 = figure('Color','w','Position',[80 80 1500 460]);

tl = tiledlayout(f4, 1, 3, ...
    'TileSpacing', 'compact', ...
    'Padding', 'compact');

for k = 1:3
    ax = nexttile(tl, k);
    plotPDFResult(ax, results{k}, false, false);
    title(ax, selected(k).title, ...
        'FontWeight', 'bold', ...
        'FontName', 'Times New Roman');
end

exportgraphics(f4, fullfile(outDir, 'Fig4_AT_schematic_selected.png'), 'Resolution', 300);
savefig(f4, fullfile(outDir, 'Fig4_AT_schematic_selected.fig'));

fprintf('Fig. 4 selected schematic saved to:\n%s\n', outDir);

%% ================================================================
%  Local functions
%  ================================================================

function result = computeATResult(seg, settings)

    seg = seg(:);
    seg = seg(~isnan(seg));

    x = settings.centers(:);
    y = histcounts(seg, settings.edges, 'Normalization', 'probability')';
    y = y(:);

    dx = x(2) - x(1);
    n  = numel(x);

    minProm = max(y) * settings.minPromRatio;

    [pks, locs] = findpeaks(y, ...
        'MinPeakProminence', minProm, ...
        'MinPeakDistance', settings.minDistBin);

    result.x = x;
    result.y = y;

    result.mode = NaN;
    result.TL = NaN;
    result.TR = NaN;
    result.Tv = NaN;
    result.SR = NaN;
    result.valleyRatio = NaN;

    result.xP = NaN;
    result.yP = NaN;

    result.xL = NaN;
    result.yL = NaN;
    result.xR = NaN;
    result.yR = NaN;
    result.valX = NaN;
    result.valY = NaN;

    result.yTL = NaN;
    result.yTR = NaN;

    result.useTwo = false;

    dist2line = @(x1,y1,x2,y2,xq,yq) ...
        abs((y2-y1).*xq - (x2-x1).*yq + (x2*y1 - y2*x1)) ./ hypot(y2-y1, x2-x1);

    %% ===== Unimodal =====
    if numel(locs) < 2

        [~, ip] = max(y);

        xP = x(ip);
        yP = y(ip);

        idL = 1:ip;
        xLseg = x(idL);
        yLseg = y(idL);

        DL = dist2line(xLseg(1), yLseg(1), xP, yP, xLseg, yLseg);
        [~, kL] = max(DL);

        TL  = xLseg(kL);
        yTL = yLseg(kL);

        idR = ip:numel(x);
        xRseg = x(idR);
        yRseg = y(idR);

        DR = dist2line(xP, yP, xRseg(end), yRseg(end), xRseg, yRseg);
        [~, kR] = max(DR);

        TR  = xRseg(kR);
        yTR = yRseg(kR);

        result.mode = 0;
        result.TL = TL;
        result.TR = TR;
        result.xP = xP;
        result.yP = yP;
        result.yTL = yTL;
        result.yTR = yTR;

        return;
    end

    %% ===== Bimodal =====
    [~, ord] = maxk(pks, 2);
    locs2 = sort(locs(ord));

    iL = locs2(1);
    iR = locs2(2);

    xL = x(iL); yL = y(iL);
    xR = x(iR); yR = y(iR);

    [valY_discrete, rel] = min(y(iL:iR));
    kv = iL + rel - 1;

    valX = x(kv);
    valY = valY_discrete;

    if kv > 1 && kv < n
        idx = (kv-1):(kv+1);
        pp = polyfit(x(idx), y(idx), 2);

        if pp(1) > 0
            xv = -pp(2) / (2 * pp(1));

            if xv >= x(idx(1)) && xv <= x(idx(3))
                valX = xv;
                valY = polyval(pp, xv);
            end
        end
    end

    valleyRatio = valY / min(yL, yR);

    [FWHM_L, FWHM_R] = computeTwoPeakFWHM(x, y, iL, iR, yL, yR);

    peakSep = xR - xL;
    meanFWHM = max(dx, mean([FWHM_L, FWHM_R]));
    SR = peakSep / meanFWHM;

    useTwo = (SR >= settings.SR_thr) && (valleyRatio <= settings.VR_thr);

    result.xL = xL;
    result.yL = yL;
    result.xR = xR;
    result.yR = yR;
    result.valX = valX;
    result.valY = valY;
    result.SR = SR;
    result.valleyRatio = valleyRatio;
    result.useTwo = useTwo;

    if useTwo

        if iL <= kv
            idLeftLocal = iL:kv;
        else
            idLeftLocal = kv:iL;
        end

        xLs = x(idLeftLocal);
        yLs = y(idLeftLocal);

        DL = dist2line(valX, valY, xL, yL, xLs, yLs);

        if numel(DL) >= 3
            DL([1 end]) = -Inf;
        end

        [~, kLocalL] = max(DL);

        TL  = xLs(kLocalL);
        yTL = yLs(kLocalL);

        if kv <= iR
            idRightLocal = kv:iR;
        else
            idRightLocal = iR:kv;
        end

        xRs = x(idRightLocal);
        yRs = y(idRightLocal);

        DR = dist2line(valX, valY, xR, yR, xRs, yRs);

        if numel(DR) >= 3
            DR([1 end]) = -Inf;
        end

        [~, kLocalR] = max(DR);

        TR  = xRs(kLocalR);
        yTR = yRs(kLocalR);

        result.mode = 1;
        result.TL = TL;
        result.TR = TR;
        result.yTL = yTL;
        result.yTR = yTR;

    else
        result.mode = 2;
        result.Tv = valX;
    end
end

function [FWHM_L, FWHM_R] = computeTwoPeakFWHM(x, y, iL, iR, yL, yR)

    halfL = 0.5 * yL;

    iLL = find(y(1:iL) < halfL, 1, 'last');

    if ~isempty(iLL) && iLL < iL
        xLL = interp1(y(iLL:iLL+1), x(iLL:iLL+1), halfL, 'linear', 'extrap');
    else
        xLL = x(1);
    end

    iLR_rel = find(y(iL:end) < halfL, 1, 'first');

    if ~isempty(iLR_rel)
        iLR = iL + iLR_rel - 1;

        if iLR > 1
            xLR = interp1(y(iLR-1:iLR), x(iLR-1:iLR), halfL, 'linear', 'extrap');
        else
            xLR = x(iLR);
        end
    else
        xLR = x(end);
    end

    FWHM_L = max(0, xLR - xLL);

    halfR = 0.5 * yR;

    iRL = find(y(1:iR) < halfR, 1, 'last');

    if ~isempty(iRL) && iRL < iR
        xRL = interp1(y(iRL:iRL+1), x(iRL:iRL+1), halfR, 'linear', 'extrap');
    else
        xRL = x(1);
    end

    iRR_rel = find(y(iR:end) < halfR, 1, 'first');

    if ~isempty(iRR_rel)
        iRR = iR + iRR_rel - 1;

        if iRR > 1
            xRR = interp1(y(iRR-1:iRR), x(iRR-1:iRR), halfR, 'linear', 'extrap');
        else
            xRR = x(iRR);
        end
    else
        xRR = x(end);
    end

    FWHM_R = max(0, xRR - xRL);
end

function plotPDFResult(ax, result, showLegend, showLongLabels)

    axes(ax);
    hold(ax, 'on');

    x = result.x;
    y = result.y;

    hPDF = plot(ax, x, y, 'r-', 'LineWidth', 1.8);
    plot(ax, x, y, 'r*', 'LineWidth', 0.7, 'MarkerSize', 3.5);

    switch result.mode

        case 0
            hChord = plot(ax, [x(1) result.xP], [y(1) result.yP], '--', ...
                'Color', [0 0.35 0.85], 'LineWidth', 1.4);

            plot(ax, [result.xP x(end)], [result.yP y(end)], '--', ...
                'Color', [0 0.35 0.85], 'LineWidth', 1.4);

            hPeak = plot(ax, result.xP, result.yP, 'o', ...
                'MarkerSize', 7, ...
                'MarkerFaceColor', [1 0.9 0], ...
                'MarkerEdgeColor', 'k');

            hTL = plot(ax, result.TL, result.yTL, 's', ...
                'MarkerSize', 6, ...
                'MarkerFaceColor', [0.15 0.15 0.15], ...
                'MarkerEdgeColor', 'k');

            hTR = plot(ax, result.TR, result.yTR, 's', ...
                'MarkerSize', 6, ...
                'MarkerFaceColor', [0.85 0.1 0.75], ...
                'MarkerEdgeColor', 'k');

            xline(ax, result.TL, '--', 'Color', [0.25 0.25 0.25], 'LineWidth', 1.2);
            xline(ax, result.TR, '--', 'Color', [0.85 0.1 0.75], 'LineWidth', 1.2);

            text(ax, result.xP - 0.01, result.yP + 0.02, 'p', ...
                'FontSize', 15, 'FontName', 'Times New Roman');

            text(ax, result.TL - 0.22, result.yTL + 0.06, 'T_L', ...
                'FontSize', 15, 'FontName', 'Times New Roman', 'Color', [0.1 0.1 0.1]);

            text(ax, result.TR + 0.05, result.yTR + 0.05, 'T_R', ...
                'FontSize', 15, ...
                'FontName', 'Times New Roman', ...
                'Color', [0.75 0 0.65]);
            % Knee point labels near square markers
            yOffset = 0.08 * max(y);
            
            text(ax, result.TL - 0.40, result.yTL + 0.007, 'knee', ...
                'FontSize', 15, ...
                'FontName', 'Times New Roman', ...
                'Color', [0.1 0.1 0.1]);
            
            text(ax, result.TR + 0.08, result.yTR + 0.005, 'knee', ...
                'FontSize', 15, ...
                'FontName', 'Times New Roman', ...
                'Color', [0.75 0 0.65]);

            if showLongLabels
                text(ax, (x(1)+result.xP)/2 - 0.15, (y(1)+result.yP)/2 + 0.01, ...
                    'left chord', 'FontSize', 11, 'Color', [0 0.35 0.85], ...
                    'FontAngle', 'italic');

                text(ax, (result.xP+x(end))/2 - 0.05, (result.yP+y(end))/2 + 0.01, ...
                    'right chord', 'FontSize', 11, 'Color', [0 0.35 0.85], ...
                    'FontAngle', 'italic');
            else
                text(ax, -2.95, max(y)*0.6, 'chord-distance', ...
                    'FontSize', 13, 'Color', [0 0.35 0.85], 'FontAngle', 'italic');
            end

            addAxesInfoBox(ax, {sprintf('T_L = %.3f', result.TL), ...
                                sprintf('T_R = %.3f', result.TR), ...
                                });

            if showLegend
                legend(ax, [hPDF, hChord, hPeak, hTL, hTR], ...
                    {'PDF','chord','peak p','T_L knee','T_R knee'}, ...
                    'Location','northwest', 'Box','off');
            end

        case 1
            hPeak1 = plot(ax, result.xL, result.yL, 'o', ...
                'MarkerSize', 7, ...
                'MarkerFaceColor', [1 0.9 0], ...
                'MarkerEdgeColor', 'k');

            hPeak2 = plot(ax, result.xR, result.yR, 'o', ...
                'MarkerSize', 7, ...
                'MarkerFaceColor', [1 0.9 0], ...
                'MarkerEdgeColor', 'k');

            hValley = plot(ax, result.valX, result.valY, 'v', ...
                'MarkerSize', 8, ...
                'MarkerFaceColor', 'k', ...
                'MarkerEdgeColor', 'k');

            hChord = plot(ax, [result.xL result.valX], [result.yL result.valY], '--', ...
                'Color', [0 0.35 0.85], 'LineWidth', 1.4);

            plot(ax, [result.valX result.xR], [result.valY result.yR], '--', ...
                'Color', [0 0.35 0.85], 'LineWidth', 1.4);

            hTL = plot(ax, result.TL, result.yTL, 's', ...
                'MarkerSize', 6, ...
                'MarkerFaceColor', [0.15 0.15 0.15], ...
                'MarkerEdgeColor', 'k');

            hTR = plot(ax, result.TR, result.yTR, 's', ...
                'MarkerSize', 6, ...
                'MarkerFaceColor', [0.85 0.1 0.75], ...
                'MarkerEdgeColor', 'k');

            xline(ax, result.TL, '--', 'Color', [0.25 0.25 0.25], 'LineWidth', 1.2);
            xline(ax, result.TR, '--', 'Color', [0.85 0.1 0.75], 'LineWidth', 1.2);

            text(ax, result.xL - 0.22, result.yL + 0.003, 'p_1', ...
                'FontSize', 15, 'FontName', 'Times New Roman');

            text(ax, result.xR + 0.05, result.yR + 0.003, 'p_2', ...
                'FontSize', 15, 'FontName', 'Times New Roman');

            text(ax, result.valX - 0.03, result.valY + 0.005, 'v', ...
                'FontSize', 15, 'FontName', 'Times New Roman');

            text(ax, result.TL + 0.02, result.yTL + 0.03, 'T_L', ...
                'FontSize', 15, 'FontName', 'Times New Roman', 'Color', [0.1 0.1 0.1]);

            text(ax, result.TR + 0.03, result.yTR + 0.03, 'T_R', ...
                'FontSize', 15, 'FontName', 'Times New Roman', 'Color', [0.75 0 0.65]);
            % Knee point labels near square markers
            yOffset = 0.08 * max(y);
            
            text(ax, result.TL - 0.30, result.yTL - 0.001, 'knee', ...
                'FontSize', 13, ...
                'FontName', 'Times New Roman', ...
                'Color', [0.1 0.1 0.1]);
            
            text(ax, result.TR + 0.08, result.yTR + 0, 'knee', ...
                'FontSize', 15, ...
                'FontName', 'Times New Roman', ...
                'Color', [0.75 0 0.65]);

            if showLongLabels
                text(ax, (result.xL+result.valX)/2 - 0.08, ...
                    (result.yL+result.valY)/2 - 0.010, ...
                    'left local chord', 'FontSize', 15, ...
                    'Color', [0 0.35 0.85], 'FontAngle', 'italic');

                text(ax, (result.valX+result.xR)/2 - 0.02, ...
                    (result.valY+result.yR)/2 + 0.006, ...
                    'right local chord', 'FontSize', 15, ...
                    'Color', [0 0.35 0.85], 'FontAngle', 'italic');
            else
                text(ax, -2.3, max(y)*0.6, 'local chord', ...
                    'FontSize', 13, 'Color', [0 0.35 0.85], 'FontAngle', 'italic');
            end

            addAxesInfoBox(ax, {sprintf('SR = %.2f', result.SR), ...
                                sprintf('valley ratio = %.2f', result.valleyRatio), ...
                                });

            if showLegend
                legend(ax, [hPDF, hChord, hPeak1, hPeak2, hValley, hTL, hTR], ...
                    {'PDF','local chord','peak p_1','peak p_2','valley v','T_L knee','T_R knee'}, ...
                    'Location','northeast', 'Box','off');
            end

        case 2
            hPeak1 = plot(ax, result.xL, result.yL, 'o', ...
                'MarkerSize', 7, ...
                'MarkerFaceColor', [1 0.9 0], ...
                'MarkerEdgeColor', 'k');

            hPeak2 = plot(ax, result.xR, result.yR, 'o', ...
                'MarkerSize', 7, ...
                'MarkerFaceColor', [1 0.9 0], ...
                'MarkerEdgeColor', 'k');

            hValley = plot(ax, result.valX, result.valY, 'v', ...
                'MarkerSize', 8, ...
                'MarkerFaceColor', 'k', ...
                'MarkerEdgeColor', 'k');

            hTv = xline(ax, result.Tv, ':', ...
                'Color', [0.15 0.15 0.15], ...
                'LineWidth', 1.5);

            text(ax, result.xL - 0.2, result.yL + 0.005, 'p_1', ...
                'FontSize', 15, 'FontName', 'Times New Roman');

            text(ax, result.xR + 0.05, result.yR + 0.0, 'p_2', ...
                'FontSize', 15, 'FontName', 'Times New Roman');

            text(ax, result.valX + 0.04, result.valY + 0.04, 'T_v', ...
                'FontSize', 15, 'FontName', 'Times New Roman', 'Color', [0.1 0.1 0.1]);

            text(ax, -2.4, 0.06, 'valley', ...
                'FontSize', 13, ...
                'FontName', 'Times New Roman', ...
                'Color', [0.1 0.1 0.1]);
            

            addAxesInfoBox(ax, {sprintf('SR = %.2f', result.SR), ...
                    sprintf('valley ratio = %.2f', result.valleyRatio), ...
                    }, [0.60, 0.92]);

            if showLegend
                legend(ax, [hPDF, hPeak1, hPeak2, hValley, hTv], ...
                    {'PDF','peak p_1','peak p_2','valley v','T_v'}, ...
                    'Location','northeast', 'Box','off');
            end
    end

    xlabel(ax, 'C_p', 'FontName', 'Times New Roman');
    ylabel(ax, 'Probability', 'FontName', 'Times New Roman');

    xlim(ax, [x(1), x(end)]);
    ylim(ax, [0, max(y)*1.18]);

    applyPubStyle(ax);
end

function addAxesInfoBox(ax, strCell, pos)

    if nargin < 3
        pos = [0.08, 0.92];   % 預設放左上
    end

    text(ax, pos(1), pos(2), strCell, ...
        'Units', 'normalized', ...
        'FontName', 'Times New Roman', ...
        'FontSize', 13, ...
        'VerticalAlignment', 'top', ...
        'HorizontalAlignment', 'left', ...
        'BackgroundColor', 'w', ...
        'EdgeColor', [0.35 0.35 0.35], ...
        'Margin', 5);
end

function applyPubStyle(ax)

    set(ax, ...
        'FontName', 'Times New Roman', ...
        'FontSize', 13, ...
        'LineWidth', 2.0, ...
        'Box', 'on', ...
        'XGrid', 'on', ...
        'YGrid', 'on', ...
        'GridAlpha', 0.18);
end