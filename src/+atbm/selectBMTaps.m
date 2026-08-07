function [CpBM, tapTableBM] = selectBMTaps(D)
%SELECTBMTAPS Return nSamples x 12 x nCases data in original BM bit order.
D = atbm.standardizeDataset(D);
tapTableBM = D.tapTable(D.tapTable.UseForBM,:);
tapTableBM = sortrows(tapTableBM, 'BMBitIndex');
CpBM = nan(D.nSamples, height(tapTableBM), D.nCases);
for k = 1:height(tapTableBM)
    CpBM(:,k,:) = reshape(D.Cp.(char(tapTableBM.VariableName(k))), ...
        D.nSamples, 1, D.nCases);
end
end
