# Adaptive Threshold and Binary Mapping (AT-BM)

MATLAB implementation of the **Adaptive Threshold and Binary Mapping (AT-BM)** framework used for pressure-state analysis of the aspect-ratio-4 finite circular cylinder.

This source-faithful rebuild was prepared directly from the author's original MATLAB programs. The supplied programs are preserved unchanged in `legacy/original_matlab/`, while the reusable functions in `src/+atbm/` provide a path-independent workflow for loading the original `.lvm` files, restoring the familiar variables, extracting adaptive thresholds, and performing 12-tap binary mapping.

## Repository status

The code is separated into two clearly defined layers:

1. **Reusable implementation** — raw-data loading, calibration, AT extraction, BM encoding, hierarchy construction, and result tables.
2. **Original-program reproduction** — the supplied figure and sensitivity programs, executed after the original workspace variables are restored.

The reviewed 12-tap baseline table, \(T_{\mathrm{basic},j}\), is provided in `config/operational_thresholds_baseline_v3.csv`. Complete tap-specific \(T_{\mathrm{mod},j}\) and \(T_{\mathrm{core},j}\) values are not invented by this repository.

AT-BM produces **pressure-based operational state descriptions**. Binary and hierarchical states are not direct reconstructions of instantaneous separation or reattachment topology.

## Method and existing manuscript figures

### 1. PDF morphology and adaptive-threshold extraction

The implemented AT logic follows the original histogram/PDF procedure:

- `mode = 0`: unimodal or fewer than two detected peaks; retain chord-distance knees `TL` and `TR`;
- `mode = 1`: bimodal-separated; retain local chord-distance knees `TL` and `TR`;
- `mode = 2`: bimodal-overlapped; retain the inter-peak valley `Tv`;
- separated versus overlapped is decided using `SR >= 1.5` and valley ratio `VR <= 0.80` by default.

<p align="center">
  <img src="docs/images/method/fig06-pdf-morphology-and-threshold-extraction.jpg"
       alt="PDF morphology and adaptive-threshold extraction"
       width="100%">
</p>

**Figure 1.** Representative extraction of PDF-derived candidate thresholds for unimodal, bimodal-separated, and bimodal-overlapped pressure distributions.

### 2. Operational pressure-state hierarchy

For each tap, PDF-derived candidate boundaries are pooled over the examined Reynolds-number range. Recurrent transition-relevant candidate groups define the operational pressure boundaries. Once selected, the boundaries are held fixed across Reynolds number.

<p align="center">
  <img src="docs/images/result/fig08-operational-threshold-hierarchy.png"
       alt="Operational threshold hierarchy"
       width="100%">
</p>

**Figure 2.** Representative candidate clustering and pressure-state hierarchy at `z/D = 2`, `theta = +90 deg`. The displayed hierarchy values are representative, not universal values for all taps.

### 3. Reynolds-number-dependent pressure-state statistics

The binary state is defined as `Cp < T`, with state 1 representing a low-`Cp` threshold crossing. The synchronized maps can be summarized by active-tap count, tap and height occupancy, binary-pattern probability, and side-asymmetry statistics.

<p align="center">
  <img src="docs/images/result/fig13-reynolds-number-state-summary.png"
       alt="Reynolds-number-dependent pressure-state statistics"
       width="100%">
</p>

**Figure 3.** Reynolds-number-dependent pressure-state statistics.

### 4. Hierarchical pressure-state map

When complete tap-specific thresholds are supplied, the hierarchy is:

```text
Level 0: Cp >= Tbasic
Level 1: Tmod <= Cp < Tbasic
Level 2: Tcore <= Cp < Tmod
Level 3: Cp < Tcore
```

<p align="center">
  <img src="docs/images/result/fig14-hierarchical-pressure-state-map.png"
       alt="Hierarchical pressure-state map"
       width="100%">
</p>

**Figure 4.** Representative synchronized multi-tap hierarchical pressure-state map.

## Robustness and sensitivity analyses

The authoritative measured-data validation is retained from the original supplied `AT_sensitivity_binwidth.m` and `VRsensitivity.m` programs.

### 5. Histogram bin-width sensitivity

<p align="center">
  <img src="docs/images/validation/Appendix A Sensitivity of AT thresholds to bin width.jpg"
       alt="Histogram bin-width sensitivity"
       width="100%">
</p>

### 6. SR/VR modality-decision sensitivity

<p align="center">
  <img src="docs/images/validation/Appendix A Sensitivity of PDF modality decision to SRVR criteria.jpg"
       alt="SR and VR modality-decision sensitivity"
       width="100%">
</p>

### 7. Bootstrap repeatability

<p align="center">
  <img src="docs/images/validation/Appendix A Bootstrap repeatability of AT-derived thresholds.jpg"
       alt="Bootstrap repeatability of adaptive thresholds"
       width="100%">
</p>

The bootstrap section quantifies sampling repeatability of measured-record threshold extraction; it is not a Reynolds-number-dependent threshold adjustment.

