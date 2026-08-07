function X = getTap(D, tapName, caseIndex)
%GETTAP Return an original pressure variable matrix or one Reynolds-number case.
D = atbm.standardizeDataset(D);
tapName = char(tapName);
if ~isfield(D.Cp, tapName)
    error('ATBM:UnknownTap', 'Unknown tap variable: %s', tapName);
end
X = D.Cp.(tapName);
if nargin >= 3 && ~isempty(caseIndex)
    X = X(:, caseIndex);
end
end
