function [T, info] = compute_threshold_AT(seg, edges, opts)
% COMPUTE_THRESHOLD_AT  GMM→(Uni/Bi)→Chord-knee→Threshold
%
% [T, info] = compute_threshold_AT(seg, edges, opts)
%
% Inputs
%   seg   : 向量 (原始壓力資料，一段窗內)
%   edges : 直方圖邊界，預設 -3.4:0.05:0
%   opts  : 結構（可省略）
%       .gmmReg   : fitgmdist RegularizationValue (default 1e-6)
%       .gmmRep   : GMM(2) Replicates (default 5)
%       .bicGap   : 判雙峰的 ΔBIC 門檻 (default 6)
%       .muZ      : 峰距/合併標準差的 Z 分數門檻 (default 2)
%       .prefer   : 'left' | 'right' | 'minabs' (T 選擇規則；單峰/雙峰皆用，default 'left')
%       .minProm  : findpeaks 最小顯著度（相對 PDF 高度）(default 0.05)
%       .minDistK : 峰距最小 bin 數 (default 6)
%
% Outputs
%   T     : 建議閥值（依 opts.prefer 規則從 TL,TR 挑選）
%   info  : 附帶資訊（結構）
%       .isBimodal, .TL, .TR, .T_O (Otsu), .peakX, .peakY
%       .hist.x, .hist.y, .edges, .centers
%
% Yu-Hsiang’s ATBM helper — 2025-08

% ---------- defaults ----------
if nargin < 2 || isempty(edges), edges = -3.4:0.05:0; end
if nargin < 3, opts = struct(); end
opts = set_default(opts, 'gmmReg', 1e-6);
opts = set_default(opts, 'gmmRep', 5);
opts = set_default(opts, 'bicGap', 6);
opts = set_default(opts, 'muZ', 2);
opts = set_default(opts, 'prefer', 'left');   % 研究中常取更負的一側
opts = set_default(opts, 'minProm', 0.05);
opts = set_default(opts, 'minDistK', 6);
opts = set_default(opts, 'kneeFrac', 0.80);   % 達到 Dmax 的比例(0.7~0.9)
% ---------- histogram / pdf ----------
centers = edges(1:end-1) + diff(edges(1:2))/2;
y = histcounts(seg, edges, 'Normalization','probability')';
x = centers(:);
%% 

% ---------- GMM: decide uni vs bi ----------
gm1 = fitgmdist(seg,1,'RegularizationValue',opts.gmmReg);
gm2 = fitgmdist(seg,2,'RegularizationValue',opts.gmmReg,'Replicates',opts.gmmRep);

deltaBIC = gm1.BIC - gm2.BIC;
% 峰距 / 合併標準差（避免兩峰重疊仍被判雙峰）
muGap = abs(diff(gm2.mu));
sigmas = squeeze(gm2.Sigma);
if numel(sigmas) == 1, s2 = sigmas; else, s2 = sum(sigmas(:)); end
muZ = muGap ./ sqrt(s2);

isBimodal = (deltaBIC >= opts.bicGap) && (muZ >= opts.muZ);

% ---------- find global peak(s) on binned PDF ----------
% 以 binned PDF 找峰（穩定且可對齊 x）
[minPromAbs, minDist] = deal(max(y)*opts.minProm, opts.minDistK);
[pks, locs] = findpeaks(y, 'MinPeakProminence',minPromAbs, 'MinPeakDistance',minDist);
peakX = x(locs); peakY = y(locs);
%%
mu2 = gm2.mu(:); [mu2, ord] = sort(mu2);
S = squeeze(gm2.Sigma); if isscalar(S), S = [S; S]; else, S = S(:); end
sig2 = sqrt(S(ord));
w2   = gm2.ComponentProportion(:); w2 = w2(ord);

% Ashman’s D
ashmanD = abs(mu2(2)-mu2(1)) / sqrt(0.5*(sig2(1)^2 + sig2(2)^2));

