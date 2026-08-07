clc
clear
close all

%AR4 光滑圓柱
%%
b=dir('\\Diskstation\Research - Finite Cylinder\光滑圓柱\AR4\原始訊號\*.lvm');
% degree=[70 80 90 100 110 120 -120 -110 -100 -90 -80 -70];
degree = 70:20:110;
ndegree= -110:20:-70;
dia=0.15;
abc=49;
R=zeros(1,abc);
%str1={Cpp90_1D,Cpp90_2D,Cpp90_3_5D,Cpn90_1D,Cpn90_2D,Cpn90_3_5D,Cpp70_1D,Cpp70_2D,Cpp70_3_5D,Cpn70_1D,Cpn70_2D,Cpn70_3_5D,Cpp110_1D,Cpp110_2D,Cpp110_3_5D,Cpn110_1D,Cpn110_2D,Cpn110_3_5D};
%str2={'Cpp90_1D','Cpp90_2D','Cpp90_3_5D','Cpn90_1D','Cpn90_2D','Cpn90_3_5D','Cpp70_1D','Cpp70_2D','Cpp70_3_5D','Cpn70_1D','Cpn70_2D','Cpn70_3_5D','Cpp110_1D','Cpp110_2D','Cpp110_3_5D','Cpn110_1D','Cpn110_2D','Cpn110_3_5D'};
cd('\\diskstation\research - finite cylinder\光滑圓柱\AR4\原始訊號')
%% FFT
Fs = 1000;
T = 1/Fs;         % 週期
rawdata = 120000;
n = rawdata;
dF = Fs/n;
freq = (0:n/2-1).*dF;
%%
V_pitot=zeros(120000,abc);
dns=zeros(120000,1);
Cpp90_1D=zeros(120000,abc);
Cpp90_2D=zeros(120000,abc);
Cpp90_3_5D=zeros(120000,abc);
Cpn90_1D=zeros(120000,abc);
Cpn90_2D=zeros(120000,abc);
Cpn90_3_5D=zeros(120000,abc);
Cpb_1D=zeros(120000,abc);
Cpb_2D=zeros(120000,abc);
Cpb_3_5D=zeros(120000,abc);
Cpp70_1D=zeros(120000,abc);
Cpp70_2D=zeros(120000,abc);
Cpp70_3_5D=zeros(120000,abc);
Cpn70_1D=zeros(120000,abc);
Cpn70_2D=zeros(120000,abc);
Cpn70_3_5D=zeros(120000,abc);
Cpp110_1D=zeros(120000,abc);
Cpp110_2D=zeros(120000,abc);
Cpp110_3_5D=zeros(120000,abc);
Cpn110_1D=zeros(120000,abc);
Cpn110_2D=zeros(120000,abc);
Cpn110_3_5D=zeros(120000,abc);
%% 
%cross110np_1D=zeros(120000,abc);
% cross70np_1D=zeros(120000,abc);
% cross90np_1D=zeros(120000,abc);
% cross110np_2D=zeros(120000,abc);
% cross70np_2D=zeros(120000,abc);
% cross90np_2D=zeros(120000,abc);
% cross110np_3_5D=zeros(120000,abc);
% cross70np_3_5D=zeros(120000,abc);
% cross90np_3_5D=zeros(120000,abc);
%Re=zeros(1,50);



%%
for i=1:abc
Ai=load(b(i).name);
        
t=Ai(:,1);

temp=Ai(:,3);
temp=temp.*10;
dns=(100950./(temp+273.15))./287.05; 

        
pitot1=Ai(:,2);
pitot= 516.1045.* pitot1  + 5.9067;
V_pitot(:,i)=(2.*pitot./dns).^0.5;     %V_pitot




B1=Ai(:,7);
B1p= 2763.1103.* B1 + 46.7353;
Cpp90_1D(:,i) = (1.*B1p)./(pitot);  %Cp+90_1D
Cpp90_1D_mean = mean(Cpp90_1D);
Cpp90_1D_rms = rms(Cpp90_1D-Cpp90_1D_mean);


