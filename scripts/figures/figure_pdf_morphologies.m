function results = figure_pdf_morphologies(dataSource, outputFile)
%FIGURE_PDF_MORPHOLOGIES Reproduce the three selected AT PDF cases.
setup;
D = atbm.loadDataset(dataSource);
cfg = atbm.defaultConfig();
selected = [cfg.validation.unimodal,cfg.validation.separated,cfg.validation.figure4Overlapped];
titles = {'(a) Unimodal PDF','(b) Bimodal-separated PDF','(c) Bimodal-overlapped PDF'};
results = cell(1,3);
for k=1:3
    seg=atbm.getTap(D,selected(k).tapName,selected(k).caseIdx);
    results{k}=atbm.extractAT(seg);
end
f=figure('Color','w','Position',[80 80 1500 460]);
tl=tiledlayout(f,1,3,'TileSpacing','compact','Padding','compact');
for k=1:3
    ax=nexttile(tl,k);
    atbm.plotATResult(ax,results{k},false,false);
    title(ax,titles{k},'FontWeight','bold','FontName','Times New Roman');
end
if nargin<2 || isempty(outputFile)
    outputFile=fullfile('figures','Fig4_AT_schematic_selected.png');
end
folder=fileparts(outputFile); if ~isempty(folder)&&~isfolder(folder),mkdir(folder);end
exportgraphics(f,outputFile,'Resolution',300);
end
