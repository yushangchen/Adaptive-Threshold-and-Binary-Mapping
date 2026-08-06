nShow=min(4,numel(S.Re)); idx=round(linspace(1,numel(S.Re),nShow));
figure("Color","w","Position",[100 100 1300 760]);
tiledlayout(nShow,1,"Padding","compact","TileSpacing","compact");
for q=1:nShow
 k=idx(q); nexttile; B=S.binaryMaps{k}; n=min(size(B,1),5000);
 imagesc((0:n-1)/S.config.Fs,1:size(B,2),B(1:n,:)');
 ylabel("Bit index"); title(sprintf("Re = %.3g",S.Re(k)));
end
xlabel("Time (s)");
exportgraphics(gcf,"figures/Fig09_12_representative_maps.png","Resolution",300);
