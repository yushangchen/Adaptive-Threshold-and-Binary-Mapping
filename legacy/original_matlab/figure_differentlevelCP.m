ia=47; %改RE範圍 
% THTH=[-0.925,-0.975,-0.925,-0.975,-1.175,-1.125]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-0.875,-0.825,-0.975,-0.875,-1.125,-1.225]; %ia=2

% THTH=[-1.025,-0.975,-0.975,-0.975,-1.225,-1.225]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-0.925,-0.875,-0.925,-0.875,-1.125,-1.175]; %ia=5

% THTH=[-1.275,-0.975,-0.975,-0.975,-1.325,-1.275]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-0.975,-0.875,-0.925,-0.825,-1.125,-1.175]; % ia=7 

% THTH=[-1.775,-0.925,-0.925,-0.925,-1.275,-1.225]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-0.925,-0.825,-0.875,-0.775,-1.075,-1.125]; % ia=12 

% THTH=[-1.844,-1.825,-1.075,-1.175,-1.275,-1.175]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-1.075,-0.925,-0.925,-0.875,-0.975,-1.025]; % ia=25 

% THTH=[-2.225,-2.175,-2.075,-1.075,-1.775,-1.125]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-1.225,-1.825,-0.925,-0.825,-1.075,-0.925]; % ia=33 

% THTH=[-1.825,-2.175,-2.025,-2.325,-1.725,-2.075]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
% THTH110=[-0.775,-1.725,-1.775,-1.675,-1.775,-1.175]; % ia=36 

THTH=[-1.925,-2.075,-1.925,-1.675,-1.975,-1.375]; % 看圖片的TH 輸入近來 1是底部正90 2是底部-90
THTH110=[-1.625,-1.075,-1.475,-0.875,-1.175,-1.375]; % ia=47 

