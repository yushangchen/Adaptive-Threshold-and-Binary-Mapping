tapTable=S.tapTable;
figure("Color","w","Position",[100 100 1200 480]); tiledlayout(1,2);
nexttile; scatter(tapTable.thetaDeg,tapTable.zD,100,tapTable.BitIndex,"filled");
text(tapTable.thetaDeg+2,tapTable.zD,string(tapTable.BitIndex));
xlabel("\theta (deg)"); ylabel("z/D"); title("12-tap bit ordering"); grid on;
nexttile; B=[zeros(1,12);ones(1,4),zeros(1,8);ones(1,12)];
imagesc(B); xlabel("Bit index"); ylabel("Example"); title("Pattern examples");
exportgraphics(gcf,"figures/Fig07_binary_mapping.png","Resolution",300);
