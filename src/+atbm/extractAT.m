function result = extractAT(seg, varargin)
%EXTRACTAT Source-faithful adaptive-threshold extraction from one Cp record.
%
% result = atbm.extractAT(seg)
% result = atbm.extractAT(seg,'BinWidth',0.04,'Support',[min(seg) max(seg)])
%
% mode 0: unimodal/fallback, retain TL and TR
% mode 1: bimodal-separated, retain TL and TR
% mode 2: bimodal-overlapped, retain Tv

cfg = atbm.defaultConfig();
p = inputParser;
p.addRequired('seg', @isnumeric);
p.addParameter('BinWidth', cfg.hist.binWidth, @isnumeric);
p.addParameter('Support', cfg.hist.support, @(x)isnumeric(x)&&numel(x)==2);
p.addParameter('SmoothWin', cfg.hist.smoothWin, @isnumeric);
p.addParameter('MinPromRatio', cfg.AT.minPromRatio, @isnumeric);
p.addParameter('MinDistBin', cfg.AT.minDistBin, @isnumeric);
p.addParameter('SRThreshold', cfg.AT.SRThreshold, @isnumeric);
p.addParameter('VRThreshold', cfg.AT.VRThreshold, @isnumeric);
p.parse(seg, varargin{:});
S = p.Results;

seg = seg(:);
seg = seg(isfinite(seg));
[x,y,edges] = atbm.makePDF(seg,S.BinWidth,S.Support,S.SmoothWin);

result = emptyResult();
result.x = x;
result.y = y;
result.edges = edges;
result.settings = rmfield(S,'seg');

if numel(x) < 5 || all(y==0)
    return;
end

[pks,locs] = findpeaks(y, ...
    'MinPeakProminence',max(y)*S.MinPromRatio, ...
    'MinPeakDistance',S.MinDistBin);
result.detectedPeakIndices = locs;
result.detectedPeakHeights = pks;

if numel(locs) < 2
    [~,ip] = max(y);
    result.xP = x(ip);
    result.yP = y(ip);

    idL = 1:ip;
    DL = chordDistance(x(idL(1)),y(idL(1)),x(ip),y(ip),x(idL),y(idL));
    if numel(DL)>=3, DL([1 end])=-Inf; end
    [~,kL] = max(DL);
    result.TL = x(idL(kL));
    result.yTL = y(idL(kL));

    idR = ip:numel(x);
    DR = chordDistance(x(ip),y(ip),x(idR(end)),y(idR(end)),x(idR),y(idR));
    if numel(DR)>=3, DR([1 end])=-Inf; end
    [~,kR] = max(DR);
    result.TR = x(idR(kR));
    result.yTR = y(idR(kR));

    result.mode = 0;
    result.morphology = "unimodal";
    result.candidateValues = [result.TL,result.TR];
    return;
end

[~,ord] = maxk(pks,2);
locs2 = sort(locs(ord));
iL = locs2(1);
iR = locs2(2);
result.iL = iL;
result.iR = iR;
result.xL = x(iL); result.yL = y(iL);
result.xR = x(iR); result.yR = y(iR);

[valY,rel] = min(y(iL:iR));
kv = iL+rel-1;
valX = x(kv);
if kv>1 && kv<numel(x)
    idx3 = (kv-1):(kv+1);
    pp = polyfit(x(idx3),y(idx3),2);
    if pp(1)>0
        xv = -pp(2)/(2*pp(1));
        if xv>=x(idx3(1)) && xv<=x(idx3(3))
            valX = xv;
            valY = polyval(pp,xv);
        end
    end
end
result.kv = kv;
result.valX = valX;
result.valY = valY;
result.Tv = valX;
result.valleyRatio = valY/min(result.yL,result.yR);
[result.SR,result.meanFWHM,result.FWHM_L,result.FWHM_R] = ...
    atbm.computeSRFWHM(x,y,iL,iR);

result.useTwo = result.SR>=S.SRThreshold && ...
    result.valleyRatio<=S.VRThreshold;

if result.useTwo
    idL = min(iL,kv):max(iL,kv);
    DL = chordDistance(valX,valY,result.xL,result.yL,x(idL),y(idL));
    if numel(DL)>=3, DL([1 end])=-Inf; end
    [~,kL] = max(DL);
    result.TL = x(idL(kL));
    result.yTL = y(idL(kL));

    idR = min(kv,iR):max(kv,iR);
    DR = chordDistance(valX,valY,result.xR,result.yR,x(idR),y(idR));
    if numel(DR)>=3, DR([1 end])=-Inf; end
    [~,kR] = max(DR);
    result.TR = x(idR(kR));
    result.yTR = y(idR(kR));

    result.mode = 1;
    result.morphology = "bimodal-separated";
    result.candidateValues = [result.TL,result.TR];
else
    result.mode = 2;
    result.morphology = "bimodal-overlapped";
    result.candidateValues = result.Tv;
end
end

function result = emptyResult()
result = struct( ...
    'mode',NaN,'morphology',"undetermined", ...
    'TL',NaN,'TR',NaN,'Tv',NaN, ...
    'SR',NaN,'valleyRatio',NaN,'meanFWHM',NaN, ...
    'FWHM_L',NaN,'FWHM_R',NaN,'useTwo',false, ...
    'x',[],'y',[],'edges',[],'settings',struct(), ...
    'xP',NaN,'yP',NaN,'xL',NaN,'yL',NaN, ...
    'xR',NaN,'yR',NaN,'valX',NaN,'valY',NaN, ...
    'yTL',NaN,'yTR',NaN,'iL',NaN,'iR',NaN,'kv',NaN, ...
    'detectedPeakIndices',[],'detectedPeakHeights',[], ...
    'candidateValues',[]);
end

function D = chordDistance(x1,y1,x2,y2,xq,yq)
den = hypot(y2-y1,x2-x1);
if den==0
    D = zeros(size(xq));
else
    D = abs((y2-y1).*xq-(x2-x1).*yq+(x2*y1-y2*x1))./den;
end
end
