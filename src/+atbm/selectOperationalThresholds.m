function thresholdTable=selectOperationalThresholds(candidateTable,tapTable,cfg)
rng(cfg.randomSeed);
nTaps=height(tapTable);
thresholdTable=tapTable(:,["TapID","zD","thetaDeg","Side","HeightGroup","BitIndex"]);
thresholdTable.Tbasic=nan(nTaps,1); thresholdTable.Tmod=nan(nTaps,1);
thresholdTable.Tcore=nan(nTaps,1); thresholdTable.NCandidates=zeros(nTaps,1);
thresholdTable.Status=strings(nTaps,1);
for j=1:nTaps
 idx=candidateTable.TapID==tapTable.TapID(j);
 vals=[candidateTable.TL(idx);candidateTable.TR(idx);candidateTable.Tv(idx)];
 vals=vals(isfinite(vals)&vals<-0.2);
 thresholdTable.NCandidates(j)=numel(vals);
 if numel(vals)<cfg.thresholdClusterCount
  thresholdTable.Status(j)="insufficient-candidates"; continue
 end
 g=kmeans(vals,cfg.thresholdClusterCount,"Replicates",20,"Start","plus");
 med=zeros(cfg.thresholdClusterCount,1);
 for c=1:cfg.thresholdClusterCount, med(c)=median(vals(g==c)); end
 med=sort(med,"descend");
 thresholdTable.Tbasic(j)=med(1); thresholdTable.Tmod(j)=med(2); thresholdTable.Tcore(j)=med(3);
 thresholdTable.Status(j)="automatic-review-required";
end
end
