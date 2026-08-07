function out = GMM(x, varargin)
% x: 向量資料（特徵、Q 或原始 Cp）
% out: 結果結構，含 T、雙峰性、AshmanD、gm2 等
p = inputParser;
p.addParameter('Replicates',5);
p.addParameter('Reg',1e-6);         % RegularizationValue
p.addParameter('BICdrop', 10);      % 視為雙峰的 ΔBIC 門檻（可設 0~10）
p.parse(varargin{:});
R = p.Results;

x = x(:); x = x(isfinite(x));       % 去 NaN/Inf
gm1 = fitgmdist(x,1,'RegularizationValue',R.Reg);
gm2 = fitgmdist(x,2,'RegularizationValue',R.Reg,'Replicates',R.Replicates);

% 基本資訊
[mu,ix] = sort(gm2.mu(:)); 
sig = sqrt(squeeze(gm2.Sigma)); sig = sig(ix);
w   = gm2.ComponentProportion(:); w = w(ix);
D   = abs(mu(2)-mu(1))/sqrt(sig(1)^2+sig(2)^2);   % Ashman’s D
dBIC= gm1.BIC - gm2.BIC;                          % BIC 降幅
is_bi = dBIC > R.BICdrop && all(w>0.05);          % 權重過小就不信

% 解交點
if is_bi
    a = 1/(2*sig(1)^2) - 1/(2*sig(2)^2);
    b = -mu(1)/sig(1)^2 + mu(2)/sig(2)^2;
    c =  mu(1)^2/(2*sig(1)^2) - mu(2)^2/(2*sig(2)^2) - log((w(1)*sig(2))/(w(2)*sig(1)));
    if abs(a) < 1e-14
        T = (mu(1)+mu(2))/2 + (sig(1)^2)/(mu(2)-mu(1))*log(w(1)/w(2));
    else
        r = roots([a b c]); r = r(imag(r)==0);            % 只要實根
        in = r >= mu(1) & r <= mu(2);
        if any(in), T = r(find(in,1,'first'));
        elseif ~isempty(r), [~,k]=min(abs(r-mean(mu))); T=r(k);
        else, T = mean(mu);                                % 萬一沒有實根
        end
    end
else
    T = NaN;  % 不可靠，請改用 Otsu 或背景RMS 作門檻
end

out = struct('T',T,'is_bimodal',is_bi,'DeltaBIC',dBIC,...
             'AshmanD',D,'mu',mu,'sigma',sig,'weights',w,'gm2',gm2);
end
