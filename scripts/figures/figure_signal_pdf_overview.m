function figure_signal_pdf_overview(dataSource, tapName, caseIndices, outputFile)
%FIGURE_SIGNAL_PDF_OVERVIEW Path-independent form of ATBMPAPERFIGURE.m.
setup;
D=atbm.loadDataset(dataSource);
if nargin<2 || isempty(tapName), tapName='Cpp90_2D'; end
if nargin<3 || isempty(caseIndices), caseIndices=[7 25 26 32 44]; end
X=atbm.getTap(D,tapName);
f=figure('Color','w','Position',[100 100 1500 620]);
for k=1:numel(caseIndices)
    idx=caseIndices(k); seg=X(:,idx);
    subplot(2,numel(caseIndices),k);
    plot(D.t,seg); ylim([-3.5 0]); grid on;
    title(sprintf('%s, case %d',tapName,idx),'Interpreter','none');
    xlabel('time (s)'); ylabel('C_p');
    subplot(2,numel(caseIndices),numel(caseIndices)+k);
    [xp,yp]=atbm.makePDF(seg);
    plot(xp,yp,'r-*','LineWidth',1.4); grid on;
    xlabel('C_p'); ylabel('Probability');
end
if nargin>=4 && ~isempty(outputFile)
    folder=fileparts(outputFile); if ~isempty(folder)&&~isfolder(folder),mkdir(folder);end
    exportgraphics(f,outputFile,'Resolution',300);
end
end
