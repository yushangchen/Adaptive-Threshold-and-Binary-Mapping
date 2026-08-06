function B=buildBinaryMap(Cp,T)
T=reshape(T,1,[]);
assert(size(Cp,2)==numel(T),"ATBM:ThresholdMismatch","One threshold per tap required.");
assert(all(isfinite(T)),"ATBM:InvalidThreshold","Thresholds must be finite.");
B=Cp<T; B(~isfinite(Cp))=false;
end