THR=[-2.825,-2.725,-2.275,-0.575,-2.375,-0.725];
TR110=[-0.525,-2.425,-1.225,-0.325,-1.975,-0.575];
%% 90
%1D
figure (1)
subplot(3,2,5)
plot(t,Cpp90_1D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(1),'-g','linewidth',2);
hold off
legend('C_{p,+90\circ}','threshold +90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=1  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
subplot(3,2,6)
plot(t,Cpn90_1D(:,ia),'r.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(2),'-k','linewidth',2);
hold off
legend('C_{p,-90\circ}','threshold -90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=1  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
% 2D
subplot(3,2,3)
plot(t,Cpp90_2D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(3),'-g','linewidth',2);
hold off
%legend('C_{p,+90\circ}','threshold +90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=2  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
subplot(3,2,4)
plot(t,Cpn90_2D(:,ia),'r.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(4),'-k','linewidth',2);
hold off
%legend('C_{p,-90\circ}','threshold -90','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=2  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
% 35D
subplot(3,2,1)
plot(t,Cpp90_3_5D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH(5),'-g','linewidth',2);
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
yline(THTH(6),'-k','linewidth',2);
hold off
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
yline(THTH110(1),'-g','linewidth',2);
hold off
legend('C_{p,+110\circ}','threshold +110','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=1  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
subplot(3,2,6)
plot(t,Cpn110_1D(:,ia),'r.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH110(2),'-k','linewidth',2);
hold off
legend('C_{p,-110\circ}','threshold -110','location','eastoutside','fontsize',14) 
xlabel('time (sec)','fontsize',18);
ylabel('Cp','fontsize',18);
axis([0,120,-3.4,0]);
set(gca,'xtick',(0:20:120),'ytick',(-3.4:0.5:0),'ydir','reverse','Fontsize',18);
title(['Pressure Coef. at z/D=1  Re=' num2str(R(1,ia)),'\times 10^5'],'FontWeight','bold','Fontsize',20);
% 2D
subplot(3,2,3)
plot(t,Cpp110_2D(:,ia),'b.','LineStyle', 'none', 'MarkerSize', 0.5)
hold on
yline(THTH110(3),'-g','linewidth',2);
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
yline(THTH110(4),'-k','linewidth',2);
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
yline(THTH110(5),'-g','linewidth',2);
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
active_count = sum(index,1);                 % 1×N
win_ms = 20; wlen = max(1, round(win_ms*1e-3*fs));
ac_ma   = movmean(active_count, wlen);

figure('Color','w','Position',[200 200 1000 340]);
plot(active_count,'-'); hold on; plot(ac_ma,'-'); grid on;
xlabel('sample'); ylabel('# of active taps');
legend('instant','movmean','Location','best');
title(sprintf('Active count (window %d ms)', win_ms));
exportgraphics(gcf, 'active_count_timeseries.png', 'Resolution', 300);

%% turbulence
datafort = {
    Cpn70_1D,
    Cpn90_1D,
    Cpn110_1D,
    Cpp70_1D,
    Cpp90_1D,
    Cpp110_1D,
    Cpn70_2D,
    Cpn90_2D,
    Cpn110_2D,
    Cpp70_2D,
    Cpp90_2D,
    Cpp110_2D,
    Cpn70_3_5D,
    Cpn90_3_5D,
    Cpn110_3_5D,
    Cpp70_3_5D,
    Cpp90_3_5D,
    Cpp110_3_5D,
    % 共 18 個
};
numProbe = 18;
numFolder = 49;

sktest  = zeros(numProbe, numFolder);
kutest  = zeros(numProbe, numFolder);
rmstest = zeros(numProbe, numFolder);
for p = 1:numProbe
    for itt = 1:numFolder
        sktest(p,itt)  = skewness(datafort{p}(:,itt));
        kutest(p,itt)  = kurtosis(datafort{p}(:,itt));
        rmstest(p,itt) = rms(datafort{p}(:,itt));
    end
end
idx_z35 = [1 4 2 5 3 6];   % ← 這個依你實際矩陣排列去改
angleLabel_z35 = { ...
    '-70°', '+70°', ...
    '-90°', '+90°', ...
    '-110°','+110°'};
%% SK
figure; 
tiledlayout(3,2,'Padding','compact','TileSpacing','compact'); % 或者用 subplot

for k = 1:numel(idx_z35)
    probeIdx = idx_z35(k);

    nexttile;    % 或者 subplot(3,2,k);

    plot(Re, sktest(probeIdx,:), 'bo');   % sktest: [18×49]
    hold on;
    yline(0,'r','LineWidth',1);           % 紅色 y=0 基準線
    hold off;

    xlabel('Re','FontSize',12);
    ylabel('Skewness','FontSize',12);

    title(sprintf('Skewness of C_{p,%s} at z/D=1', angleLabel_z35{k}), ...
          'FontSize',12);

    xlim([min(Re) max(Re)]);   % 例如 [2.0e5 4.0e5]
    % 視需要加上 ylim([...])
end
%% rms
figure;
tiledlayout(3,2,'Padding','compact','TileSpacing','compact');

for k = 1:numel(idx_z35)
    probeIdx = idx_z35(k);

    nexttile;
    plot(Re, rmstest(probeIdx,:), 'bo');

    xlabel('Re','FontSize',12);
    ylabel('RMS','FontSize',12);
    title(sprintf('RMS of C_{p,%s} at z/D=1', angleLabel_z35{k}), ...
          'FontSize',12);

    xlim([min(Re) max(Re)]);
end

%% Ku
figure;
tiledlayout(3,2,'Padding','compact','TileSpacing','compact');

for k = 1:numel(idx_z35)
    probeIdx = idx_z35(k);

    nexttile;
    plot(Re, kutest(probeIdx,:), 'bo');
    hold on;
    yline(3,'r','LineWidth',1);   % 如果要標 Gaussian 的 ku=3，視你需求
    hold off;

    xlabel('Re','FontSize',12);
    ylabel('Kurtosis','FontSize',12);
    title(sprintf('Kurtosis of C_{p,%s} at z/D=1', angleLabel_z35{k}), ...
          'FontSize',12);

    xlim([min(Re) max(Re)]);
end
%% 2D
idx_z35 = [7 10 8 11 9 12];   % ← 這個依你實際矩陣排列去改
angleLabel_z35 = { ...
    '-70°', '+70°', ...
    '-90°', '+90°', ...
    '-110°','+110°'};
%% SK
figure; 
tiledlayout(3,2,'Padding','compact','TileSpacing','compact'); % 或者用 subplot

for k = 1:numel(idx_z35)
    probeIdx = idx_z35(k);

    nexttile;    % 或者 subplot(3,2,k);

    plot(Re, sktest(probeIdx,:), 'bo');   % sktest: [18×49]
    hold on;
    yline(0,'r','LineWidth',1);           % 紅色 y=0 基準線
    hold off;

    xlabel('Re','FontSize',12);
    ylabel('Skewness','FontSize',12);

    title(sprintf('Skewness of C_{p,%s} at z/D=2', angleLabel_z35{k}), ...
          'FontSize',12);

    xlim([min(Re) max(Re)]);   % 例如 [2.0e5 4.0e5]
    % 視需要加上 ylim([...])
end
%% rms
figure;
tiledlayout(3,2,'Padding','compact','TileSpacing','compact');

for k = 1:numel(idx_z35)
    probeIdx = idx_z35(k);

    nexttile;
    plot(Re, rmstest(probeIdx,:), 'bo');

    xlabel('Re','FontSize',12);
    ylabel('RMS','FontSize',12);
    title(sprintf('RMS of C_{p,%s} at z/D=2', angleLabel_z35{k}), ...
          'FontSize',12);

    xlim([min(Re) max(Re)]);
end

%% Ku
figure;
tiledlayout(3,2,'Padding','compact','TileSpacing','compact');

for k = 1:numel(idx_z35)
    probeIdx = idx_z35(k);

    nexttile;
    plot(Re, kutest(probeIdx,:), 'bo');
    hold on;
    yline(3,'r','LineWidth',1);   % 如果要標 Gaussian 的 ku=3，視你需求
    hold off;

    xlabel('Re','FontSize',12);
    ylabel('Kurtosis','FontSize',12);
    title(sprintf('Kurtosis of C_{p,%s} at z/D=2', angleLabel_z35{k}), ...
          'FontSize',12);

    xlim([min(Re) max(Re)]);
end
%% 3.5D
idx_z35 = [13 16 14 17 15 18];   % ← 這個依你實際矩陣排列去改
angleLabel_z35 = { ...
    '-70°', '+70°', ...
    '-90°', '+90°', ...
    '-110°','+110°'};
%% SK
figure; 
tiledlayout(3,2,'Padding','compact','TileSpacing','compact'); % 或者用 subplot

for k = 1:numel(idx_z35)
    probeIdx = idx_z35(k);

    nexttile;    % 或者 subplot(3,2,k);

    plot(Re, sktest(probeIdx,:), 'bo');   % sktest: [18×49]
    hold on;
    yline(0,'r','LineWidth',1);           % 紅色 y=0 基準線
    hold off;

    xlabel('Re','FontSize',12);
    ylabel('Skewness','FontSize',12);

    title(sprintf('Skewness of C_{p,%s} at z/D=3.5', angleLabel_z35{k}), ...
          'FontSize',12);

    xlim([min(Re) max(Re)]);   % 例如 [2.0e5 4.0e5]
    % 視需要加上 ylim([...])
end
%% rms
figure;
tiledlayout(3,2,'Padding','compact','TileSpacing','compact');

for k = 1:numel(idx_z35)
    probeIdx = idx_z35(k);

    nexttile;
    plot(Re, rmstest(probeIdx,:), 'bo');

    xlabel('Re','FontSize',12);
    ylabel('RMS','FontSize',12);
    title(sprintf('RMS of C_{p,%s} at z/D=3.5', angleLabel_z35{k}), ...
          'FontSize',12);

    xlim([min(Re) max(Re)]);
end

%% Ku
figure;
tiledlayout(3,2,'Padding','compact','TileSpacing','compact');

for k = 1:numel(idx_z35)
    probeIdx = idx_z35(k);

    nexttile;
    plot(Re, kutest(probeIdx,:), 'bo');
    hold on;
    yline(3,'r','LineWidth',1);   % 如果要標 Gaussian 的 ku=3，視你需求
    hold off;

    xlabel('Re','FontSize',12);
    ylabel('Kurtosis','FontSize',12);
    title(sprintf('Kurtosis of C_{p,%s} at z/D=3.5', angleLabel_z35{k}), ...
          'FontSize',12);

    xlim([min(Re) max(Re)]);
end

