% 必要: x, fs；W≈事件最短長度的 20–30%（樣本）
function [T, I, Q, gamma] = IF_background(x, fs, varargin)
p = inputParser;
p.addParameter('W', 25);          % 平滑窗(樣本)
p.addParameter('k', 2.5);         % 背景估計時剔除倍數
p.addParameter('pad', 3);         % 膨脹邊界(樣本)
p.addParameter('loRatio', 0.8);   % 雙門檻維持比
p.addParameter('alpha', 1.0);     % 啟動倍率(>1 更保守)
p.addParameter('minDur', 0.02);   % 事件最短持續(秒)
p.addParameter('minGap', 0.01);   % 合併的小間隙(秒)
p.addParameter('mode', 'd2');     % 'd2' | 'd1' | 'bp' | 'amp'
p.addParameter('bpHz', [3 30]);   % 帶通頻帶(Hz), 用於 mode='bp'
p.addParameter('baseWin', 0.5);   % 基線視窗(秒), 用於 mode='amp'
p.parse(varargin{:});
W   = p.Results.W;    k  = p.Results.k;   pad = p.Results.pad;
lr  = p.Results.loRatio; alpha = p.Results.alpha;
M   = max(1, round(p.Results.minDur*fs));
G   = max(1, round(p.Results.minGap*fs));
mode= lower(p.Results.mode);

x = x(:) - mean(x,'omitnan');    % 去均值

% -------- 1) 準則量 Q：依偵測子選擇 --------
switch mode
    case 'd2'   % 二階導數能量（曲率）
        s = conv(x,[1 -2 1],'same');      % 也可用 gradient(gradient(x))*fs^2
        Q = movmean(s.^2, W);
    case 'd1'   % 一階導數能量（斜率）
        s = gradient(x)*fs;
        Q = movmean(s.^2, W);
    case 'bp'   % 帶通能量（匹配 ~100ms）
        Wn = p.Results.bpHz/(fs/2);
        [sos,g] = butter(4, Wn, 'bandpass');
        xb = filtfilt(sos,g,x);
        Q  = movmean(xb.^2, W);
    case 'amp'  % 振幅偏離能量（深谷/高峰）
        Ltr = max(1, round(p.Results.baseWin*fs));
        base = movmedian(x, Ltr);         % 或 movmean
        a = abs(x - base);
        Q = movmean(a.^2, W);
    otherwise
        error('Unknown mode: %s', mode);
end

% -------- 2) 背景法估門檻 T（在 Q 的尺度上） --------
Qr  = rms(Q, 'omitnan');                 % 粗 RMS
mask = Q > k*Qr;                         % 標出高能量片段
if any(mask), mask = conv(double(mask),ones(1,2*pad+1),'same')>0; end
Qlam = Q; Qlam(mask) = NaN;              % 僅留背景
T = rms(Qlam, 'omitnan'); if ~isfinite(T) || T<=0, T = Qr; end

% -------- 3) 二值化：雙門檻 + 最短持續 + 合併小間隙 --------
Ihi = Q > (alpha*T); Ilo = Q > (lr*alpha*T);
Ih  = false(size(Q));
d = diff([0; Ihi; 0]); sidx = find(d==1); eidx = find(d==-1)-1;
for j=1:numel(sidx)
    a = find(~Ilo(1:sidx(j)-1),1,'last'); if isempty(a), a=1; else, a=a+1; end
    b = find(~Ilo(eidx(j)+1:end),1,'first'); if isempty(b), b=numel(Ilo)-eidx(j); end
    b = eidx(j)+b-1; Ih(a:b) = true;
end
% 合併小間隙
d = diff([0; Ih; 0]); sidx = find(d==1); eidx = find(d==-1)-1;
j=1; while j<numel(sidx)
    if sidx(j+1)-eidx(j)-1 <= G
        eidx(j) = eidx(j+1); sidx(j+1)=[]; eidx(j+1)=[];
    else
        j = j+1;
    end
end
% 去掉太短
I = false(size(Ih));
for j=1:numel(sidx)
    if eidx(j)-sidx(j)+1 >= M, I(sidx(j):eidx(j)) = true; end
end

gamma = mean(I);
end
