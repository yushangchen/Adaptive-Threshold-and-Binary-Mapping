function tapTable = defaultTapTable()
%DEFAULTTAPTABLE Original 18-variable order and 12-tap BM bit order.

VariableName = string({ ...
    'Cpp70_1D','Cpp90_1D','Cpp110_1D','Cpn70_1D','Cpn90_1D','Cpn110_1D', ...
    'Cpp70_2D','Cpp90_2D','Cpp110_2D','Cpn70_2D','Cpn90_2D','Cpn110_2D', ...
    'Cpp70_3_5D','Cpp90_3_5D','Cpp110_3_5D', ...
    'Cpn70_3_5D','Cpn90_3_5D','Cpn110_3_5D'}).';

zD = [1 1 1 1 1 1, 2 2 2 2 2 2, 3.5 3.5 3.5 3.5 3.5 3.5].';
thetaDeg = [70 90 110 -70 -90 -110, 70 90 110 -70 -90 -110, ...
            70 90 110 -70 -90 -110].';
Side = sign(thetaDeg);
HeightGroup = repelem((1:3).', 6);
BMBitIndex = [NaN 1 3 NaN 2 4, NaN 5 7 NaN 6 8, NaN 9 11 NaN 10 12].';
UseForBM = isfinite(BMBitIndex);

tapTable = table(VariableName, zD, thetaDeg, Side, HeightGroup, ...
    UseForBM, BMBitIndex);
end
