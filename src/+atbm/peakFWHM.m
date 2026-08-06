function w=peakFWHM(x,y,ip)
half=y(ip)/2;
il=find(y(1:ip)<=half,1,"last");
ir0=find(y(ip:end)<=half,1,"first");
if isempty(il), xl=x(1); else, j=min(il+1,numel(x)); xl=interp1(y([il j]),x([il j]),half,"linear","extrap"); end
if isempty(ir0), xr=x(end); else, ir=ip+ir0-1; j=max(ir-1,1); xr=interp1(y([j ir]),x([j ir]),half,"linear","extrap"); end
w=max(xr-xl,eps);
end
