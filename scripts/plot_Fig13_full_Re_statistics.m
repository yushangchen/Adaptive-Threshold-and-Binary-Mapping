T=atbm.summaryTable(S);
figure("Color","w","Position",[100 100 1350 850]); tiledlayout(2,2);
nexttile; plot(T.Re,T.MeanActiveTapCount,"-o"); xlabel("Re"); ylabel("Mean active taps"); grid on;
nexttile; plot(T.Re,T.Occupancy_zD1,"-o",T.Re,T.Occupancy_zD2,"-s", ...
 T.Re,T.Occupancy_zD3p5,"-^"); xlabel("Re"); ylabel("Occupancy");
legend("z/D=1","z/D=2","z/D=3.5"); grid on;
nexttile; plot(T.Re,T.AllZeroProbability,"-o"); xlabel("Re"); ylabel("P(pattern 0)"); grid on;
nexttile; plot(T.Re,T.SAI,"-o"); yline(0,":"); xlabel("Re"); ylabel("SAI"); grid on;
writetable(T,"results/Fig13_statistics.csv");
exportgraphics(gcf,"figures/Fig13_full_Re_statistics.png","Resolution",300);
