function out=analyzeLocalSignal(x,cfg)
out.pdf=atbm.estimatePDF(x,cfg);
out.classification=atbm.classifyPDF(out.pdf,cfg);
out.candidates=atbm.extractCandidates(out.pdf,out.classification);
end