% Bayes 分界點：解 w1*N1(x) = w2*N2(x)
a = (1/sig2(2)^2) - (1/sig2(1)^2);
b = 2*(mu2(1)/sig2(1)^2 - mu2(2)/sig2(2)^2);
L = log((w2(2)*sig2(1))/(w2(1)*sig2(2)));
c = (mu2(2)^2/sig2(2)^2 - mu2(1)^2/sig2(1)^2) - 2*L;
if abs(a) < 1e-12
    bayesBoundary = -c/b;                      % 等方差近似
else
    r = roots([a b c]); r = r(imag(r)==0);
    if isempty(r)
        bayesBoundary = NaN;
    else
        mid = mean(mu2);
        in = r(r>=min(mu2) & r<=max(mu2));
        if ~isempty(in), bayesBoundary = in(1);
        else [~,ix] = min(abs(r-mid)); bayesBoundary = r(ix);
        end
    end
end

% 兩高斯重疊度（數值近似 0..1；越小越可分）
xx = linspace(min(seg), max(seg), 2000);
f1 = w2(1)*normpdf(xx, mu2(1), sig2(1));
f2 = w2(2)*normpdf(xx, mu2(2), sig2(2));
overlap = trapz(xx, min(f1,f2));

% 谷深比例 valleyRatio = (兩峰間最小 y) / (較小的峰高)
% ===== 用 PDF(x,y) 求兩峰之間的谷底位置與谷深 =====
valleyRatio = NaN; valleyX = NaN; valleyY = NaN;

if numel(peakX) >= 2
    % 取最接近兩個 GMM 均值的兩個峰
    [~,iL] = min(abs(peakX - mu2(1)));
    [~,iR] = min(abs(peakX - mu2(2)));
    xL = peakX(iL); yL = peakY(iL);
    xR = peakX(iR); yR = peakY(iR);

    % 找出這兩峰之間（在 x 上）的索引區間
    i1 = find(x <= min(xL,xR), 1, 'last');
    i2 = find(x >= max(xL,xR), 1, 'first');

    if ~isempty(i1) && ~isempty(i2) && i1 < i2
        % 先在離散 bin 上取最小值（谷底）
        [valleyY, rel] = min(y(i1:i2));
        kv = i1 + rel - 1;
        valleyX = x(kv);

        % （可選）三點二次曲線做亞像素微調
        if kv > 1 && kv < numel(x)
            idx = (kv-1):(kv+1);
            p = polyfit(x(idx), y(idx), 2);         % y = p1 x^2 + p2 x + p3
            if p(1) > 0                               % 開口向上才是谷
                xv = -p(2)/(2*p(1));                 % 二次函數頂點
                if xv >= x(idx(1)) && xv <= x(idx(3))
                    valleyX = xv;
                    valleyY = polyval(p, xv);
                end
            end
        end

        % 谷深比例（越小越「真雙峰」）
        valleyRatio = valleyY / min(yL, yR);
    end
end



%%

% ---------- small helpers ----------
dist_to_line = @(x1,y1,x2,y2,xq,yq) ...
    abs((y2-y1).*xq - (x2-x1).*yq + (x2*y1 - y2*x1)) ./ hypot(y2-y1, x2-x1);

take_knee = @(xa,ya, xb,yb, xid) ...
    local_knee(xa,ya, xb,yb, x(xid), y(xid));  % returns [Tk, yk, ik_rel]

% ---------- main logic ----------
info = struct('isBimodal',isBimodal, 'TL',NaN, 'TR',NaN, 'T_O',NaN, ...
              'peakX',peakX, 'peakY',peakY, ...
              'hist',struct('x',x,'y',y), 'edges',edges, 'centers',centers,...
              'deltaBIC',deltaBIC, 'muZ',muZ,...
              'gmm',struct( ...
                    'mu',mu2(:).','sigma',sig2(:).','weight',w2(:).', ...
                    'ashmanD',ashmanD, ...
                    'bayesBoundary',bayesBoundary, ...
                    'overlap',overlap, ...
                    'valleyRatio',valleyRatio,...
                    'valleyX',valleyX, 'valleyY',valleyY));