B2=Ai(:,8);
B2p= 2760.5462.* B2 -3.9812;
Cpp90_2D(:,i)= (1.*B2p)./(pitot); %Cp90_2D
Cpp90_2D_mean = mean(Cpp90_2D);
Cpp90_2D_rms = rms(Cpp90_2D-Cpp90_2D_mean);


B3=Ai(:,9);
B3p= 2771.2718.* B3 +6977.6853;
Cpp90_3_5D(:,i)= (1.*B3p)./(pitot); %Cp90_3.5D
Cpp90_3_5D_mean = mean(Cpp90_3_5D);
Cpp90_3_5D_rms = rms(Cpp90_3_5D-Cpp90_3_5D_mean);

C1=Ai(:,10);
C1n= 2770.025 .* C1 +1384.8747;
Cpn90_1D(:,i) = (1.*C1n)./(pitot);  %Cp-90_1D
Cpn90_1D_mean = mean(Cpn90_1D);
Cpn90_1D_rms = rms(Cpn90_1D-Cpn90_1D_mean);

C2=Ai(:,11);
C2n= 2764.0335 .* C2 +6882.2088;
Cpn90_2D(:,i) = (1.*C2n)./(pitot);  %Cp-90_2D
Cpn90_2D_mean = mean(Cpn90_2D);
Cpn90_2D_rms = rms(Cpn90_2D-Cpn90_2D_mean);

C3=Ai(:,12);
C3n= 2761.5253 .* C3 +37.5180;
Cpn90_3_5D(:,i) = (1.*C3n)./(pitot);  %Cp-90_3.5D
Cpn90_3_5D_mean = mean(Cpn90_3_5D);
Cpn90_3_5D_rms = rms(Cpn90_3_5D-Cpn90_3_5D_mean);

D1=Ai(:,13);
D1pb= 2758.6922 .* D1 -29.2788;
Cpb_1D(:,i) = (1.*D1pb)./(pitot);  %Cpb_1D
Cpb_1D_mean = mean(Cpb_1D);
Cpb_1D_rms = rms(Cpb_1D-Cpb_1D_mean);

D2=Ai(:,14);
D2pb= 2751.3767 .* D2 +8.9979;
Cpb_2D(:,i) = (1.*D2pb)./(pitot);  %Cpb_2D
Cpb_2D_mean = mean(Cpb_2D);
Cpb_2D_rms = rms(Cpb_2D-Cpb_2D_mean);

D3=Ai(:,15);
D3pb= 2750.6685 .* D3 +0.0327;
Cpb_3_5D(:,i) = (1.*D3pb)./(pitot);  %Cpb_3.5D
Cpb_3_5D_mean = mean(Cpb_3_5D);
Cpb_3_5D_rms = rms(Cpb_3_5D-Cpb_3_5D_mean);

E1=Ai(:,16);
E1p= 2763.13 .* E1 +1602.1266;
Cpp70_1D(:,i) = (1.*E1p)./(pitot);  %Cp+70_1D
Cpp70_1D_mean = mean(Cpp70_1D);
Cpp70_1D_rms = rms(Cpp70_1D-Cpp70_1D_mean);

E2=Ai(:,17);
E2p= 2765.6519 .* E2 +27.0844;
Cpp70_2D(:,i) = (1.*E2p)./(pitot);  %Cp+70_2D
Cpp70_2D_mean = mean(Cpp70_2D);
Cpp70_2D_rms = rms(Cpp70_2D-Cpp70_2D_mean);

E3=Ai(:,18);
E3p= 2754.8263 .* E3 -2.7767;
Cpp70_3_5D(:,i) = (1.*E3p)./(pitot);  %Cp+70_3.5D
Cpp70_3_5D_mean = mean(Cpp70_3_5D);
Cpp70_3_5D_rms = rms(Cpp70_3_5D-Cpp70_3_5D_mean);

F1=Ai(:,19);
F1n= 2758.8502 .* F1 +2133.7652;
Cpn70_1D(:,i) = (1.*F1n)./(pitot);  %Cp-70_1D
Cpn70_1D_mean = mean(Cpn70_1D);
Cpn70_1D_rms = rms(Cpn70_1D-Cpn70_1D_mean);

