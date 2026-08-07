function [T_total, infos] = batch_thresholds_AT(data, edges, opts, seriesName)
% BATCH_THRESHOLD_AT
% data:  (Nsamples x Nseg) 矩陣；每一欄是一段 seg
% edges: 直方圖邊界
% opts:  傳給 compute_threshold_AT 的選項
% seriesName: (可選) 字串，會寫入表格的 Series 欄
%
% Outputs:
%   T_total: table，欄位如下
%       Series, Index, IsBimodal, T, TL, TR, T_O, Prefer
%   infos:   cell{1,Nseg}，每一格放 compute_threshold_AT 回傳的 info 結構

if nargin < 2 || isempty(edges), edges = -3.4:0.05:0; end
if nargin < 3, opts = struct(); end
if nargin < 4, seriesName = ""; end

Nseg = size(data, 2);
Series  = strings(Nseg,1);
Index   = (1:Nseg).';
IsBimod = false(Nseg,1);
T_arr   = nan(Nseg,1);
TL_arr  = nan(Nseg,1);
TR_arr  = nan(Nseg,1);
TO_arr  = nan(Nseg,1);
Prefer  = strings(Nseg,1);

infos = cell(1, Nseg);

for k = 1:Nseg
    seg = data(:,k);
    [T, info] = compute_threshold_AT(seg, edges, opts);

    Series(k)  = string(seriesName);
    IsBimod(k) = logical(info.isBimodal);
    T_arr(k)   = T;
    TL_arr(k)  = info.TL;
    TR_arr(k)  = info.TR;
    TO_arr(k)  = info.T_O;        % 單峰時會是 NaN
    Prefer(k)  = isfield(opts,'prefer') ? string(opts.prefer) : "left";

    infos{k} = info;
end

T_total = table(Series, Index, IsBimod, T_arr, TL_arr, TR_arr, TO_arr, Prefer, ...
    'VariableNames', {'Series','Index','IsBimodal','T','TL','TR','T_O','Prefer'});
end
