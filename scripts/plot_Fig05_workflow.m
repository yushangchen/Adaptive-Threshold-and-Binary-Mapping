figure("Color","w","Position",[100 100 1250 520]); axis off;
labels=["Multi-tap Cp","Local PDFs","Candidate extraction","Threshold selection", ...
 "Binary conversion","12-bit assembly","State map","Transition metrics"];
x=linspace(0.08,0.92,4);
for i=1:4
 annotation("textbox",[x(i)-0.09 0.62 0.18 0.18],"String",labels(i), ...
  "HorizontalAlignment","center","VerticalAlignment","middle","LineWidth",1.2);
 if i<4, annotation("arrow",[x(i)+0.09 x(i+1)-0.09],[0.71 0.71]); end
 annotation("textbox",[x(i)-0.09 0.20 0.18 0.18],"String",labels(i+4), ...
  "HorizontalAlignment","center","VerticalAlignment","middle","LineWidth",1.2);
 if i<4, annotation("arrow",[x(i)+0.09 x(i+1)-0.09],[0.29 0.29]); end
end
annotation("arrow",[0.92 0.92],[0.62 0.38]);
exportgraphics(gcf,"figures/Fig05_ATBM_workflow.png","Resolution",300);
