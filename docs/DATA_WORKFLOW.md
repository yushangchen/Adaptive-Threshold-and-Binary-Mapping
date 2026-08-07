# Data workflow

## Recommended interactive entry point

From the repository root, the simplest first run is:

```matlab
D = start_atbm(rawFolder);
```

This reads the original `.lvm` files, saves the standardized dataset to
`data/processed/ATBM_dataset.mat`, and exports `D` together with the original
variables to the MATLAB base workspace. Later sessions can use:

```matlab
D = start_atbm();
```

## Standardized dataset structure

`atbm.loadLVMFolder` and `atbm.loadDataset` return a structure `D` containing:

- `D.Cp.<VariableName>`: one `nSamples x nCases` matrix for each original pressure variable;
- `D.alldata`: the 18 pressure matrices in the original analysis order;
- `D.tapNames`: the matching 18 variable names;
- `D.tapTable`: tap coordinates, side, and binary-map bit index;
- `D.Re`: dimensional Reynolds numbers;
- `D.R`: `Re/1e5`, rounded to two decimals as in the original scripts;
- `D.t`, `D.Fs`, `D.V_pitot`, `D.density`, `D.temperatureC`;
- `D.meta.sourceFiles` and calibration metadata.

## Original 18-variable order

```text
Cpp70_1D, Cpp90_1D, Cpp110_1D, Cpn70_1D, Cpn90_1D, Cpn110_1D,
Cpp70_2D, Cpp90_2D, Cpp110_2D, Cpn70_2D, Cpn90_2D, Cpn110_2D,
Cpp70_3_5D, Cpp90_3_5D, Cpp110_3_5D,
Cpn70_3_5D, Cpn90_3_5D, Cpn110_3_5D
```

## Original 12-tap BM order

```text
Cpp90_1D, Cpn90_1D, Cpp110_1D, Cpn110_1D,
Cpp90_2D, Cpn90_2D, Cpp110_2D, Cpn110_2D,
Cpp90_3_5D, Cpn90_3_5D, Cpp110_3_5D, Cpn110_3_5D
```

The first row/tap is the most significant bit by default, matching the supplied binary-mapping scripts.

## Loading raw data

```matlab
D = atbm.loadLVMFolder(rawFolder);
```

The loader sorts `.lvm` files by filename, matching the practical behavior of the original `dir` workflow. The file order must therefore match the intended Reynolds-number order.

## Loading an existing workspace MAT file

The loader accepts either:

1. a MAT file containing a standardized `D` structure;
2. a MAT file containing the original top-level variables;
3. a MAT file containing `Cp`, `Re`, and `tapTable` from the previous repository layout.

## Exporting old variables

```matlab
atbm.exportLegacyVariables(D);
```

This writes the original variable names into the calling workspace so that older figure scripts can run without rewriting every variable reference.