F2=Ai(:,20);
F2n= 2760.5056 .* F2 -32.096;
Cpn70_2D(:,i) = (1.*F2n)./(pitot);  %Cp-70_2D
Cpn70_2D_mean = mean(Cpn70_2D);
Cpn70_2D_rms = rms(Cpn70_2D-Cpn70_2D_mean);

F3=Ai(:,21);
F3n= 2760.718 .* F3 +6.6842;
Cpn70_3_5D(:,i) = (1.*F3n)./(pitot);  %Cp-70_3.5D
Cpn70_3_5D_mean = mean(Cpn70_3_5D);
Cpn70_3_5D_rms = rms(Cpn70_3_5D-Cpn70_3_5D_mean);

G1=Ai(:,22);
G1p= 2758.6562.* G1 +93.6785;
Cpp110_1D(:,i) = (1.*G1p)./(pitot);  %Cp+110_1D
Cpp110_1D_mean = mean(Cpp110_1D);
Cpp110_1D_rms = rms(Cpp110_1D-Cpp110_1D_mean);

G2=Ai(:,23);
G2p= 2758.2751.* G2 +13.1394;
Cpp110_2D(:,i) = (1.*G2p)./(pitot);    %Cp+110_2D
Cpp110_2D_mean = mean(Cpp110_2D);
Cpp110_2D_rms = rms(Cpp110_2D-Cpp110_2D_mean);

G3=Ai(:,24);
G3p= 2764.5686.* G3 -21.7986;
Cpp110_3_5D(:,i) = (1.*G3p)./(pitot);   %Cp+110_3.5D
Cpp110_3_5D_mean = mean(Cpp110_3_5D);
Cpp110_3_5D_rms = rms(Cpp110_3_5D-Cpp110_3_5D_mean);

H1=Ai(:,25);
H1n= 2766.2835.* H1 -50.9285;
Cpn110_1D(:,i) = (1.*H1n)./(pitot);  %Cp-110_1D
Cpn110_1D_mean = mean(Cpn110_1D);
Cpn110_1D_rms = rms(Cpn110_1D-Cpn110_1D_mean);

H2=Ai(:,26);
H2n= 2776.6497.* H2 +16.3731;
Cpn110_2D(:,i) = (1.*H2n)./(pitot);  %Cp-110_2D
Cpn110_2D_mean = mean(Cpn110_2D);
Cpn110_2D_rms = rms(Cpn110_2D-Cpn110_2D_mean);

H3=Ai(:,27);
H3n= 2766.8385.* H3 +34.6345;
Cpn110_3_5D(:,i) = (1.*H3n)./(pitot);  %Cp-110_3.5D
Cpn110_3_5D_mean = mean(Cpn110_3_5D);
Cpn110_3_5D_rms = rms(Cpn110_3_5D-Cpn110_3_5D_mean);

