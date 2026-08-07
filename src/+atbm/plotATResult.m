function plotATResult(ax, result, showLegend, showLongLabels)
%PLOTATRESULT Plot AT geometry in the style of NEWmethod_test.m.

if nargin < 3, showLegend=false; end
if nargin < 4, showLongLabels=false; end
hold(ax,'on');
x=result.x; y=result.y;
hPDF=plot(ax,x,y,'r-','LineWidth',1.8);
plot(ax,x,y,'r*','LineWidth',0.7,'MarkerSize',3.5);

switch result.mode
    case 0
        hChord=plot(ax,[x(1) result.xP],[y(1) result.yP],'--', ...
            'Color',[0 0.35 0.85],'LineWidth',1.4);
        plot(ax,[result.xP x(end)],[result.yP y(end)],'--', ...
            'Color',[0 0.35 0.85],'LineWidth',1.4);
        hPeak=plot(ax,result.xP,result.yP,'o','MarkerSize',7, ...
            'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor','k');
        hTL=plot(ax,result.TL,result.yTL,'s','MarkerSize',6, ...
            'MarkerFaceColor',[0.15 0.15 0.15],'MarkerEdgeColor','k');
        hTR=plot(ax,result.TR,result.yTR,'s','MarkerSize',6, ...
            'MarkerFaceColor',[0.85 0.1 0.75],'MarkerEdgeColor','k');
        xline(ax,result.TL,'--','Color',[0.25 0.25 0.25],'LineWidth',1.2);
        xline(ax,result.TR,'--','Color',[0.85 0.1 0.75],'LineWidth',1.2);
        text(ax,result.xP-0.01,result.yP+0.02,'p','FontSize',15,'FontName','Times New Roman');
        text(ax,result.TL-0.22,result.yTL+0.06,'T_L','FontSize',15,'FontName','Times New Roman');
        text(ax,result.TR+0.05,result.yTR+0.05,'T_R','FontSize',15, ...
            'FontName','Times New Roman','Color',[0.75 0 0.65]);
        if showLongLabels
            text(ax,(x(1)+result.xP)/2,(y(1)+result.yP)/2,'left chord', ...
                'FontSize',11,'Color',[0 0.35 0.85],'FontAngle','italic');
        else
            text(ax,x(1)+0.15,max(y)*0.6,'chord-distance','FontSize',13, ...
                'Color',[0 0.35 0.85],'FontAngle','italic');
        end
        infoBox(ax,{sprintf('T_L = %.3f',result.TL),sprintf('T_R = %.3f',result.TR)},[0.08 0.92]);
        if showLegend
            legend(ax,[hPDF hChord hPeak hTL hTR], ...
                {'PDF','chord','peak','T_L knee','T_R knee'},'Location','northwest','Box','off');
        end
    case 1
        hP1=plot(ax,result.xL,result.yL,'o','MarkerSize',7,'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor','k');
        hP2=plot(ax,result.xR,result.yR,'o','MarkerSize',7,'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor','k');
        hV=plot(ax,result.valX,result.valY,'v','MarkerSize',8,'MarkerFaceColor','k','MarkerEdgeColor','k');
        hChord=plot(ax,[result.xL result.valX],[result.yL result.valY],'--','Color',[0 0.35 0.85],'LineWidth',1.4);
        plot(ax,[result.valX result.xR],[result.valY result.yR],'--','Color',[0 0.35 0.85],'LineWidth',1.4);
        hTL=plot(ax,result.TL,result.yTL,'s','MarkerSize',6,'MarkerFaceColor',[0.15 0.15 0.15],'MarkerEdgeColor','k');
        hTR=plot(ax,result.TR,result.yTR,'s','MarkerSize',6,'MarkerFaceColor',[0.85 0.1 0.75],'MarkerEdgeColor','k');
        xline(ax,result.TL,'--','Color',[0.25 0.25 0.25],'LineWidth',1.2);
        xline(ax,result.TR,'--','Color',[0.85 0.1 0.75],'LineWidth',1.2);
        text(ax,result.xL-0.22,result.yL+0.003,'p_1','FontSize',15,'FontName','Times New Roman');
        text(ax,result.xR+0.05,result.yR+0.003,'p_2','FontSize',15,'FontName','Times New Roman');
        text(ax,result.valX-0.03,result.valY+0.005,'v','FontSize',15,'FontName','Times New Roman');
        text(ax,result.TL+0.02,result.yTL+0.03,'T_L','FontSize',15,'FontName','Times New Roman');
        text(ax,result.TR+0.03,result.yTR+0.03,'T_R','FontSize',15,'FontName','Times New Roman','Color',[0.75 0 0.65]);
        infoBox(ax,{sprintf('SR = %.2f',result.SR),sprintf('valley ratio = %.2f',result.valleyRatio)},[0.08 0.92]);
        if showLegend
            legend(ax,[hPDF hChord hP1 hP2 hV hTL hTR], ...
                {'PDF','local chord','peak p_1','peak p_2','valley','T_L knee','T_R knee'}, ...
                'Location','northeast','Box','off');
        end
    case 2
        hP1=plot(ax,result.xL,result.yL,'o','MarkerSize',7,'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor','k');
        hP2=plot(ax,result.xR,result.yR,'o','MarkerSize',7,'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor','k');
        hV=plot(ax,result.valX,result.valY,'v','MarkerSize',8,'MarkerFaceColor','k','MarkerEdgeColor','k');
        hTv=xline(ax,result.Tv,':','Color',[0.15 0.15 0.15],'LineWidth',1.5);
        text(ax,result.xL-0.2,result.yL+0.005,'p_1','FontSize',15,'FontName','Times New Roman');
        text(ax,result.xR+0.05,result.yR,'p_2','FontSize',15,'FontName','Times New Roman');
        text(ax,result.valX+0.04,result.valY+0.04,'T_v','FontSize',15,'FontName','Times New Roman');
        infoBox(ax,{sprintf('SR = %.2f',result.SR),sprintf('valley ratio = %.2f',result.valleyRatio)},[0.60 0.92]);
        if showLegend
            legend(ax,[hPDF hP1 hP2 hV hTv],{'PDF','peak p_1','peak p_2','valley','T_v'}, ...
                'Location','northeast','Box','off');
        end
end
xlabel(ax,'C_p','FontName','Times New Roman');
ylabel(ax,'Probability','FontName','Times New Roman');
xlim(ax,[x(1) x(end)]); ylim(ax,[0 max(y)*1.18]);
set(ax,'FontName','Times New Roman','FontSize',13,'LineWidth',2, ...
    'Box','on','XGrid','on','YGrid','on','GridAlpha',0.18);
end

function infoBox(ax,strCell,pos)
text(ax,pos(1),pos(2),strCell,'Units','normalized','FontName','Times New Roman', ...
    'FontSize',13,'VerticalAlignment','top','HorizontalAlignment','left', ...
    'BackgroundColor','w','EdgeColor',[0.35 0.35 0.35],'Margin',5);
end
