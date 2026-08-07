function bits = decodePatterns(state, nTaps, row1IsMSB)
%DECODEPATTERNS Decode decimal identifiers to nPatterns x nTaps logical bits.

if nargin < 3, row1IsMSB = true; end
state = uint16(state(:));
bits = false(numel(state),nTaps);
for row = 1:nTaps
    if row1IsMSB
        bitPosition = nTaps-row+1;
    else
        bitPosition = row;
    end
    bits(:,row) = logical(bitget(state,bitPosition));
end
end
