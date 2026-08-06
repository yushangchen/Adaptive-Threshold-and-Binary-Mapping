function id=encodePatterns(B,bitIndex)
if nargin<2, bitIndex=1:size(B,2); end
[~,ord]=sort(bitIndex); B=logical(B(:,ord)); n=size(B,2);
assert(n<=52,"ATBM:TooManyBits","Exact encoding limited to 52 bits.");
id=double(B)*2.^((n-1):-1:0)';
end
