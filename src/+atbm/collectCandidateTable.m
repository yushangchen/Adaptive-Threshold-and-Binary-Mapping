function T=collectCandidateTable(Cp,Re,tapTable,cfg)
[~,nTaps,nRe]=size(Cp); rows=cell(nTaps*nRe,12); q=0;
for k=1:nRe
 for j=1:nTaps
  q=q+1; a=atbm.analyzeLocalSignal(Cp(:,j,k),cfg);
  rows(q,:)={Re(k),tapTable.TapID(j),tapTable.zD(j),tapTable.thetaDeg(j), ...
   tapTable.BitIndex(j),a.classification.type,a.classification.SR, ...
   a.classification.VR,a.candidates.TL,a.candidates.TR,a.candidates.Tv,a.pdf.nSamples};
 end
end
T=cell2table(rows,"VariableNames",["Re","TapID","zD","thetaDeg","BitIndex", ...
 "Morphology","SR","VR","TL","TR","Tv","NSamples"]);
end
