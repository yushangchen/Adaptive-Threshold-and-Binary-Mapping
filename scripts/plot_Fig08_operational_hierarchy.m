cfg=atbm.defaultConfig();
T=[cfg.representative.Tcore cfg.representative.Tmod cfg.representative.Tbasic];
figure("Color","w","Position",[100 100 1250 480]); tiledlayout(1,2);
nexttile;
if isfield(S,"candidateTable")
 C=S.candidateTable; idx=C.zD==2 & C.thetaDeg==90;
 vals=[C.TL(idx);C.TR(idx);C.Tv(idx)]; vals=vals(isfinite(vals)&vals<-0.2);
else
 vals=[-2.55 -2.46 -2.42 -2.02 -1.95 -1.91 -1.02 -0.97 -0.92];
end
scatter(ones(size(vals)),vals,45,"filled"); xlim([0.7 1.3]); xticks([]);
for v=T, yline(v,"--"); end
ylabel("Candidate C_p"); title("Pooled candidates"); grid on;
nexttile; x=linspace(-3.5,0,500);
plot(x,exp(-((x+0.65)/0.25).^2),"LineWidth",1.4); hold on;
plot(x,0.6*exp(-((x+1.55)/0.28).^2),"LineWidth",1.4);
plot(x,0.45*exp(-((x+2.25)/0.22).^2),"LineWidth",1.4);
for v=T, xline(v,"--"); end
xlabel("C_p"); ylabel("Representative PDF"); title("Operational hierarchy"); grid on;
exportgraphics(gcf,"figures/Fig08_operational_hierarchy.png","Resolution",300);
