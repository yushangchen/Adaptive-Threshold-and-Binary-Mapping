setup; rng(42);
cfg=atbm.defaultConfig();
n=30000; nTaps=12;
Re=[2.17 2.49 2.81 3.20 3.29 3.40 3.75]*1e5;
Cp=zeros(n,nTaps,numel(Re));
for k=1:numel(Re)
 p=(k-1)/(numel(Re)-1);
 for j=1:nTaps
  lower=j<=4; positive=mod(j,2)==1;
  prob=0.02+0.72*p+0.16*lower*p*(1-p)+0.18*positive*exp(-((p-0.55)/0.2)^2);
  active=rand(n,1)<min(prob,0.95);
  x=-0.62+0.13*randn(n,1);
  x(active)=-1.45-0.45*p+0.20*randn(sum(active),1);
  Cp(:,j,k)=x;
 end
end
zD=repelem([1;2;3.5],4);
theta=repmat([90;-90;110;-110],3,1);
tapTable=table("T"+(1:nTaps)',zD,theta,sign(theta), ...
 repelem((1:3)',4),(1:nTaps)', ...
 "VariableNames",["TapID","zD","thetaDeg","Side","HeightGroup","BitIndex"]);
thresholdTable=tapTable;
thresholdTable.Tbasic=-0.975*ones(nTaps,1);
thresholdTable.Tmod=-1.975*ones(nTaps,1);
thresholdTable.Tcore=-2.475*ones(nTaps,1);
cfg.operationalThresholds=thresholdTable;
out=atbm.runATBM(Cp,Re,tapTable,cfg);
S=out; S.Cp=Cp;
save("results/ATBM_results.mat","-struct","S","-v7.3");
disp(atbm.summaryTable(out));
run("scripts/reproduce_all_figures.m");
