function saveDataset(D, filePath)
%SAVEDATASET Save a standardized dataset as variable D.
D = atbm.standardizeDataset(D);
folder = fileparts(char(filePath));
if ~isempty(folder) && ~isfolder(folder)
    mkdir(folder);
end
save(char(filePath), 'D', '-v7.3');
end
