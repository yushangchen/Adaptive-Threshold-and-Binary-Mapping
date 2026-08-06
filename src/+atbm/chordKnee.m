function [xKnee,idx,d]=chordKnee(x,y)
x=x(:); y=y(:);
assert(numel(x)==numel(y)&&numel(x)>=3,"ATBM:InvalidSegment","Need >=3 points.");
xs=max(x)-min(x); ys=max(y)-min(y);
if xs<=eps, xs=1; end
if ys<=eps, ys=1; end
xn=(x-min(x))/xs; yn=(y-min(y))/ys;
p1=[xn(1) yn(1)]; p2=[xn(end) yn(end)]; v=p2-p1; den=hypot(v(1),v(2));
if den<=eps, d=zeros(size(xn)); idx=ceil(numel(xn)/2);
else
 d=abs(v(2).*xn-v(1).*yn+p2(1)*p1(2)-p2(2)*p1(1))/den;
 [~,idx]=max(d);
end
xKnee=x(idx);
end