Res = (dns.*V_pitot.*dia)./((temp+273.15).^0.5.*1.458.*0.000001./(110.4./(temp+273.15)+1));     % Re
Re(1,i) = mean(Res(:,i)); 
re1 = Re ;
re1 = round(re1/100000,2);
R(1,i)=re1(1,i); 
end
cd('\\diskstation\research - finite cylinder\光滑圓柱\AR4\原始訊號\newmethod\')

%% otsu-1D
for i=1:49
[T, info] = otsu1d(Cpp90_2D(:,i), 'NumBins', 128);
tt(i)=T;
end

%% test gmm method
for i=1:49
x = Cpp90_2D(:,i);
gm1 = fitgmdist(x,1,'RegularizationValue',1e-6);
gm2 = fitgmdist(x,2,'RegularizationValue',1e-6,'Replicates',5);
is_bimodal = (gm2.BIC < gm1.BIC);
mu = gm2.mu(:); sig = sqrt(squeeze(gm2.Sigma));
AshmanD(i) = abs(mu(1)-mu(2))/sqrt(sig(1)^2+sig(2)^2);


end


% x  = Cpp90_2D(:,2);          % 你要處理的那一欄
% dt = 1/fs;                   % 取樣間隔
% d1 = gradient(x, dt);        % 一階導數 dx/dt
% s  = gradient(d1, dt);       % 二階導數 d2x/dt2（與 x 等長）
% figure('Color','w'); tiledlayout(3,1,'TileSpacing','compact','Padding','compact');
% nexttile;plot(x)
% nexttile;plot(s)
% nexttile;plot(d1)

%% IF(intermittience function)_background
i=7;
x=Cpp90_2D(:,i);
fs=1000;
[T_IF, I_IF, Q_IF, gamma_IF] = IF_background(x, fs, 'mode','d2', 'W',25, ...
    'alpha',1.3, 'loRatio',0.8, 'minDur',0.08, 'minGap',0.02);
% 你已經有：
% [T, I, Q, gamma] = IF_background(x, fs, 'W',25, 'k',2.5, ...
%                                  'loRatio',0.8, 'minDur',0.08, 'minGap',0.02);

t    = (0:numel(x)-1)'/fs;     % 時間軸
Drel = Q_IF / T_IF;                  % 無量綱；門檻 = 1 最直觀

% ===== 三層總覽圖 =====
figure('Color','w'); tiledlayout(3,1,'TileSpacing','compact','Padding','compact');

% (1) 原始訊號 + 事件區段上色（用 I）
nexttile; plot(t, x, 'k-','LineWidth',0.8); grid on; hold on
yl = ylim; d = diff([false; I(:); false]); s = find(d==1); e = find(d==-1)-1;
for k = 1:numel(s)
    patch([t(s(k)) t(e(k)) t(e(k)) t(s(k))], [yl(1) yl(1) yl(2) yl(2)], ...
          [0.85 0.92 1], 'FaceAlpha',0.8, 'EdgeColor','none');
end
uistack(findobj(gca,'Type','line'),'top');   % 把曲線放回最上層
xlabel('Time (s)'); ylabel('C_p'); title('原始訊號（淺藍為事件）');

% (2) 事件強度 vs 門檻（=1）
nexttile; plot(t, Drel, 'b-'); grid on; yline(1,'r--','Th=1');
xlabel('Time (s)'); ylabel('Q/T'); title('準則量（正規化）');

% (3) 0/1 指示與 \gamma
nexttile; stairs(t, I, 'LineWidth',1);
ylim([-0.1 1.1]); grid on
xlabel('Time (s)'); ylabel('I(t)');
title(sprintf('事件指示 I(t)（\\gamma = %.3f）', gamma));
%
figure('Color','w'); 
histogram(Q_IF, 128, 'Normalization','pdf', 'FaceColor',[.75 .8 .95], 'EdgeColor','none');
hold on; xline(T,'r--','Th'); grid on
xlabel('Q'); ylabel('PDF'); title('Q 的分佈與門檻 Th');

%%
YLIM = [-3.5 0.5];    
figure 
plot(t, Cpp90_2D(:,1))
 ylim(YLIM);

figure 
plot(t, Cpp90_2D(:,7))
 ylim(YLIM);

figure 
plot(t, Cpp90_2D(:,25))
 ylim(YLIM);

figure 
plot(t, Cpp90_2D(:,33))
 ylim(YLIM);

 figure 
plot(t, Cpp90_2D(:,45))
 ylim(YLIM);


%%
for i=[1,7,25,33,45]
[T, info] = otsu1d(Cpp90_2D(:,i), 'NumBins', 128);
fprintf('Otsu threshold T = %.3f\n', T);
% 視覺化
figure(i)
edges = info.edges; c = info.counts;
bc = 0.5*(edges(1:end-1)+edges(2:end));
bar(bc, c, 'hist'); hold on
xlim([-3.5 0]);
title('Histogram with Otsu threshold'); xlabel('x'); ylabel('count'); grid on
tt(i)=T;
end


%% test all (GMM, OSTU and IF)
for i=[7,25,33,45]

x=Cpp90_2D(:,i);
fs=1000;
[T_IF, I_IF, Q_IF, gamma_IF] = IF_background(x, fs, 'mode','d2', 'W',25, ...
    'alpha',1.3, 'loRatio',0.8, 'minDur',0.08, 'minGap',0.02);
%                                  'loRatio',0.8, 'minDur',0.08, 'minGap',0.02);
t    = (0:numel(x)-1)'/fs;     % 時間軸
Drel = Q_IF / T_IF;                  % 無量綱；門檻 = 1 最直觀
%
[T_otsu, info] = otsu1d(x, 'NumBins', 128);
% GMM
g = GMM(x);
% PV
x_lp  = lowpass(x, 100, fs);
x_use = x_lp(21:end-20);
d0 = 0.03;
[pPk, idxPk] = findpeaks( x_use, 'MinPeakProminence', d0);
[pVl, idxVl] = findpeaks(-x_use, 'MinPeakProminence', d0); pVl = -pVl;
tmp=[idxPk,pPk; idxVl,pVl]; [~,k]=sort(tmp(:,1)); pv=tmp(k,:);

