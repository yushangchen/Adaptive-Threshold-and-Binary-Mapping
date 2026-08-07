ia=33; %改RE範圍 
THTH=[-1.025,-0.975,-0.975,-0.975,-1.225,-1.225]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
THTH110=[-0.925,-0.875,-0.925,-0.875,-1.125,-1.175]; %ia=5

% THTH=[-1.275,-0.975,-0.975,-0.975,-1.325,-1.275]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-0.975,-0.875,-0.925,-0.825,-1.125,-1.175]; % ia=7 

% THTH=[-1.844,-1.825,-1.075,-1.175,-1.275,-1.175]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-1.075,-0.925,-0.925,-0.875,-0.975,-1.025]; % ia=25 

% THTH=[-2.225,-2.175,-2.275,-1.075,-2.375,-1.125]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-1.825,-1.825,-1.775,-0.825,-1.975,-0.925]; % ia=33 
% 
% THTH_5=[-1.025,-0.975,-0.975,-0.975,-1.225,-1.225]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110_5=[-0.925,-0.875,-0.925,-0.875,-1.125,-1.175]; %ia=5
% 
% THR=[-2.825,-2.725,-1.475,-0.575,-1.775,-0.725];
% TR110=[-1.225,-2.425,-1.225,-0.325,-1.975,-0.575];
%% 90
%1D
figure (1)
subplot(3,2,5)
plot(t,Cpp90_1D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(1),'-r','linewidth',2);
hold on
% yline(THR(1),'-g','linewidth',2);
% hold on
yline(THTH_5(1),'-k','linewidth',2);
hold off
% legend('C_{p,+90\circ}','Th_LSB +90','Th_basic +90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=1  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
subplot(3,2,6)
plot(t,Cpn90_1D(:,ia),'r.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(2),'-r','linewidth',2);
hold on
% yline(THR(2),'-g','linewidth',2);
% hold on
yline(THTH_5(2),'-k','linewidth',2);
hold off
legend('C_{p,-90\circ}','Th_{LSB2,-90} ','Th_{basic,-90}','Th_{LSB2,-90}','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=1  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
% 2D
subplot(3,2,3)
plot(t,Cpp90_2D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(3),'-r','linewidth',2);
hold on
yline(THR(3),'-g','linewidth',2);
hold on
yline(THTH_5(3),'-k','linewidth',2);
hold off
legend('C_{p,+90\circ}','Th_{LSB2,+90} ','Th_{LSB1,+90}','Th_{basic,+90}','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=2  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
subplot(3,2,4)
plot(t,Cpn90_2D(:,ia),'r.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(4),'-k','linewidth',2);
% hold on
% yline(THR(4),'-g','linewidth',2);
hold off
% legend('C_{p,-90\circ}','Th_{LSB1,-90} ','Th_{basic,-90}','Th_{LSB2,-90}','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=2  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
% 35D
subplot(3,2,1)
plot(t,Cpp90_3_5D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(5),'-r','linewidth',2);
hold on
yline(THR(5),'-g','linewidth',2);
hold on
yline(THTH_5(5),'-k','linewidth',2);
hold off
%legend('C_{p,+90\circ}','threshold +90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=3.5  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
subplot(3,2,2)
plot(t,Cpn90_3_5D(:,ia),'r.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH_5(6),'-k','linewidth',2);
hold on
% yline(THR(6),'-g','linewidth',2);
% hold off
%legend('C_{p,-90\circ}','threshold -90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=3.5  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);

%% 110
%1D
figure
subplot(3,2,5)
plot(t,Cpp110_1D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH110(1),'-r','linewidth',2);
hold on
yline(TR110(1),'-g','linewidth',2);
hold on
yline(THTH110_5(1),'-k','linewidth',2);
hold off
legend('C_{p,+110\circ}','Th_{LSB2,+110}','Th_{LSB1,+110}','Th_{basic,+110}','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=1  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
subplot(3,2,6)
plot(t,Cpn110_1D(:,ia),'r.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH110(2),'-r','linewidth',2);
hold on
% yline(TR110(2),'-g','linewidth',2);
% hold on
yline(THTH110_5(2),'-k','linewidth',2);
hold off
legend('C_{p,-110\circ}','Th_{LSB2,-110}','Th_{basic,-110}','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=1  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
% 2D
subplot(3,2,3)
plot(t,Cpp110_2D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH110(3),'-r','linewidth',2);
hold on
yline(TR110(3),'-g','linewidth',2);
hold on
yline(THTH110_5(3),'-k','linewidth',2);
hold off
%legend('C_{p,+90\circ}','threshold +90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=2  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
subplot(3,2,4)
plot(t,Cpn110_2D(:,ia),'r.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH110(4),'-r','linewidth',2);
hold on
yline(TR110(4),'-g','linewidth',2);
hold on
yline(THTH110_5(4),'-k','linewidth',2);
hold off
%legend('C_{p,-90\circ}','threshold -90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=2  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
%35D
subplot(3,2,1)
plot(t,Cpp110_3_5D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH110(5),'-r','linewidth',2);
hold on
% yline(TR110(5),'-g','linewidth',2);
% hold on
yline(THTH110_5(5),'-k','linewidth',2);
hold off
%legend('C_{p,+90\circ}','threshold +90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=3.5  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
subplot(3,2,2)
plot(t,Cpn110_3_5D(:,ia),'r.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH110(6),'-k','linewidth',2);
% hold on
% yline(TR110(6),'-g','linewidth',2);
% hold on
% yline(THTH110_5(6),'-k','linewidth',2);
hold off
%legend('C_{p,-90\circ}','threshold -90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=3.5  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);

%% BM
% 假設每個變數長度相同 (120000)
Cp_1D = [Cpp90_1D(:,ia).'; Cpn90_1D(:,ia).';Cpp110_1D(:,ia).'; Cpn110_1D(:,ia).'];
Cp_2D = [Cpp90_2D(:,ia).'; Cpn90_2D(:,ia).'; Cpp110_2D(:,ia).'; Cpn110_2D(:,ia).'];
Cp_35D= [Cpp90_3_5D(:,ia).'; Cpn90_3_5D(:,ia).';Cpp110_3_5D(:,ia).'; Cpn110_3_5D(:,ia).'];

% 合併成完整矩陣 (12 x 120000)
Cp_all = [Cp_1D; Cp_2D; Cp_35D];

% 閥值（THTH 對應前 6 點，THTH110 對應後 6 點）
TH = [THTH(1);THTH(2);THTH110(1);THTH110(2); THTH(3);THTH(4);THTH110(3);THTH110(4);...
    THTH(5);THTH(6);THTH110(5);THTH110(6)];   % 12×1 向量

% 一次性生成二值矩陣 (12 × 120000)
index = Cp_all < TH;

% index 現在是 logical 矩陣
% 若你要 0/1 整數形式：
index = double(index);
%% B
%% 假設你已有 index: 12×N 的 0/1 (logical 或 0/1 double)
[Ntaps, N] = size(index);

% 若你希望「第1列」是字串的最左邊，也是最大的位元（MSB），設為 true
row1_is_MSB = true;    % 若想第1列是 LSB，改成 false

% --- 用你的列順序直接編碼 state ---
if row1_is_MSB
    % 第1列→最高位，…，第Ntaps列→最低位
    w = 2.^(Ntaps-1:-1:0);              % 1×Ntaps（double）
else
    % 第1列→最低位（LSB），…，第Ntaps列→最高位
    w = 2.^(0:Ntaps-1);                  % 1×Ntaps
end
state = uint16( sum(double(index.').*w, 2) );   % N×1

% --- 分布與 Top-K（照舊） ---
nbin = 2^Ntaps;
hist4096 = accumarray(double(state)+1, 1, [nbin,1], @sum, 0);
pdf4096  = hist4096 / N;

K = 6;
[topCount, ridx] = maxk(hist4096, K);
topState = ridx - 1;
topFrac  = topCount / N;

% --- 依你的列順序，還原成 12×K 的 0/1 圖樣（不重排、不翻轉） ---
s16 = uint16(topState(:));
bits_mat = false(Ntaps, K);          % 列=你的 tap 順序
if row1_is_MSB
    % 注意：bitget 的 1 是 LSB，所以這裡用 (Ntaps - row + 1)
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, Ntaps - row + 1).';
    end
else
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, row).';
    end
end

% --- 產生與「你的列順序」一致的 0/1 字串（左→右 = 第1列→第Ntaps列） ---
topBin = strings(K,1);
for k = 1:K
    topBin(k) = string(num2str(bits_mat(:,k).','%1d'));
end
%% 4) 作圖與輸出
% 圖1：4096格直方圖（非零項）
nz = find(hist4096>0);
% figure('Color','w','Position',[200 200 900 420]);
% tiledlayout(1,2,'Padding','compact','TileSpacing','compact');
% nexttile;  bar(nz-1, hist4096(nz), 'BarWidth', 1);
% xlabel('state'); ylabel('count'); title('Histogram (non-zero)'); grid on; xlim([0 nbin-1]);
% nexttile;  semilogy(nz-1, hist4096(nz), '.-');
% xlabel('state'); ylabel('count (log)'); title('Histogram (log, non-zero)'); grid on; xlim([0 nbin-1]);
% exportgraphics(gcf, 'hist4096_overview.png', 'Resolution', 300);

% 圖2：Top-K 條狀圖（標 bit 與比例）
figure('Color','w','Position',[200 200 760 420]);

% ---- 固定 X 類別順序為你給的順序 ----
% topBin 已是 string；若你要顯示十進位(四位數)：
topDec = bin2dec(topBin);                  % 0..4095
xLabels = compose('%04d', topDec);         % '0000'..'4095'
xCat    = categorical(xLabels, xLabels, 'Ordinal', true);  % 依輸入順序

% ---- 用百分比繪圖（或改成比率，二擇一）----
yPerc = 100*topFrac;                       % 轉百分比
bar(xCat, yPerc);
ylabel('Percentage (%)');                  % 若改用比率，就畫 bar(xCat, topFrac); ylabel('Ratio');

xlabel(sprintf('%d-bit pattern', Ntaps));
title(sprintf('Top-%d states (fraction)', K));
grid on;

% ---- 標註數值，並給一點上方空間 ----
text(1:numel(yPerc), yPerc, compose('%.2f%%', yPerc), ...
     'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',8);

ylim([0, max(yPerc)*1.15]);                % 讓標註不被裁掉
set(gca,'TickLabelInterpreter','none');    % 避免 '^\o' 之類被當成 TeX

%%
Ntaps = size(index,1);           % 應為 12
row1_is_MSB = true;              % 若第1列為最高位 (MSB)，設 true；若第1列為 LSB，設 false
K = numel(topState);             % 確保 K 與 topState 一致
s16 = uint16(topState(:));       % K×1
bits_mat = false(Ntaps, K);
if row1_is_MSB
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, Ntaps-row+1).';  % 第1列取最高位
    end
else
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, row).';          % 第1列取最低位
    end
end
bits_vis = flipud(bits_mat);     % 只為了視覺上把列顛倒（可拿掉）
% 圖3：Top-K 二值圖（tap × state）
figure('Color','w','Position',[200 200 460 520]);
imagesc(bits_vis); axis image; colormap(gray); caxis([0 1]); cb = colorbar; cb.Ticks=[0 1]; cb.TickLabels={'0','1'};
title(sprintf('Top-%d states (binary map: tap × state)', K));
xlabel('state rank (1=most)'); ylabel('tap (top=flipud)');
set(gca,'XTick',1:K,'XTickLabel',1:K);

% y 軸 tap 名稱（請依你的 12 測點實際順序替換）
tap_names = {'90^o 1D p','90^o 1D n','110^o 1D p','110^o 1D n','90^o 2D p','90^o 2D n', ...
             '110^o 2D p','110^o 2D n','90^o 3.5D p','90^o 3.5D n','110^o 3.5D p','110^o 3.5D n'};
set(gca,'YTick',1:Ntaps,'YTickLabel',tap_names(end:-1:1));  % flip 後對齊 bits_vis
exportgraphics(gcf, 'topK_bits_map.png', 'Resolution', 300);

%% 5) （可選）每瞬間同時為 1 的 tap 數與滑動平均
fs=1000;
active_count = sum(index,1);                 % 1×N
win_ms = 20; wlen = max(1, round(win_ms*1e-3*fs));
ac_ma   = movmean(active_count, wlen);

figure('Color','w','Position',[200 200 1000 340]);
edges = -0.5:1:12.5;
[counts,~] = histcounts(active_count, edges);
prob = counts / numel(active_count) * 100;

bar(0:12, prob);
xlabel('Number of active taps');
ylabel('Probability (%)');
title('Active-count distribution');
grid on;
xlim([-0.5 12.5]);
%% all figure 
%% 4) Combined figure: Top-K pattern + probability + tap occupancy

K = 6;

% ---------- Top-K pattern probability ----------
topDec  = bin2dec(topBin);
xLabels = compose('%04d', topDec);
yPerc   = 100 * topFrac;

% ---------- Top-K binary map ----------
Ntaps = size(index,1);
s16 = uint16(topState(:));
bits_mat = false(Ntaps, K);

if row1_is_MSB
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, Ntaps-row+1).';
    end
else
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, row).';
    end
end

% 視覺上由上到下顯示 3.5D -> 2D -> 1D
bits_vis = flipud(bits_mat);

tap_names = {'90 1D p','90 1D n','110 1D p','110 1D n', ...
             '90 2D p','90 2D n','110 2D p','110 2D n', ...
             '90 3.5D p','90 3.5D n','110 3.5D p','110 3.5D n'};

tap_names_vis = tap_names(end:-1:1);

% ---------- Tap-wise occupancy ----------
tap_occ = mean(index, 2) * 100;      % 每個 tap 進入 state 1 的比例
tap_occ_vis = flipud(tap_occ);       % 與 binary map 顯示方向一致

% ---------- Combined figure layout ----------
fig = figure('Color','w','Position',[100 100 1350 780]);

tiledlayout(2,2,'Padding','compact','TileSpacing','compact');

% (a) Top-K binary state map
nexttile([2 1]);
imagesc(1-bits_vis);
hold on

% 垂直格線
for x = 0.5:1:(K+0.5)
    plot([x x],[0.5 Ntaps+0.5], ...
        'Color',[0.7 0.7 0.7], ...
        'LineWidth',0.8);
end

% 水平格線
for y = 0.5:1:(Ntaps+0.5)
    plot([0.5 K+0.5],[y y], ...
        'Color',[0.7 0.7 0.7], ...
        'LineWidth',0.8);
end

hold off
colormap(gca, gray);
caxis([0 1]);
axis image;

title('(a) Top-6 binary pressure-state patterns','FontWeight','bold','FontSize',16);
xlabel('State rank (1 = most frequent)','FontSize',14);
ylabel('Pressure tap','FontSize',14);

set(gca,'XTick',1:K,'XTickLabel',xLabels, ...
        'YTick',1:Ntaps,'YTickLabel',tap_names_vis, ...
        'FontSize',13, ...
        'TickLabelInterpreter','none');

xlabel('Pattern ID','FontSize',14);

% 拿掉 colorbar，避免占空間
% 白色 = state 1, 黑色 = state 0

% (b) Top-K probability
nexttile;
bar(yPerc);
grid on;

title('(b) Top-6 pattern probability','FontWeight','bold','FontSize',16);
ylabel('Probability (%)','FontSize',14);
xlabel('Pattern ID','FontSize',14);

set(gca,'XTick',1:K,'XTickLabel',xLabels, ...
        'FontSize',13, ...
        'TickLabelInterpreter','none');

ylim([0, max(yPerc)*1.18]);

text(1:K, yPerc, compose('%.2f%%', yPerc), ...
     'HorizontalAlignment','center', ...
     'VerticalAlignment','bottom', ...
     'FontSize',11);

%% (c) Spatial occupancy map

nexttile;

occ = mean(index,2)*100;

% 重排成實際空間位置

% occ_map = [
%     occ(10) occ(9)  occ(12) occ(11);   % 3.5D
%     occ(6)  occ(5)  occ(8)  occ(7);    % 2D
%     occ(2)  occ(1)  occ(4)  occ(3)     % 1D
% ];
occ_map = [
    occ(9)  occ(10)  occ(11)  occ(12);   % 3.5D: +90, -90, +110, -110
    occ(5)  occ(6)   occ(7)   occ(8);    % 2D:   +90, -90, +110, -110
    occ(1)  occ(2)   occ(3)   occ(4)     % 1D:   +90, -90, +110, -110
];


imagesc(occ_map);

colormap(gca, flipud(gray));
caxis([0 100]);   % Fig. 8–11 全部固定同一尺度
cb = colorbar;
cb.Label.String = 'Occupancy (%)';

title('(c) Spatial occupancy map','FontWeight','bold','FontSize',16);

xticks(1:4);
xticklabels({'+90','-90','+110','-110'});

yticks(1:3);
yticklabels({'3.5D','2D','1D'});

xlabel('Azimuth location');
ylabel('Height');

set(gca,'FontSize',13);

% 數值標註
for i=1:3
    for j=1:4
        if occ_map(i,j) > 50
            txtColor = 'w';
        else
            txtColor = 'k';
        end

        text(j,i,...
            sprintf('%.1f',occ_map(i,j)),...
            'HorizontalAlignment','center',...
            'Color',txtColor,...
            'FontWeight','bold');
    end
end

% ---------- Export ----------
exportgraphics(fig, sprintf('ATBM_Re_%d_TopK_summary.png', ia), 'Resolution', 600);


% THTH=[-2.225,-2.175,-2.275,-1.075,-2.375,-1.125]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-1.825,-1.825,-1.775,-0.825,-1.075,-0.925]; % ia=33 
% 
% THTH_5=[-1.025,-0.975,-0.975,-0.975,-1.225,-1.225]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110_5=[-0.925,-0.875,-0.925,-0.875,-1.125,-1.175]; %ia=5
% 
% THR=[-2.825,-2.725,-1.475,-0.575,-1.775,-0.725];
% TR110=[-1.225,-2.425,-1.225,-0.325,-1.975,-0.575];
%% BM
THTH=[-2.225,-2.175,-2.275,NaN,-2.375,NaN]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
THTH_5=[-1.025,-0.975,-0.975,-0.975,-1.225,-1.225]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
THR=[NaN,NaN,-1.475,NaN,-1.775,NaN];

THTH110=[-1.825,-1.825,NaN,NaN,-1.975,-0.925]; % ia=33 
THTH110_5=[-0.925,-0.875,-0.925,-0.875,-1.125,NaN]; %ia=5
TR110=[NaN,NaN,-1.225,NaN,NaN,NaN];

% 假設每個變數長度相同 (120000)
CpLSB_1D = [Cpp90_1D(:,ia).'; Cpn90_1D(:,ia).';Cpp110_1D(:,ia).'; Cpn110_1D(:,ia).'];
CpLSB_2D = [Cpp90_2D(:,ia).'; Cpn90_2D(:,ia).'; Cpp110_2D(:,ia).'; Cpn110_2D(:,ia).'];
CpLSB_35D= [Cpp90_3_5D(:,ia).'; Cpn90_3_5D(:,ia).';Cpp110_3_5D(:,ia).'; Cpn110_3_5D(:,ia).'];

% 合併成完整矩陣 (12 x 120000)
Cp_allLSB = [CpLSB_1D; CpLSB_2D; CpLSB_35D];

% 閥值（THTH 對應前 6 點，THTH110 對應後 6 點）
THbasic = [THTH_5(1);THTH_5(2);THTH110_5(1);THTH110_5(2); THTH_5(3);THTH_5(4);THTH110_5(3);THTH110_5(4);...
    THTH_5(5);THTH_5(6);THTH110_5(5);THTH110_5(6)];   % 12×1 向量
THLSB2=[THTH(1);THTH(2);THTH110(1);THTH110(2); THTH(3);THTH(4);THTH110(3);THTH110(4);...
    THTH(5);THTH(6);THTH110(5);THTH110(6)];
THLSB1=[THR(1);THR(2);TR110(1);TR110(2); THR(3);THR(4);TR110(3);TR110(4);...
    THR(5);THR(6);TR110(5);TR110(6)];

use1 = ~isnan(THbasic);   % 12×1
use2 = ~isnan(THLSB1);
use3 = ~isnan(THLSB2);

% 2) index 計算：比較 + 遮罩（避免 NaN 被當成 0）
index1 = (Cp_all < THbasic) & use1;   % 邏輯 12×N
index2 = (Cp_all < THLSB1) & use2;
index3 = (Cp_all < THLSB2) & use3;

% 3) 需要 0/1 時再轉型
index1 = double(index1);
index2 = double(index2);
index3 = double(index3);
%
idx1_vis = index1;                 % 0/1
idx1_vis(~use1, :) = NaN;          % 缺門檻的整列標 NaN

figure('Color','w');
imagesc(idx1_vis, 'AlphaData', ~isnan(idx1_vis));   % NaN 透明
set(gca,'YDir','normal');                           % y 軸由上到下為 1..12
colormap(gray); caxis([0 1]);
cb = colorbar; cb.Ticks = [0 1]; cb.TickLabels = {'0','1'};
xlabel('sample'); ylabel('tap');
title('Index1: Cp < TH_{basic}');

% （可選）設定背景色，NaN 會透出這個顏色
set(gca,'Color',[1 1 1]);  % 白底

% （可選）y 軸 tap 名稱（依你的順序）
tap_names = {'90^o 1D p','90^o 1D n','110^o 1D p','110^o 1D n', ...
             '90^o 2D p','90^o 2D n','110^o 2D p','110^o 2D n', ...
             '90^o 3.5D p','90^o 3.5D n','110^o 3.5D p','110^o 3.5D n'};
set(gca,'YTick',1:numel(tap_names),'YTickLabel',tap_names);
grid on; box on;

%% 1) 合併 index1/2/3 → level ∈ {0,1,2,3}
% 既有：
% index1 = Cp_all < THbasic;   use1 = ~isnan(THbasic);   % pre-LSB(離開basic)
% index2 = Cp_all < THLSB1;    use2 = ~isnan(THLSB1);    % small-LSB 門檻
% index3 = Cp_all < THLSB2;    use3 = ~isnan(THLSB2);    % large-LSB 門檻
% （indexX 已經 & useX 過或尚未 &，都可；下方再用 useX 保護）

[Ntaps, N] = size(Cp_all);   % 與你的資料一致

% 轉成 logical（保險起見）
b1 = logical(index1);   b2 = logical(index2);   b3 = logical(index3);

% 初始化
level = zeros(Ntaps, N, 'uint8');

% 依規則逐層覆寫（越「大」的LSB優先）
% 規則：
%   - 有 large 門檻且達標 → 3
%   - 否則若有 small 門檻且達標 → 2
%   - 否則若有 basic 門檻且達標 → 1
%   - 其他 → 0（basic 狀態或無法判定）
if any(use3)
    mask3 = use3 & b3;           % 只能在有定義 LSB2 的 tap 上判 3
    level(mask3) = 3;
end
if any(use2)
    mask2 = use2 & b2 & (level < 3);   % 未被 3 蓋過的才設 2
    level(mask2) = 2;
end
if any(use1)
    mask1 = use1 & b1 & (level < 2);   % 未被 2/3 蓋過的才設 1
    level(mask1) = 1;
end

% （可選）若完全沒有任何門檻的 tap（~use1 & ~use2 & ~use3），你可視覺上標 NaN
has_any_TH = use1 | use2 | use3;
level_vis = double(level);
level_vis(~has_any_TH, :) = NaN;   % 只影響視覺，不影響後續統計

%% 2) level 熱圖（0..3，NaN 透明）
figure('Color','w');
imagesc(level_vis, 'AlphaData', ~isnan(level_vis));
set(gca,'YDir','normal');
% 離散 colormap：0 basic, 1 pre, 2 small, 3 large
cmap = [1 1 1;       % 0: 白 (basic)
        0.8 0.8 0.8; % 1: 淺灰 (pre-LSB)
        1 0.4 0.4;   % 2: 紅 (small-LSB)
        0 0 0];      % 3: 黑 (large-LSB)

colormap(cmap);
caxis([0 3]);
cb = colorbar; 
cb.Ticks = 0:3; 
cb.TickLabels = {'Inactive(0)','Weak(1)','Moderate(2)','Persistent(3)'};
xlabel('sample number'); ylabel('pressure tap');
title('Hierarchical pressure-state map');
grid on; box on;

% 若要自訂 y 軸標籤：
tap_names = {'90^o 1D p','90^o 1D n','110^o 1D p','110^o 1D n', ...
             '90^o 2D p','90^o 2D n','110^o 2D p','110^o 2D n', ...
             '90^o 3.5D p','90^o 3.5D n','110^o 3.5D p','110^o 3.5D n'};
set(gca,'YTick',1:Ntaps,'YTickLabel',tap_names);

%% 3) 進入 BM 所需的二值化與遮罩
% 三種關注：
index_pre   = (level >= 1);    use_pre   = use1;             % 需要 basic（離開basic即1）
index_any   = (level >= 2);    use_any   = (use2 | use3);    % 至少有 small 或 large 門檻
index_large = (level == 3);    use_large = use3;             % 必須有 large 門檻

% —— 最小化的 BM 編碼（以 index_any 為例；large/pre 類推）——
row1_is_MSB = true;
if row1_is_MSB
    w = 2.^(Ntaps-1:-1:0);
else
    w = 2.^(0:Ntaps-1);
end
% 用遮罩把不可用 tap 的權重清零（等效忽略）
w_any = w;  w_any(~use_any) = 0;
w_lrg = w;  w_lrg(~use_large) = 0;
w_pre = w;  w_pre(~use_pre) = 0;

% 狀態編碼
state_any = uint16(sum(double(index_any.').*w_any, 2));
state_lrg = uint16(sum(double(index_large.').*w_lrg, 2));
state_pre = uint16(sum(double(index_pre.').*w_pre, 2));

% 直方圖與 Top-K（以 any 為例）
nbin = 2^Ntaps;
hist_any = accumarray(double(state_any)+1, 1, [nbin,1], @sum, 0);
N = size(index_any,2);
[topCount, ridx] = maxk(hist_any, 6);
topState_any = ridx - 1;
topFrac_any  = topCount / N;

% 還原 bit 圖（any）
K = numel(topState_any);
bits_any = false(Ntaps, K);
s16 = uint16(topState_any(:));
for r = 1:Ntaps
    bitpos = row1_is_MSB * (Ntaps-r+1) + (~row1_is_MSB) * r;
    bits_any(r,:) = bitget(s16, bitpos).';
end

% 你已有的繪圖程式可直接餵：level 熱圖已完成；
% 若要畫 any 的 Top-K 條圖/bit map，就用 topState_any/topFrac_any/bits_any。

%% -------------------------------------------------------------------------------

THTH=[-2.225,-2.175,-2.275,-2.275,-2.375,-2.375]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
THTH110=[-1.825,-1.825,-1.775,-1.775,-1.775,-1.775]; % ia=33 

THTH_5=[-1.025,-0.975,-0.975,-0.975,-1.225,-1.225]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
THTH110_5=[-0.925,-0.875,-0.925,-0.875,-1.125,-1.175]; %ia=5

THR=[-1.475,-1.475,-1.475,-1.475,-1.775,-1.775];
TR110=[-1.225,-1.225,-1.225,-1.225,-1.475,-1.475];

THbasic = [THTH_5(1);THTH_5(2);THTH110_5(1);THTH110_5(2); THTH_5(3);THTH_5(4);THTH110_5(3);THTH110_5(4);...
    THTH_5(5);THTH_5(6);THTH110_5(5);THTH110_5(6)];   % 12×1 向量

THLSB1=[THR(1);THR(2);TR110(1);TR110(2); THR(3);THR(4);TR110(3);TR110(4);...
    THR(5);THR(6);TR110(5);TR110(6)];

THLSB2=[THTH(1);THTH(2);THTH110(1);THTH110(2); THTH(3);THTH(4);THTH110(3);THTH110(4);...
    THTH(5);THTH(6);THTH110(5);THTH110(6)];

use1 = ~isnan(THbasic);   % 12×1
use2 = ~isnan(THLSB1);
use3 = ~isnan(THLSB2);

% 2) index 計算：比較 + 遮罩（避免 NaN 被當成 0）
index1 = (Cp_all < THbasic) & use1;   % 邏輯 12×N
index2 = (Cp_all < THLSB1) & use2;
index3 = (Cp_all < THLSB2) & use3;

% 3) 需要 0/1 時再轉型
index1 = double(index1);
index2 = double(index2);
index3 = double(index3);
%% 假設你已有 index: 12×N 的 0/1 (logical 或 0/1 double)
[Ntaps, N] = size(index1);

% 若你希望「第1列」是字串的最左邊，也是最大的位元（MSB），設為 true
row1_is_MSB = true;    % 若想第1列是 LSB，改成 false

% --- 用你的列順序直接編碼 state ---
if row1_is_MSB
    % 第1列→最高位，…，第Ntaps列→最低位
    w = 2.^(Ntaps-1:-1:0);              % 1×Ntaps（double）
else
    % 第1列→最低位（LSB），…，第Ntaps列→最高位
    w = 2.^(0:Ntaps-1);                  % 1×Ntaps
end
state = uint16( sum(double(index1.').*w, 2) );   % N×1

% --- 分布與 Top-K（照舊） ---
nbin = 2^Ntaps;
hist4096 = accumarray(double(state)+1, 1, [nbin,1], @sum, 0);
pdf4096  = hist4096 / N;

K = 6;
[topCount, ridx] = maxk(hist4096, K);
topState = ridx - 1;
topFrac  = topCount / N;

% --- 依你的列順序，還原成 12×K 的 0/1 圖樣（不重排、不翻轉） ---
s16 = uint16(topState(:));
bits_mat = false(Ntaps, K);          % 列=你的 tap 順序
if row1_is_MSB
    % 注意：bitget 的 1 是 LSB，所以這裡用 (Ntaps - row + 1)
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, Ntaps - row + 1).';
    end
else
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, row).';
    end
end

% --- 產生與「你的列順序」一致的 0/1 字串（左→右 = 第1列→第Ntaps列） ---
topBin = strings(K,1);
for k = 1:K
    topBin(k) = string(num2str(bits_mat(:,k).','%1d'));
end
%% 4) 作圖與輸出
% 圖1：4096格直方圖（非零項）
nz = find(hist4096>0);
% figure('Color','w','Position',[200 200 900 420]);
% tiledlayout(1,2,'Padding','compact','TileSpacing','compact');
% nexttile;  bar(nz-1, hist4096(nz), 'BarWidth', 1);
% xlabel('state'); ylabel('count'); title('Histogram (non-zero)'); grid on; xlim([0 nbin-1]);
% nexttile;  semilogy(nz-1, hist4096(nz), '.-');
% xlabel('state'); ylabel('count (log)'); title('Histogram (log, non-zero)'); grid on; xlim([0 nbin-1]);
% exportgraphics(gcf, 'hist4096_overview.png', 'Resolution', 300);

% 圖2：Top-K 條狀圖（標 bit 與比例）
figure('Color','w','Position',[200 200 760 420]);

% ---- 固定 X 類別順序為你給的順序 ----
% topBin 已是 string；若你要顯示十進位(四位數)：
topDec = bin2dec(topBin);                  % 0..4095
xLabels = compose('%04d', topDec);         % '0000'..'4095'
xCat    = categorical(xLabels, xLabels, 'Ordinal', true);  % 依輸入順序

% ---- 用百分比繪圖（或改成比率，二擇一）----
yPerc = 100*topFrac;                       % 轉百分比
bar(xCat, yPerc);
ylabel('Percentage (%)');                  % 若改用比率，就畫 bar(xCat, topFrac); ylabel('Ratio');

xlabel(sprintf('%d-bit pattern', Ntaps));
title(sprintf('Top-%d states (fraction)', K));
grid on;

% ---- 標註數值，並給一點上方空間 ----
text(1:numel(yPerc), yPerc, compose('%.2f%%', yPerc), ...
     'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',8);

ylim([0, max(yPerc)*1.15]);                % 讓標註不被裁掉
set(gca,'TickLabelInterpreter','none');    % 避免 '^\o' 之類被當成 TeX

%%
Ntaps = size(index,1);           % 應為 12
row1_is_MSB = true;              % 若第1列為最高位 (MSB)，設 true；若第1列為 LSB，設 false
K = numel(topState);             % 確保 K 與 topState 一致
s16 = uint16(topState(:));       % K×1
bits_mat = false(Ntaps, K);
if row1_is_MSB
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, Ntaps-row+1).';  % 第1列取最高位
    end
else
    for row = 1:Ntaps
        bits_mat(row,:) = bitget(s16, row).';          % 第1列取最低位
    end
end
bits_vis = flipud(bits_mat);     % 只為了視覺上把列顛倒（可拿掉）

%
figure('Color','w','Position',[200 200 460 520]);
imagesc(1-bits_vis); axis image; colormap(gca,"gray"); caxis([0 1]); cb = colorbar; cb.Ticks=[0 1]; cb.TickLabels={'0','1'};
title(sprintf('Top-%d states (binary map: tap × state)', K));
xlabel('state rank (1=most)'); ylabel('tap (top=flipud)');
set(gca,'XTick',1:K,'XTickLabel',1:K);

% y 軸 tap 名稱（請依你的 12 測點實際順序替換）
tap_names = {'90^o 1D p','90^o 1D n','110^o 1D p','110^o 1D n','90^o 2D p','90^o 2D n', ...
             '110^o 2D p','110^o 2D n','90^o 3.5D p','90^o 3.5D n','110^o 3.5D p','110^o 3.5D n'};
set(gca,'YTick',1:Ntaps,'YTickLabel',tap_names(end:-1:1));  % flip 後對齊 bits_vis
exportgraphics(gcf, 'topK_bits_map.png', 'Resolution', 300);