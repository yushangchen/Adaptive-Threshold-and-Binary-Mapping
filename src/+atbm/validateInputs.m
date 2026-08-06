function validateInputs(Cp,Re,tapTable)
assert(isnumeric(Cp),"ATBM:InvalidCp","Cp must be numeric.");
[~,nTaps,nRe]=size(Cp);
assert(numel(Re)==nRe,"ATBM:ReMismatch","Re count must match size(Cp,3).");
assert(istable(tapTable)&&height(tapTable)==nTaps,"ATBM:TapMismatch", ...
    "tapTable must have one row per tap.");
required=["TapID","zD","thetaDeg","Side","HeightGroup","BitIndex"];
missing=setdiff(required,string(tapTable.Properties.VariableNames));
assert(isempty(missing),"ATBM:MissingMetadata","Missing: %s",strjoin(missing,", "));
assert(all(ismember(tapTable.Side,[-1 1])),"ATBM:InvalidSide","Side must be +/-1.");
assert(isequal(sort(tapTable.BitIndex(:))',(1:nTaps)), ...
    "ATBM:InvalidBitIndex","BitIndex must contain 1:nTaps.");
end