% 2) 跑 PV 事件偵測（門檻設定）
thd1 = -1.3; thd2 = -1.6; d1 = 0.10; d2 = 0.10;
chevent = eventPVver2(pv, thd1, thd2, d1, d2);

% 3) 轉回時間（秒）與型別分類
tt     = (0:numel(x_use)-1)'/fs;
type1 = chevent(chevent(:,1)==1,:);    % 向下
type2 = chevent(chevent(:,1)==2,:);    % 向上
dur_s = (chevent(:,3)-chevent(:,2))/fs;
%% K-MEAN
x = x(isfinite(x));
[idx,C] = kmeans(x, 2, 'Replicates', 20, 'MaxIter', 1000);
C = sort(C);                     % c1 < c2
T_km = mean(C);                  % 門檻

% ===== 三層總覽圖 =====
figure('Color','w'); tiledlayout(1,1,'TileSpacing','compact','Padding','compact');

% (1) 原始訊號 + 事件區段上色（用 I）
nexttile; plot(t, x, 'k-','LineWidth',0.8); grid on; hold on
yl = ylim; d = diff([false; I(:); false]); s = find(d==1); e = find(d==-1)-1;
for k = 1:numel(s)
    patch([t(s(k)) t(e(k)) t(e(k)) t(s(k))], [yl(1) yl(1) yl(2) yl(2)], ...
          [0.85 0.92 1].* 0.8, 'FaceAlpha',1, 'EdgeColor','none');
end
hold on
for rr = 1:size(chevent,1)
    sidx = chevent(rr,2); 
    eidx = chevent(rr,3);
    if chevent(rr,1)==1     % Type-1 (下降)
        col = [1 0.90 0];
    else                    % Type-2 (上升)
        col = [1 0.90 0];
    end
    patch([t_use(sidx) t_use(eidx) t_use(eidx) t_use(sidx)], ...
          [yl(1) yl(1) yl(2) yl(2)], col, ...
          'FaceAlpha',0.95, 'EdgeColor',[1 0.90 0], 'LineWidth',1.2);
end

uistack(findobj(gca,'Type','line'),'top');   % 把曲線放回最上層
yline(T_otsu,'r--','Th=OTSU','LineWidth',1.6, 'FontSize', 14);
yline(g.T,'g--','Th=GMM','LineWidth',1.6, 'FontSize', 14);
yline(T_km,'m--','Th=k-mean','LineWidth',1.6, 'FontSize', 14,'LabelVerticalAlignment', 'bottom');
 text(0.02, 0.95, sprintf('GMM TH: N/A (\\ D=%.2f)', ...
          g.AshmanD), 'Units','normalized', ...
          'HorizontalAlignment','left','VerticalAlignment','top', ...
          'BackgroundColor',[1 1 1 0.7],'EdgeColor',[1 1 1 0.7]);
xlabel('Time (s)'); ylabel('C_p'); title('原始訊號（淺藍為事件）');


end
%%
% x = Cpp90_2D(:,i);
% x = x(isfinite(x));
% [idx,C] = kmeans(x, 2, 'Replicates', 20, 'MaxIter', 1000);
% C = sort(C);                     % c1 < c2
% T_km = mean(C);                  % 門檻
% I_km = x < T_km;                 % 若事件是「向下脈衝」，用 x < T_km；相反則 >