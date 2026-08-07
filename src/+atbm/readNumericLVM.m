function A = readNumericLVM(filePath)
%READNUMERICLVM Read the numeric matrix used by the original load-based workflow.

filePath = char(filePath);
try
    A = load(filePath);
    if isstruct(A)
        names = fieldnames(A);
        if numel(names) ~= 1 || ~isnumeric(A.(names{1}))
            error('ATBM:UnsupportedLVM', ...
                'Loaded MAT-style file does not contain one numeric matrix.');
        end
        A = A.(names{1});
    end
catch firstError
    try
        A = readmatrix(filePath, 'FileType', 'text');
        A = A(~all(isnan(A),2), :);
    catch
        rethrow(firstError);
    end
end

if ~isnumeric(A) || isempty(A)
    error('ATBM:InvalidLVM', 'No numeric data were read from %s.', filePath);
end
end
