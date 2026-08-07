function [T, info] = knee_from_cdf(seg, varargin)
% KNEE_FROM_CDF  用視窗資料 seg 的 CDF 求「膝點」作門檻（山腳）
% T：膝點對應的 x（原單位）
% info：結構，回傳 xi, Fi, metric, side 等以便除錯/畫圖
%
% 可選參數：
%   'NumPoints'  : CDF 取樣點數 (default 256)
%   'Smooth'     : 是否平滑 CDF (true/false, default true)
%   'Side'       : 'auto' | 'left' | 'right'
%                  left → 取 max(F - x_norm)，right → 取 max(x_norm - F)
%                  auto → 取兩者較大者（常用）
%   'Metric'     : 'kneedle' | 'curvature'
%                  kneedle：最大 |F - x_norm|（對 y=x 的最大偏差）
%                  curvature：最大曲率 κ = |y''|/(1+y'^2)^(3/2)
%
% 用法：
%   [T,info] = knee_from_cdf(seg,'Side','auto','Metric','kneedle');

p = inputParser;
p.addParameter('NumPoints', 256);
p.addParameter('Smooth', true);
p.addParameter('Side', 'auto');        % 'left'/'right'/'auto'
p.addParameter('Metric','kneedle');    % 'kneedle'/'curvature'
p.parse(varargin{:});
M = p.Results.NumPoints;
doSmooth = p.Results.Smooth;
side     = lower(p.Results.Side);
metric   = lower(p.Results.Metric);

seg = seg(:);
if numel(seg) < 20
    T = NaN; info = struct('reason','too_few_samples'); return
end

% 1) 用 KDE 估 CDF
[xi, Fi] = ksdensity(seg, 'Function','cdf', 'NumPoints', M);
% 正規化 x 到 [0,1]，CDF 本身就是 0~1
x0 = xi(1); x1 = xi(end);
if x1 <= x0
    T = NaN; info = struct('reason','degenerate_support'); return
end
xn = (xi - x0) / (x1 - x0);
Fn = Fi(:)'; xn = xn(:)';

% 平滑（避免毛刺）
if doSmooth
    win = max(5, 2*floor(M/25)+1);        % 依點數自動選個奇數窗
    Fn = sgolayfilt(Fn, 3, win);          % 三階 SG
end

% 2) 指標：kneedle 或 curvature
switch metric
    case 'kneedle'
        dL = Fn - xn;          % 對 y=x 的偏差（左膝 → 正大）
        dR = xn - Fn;          % 右膝（Fn 在下方）
        if strcmp(side,'left')
            [~,k] = max(dL);
            chosen = 'left';
        elseif strcmp(side,'right')
            [~,k] = max(dR);
            chosen = 'right';
        else
            [mL,kL] = max(dL); [mR,kR] = max(dR);
            if mL >= mR, k=kL; chosen='left'; else, k=kR; chosen='right'; end
        end

    case 'curvature'
        % κ(x) = |y''|/(1+y'^2)^(3/2)
        dy  = gradient(Fn, xn);
        d2y = gradient(dy,  xn);
        kappa = abs(d2y) ./ max(1e-12, (1 + dy.^2).^(3/2));
        % 篩掉兩端極端值，避免端點效應
        mask = true(size(kappa)); mskN = max(3, round(0.03*M));
        mask(1:mskN) = false; mask(end-mskN+1:end) = false;
        kappa(~mask) = -inf;
        [~,k] = max(kappa);
        % 判斷左右（純資訊用）
        chosen = (Fn(k)-xn(k) >= 0) * "left" + (Fn(k)-xn(k) < 0) * "right";
        chosen = char(chosen);
    otherwise
        error('Unknown Metric: %s', metric);
end

% 3) 回到原單位
T = xi(k);

% 回傳資訊
info = struct('xi',xi,'Fi',Fi,'xn',xn,'Fn',Fn,'idx',k, ...
              'metric',metric,'side',chosen);
end
