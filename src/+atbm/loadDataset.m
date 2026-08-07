function D = loadDataset(source, varargin)
%LOADDATASET Load a standardized MAT file, old workspace MAT file, or LVM folder.

if isstruct(source)
    D = atbm.standardizeDataset(source);
    return;
end

source = char(source);
if isfolder(source)
    D = atbm.loadLVMFolder(source, varargin{:});
elseif isfile(source)
    D = atbm.standardizeDataset(source);
else
    error('ATBM:DataSourceNotFound', 'Data source not found: %s', source);
end
end
