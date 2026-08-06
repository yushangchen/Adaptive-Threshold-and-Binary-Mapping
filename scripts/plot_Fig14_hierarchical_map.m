valid=find(~cellfun(@isempty,S.hierarchicalMaps),1,"last");
assert(~isempty(valid),"No hierarchical map available.");
H=S.hierarchicalMaps{valid}; n=min(size(H,1),5000);
figure("Color","w","Position",[100 100 1250 520]);
imagesc((0:n-1)/S.config.Fs,1:size(H,2),H(1:n,:)');
xlabel("Time (s)"); ylabel("Bit index");
title(sprintf("Hierarchical map, Re = %.3g",S.Re(valid)));
colorbar; clim([0 3]);
exportgraphics(gcf,"figures/Fig14_hierarchical_map.png","Resolution",300);
