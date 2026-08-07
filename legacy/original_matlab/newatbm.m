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



cd('\\diskstation\research - finite cylinder\光滑圓柱\AR4\原始訊號\newmethod\');
edges = -3.4:0.05:0;
opts.prefer  = 'left';  % 研究常用較負的一側作 T
opts.minProm = 0.05;    % 視資料可調 0.03~0.10
opts.minDistK = 6;
alldata={Cpp70_1D,Cpp90_1D,Cpp110_1D,Cpn70_1D,Cpn90_1D,Cpn110_1D,...
    Cpp70_2D,Cpp90_2D,Cpp110_2D,Cpn70_2D,Cpn90_2D,Cpn110_2D,...
    Cpp70_3_5D,Cpp90_3_5D,Cpp110_3_5D,Cpn70_3_5D,Cpn90_3_5D,Cpn110_3_5D};

tapNames = { ...
  'Cpp70_1D','Cpp90_1D','Cpp110_1D','Cpn70_1D','Cpn90_1D','Cpn110_1D', ...
  'Cpp70_2D','Cpp90_2D','Cpp110_2D','Cpn70_2D','Cpn90_2D','Cpn110_2D', ...
  'Cpp70_3_5D','Cpp90_3_5D','Cpp110_3_5D','Cpn70_3_5D','Cpn90_3_5D','Cpn110_3_5D'};

T_total = nan(4, 49, 18);
% ====== 批次跑 compute_threshold_AT：PDF 圖與分界 ======
T_total   = nan(4, 49, 18);   % 1:TL, 2:TR, 3:IsBimodal, 4:T_O (僅存參考)
Split_all = nan(49, 18);      % ★ 本次採用的分界（valley 優先，否則 Otsu）
Valley_all= nan(49, 18);      % 純谷底（可能 NaN）
VR_all    = nan(49, 18);      % （可選）谷深比例 valleyRatio
opts.kneeMode = 'outer';
for ii = 1:18
    dataloc = alldata{ii};
    % 建 PDF 輸出資料夾
    pdfDir = fullfile('\\Diskstation\Research - Finite Cylinder\光滑圓柱\AR4\原始訊號\newmethod\NEWPDF_figure', tapNames{ii});
    if ~exist(pdfDir,'dir'), mkdir(pdfDir); end

    for i = 1:49
        seg = dataloc(:, i);
        [T, info] = compute_threshold_AT(seg, edges, opts);

        % 存你原本的四個量（Otsu 仍保留做參考）
        T_total(1,i,ii) = info.TL;
        T_total(2,i,ii) = info.TR;
        T_total(3,i,ii) = double(info.isBimodal);
        T_total(4,i,ii) = info.T_O;

        % ★ 決定這次要用的分界：valleyX 優先，沒有就退回 Otsu
        T_val = NaN;
        if isfield(info,'gmm') && isfield(info.gmm,'valleyX')
            T_val = info.gmm.valleyX;
        end
        if ~isnan(T_val)
            T_split = T_val;                % 用谷底
        else
            T_split = info.T_O;             % 無谷底→退回 Otsu
        end
        Split_all(i,ii)   = T_split;
        Valley_all(i,ii)  = T_val;
        if isfield(info,'gmm') && isfield(info.gmm,'valleyRatio')
            VR_all(i,ii) = info.gmm.valleyRatio;
        end

        % --- 繪 PDF（標示 TL/TR 與 Valley 分界）---
        f = figure(i); clf(f); hold on; box on; grid on
        plot(info.hist.x, info.hist.y, 'r-*', 'LineWidth', 1.4);
        xline(info.TL, '--k', 'TL', 'LineWidth', 1.4); 
        xline(info.TR, '--m', 'TR', 'LineWidth', 1.4);
        if ~isnan(T_split)
            xline(T_split, 'k:', 'Valley', 'LineWidth', 1.4);      % ★ 用 Valley 當分界
        end
        % 若想同時參考 Otsu，可解除下一行註解：
        % if ~isnan(info.T_O), xline(info.T_O, 'g--', 'Otsu'); end

        xlabel('C_p'); ylabel('Probability');
        title(sprintf('PDF & thresholds | %s | idx=%02d', tapNames{ii}, i));
        saveas(f, fullfile(pdfDir, sprintf('%02d.png', i)));
    end
    %close all
end

% ====== 時間序列圖（用 Valley 分界，而不是 Otsu）======
for ii = 1:18
    dataloc = alldata{ii};
    thDir = fullfile('\\Diskstation\Research - Finite Cylinder\光滑圓柱\AR4\原始訊號\newmethod\NEWTH_figure', tapNames{ii});
    if ~exist(thDir,'dir'), mkdir(thDir); end

    for i = 1:49
        seg = dataloc(:, i);

        f = figure(i); clf(f); hold on; box on; grid on
        plot(t, seg, 'k-', 'LineWidth', 1);
        yline(T_total(1,i,ii), '--r', 'TL', 'LineWidth', 1.6);
        yline(T_total(2,i,ii), '--m', 'TR', 'LineWidth', 1.6);

        % ★ 用 Split_all（valley 優先）當分界
        if ~isnan(Split_all(i,ii))
            yline(Split_all(i,ii), 'k:', 'Valley');
        end

        ylim([-3.5 0]);
        xlabel('time'); ylabel('C_p');
        title(sprintf('pressure data & TH | %s | idx=%02d', tapNames{ii}, i));
        saveas(f, fullfile(thDir, sprintf('%02d.png', i)));
    end
    close all
end

% （可選）把結果一起存檔
save('T_total_all.mat', 'T_total', 'Split_all', 'Valley_all', 'VR_all', '-v7.3');

