function H=buildHierarchy(Cp,Tbasic,Tmod,Tcore)
Tbasic=reshape(Tbasic,1,[]); Tmod=reshape(Tmod,1,[]); Tcore=reshape(Tcore,1,[]);
assert(all(Tcore<Tmod & Tmod<Tbasic),"ATBM:ThresholdOrder","Tcore<Tmod<Tbasic required.");
H=zeros(size(Cp),"uint8");
H(Cp<Tbasic)=1; H(Cp<Tmod)=2; H(Cp<Tcore)=3; H(~isfinite(Cp))=0;
end
