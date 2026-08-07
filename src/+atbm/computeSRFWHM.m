function [SR, meanFWHM, FWHM_L, FWHM_R] = computeSRFWHM(x, y, iLpk, iRpk)
%COMPUTESRFWHM Peak separation divided by the mean two-peak FWHM.

x = x(:); y = y(:);
dx = x(2)-x(1);
yLpk = y(iLpk);
yRpk = y(iRpk);
halfL = 0.5*yLpk;
halfR = 0.5*yRpk;

xLL = crossingLeft(x,y,iLpk,halfL);
xLR = crossingRight(x,y,iLpk,halfL);
xRL = crossingLeft(x,y,iRpk,halfR);
xRR = crossingRight(x,y,iRpk,halfR);

FWHM_L = max(0, xLR-xLL);
FWHM_R = max(0, xRR-xRL);
meanFWHM = max(dx, mean([FWHM_L,FWHM_R]));
SR = (x(iRpk)-x(iLpk))/meanFWHM;
end

function xc = crossingLeft(x,y,ip,halfHeight)
i = find(y(1:ip) < halfHeight,1,'last');
if ~isempty(i) && i < ip
    xc = interpolateCrossing(y(i:i+1),x(i:i+1),halfHeight);
else
    xc = x(1);
end
end

function xc = crossingRight(x,y,ip,halfHeight)
rel = find(y(ip:end) < halfHeight,1,'first');
if ~isempty(rel)
    i = ip + rel - 1;
    if i > 1
        xc = interpolateCrossing(y(i-1:i),x(i-1:i),halfHeight);
    else
        xc = x(i);
    end
else
    xc = x(end);
end
end

function xc = interpolateCrossing(yPair,xPair,target)
if yPair(1) == yPair(2)
    xc = mean(xPair);
else
    xc = interp1(yPair,xPair,target,'linear','extrap');
end
end
