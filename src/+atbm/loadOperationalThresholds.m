function [thresholdTable, vectors] = loadOperationalThresholds(source)
%LOADOPERATIONALTHRESHOLDS Read and align thresholds by BMBitIndex.

if istable(source)
    thresholdTable = source;
else
    thresholdTable = readtable(char(source), 'TextType','string');
end
required = {'BitIndex','Tbasic'};
missing = setdiff(required, thresholdTable.Properties.VariableNames);
if ~isempty(missing)
    error('ATBM:ThresholdColumns', 'Missing threshold columns: %s', ...
        strjoin(missing,', '));
end
thresholdTable = sortrows(thresholdTable,'BitIndex');
if ~isequal(thresholdTable.BitIndex(:),(1:height(thresholdTable)).')
    error('ATBM:BitIndex', 'BitIndex must be consecutive and start at 1.');
end
vectors = struct();
vectors.Tbasic = thresholdTable.Tbasic(:);
for name = ["Tmod","Tcore"]
    if ismember(name, string(thresholdTable.Properties.VariableNames))
        vectors.(char(name)) = thresholdTable.(char(name))(:);
    else
        vectors.(char(name)) = nan(height(thresholdTable),1);
    end
end
end
