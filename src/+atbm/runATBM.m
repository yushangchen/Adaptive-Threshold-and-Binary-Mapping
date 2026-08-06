function out=runATBM(Cp,Re,tapTable,cfg)
if nargin<4, cfg=atbm.defaultConfig(); end
atbm.validateInputs(Cp,Re,tapTable);
candidateTable=atbm.collectCandidateTable(Cp,Re,tapTable,cfg);
if isempty(cfg.operationalThresholds)
 thresholdTable=atbm.selectOperationalThresholds(candidateTable,tapTable,cfg);
else
 thresholdTable=cfg.operationalThresholds;
end
assert(all(isfinite(thresholdTable.Tbasic)),"ATBM:ThresholdReviewRequired", ...
 "Review candidate clusters and provide complete Tbasic values.");
nRe=numel(Re); binaryMaps=cell(1,nRe); hierarchicalMaps=cell(1,nRe); metrics=cell(1,nRe);
for k=1:nRe
 binaryMaps{k}=atbm.buildBinaryMap(Cp(:,:,k),thresholdTable.Tbasic);
 metrics{k}=atbm.computeMetrics(binaryMaps{k},tapTable);
 if all(isfinite(thresholdTable.Tmod))&&all(isfinite(thresholdTable.Tcore))
  hierarchicalMaps{k}=atbm.buildHierarchy(Cp(:,:,k),thresholdTable.Tbasic, ...
   thresholdTable.Tmod,thresholdTable.Tcore);
 else
  hierarchicalMaps{k}=[];
 end
end
out.Re=Re(:)'; out.tapTable=tapTable; out.config=cfg;
out.candidateTable=candidateTable; out.thresholdTable=thresholdTable;
out.binaryMaps=binaryMaps; out.hierarchicalMaps=hierarchicalMaps; out.metrics=metrics;
end
