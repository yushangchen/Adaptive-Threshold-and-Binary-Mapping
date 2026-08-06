# Validation protocol

## Algorithmic verification

Use synthetic unimodal, separated-bimodal, and overlapped-bimodal PDFs.
Confirm morphology, SR/VR behavior, and threshold-candidate existence.

## Numerical sensitivity

Evaluate:

```text
bin width: 0.0125, 0.025, 0.05 Cp
smoothing span: 1, 3, 5, 7 bins
record fraction: 25%, 50%, 75%, 100%
```

For archival work, use block bootstrap because pressure samples are temporally
correlated.

## Threshold sensitivity

Perturb fixed tap-wise thresholds and confirm whether the reported
Reynolds-number-dependent transition sequence remains unchanged.

## Mapping invariants

- tap reordering changes decimal identifiers but not active-tap count;
- side inversion changes SAI sign but not magnitude;
- all-zero activity produces SAI = 0;
- missing pressure samples are not counted as active;
- height occupancy depends only on taps assigned to that height.

## Scientific validation

Oil-film visualization is time integrated. It can provide qualitative
consistency with Reynolds-number-dependent pressure-state trends, but it cannot
validate instantaneous binary topology.