## Original tap and bit ordering

The 12 BM taps are encoded in the original order:

```text
bit 1  Cpp90_1D       bit 2  Cpn90_1D
bit 3  Cpp110_1D      bit 4  Cpn110_1D
bit 5  Cpp90_2D       bit 6  Cpn90_2D
bit 7  Cpp110_2D      bit 8  Cpn110_2D
bit 9  Cpp90_3_5D     bit 10 Cpn90_3_5D
bit 11 Cpp110_3_5D    bit 12 Cpn110_3_5D
```

The first tap is the most significant bit by default. The decimal pattern code is an identifier only.

## Quick start: one command in MATLAB

For the first run, provide the folder containing the original `.lvm` files:

```matlab
D = start_atbm("I:\\your_path\\AR4\\原始訊號");
```

`start_atbm` performs four operations:

1. configures the repository path;
2. reads and calibrates the original `.lvm` files;
3. saves `data/processed/ATBM_dataset.mat`;
4. restores the familiar variables to the MATLAB base workspace.

After the standardized MAT file has been created, later sessions require only:

```matlab
D = start_atbm();
```

The loader applies the original pitot, temperature, and pressure-channel calibration constants; calculates `Cp`, air density, velocity, and Reynolds number; and prepares all variables required by the original programs.

Examples immediately available in the Command Window are:

```matlab
seg1 = Cpp90_2D(:,25);
seg2 = alldata{8}(:,25);
Re25 = Re(25);
result = atbm.extractAT(seg1);
```

## Load an existing MAT file

```matlab
setup;
D = atbm.loadDataset(fullfile('data','processed','ATBM_dataset.mat'));
```

`atbm.loadDataset` accepts:

- a standardized MAT file containing `D`;
- an older MAT file containing top-level variables such as `Cpp90_2D`;
- the previous repository layout containing numeric `Cp`, `Re`, and `tapTable`.

## Restore the original variables

```matlab
atbm.exportLegacyVariables(D);

% Original variables now exist in the current workspace:
% Cpp90_2D, Cpp110_1D, Cpn90_3_5D, alldata, tapNames,
% Re, R, t, tt, Fs, edges, centers, ...

seg = Cpp90_2D(:,25);
result = atbm.extractAT(seg);
```

Direct access without workspace export is also available:

```matlab
seg = atbm.getTap(D, 'Cpp90_2D', 25);
result = atbm.extractAT(seg);
```

## Extract AT candidates for all 18 taps and cases

```matlab
cfg = atbm.defaultConfig();
candidates = atbm.runCandidateExtraction(D, cfg);
writetable(candidates.table, fullfile('results','AT_candidates.csv'));
```

## Run 12-tap baseline mapping

```matlab
thresholdFile = fullfile('config','operational_thresholds_baseline_v3.csv');
out = atbm.runATBM(D, thresholdFile);
save(fullfile('results','ATBM_results.mat'), 'out', '-v7.3');
```

## Reproduce the supplied measured-data validation

```matlab
run_experimental_validation( ...
    fullfile('data','processed','ATBM_dataset.mat'));
```

This restores the original variables and executes the supplied validation programs without replacing their scientific logic.

## Reproduce the three selected PDF morphology panels

```matlab
figure_pdf_morphologies( ...
    fullfile('data','processed','ATBM_dataset.mat'));
```

The default cases are retained from the original program:

- `Cpp90_2D(:,7)` — unimodal;
- `Cpp90_2D(:,25)` — bimodal-separated;
- `Cpp70_1D(:,26)` — bimodal-overlapped.

## GitHub Actions

GitHub Actions runs only software unit tests and synthetic smoke tests. A green Actions result confirms that the reusable code and data interfaces execute successfully; it does **not** claim reproduction of the unpublished experimental dataset.

## Repository structure

```text
src/+atbm/                 reusable source-faithful MATLAB functions
scripts/workflows/         data preparation and analysis entry points
scripts/figures/           path-independent figure scripts
validation/experimental/   measured-data validation entry points
legacy/original_matlab/    supplied original programs, unchanged
data/raw/                   raw .lvm files; excluded from Git
data/processed/             standardized MAT data; excluded from Git
config/                     calibration and threshold tables
tests/                      software unit and smoke tests
results/                    generated tables; excluded from Git
figures/                    generated figures; excluded from Git
```

## MATLAB requirements

Core AT extraction and figure reproduction require MATLAB and Signal Processing Toolbox (`findpeaks`). The original validation and comparison programs additionally use functions from Statistics and Machine Learning Toolbox, including `randsample`, `iqr`, `boxchart`, `fitgmdist`, and `ksdensity`.

## Provenance and limitations

- The pressure-channel calibration values were copied exactly from the supplied `newatbm.m`; no large offset was silently corrected.
- The final histogram/SR/VR AT logic is kept separate from the earlier GMM/BIC/Otsu comparison branch.
- Raw experimental data and generated outputs are not committed.
- No license is declared until the author selects one.
