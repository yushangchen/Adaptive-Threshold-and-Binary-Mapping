function m=computeMetrics(B,tapTable)
B=logical(B);
assert(size(B,2)==height(tapTable),"ATBM:TapMismatch","Map columns must match taps.");
m.activeTapCountInstantaneous=sum(B,2);
m.meanActiveTapCount=mean(m.activeTapCountInstantaneous);
m.tapOccupancy=mean(B,1);
groups=unique(tapTable.HeightGroup,"stable");
m.heightGroups=groups(:)'; m.heightOccupancy=nan(1,numel(groups));
for k=1:numel(groups)
 idx=tapTable.HeightGroup==groups(k); m.heightOccupancy(k)=mean(B(:,idx),"all");
end
m.patternID=atbm.encodePatterns(B,tapTable.BitIndex);
[u,~,ic]=unique(m.patternID); count=accumarray(ic,1);
[count,ord]=sort(count,"descend"); u=u(ord);
m.patternTable=table(u,count,count/size(B,1), ...
 "VariableNames",["PatternID","Count","Probability"]);
Np=sum(B(:,tapTable.Side>0),2); Nm=sum(B(:,tapTable.Side<0),2);
m.NplusTotal=sum(Np); m.NminusTotal=sum(Nm); den=m.NplusTotal+m.NminusTotal;
if den==0, m.SAI=0; else, m.SAI=(m.NplusTotal-m.NminusTotal)/den; end
di=Np+Nm; s=zeros(size(di)); q=di>0; s(q)=(Np(q)-Nm(q))./di(q);
m.SAIInstantaneousDiagnostic=s;
m.meanAbsoluteInstantaneousSAI=mean(abs(s));
end
