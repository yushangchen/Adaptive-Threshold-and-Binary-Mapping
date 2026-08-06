# Adaptive Threshold and Binary Mapping (AT-BM)

MATLAB implementation of the **Adaptive Threshold and Binary Mapping (AT-BM)**
framework for extracting local pressure-state boundaries and quantifying the
Reynolds-number-dependent organization of synchronized multi-tap surface
pressure signals.

This repository follows the current manuscript methodology for a finite
circular cylinder with aspect ratio 4.

> **Repository version:** 0.3.0 — third revision

## Repository status

The repository provides:

- reusable MATLAB functions for Adaptive Thresholding and Binary Mapping;
- an executable synthetic example;
- figure-generation entry points;
- numerical sensitivity and repeatability checks;
- MATLAB unit tests;
- reviewed baseline-reference thresholds used for the 12-tap binary mapping.

Exact reproduction of all experimental figures still requires the original
synchronized pressure dataset, verified tap ordering, and the complete reviewed
tap-specific hierarchy table used for the multi-threshold map.

AT-BM produces **pressure-based operational state descriptions**. Binary and
hierarchical states are not direct reconstructions of instantaneous separation
or reattachment topology.

## Method, representative results, and validation

### 1. PDF morphology and adaptive-threshold extraction

Local pressure-coefficient PDFs are classified as unimodal,
bimodal-separated, or bimodal-overlapped. Depending on morphology, the method
retains chord-distance knee points, \(T_L\) and \(T_R\), or the inter-peak
valley, \(T_v\), as candidate pressure-state boundaries.

<p align="center">
  <img src="docs/images/method/fig06-pdf-morphology-and-threshold-extraction.jpg"
       alt="PDF morphology and adaptive-threshold extraction" width="100%">
</p>

**Figure 1.** Representative extraction of PDF-derived candidates.

### 2. Operational pressure-state hierarchy

For each pressure tap, transition-relevant candidates are pooled over the
examined Reynolds-number range. Recurrent candidate groups define the
tap-specific operational thresholds:

- \(T_{\mathrm{basic},j}\)
- \(T_{\mathrm{mod},j}\)
- \(T_{\mathrm{core},j}\)

Once selected, these thresholds are held fixed across Reynolds number.

<p align="center">
  <img src="docs/images/result/fig08-operational-threshold-hierarchy.png"
       alt="Operational threshold hierarchy" width="100%">
</p>

**Figure 2.** Representative threshold-candidate distribution and operational
hierarchy at \(z/D=2\), \(\theta=+90^\circ\). The displayed hierarchy is a
representative tap result and is not a universal threshold set.

### 3. Reynolds-number-dependent pressure-state statistics

The synchronized binary maps are summarized using mean active-tap count,
height-wise occupancy, binary-pattern probability, and the manuscript-defined
side-asymmetry index.

<p align="center">
  <img src="docs/images/result/fig13-reynolds-number-state-summary.png"
       alt="Reynolds-number-dependent pressure-state statistics" width="100%">
</p>

**Figure 3.** Reynolds-number-dependent pressure-state statistics over the
monitored tap array.

### 4. Hierarchical pressure-state map

```text
Level 0: Cp >= Tbasic
Level 1: Tmod <= Cp < Tbasic
Level 2: Tcore <= Cp < Tmod
Level 3: Cp < Tcore
```

<p align="center">
  <img src="docs/images/result/fig14-hierarchical-pressure-state-map.png"
       alt="Hierarchical pressure-state map" width="100%">
</p>

**Figure 4.** Representative synchronized multi-tap hierarchical pressure-state
map.

## Robustness and sensitivity analyses

### 5. Histogram bin-width sensitivity

<p align="center">
  <img src="docs/images/validation/Appendix A Sensitivity of AT thresholds to bin width.jpg"
       alt="Histogram bin-width sensitivity" width="100%">
</p>

The candidate thresholds are evaluated over multiple PDF bin widths. The
included script also checks PDF-smoothing sensitivity.

### 6. SR/VR modality-decision sensitivity

<p align="center">
  <img src="docs/images/validation/Appendix A Sensitivity of PDF modality decision to SRVR criteria.jpg"
       alt="SR and VR modality-decision sensitivity" width="100%">
</p>

The nominal \(SR\) and \(VR\) criteria are varied by ±20%. The representative
separated and overlapped cases retain their morphology assignments throughout
the tested criterion grid.

### 7. Bootstrap repeatability

<p align="center">
  <img src="docs/images/validation/Appendix A Bootstrap repeatability of AT-derived thresholds.jpg"
       alt="Bootstrap repeatability of adaptive thresholds" width="100%">
