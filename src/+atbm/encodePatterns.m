function [state, binaryStrings, weights] = encodePatterns(index, row1IsMSB)
%ENCODEPATTERNS Encode nSamples x nTaps logical states as decimal identifiers.

if nargin < 2, row1IsMSB = true; end
index = logical(index);
nTaps = size(index,2);
if row1IsMSB
    weights = 2.^(nTaps-1:-1:0);
else
    weights = 2.^(0:nTaps-1);
end
state = uint16(double(index)*weights(:));
if nargout > 1
    binaryStrings = strings(size(index,1),1);
    for k = 1:size(index,1)
        binaryStrings(k) = string(sprintf('%d',index(k,:)));
    end
end
end
