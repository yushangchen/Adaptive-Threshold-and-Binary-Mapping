function T=summaryTable(out)
n=numel(out.Re); rows=cell(n,8);
for k=1:n
 m=out.metrics{k}; occ=nan(1,3);
 occ(1:min(3,numel(m.heightOccupancy)))=m.heightOccupancy(1:min(3,end));
 rows(k,:)={out.Re(k),m.meanActiveTapCount,occ(1),occ(2),occ(3), ...
  mean(m.patternID==0),m.SAI,m.meanAbsoluteInstantaneousSAI};
end
T=cell2table(rows,"VariableNames",["Re","MeanActiveTapCount","Occupancy_zD1", ...
 "Occupancy_zD2","Occupancy_zD3p5","AllZeroProbability","SAI", ...
 "MeanAbsoluteInstantaneousSAI"]);
end