</p>

The repeatability script performs 200 **m-out-of-n bootstrap** realizations.
Each realization draws 80% of the original record length **with replacement**.
The test evaluates numerical repeatability of PDF-derived candidates; it does
not test physical stationarity or preserve temporal ordering.

## Scientific scope

AT-BM contains two stages:

1. **Adaptive Thresholding (AT)** — morphology-dependent extraction of local
   PDF-derived boundary candidates.
2. **Binary Mapping (BM)** — fixed tap-specific operational thresholds are
   applied to synchronized signals and converted into multi-tap state vectors.

The operational thresholds are dataset-defined reference boundaries for the
present experimental configuration. They are not continuously retuned at every
Reynolds number.

## Latest implemented logic

- 12 taps at `theta = +/-90 deg` and `+/-110 deg`;
- three heights: `z/D = 1, 2, 3.5`;
- `Fs = 1000 Hz`, `120 s`, `120000 samples per tap`;
- candidate thresholds: `TL`, `TR`, and `Tv`;
- morphology criteria: `SR >= 1.5` and `VR <= 0.8`;
- tap-specific `Tbasic,j`, `Tmod,j`, and `Tcore,j`;
- operational thresholds pooled across Reynolds number and then fixed;
- decimal pattern code used only as an identifier;
- manuscript SAI defined as the time average of the instantaneous normalized
  side bias;
- aggregate complete-record side occupancy retained as a separate diagnostic.

## Repository structure

```text
src/+atbm/       reusable core functions
scripts/         end-to-end analysis and figure generation
validation/      sensitivity and robustness checks
tests/           MATLAB unit tests
examples/        executable synthetic demonstration
config/          default parameters and reviewed threshold tables
docs/            method, equations, data format, and limitations
data/raw/        raw data; excluded from Git
results/         generated numerical tables; excluded from Git
figures/         generated figures; excluded from Git
```

## Quick start

```matlab
setup;
run("examples/demo_ATBM.m");
```

Run all validation and unit tests:

```matlab
setup;
run("validation/run_all_validation.m");
```

Analyze experimental data:

```matlab
setup;
cfg = atbm.defaultConfig();
D = load("data/raw/ATBM_pressure_data.mat");
out = atbm.runATBM(D.Cp,D.Re,D.tapTable,cfg);
save("results/ATBM_results.mat","-struct","out","-v7.3");
```

## Required data

```matlab
Cp        % nSamples x nTaps x nRe
Re        % 1 x nRe
tapTable  % one row per tap
```

Required `tapTable` columns:

```text
TapID, zD, thetaDeg, Side, HeightGroup, BitIndex
```

## Threshold tables included in v0.3.0

- `config/operational_thresholds_baseline_v3.csv` — the 12 reviewed
  \(T_{\mathrm{basic},j}\) values used for baseline-departure mapping.
- `config/representative_hierarchy_thresholds_v3.csv` — the representative
  \(z/D=2,\theta=+90^\circ\) hierarchy shown in the manuscript.

See `docs/THRESHOLD_TABLES.md` for scope and limitations. The representative
hierarchy must not be applied globally to all taps.

## Validation

`validation/run_all_validation.m` runs:

- synthetic morphology verification;
- histogram bin-width and PDF-smoothing sensitivity;
- record-length sensitivity;
- SR/VR modality-decision sensitivity;
- m-out-of-n bootstrap repeatability;
- MATLAB unit tests for binary mapping, hierarchy, pattern encoding, and SAI.

Generated CSV tables are written to `results/`, and the two new validation
figures are written to `figures/`.

## Figure entry points

```matlab
run("scripts/reproduce_all_figures.m");
```

The repository contains generation entry points for manuscript Figs. 5–14.
Exact publication reproduction requires the corresponding experimental MAT
file and any complete author-reviewed tap-wise hierarchy table not included in
this public revision.

## Reproducibility rules

1. Do not independently retune the final threshold at every Reynolds number.
2. Do not silently replace failed candidate extractions.
3. Store the exact tap order with every dataset.
4. Distinguish candidate thresholds from operational thresholds.
5. Export numerical tables in addition to figures.
6. Treat oil-film comparison as qualitative consistency only.
7. Do not interpret a near-zero time-averaged SAI as proof of instantaneous
   bilateral symmetry.
8. Do not interpret ordinary bootstrap resampling as a test of physical
   stationarity.

## Citation and release

`CITATION.cff` is prepared for software version `0.3.0`. Create a GitHub release
and archive that release with Zenodo before inserting a DOI into the manuscript.

## License

No license is assigned in this revision. Add a license only after author and
coauthor approval.
