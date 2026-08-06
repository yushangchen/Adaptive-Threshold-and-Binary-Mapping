cfg=atbm.defaultConfig(); rng(7);
X={-0.75+0.13*randn(40000,1), ...
 [-1.85+0.09*randn(20000,1);-0.62+0.10*randn(20000,1)], ...
 [-1.35+0.24*randn(22000,1);-0.90+0.23*randn(18000,1)]};
figure("Color","w","Position",[100 100 1400 440]);
tiledlayout(1,3,"Padding","compact","TileSpacing","compact");
titles=["Unimodal","Bimodal-separated","Bimodal-overlapped"];
for i=1:3
 a=atbm.analyzeLocalSignal(X{i},cfg); nexttile;
 plot(a.pdf.centers,a.pdf.density,"LineWidth",1.5); hold on;
 vals=[a.candidates.TL a.candidates.TR a.candidates.Tv];
 for v=vals(isfinite(vals)), xline(v,"--","LineWidth",1.2); end
 title(titles(i)); xlabel("C_p"); ylabel("PDF"); grid on;
end
exportgraphics(gcf,"figures/Fig06_threshold_examples.png","Resolution",300);
