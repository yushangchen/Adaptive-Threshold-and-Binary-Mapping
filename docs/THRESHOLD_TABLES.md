# Threshold tables

## Baseline-reference thresholds

`config/operational_thresholds_baseline_v3.csv` contains the 12 reviewed
\(T_{\mathrm{basic},j}\) values used for the baseline-departure mapping in the
manuscript. The table also stores the tap position, side label, height group,
and binary bit index.

These thresholds are tap dependent but fixed across the examined Reynolds
numbers.

## Representative hierarchy

`config/representative_hierarchy_thresholds_v3.csv` contains the hierarchy
shown for the representative tap at \(z/D=2\), \(\theta=+90^\circ\):

```text
Tbasic = -0.975
Tmod   = -1.975
Tcore  = -2.475
```

This row demonstrates the operational hierarchy and must not be copied to all
12 taps.

## Reproduction boundary

The public v0.3.0 table is sufficient to reproduce the baseline-reference
binary mapping once the synchronized experimental pressure data are supplied.
Exact reproduction of a publication-specific hierarchical map additionally
requires the complete author-reviewed tap-wise \(T_{\mathrm{mod},j}\) and
\(T_{\mathrm{core},j}\) values used for that figure.
