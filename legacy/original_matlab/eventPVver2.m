% version 2022 01 13
% chevent = eventPV(data,thd1,thd2,d1,d2)
% data: 2-D numeric array, col 1 should be indecies, col 2 should be values
% thd1: upper threshold
% thd2: lower threshold
% d1: minimum height of first ramp element, which is composed of
%     neighbored peak and valley pair
% d2: minimum change, which is defined by difference between neighbored
%     peaks or valleys

function chevent = eventPVver2(data,thd1,thd2,d1,d2)
if nargin < 4
    d1 = 0.3;
    d2 = 0.12;
end
if nargin < 2
    thd1 = -1.5;
    thd2 = -2;
end
if thd1 < thd2
    temp0 = thd1;
    thd1 = thd2;
    thd2 = temp0;
end
tol1 = 0.03;
if thd1>0
    thd1 = thd1*(1-tol1);
else
    thd1 = thd1*(1+tol1);
end
if thd2>0
    thd2 = thd2*(1+tol1);
else
    thd2 = thd2*(1-tol1);
end
if d1<0; d1 = abs(d1); end
if d2<0; d2 = abs(d2); end
N = length(data(:,1));
chevent = nan(N,3);
uu = 2;
ww = 1;
while uu<N-1
    flag1 = 0;
    cond1 = data(uu+1,2) - data(uu,2) < -1*d1;
    cond2 = data(uu+1,2) - data(uu,2) > d1;
    if data(uu,2)> thd1  && cond1
        vv = 1;
        while uu+vv+2 <= N
%             cond3 = data(uu+vv+2,2) - data(uu+vv,2) < -1*d1;
%             cond4 = data(uu+vv+1,2) - data(uu+vv-1,2) < -1*d2;
%             cond5 = data(uu+vv+1,2) - data(uu+vv-1,2) < -1*d2;
%             cond6 = data(uu+vv+2,2) - data(uu+vv,2) < 0; % -1*0.5*d2
            cond3 = data(uu+vv+2,2) - data(uu+vv,2) < -1*d2;
            cond4 = data(uu+vv+1,2) - data(uu+vv-1,2) < -1*d2;
%             if (cond3&&cond5)||(cond4&&cond6)
            if cond3&&cond4
                vv = vv+2;
                flag1= 1;
            else
                break
            end
        end
        if data(uu+vv,2)<thd2
            chevent(ww,1) = 1;
            chevent(ww,2) = data(uu,1);
            chevent(ww,3) = data(uu+vv,1);
            ww = ww+1;
        end
    elseif data(uu,2)< thd2  && cond2
        vv = 1;
        while uu+vv+2<=N
%             cond3 = data(uu+vv+2,2) - data(uu+vv,2) > d1;
%             cond4 = data(uu+vv+1,2) - data(uu+vv-1,2) > d2;
%             cond5 = data(uu+vv+1,2) - data(uu+vv-1,2) > d2;
%             cond6 = data(uu+vv+2,2) - data(uu+vv,2) > 0; % 0.5*d2
            cond3 = data(uu+vv+2,2) - data(uu+vv,2) > d2;
            cond4 = data(uu+vv+1,2) - data(uu+vv-1,2) > d2;
%             if (cond3&&cond5)||(cond4&&cond6)
            if cond3&&cond4
                vv = vv+2;
                flag1= 1;
            else
                break
            end
        end
        if data(uu+vv,2)>thd1
            chevent(ww,1) = 2;
            chevent(ww,2) = data(uu,1);
            chevent(ww,3) = data(uu+vv,1);
            ww = ww+1;
        end
    end
    if flag1 == 1
        uu = uu+vv;
    else
        uu = uu+1;
    end
end
chevent = chevent(~isnan(chevent(:,1)),:);