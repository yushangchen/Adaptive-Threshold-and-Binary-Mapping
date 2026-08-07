function shadeIntervals(t, I, color)
% 在當前座標軸把 I==1 的時間區段塗成半透明色塊
if nargin<3, color = [0.85 0.92 1]; end
I = logical(I(:));
d = diff([false; I; false]); s = find(d==1); e = find(d==-1)-1;
yl = ylim; holdState = ishold; hold on
for k = 1:numel(s)
    patch([t(s(k)) t(e(k)) t(e(k)) t(s(k))], [yl(1) yl(1) yl(2) yl(2)], ...
          color, 'FaceAlpha',0.25, 'EdgeColor','none');
end
if ~holdState, hold off, end
end
