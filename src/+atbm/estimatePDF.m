function out=estimatePDF(x,cfg)
x=x(:); x=x(isfinite(x));
assert(numel(x)>=10,"ATBM:InsufficientData","At least 10 samples required.");
edges=cfg.cpRange(1):cfg.binWidth:cfg.cpRange(2);
if edges(end)<cfg.cpRange(2), edges(end+1)=cfg.cpRange(2); end
f=histcounts(x,edges,"Normalization","pdf");
c=edges(1:end-1)+diff(edges)/2;
if cfg.smoothSpan>1, f=smoothdata(f,"movmean",cfg.smoothSpan); end
A=trapz(c,f); if A>0, f=f/A; end
out.edges=edges(:); out.centers=c(:); out.density=f(:);
out.nSamples=numel(x); out.binWidth=cfg.binWidth; out.smoothSpan=cfg.smoothSpan;
end
