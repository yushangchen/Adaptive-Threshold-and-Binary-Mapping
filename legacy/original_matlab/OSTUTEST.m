% 造一個雙峰資料：N(0,1) 與 N(4,1) 混合
x = [randn(400,1)*1 + 0; randn(600,1)*1 + 4];

[T, info] = otsu1d(x, 'NumBins', 128);

fprintf('Otsu threshold T = %.3f\n', T);

% 視覺化
edges = info.edges; c = info.counts;
bc = 0.5*(edges(1:end-1)+edges(2:end));
bar(bc, c, 'hist'); hold on
ymax = max(c)*1.1;
plot([T T], [0 ymax], 'r--','LineWidth',1.5)
title('Histogram with Otsu threshold'); xlabel('x'); ylabel('count'); grid on
