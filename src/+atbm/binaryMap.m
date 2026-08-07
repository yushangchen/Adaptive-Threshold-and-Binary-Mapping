function index = binaryMap(Cp, thresholds)
%BINARYMAP Apply Cp < threshold to nSamples x nTaps data.

if ~isnumeric(Cp) || ndims(Cp)~=2
    error('ATBM:BinaryMapShape','Cp must be nSamples x nTaps.');
end
thresholds = thresholds(:).';
if size(Cp,2) ~= numel(thresholds)
    error('ATBM:ThresholdSize','One threshold is required per tap.');
end
valid = isfinite(thresholds);
index = false(size(Cp));
index(:,valid) = Cp(:,valid) < thresholds(valid);
end
