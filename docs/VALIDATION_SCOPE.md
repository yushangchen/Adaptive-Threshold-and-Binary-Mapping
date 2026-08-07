# Validation scope

## GitHub Actions

CI executes only software tests that do not require the private experimental dataset:

- tap and calibration table integrity;
- old-variable dataset conversion;
- 12-tap threshold crossing;
- MSB-first decimal pattern encoding and decoding;
- hierarchy-level construction;
- AT function smoke execution.

A green CI result is therefore a software-execution result, not a claim that the experimental manuscript figures were reproduced.

## Experimental validation

Measured-data validation is executed locally with:

```matlab
run_experimental_validation('data/processed/ATBM_dataset.mat');
```

The representative cases and parameter ranges are retained from the original supplied programs. Generated files are written to `results/validation` and `figures/validation`.
