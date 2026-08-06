# Validation protocol — version 0.3.0

## Execution

```matlab
setup;
run("validation/run_all_validation.m");
```

The runner executes the scripts listed below and then runs the MATLAB unit-test
suite.

## 1. Synthetic morphology verification

`validate_synthetic_morphologies.m` evaluates representative unimodal,
bimodal-separated, and bimodal-overlapped signals. It records the observed
morphology, SR, VR, and retained candidates.

## 2. Bin-width and smoothing sensitivity

`validate_bin_width_and_smoothing.m` evaluates whether PDF-derived candidates
are controlled by histogram discretization or smoothing span.

## 3. Record-length sensitivity

`validate_record_length.m` evaluates candidate stability over selected record
fractions. This is a convergence check, not a claim that individual samples are
statistically independent.

## 4. SR/VR decision sensitivity

`validate_sr_vr_sensitivity.m` varies the nominal SR and VR cutoffs by ±20% for
representative separated and overlapped bimodal signals. The script writes the
complete decision grid to CSV and exports a decision-map figure.

## 5. Bootstrap repeatability

`validate_bootstrap_repeatability.m` performs 200 m-out-of-n bootstrap
realizations. Each realization draws 80% of the original record length with
replacement. Candidate deviations are normalized by the full-record IQR.

This bootstrap test evaluates numerical repeatability of the PDF-based
candidate extraction under finite-sample perturbation. Random resampling removes
time order and therefore does not test physical stationarity, event duration,
or temporal dependence. Block bootstrap or segmented-run analysis is required
for those questions.

## 6. Mapping and metric invariants

The unit tests verify:

- binary threshold mapping;
- decimal pattern encoding;
- hierarchical level assignment;
- zero-activity SAI behavior;
- the manuscript time-averaged SAI;
- the distinction between manuscript SAI and aggregate occupancy bias;
- representative separated-PDF classification.

## Scientific interpretation

Oil-film visualization is time integrated. It provides qualitative consistency
with Reynolds-number-dependent pressure-state trends but does not validate an
instantaneous binary topology.
