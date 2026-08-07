% this code is using to create paper's figure

%%ii = { ...
 % 'Cpp70_1D','Cpp90_1D','Cpp110_1D','Cpn70_1D','Cpn90_1D','Cpn110_1D', ...
 % 'Cpp70_2D','Cpp90_2D','Cpp110_2D','Cpn70_2D','Cpn90_2D','Cpn110_2D', ...
 % 'Cpp70_3_5D','Cpp90_3_5D','Cpp110_3_5D','Cpn70_3_5D','Cpn90_3_5D','Cpn110_3_5D'};

ii=8; % pressure taps
i=1; %Re(file number) 7 25 26 32 44
% step1 基本計算
dataloc = alldata{ii};
y7 = histcounts(dataloc(:,7), edges, 'Normalization','probability')';
x7 = centers(:);  n7 = numel(x7);  dx7 = x7(2)-x7(1);

y25 = histcounts(dataloc(:,25), edges, 'Normalization','probability')';
x25 = centers(:);  n25 = numel(x25);  dx25 = x25(2)-x25(1);

y26 = histcounts(dataloc(:,26), edges, 'Normalization','probability')';
x26 = centers(:);  n26 = numel(x26);  dx26 = x26(2)-x26(1);

y32 = histcounts(dataloc(:,32), edges, 'Normalization','probability')';
x32 = centers(:);  n32 = numel(x32);  dx32 = x32(2)-x32(1);

y44 = histcounts(dataloc(:,44), edges, 'Normalization','probability')';
x44 = centers(:);  n44 = numel(x44);  dx44 = x44(2)-x44(1);

% 傳統方法 mean 
m7=mean(dataloc(:,7));
m25=mean(dataloc(:,25));
m26=mean(dataloc(:,26));
m32=mean(dataloc(:,32));
m44=mean(dataloc(:,44));
%rms 
r7=rms(dataloc(:,7));
r25=rms(dataloc(:,25));
r26=rms(dataloc(:,26));
r32=rms(dataloc(:,32));
r44=rms(dataloc(:,44));
%sk
sk7=skewness(dataloc(:,7));
sk25=skewness(dataloc(:,25));
sk26=skewness(dataloc(:,26));
sk32=skewness(dataloc(:,32));
sk44=skewness(dataloc(:,44));
%ku
ku7=kurtosis(dataloc(:,7));
ku25=kurtosis(dataloc(:,25));
ku26=kurtosis(dataloc(:,26));
ku32=kurtosis(dataloc(:,32));
ku44=kurtosis(dataloc(:,44));

%% 作圖區
figure
subplot(2,5,1)
plot(tt, dataloc(:,7))
hold on
yline(m7,'m--','LineWidth',1.6);
 ylim([-3.5 0]);
text(5, -3.5, sprintf('rms = %6.2f\nsk  = %6.2f ,ku  = %6.2f', r7, sk7, ku7), ...
    'FontSize', 12, 'Color', 'blue', 'VerticalAlignment', 'bottom');
title('(a) pre-critical')
subplot(2,5,2)
plot(tt, dataloc(:,25))
hold on
yline(m25,'m--','LineWidth',1.6);
ylim([-3.5 0]);
text(5, -3.5, sprintf('rms = %6.2f\nsk  = %6.2f ,ku  = %6.2f', r25, sk25, ku25), ...
    'FontSize', 12, 'Color', 'blue', 'VerticalAlignment', 'bottom');
title('(b) pre-critical to one bubble')
subplot(2,5,3)
plot(tt, dataloc(:,26))
hold on
yline(m26,'m--','LineWidth',1.6);
 ylim([-3.5 0]);
 text(5, -3.5, sprintf('rms = %6.2f\nsk  = %6.2f ,ku  = %6.2f', r26, sk26, ku26), ...
    'FontSize', 12, 'Color', 'blue', 'VerticalAlignment', 'bottom');
 title('(c) pre-critical to one bubble')
subplot(2,5,4)
plot(tt, dataloc(:,32))
hold on
yline(m32,'m--','LineWidth',1.6);
 ylim([-3.5 0]);
 text(5, -3.5, sprintf('rms = %6.2f\nsk  = %6.2f ,ku  = %6.2f', r32, sk32, ku32), ...
    'FontSize', 12, 'Color', 'blue', 'VerticalAlignment', 'bottom');
  title('(d) one bubble')
subplot(2,5,5)
plot(tt, dataloc(:,44))
hold on
yline(m44,'m--','LineWidth',1.6);
 ylim([-3.5 0]);
 text(5, -3.5, sprintf('rms = %6.2f\nsk  = %6.2f ,ku  = %6.2f', r44, sk44, ku44), ...
    'FontSize', 12, 'Color', 'blue', 'VerticalAlignment', 'bottom');
  title('(e) two bubble')

subplot(2,5,6)
plot(x7, y7, 'r-*', 'LineWidth',1.4);
hold on
xline(m25,'m--','LineWidth',1.6);
subplot(2,5,7)
plot(x25, y25, 'r-*', 'LineWidth',1.4);
hold on
xline(m25,'m--','LineWidth',1.6);
subplot(2,5,8)
plot(x26, y26, 'r-*', 'LineWidth',1.4);
hold on
xline(m25,'m--','LineWidth',1.6);
subplot(2,5,9)
plot(x32, y32, 'r-*', 'LineWidth',1.4);
hold on
xline(m25,'m--','LineWidth',1.6);
subplot(2,5,10)
plot(x44, y44, 'r-*', 'LineWidth',1.4);
hold on
xline(m25,'m--','LineWidth',1.6);
