function T = gmm_intersection(gm)
% gm: fitgmdist 物件，1 維、NumComponents=2
w = gm.ComponentProportion(:);
mu = gm.mu(:);
S  = squeeze(gm.Sigma);                      % 1D -> [1x1x2] 或 [2x1x1]
sigma = sqrt(S(:));

% 按均值排序
[mu,ord] = sort(mu); sigma = sigma(ord); w = w(ord);

% 等方差近似
if abs(sigma(1)-sigma(2)) <= 1e-8*max(sigma)
    sig = mean(sigma);
    T = 0.5*(mu(1)+mu(2)) + (sig^2/(mu(1)-mu(2))) * log(w(2)/w(1));
    return
end

a = 1/(2*sigma(2)^2) - 1/(2*sigma(1)^2);
b = -mu(2)/sigma(2)^2 + mu(1)/sigma(1)^2;
c = (mu(2)^2)/(2*sigma(2)^2) - (mu(1)^2)/(2*sigma(1)^2) + log((w(2)*sigma(1))/(w(1)*sigma(2)));

r = roots([a b c]);                           % 兩個交會解
r = r(imag(r)==0);                            % 只留實根
cand = r(r>=mu(1) & r<=mu(2));                % 夾在兩均值之間的根
if ~isempty(cand)
    [~,k] = min(abs(cand - mean(mu)));
    T = cand(k);
else
    % 後備：取中點（或用 KDE 的谷底）
    T = mean(mu);
end
end