if ~isBimodal
    % ===== Single-peak mode =====
    if isempty(locs)
        [~, ip] = max(y);
    else
        [~, kmax] = max(pks);
        ip = locs(kmax);
    end
    xP = x(ip); yP = y(ip);

    % 左端→峰、峰→右端，用原本 take_knee
    idL = 1:ip;
    [TL, ~] = take_knee(x(idL(1)), y(idL(1)), xP, yP, idL);

    idR = ip:numel(x);
    [TR, ~] = take_knee(xP, yP, x(idR(end)), y(idR(end)), idR);

    T = choose_T(TL, TR, opts.prefer);
    info.TL = TL; info.TR = TR;

else
    % ===== Bimodal mode =====
    % 先算 Otsu（備用/參考）
    n = numel(y);
    t_norm = otsuthresh(max(y,0));
    tau    = t_norm*(n-1) + 1;
    jO     = max(1, min(n-1, floor(tau)));
    alpha  = tau - jO;
    T_O    = x(jO) + alpha*(x(jO+1)-x(jO));
    y_O    = y(jO) + alpha*(y(jO+1)-y(jO));
    info.T_O = T_O;

    % 分界：谷底優先，否則用 Otsu
    if ~isnan(valleyX)
        T_split = valleyX;  y_split = valleyY;
    else
        T_split = T_O;      y_split = y_O;
    end
    info.T_V     = valleyX;
    info.T_split = T_split;

    % 以 T_split 切左右
    j = find(x <= T_split, 1, 'last'); if isempty(j), j = 1; end
    [~, iPL_rel] = max(y(1:j));       iPL = iPL_rel;          % 左峰
    [~, iPR_rel] = max(y(j+1:end));   iPR = j + iPR_rel;      % 右峰

    % ----- 左側（分界→左峰）：第一個達到 kneeFrac·Dmax 的點 -----
    idL_in = sort([iPL, j]); idL_in = idL_in(1):idL_in(2);
    xseg = x(idL_in); yseg = y(idL_in);
    A = (y(iPL) - y_split);
    B = -(x(iPL) - T_split);
    C = (x(iPL)*y_split - y(iPL)*T_split);
    D = abs(A*xseg + B*yseg + C) / hypot(A,B);
    Dmax = max(D);
    if ~isfinite(Dmax) || Dmax==0
        k = 1;
    else
        k = find(D >= opts.kneeFrac*Dmax, 1, 'first');
        if isempty(k), [~,k] = max(D); end
    end
    TL = xseg(k);

    % ----- 右側（分界→右峰）：第一個達到 kneeFrac·Dmax 的點 -----
    idR_in = sort([j+1, iPR]); idR_in = idR_in(1):idR_in(2);
    xseg = x(idR_in); yseg = y(idR_in);
    A = (y(iPR) - y_split);
    B = -(x(iPR) - T_split);
    C = (x(iPR)*y_split - y(iPR)*T_split);
    D = abs(A*xseg + B*yseg + C) / hypot(A,B);
    Dmax = max(D);
    if ~isfinite(Dmax) || Dmax==0
        k = numel(xseg);
    else
        k = find(D >= opts.kneeFrac*Dmax, 1, 'first');
        if isempty(k), [~,k] = max(D); end
    end
    TR = xseg(k);

    % 回傳建議 T
    T = choose_T(TL, TR, opts.prefer);
    info.TL = TL; info.TR = TR;
end


% ---------- nested helpers ----------
    function v = set_default(s, f, d)
        if ~isfield(s,f) || isempty(s.(f)), s.(f) = d; end
        v = s;
    end

    function [Tk, yk] = local_knee(x1,y1, x2,y2, xq,yq)
        % 端點弦最大距離 knee（在查詢點集合上）
        D = dist_to_line(x1,y1, x2,y2, xq, yq);
        [~, k] = max(D);
        Tk = xq(k);
        yk = yq(k);
    end

    function Tout = choose_T(TL, TR, mode)
        switch lower(mode)
            case 'left'   % Cp 越負越嚴格
                Tout = TL;
            case 'right'
                Tout = TR;
            case 'minabs' % 取 |Cp| 較大者（更遠離 0）
                if abs(TL) > abs(TR), Tout = TL; else, Tout = TR; end
            otherwise
                Tout = TL;
        end
    end
end
