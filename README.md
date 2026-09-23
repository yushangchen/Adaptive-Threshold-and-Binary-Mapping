Adaptive Threshold and Binary Mapping (AT-BM)

MATLAB implementation of the Adaptive Threshold and Binary Mapping (AT-BM) framework for extracting local pressure-state boundaries and quantifying the Reynolds-number-dependent organization of synchronized multi-tap surface-pressure signals.

This repository follows the manuscript methodology for a finite circular cylinder with aspect ratio 4.

Repository status

This repository provides the MATLAB implementation, validation procedures, and representative outputs of the AT-BM framework.

The included synthetic example is directly executable. Exact reproduction of the experimental figures requires the original synchronized pressure dataset, the verified pressure-tap ordering, and the reviewed tap-specific operational threshold table.

AT-BM produces pressure-based operational state descriptions. The derived binary and hierarchical states should not be interpreted as direct reconstructions of instantaneous separation or reattachment topology.

Method, representative results, and validation

The figures below summarize the construction of the adaptive thresholds, the resulting Reynolds-number-dependent pressure-state statistics, and the sensitivity analyses used to evaluate the robustness of the method.

1. PDF morphology and adaptive-threshold extraction

Local pressure-coefficient PDFs are classified as unimodal, bimodal-separated, or bimodal-overlapped. Depending on the PDF morphology, the method retains chord-distance knee points, (T_L) and (T_R), or the inter-peak valley, (T_v), as candidate pressure-state boundaries.

<p align="center">
  <img src="docs/images/method/fig06-pdf-morphology-and-threshold-extraction.jpg"
       alt="PDF morphology and adaptive-threshold extraction"
       width="100%">
</p>

Figure 1. Representative extraction of PDF-derived candidate thresholds for unimodal, bimodal-separated, and bimodal-overlapped pressure distributions.

2. Operational pressure-state hierarchy

For each pressure tap, candidate boundaries are pooled over the examined Reynolds-number range. Recurrent transition-relevant candidate groups define the tap-specific operational thresholds:

(T_{\mathrm{basic},j})

(T_{\mathrm{mod},j})

(T_{\mathrm{core},j})

Once selected, these thresholds are held fixed across Reynolds number. The fixed thresholds are operational reference boundaries for cross-Reynolds-number comparison and are not universal physical separation criteria.

<p align="center">
  <img src="docs/images/result/fig08-operational-threshold-hierarchy.png"
       alt="Operational threshold hierarchy"
       width="100%">
</p>

Figure 2. Representative clustering of PDF-derived candidates and the corresponding operational pressure-state hierarchy. The displayed threshold values correspond to the representative tap at (z/D=2) and (\theta=+90^\circ); they are not universal values for all pressure taps.

3. Reynolds-number-dependent pressure-state statistics

The synchronized binary maps are summarized using the mean active-tap count, height-wise state occupancy, binary-pattern probability, and complete-record side-asymmetry index.

<p align="center">
  <img src="docs/images/result/fig13-reynolds-number-state-summary.png"
       alt="Reynolds-number-dependent pressure-state statistics"
       width="100%">
</p>

Figure 3. Reynolds-number-dependent evolution of the global active-tap count, height-resolved occupancy, representative pattern probabilities, and side-asymmetry index.

4. Hierarchical pressure-state map

The three operational boundaries produce four pressure-state levels:

Level 0: Cp >= Tbasic
Level 1: Tmod <= Cp < Tbasic
Level 2: Tcore <= Cp < Tmod
Level 3: Cp < Tcore

<p align="center">
  <img src="docs/images/result/fig14-hierarchical-pressure-state-map.png"
       alt="Hierarchical pressure-state map"
       width="100%">
</p>

Figure 4. Representative synchronized multi-tap hierarchical pressure-state map. The hierarchy preserves pressure-state intensity while retaining the temporal and spatial organization of the pressure-tap array.

Robustness and sensitivity analyses

The validation suite addresses different sources of methodological uncertainty. These tests are complementary and should not be interpreted as interchangeable.

5. Histogram bin-width sensitivity

The sensitivity of the PDF-derived candidate thresholds to histogram resolution is evaluated for representative unimodal, bimodal-separated, and bimodal-overlapped pressure distributions.

<p align="center">
  <img src="docs/images/validation/Appendix A Sensitivity of AT thresholds to bin width.jpg"
       alt="Histogram bin-width sensitivity"
       width="100%">
</p>

The analysis evaluates whether the principal PDF-derived boundaries remain stable under reasonable changes in histogram discretization.

6. SR/VR modality-decision sensitivity

The peak-separation ratio, (SR), and valley ratio, (VR), are used to distinguish separated and overlapped bimodal PDFs. Their influence is examined over a range of decision criteria.

<p align="center">
  <img src="docs/images/validation/Appendix A Sensitivity of PDF modality decision to SRVR criteria.jpg"
       alt="SR and VR modality-decision sensitivity"
       width="100%">
</p>

This validation evaluates the robustness of PDF morphology classification to perturbations of the (SR) and (VR) criteria.

7. Bootstrap repeatability

Bootstrap resampling is used to quantify the repeatability of the PDF-derived candidate thresholds. Threshold variation is normalized by the interquartile range of the corresponding pressure distribution.

<p align="center">
  <img src="docs/images/validation/Appendix A Bootstrap repeatability of AT-derived thresholds.jpg"
       alt="Bootstrap repeatability of adaptive thresholds"
       width="100%">
</p>

The bootstrap analysis quantifies finite-sample statistical variability. It is distinct from the record-length convergence analysis below because bootstrap resampling does not preserve the contiguous temporal organization of the intermittent pressure signal.

8. Full-dataset record-length convergence

A full-dataset convergence analysis was performed to assess whether the 120-s acquisition duration is sufficient for stable estimation of the pressure-coefficient PDFs used by AT-BM.

The analysis includes:

49 Reynolds-number conditions;

12 AT-BM pressure taps;

588 tap-Reynolds-number combinations;

(F_s = 1000) Hz;

120 s and 120,000 samples per record.

For each tap and Reynolds-number condition, PDFs were recomputed using contiguous records of 10, 20, 30, 60, 90, and 120 s. Contiguous windows were retained so that intermittent-state persistence and temporal organization were not destroyed by random shuffling.

The PDF settings were identical to those used in the manuscript:

histogram bin width: (\Delta C_p = 0.025);

three-bin moving-average smoothing.

Convergence was quantified using:

Total Variation Distance (TVD) relative to the complete 120-s PDF;

Jensen-Shannon Divergence (JSD) relative to the complete 120-s PDF;

dominant PDF peak displacement.

An independent comparison between the first and second 60-s portions of each record was also included.

<p align="center">
  <img src="figures/R1_global_record_length_convergence.png"
       alt="Full-dataset record-length convergence"
       width="90%">
</p>

Record-length convergence. TVD and JSD decrease systematically with increasing observation duration across the complete set of 588 tap-Reynolds-number combinations, while the dominant PDF peak location remains comparatively stable.

<p align="center">
  <img src="figures/R1_60s_metric_distributions.png"
       alt="Distribution of 60-s convergence metrics"
       width="90%">
</p>

Distribution of 60-s convergence metrics. Most tap-Reynolds-number combinations exhibit small differences relative to the complete 120-s PDF, while a limited number of strongly intermittent transitional cases form the upper tail of the distributions.

Representative worst-converged cases indicate that shorter records primarily change the relative probability mass associated with coexisting pressure states rather than strongly shifting the locations of the principal PDF modes. The 120-s acquisition therefore provides a conservative basis for estimating intermittent-state occupancy in the critical-transition regime.

The corresponding full-dataset analysis script is retained in validation/.

The original synchronized experimental pressure records are not distributed through this repository.

Scientific scope

AT-BM contains two explicitly separated stages:

Adaptive Thresholding (AT)
Local pressure PDFs are classified as unimodal, bimodal-separated, or bimodal-overlapped. Chord-distance knee points or an inter-peak valley provide PDF-derived candidate boundaries.

Binary Mapping (BM)
Tap-specific operational thresholds are obtained from recurrent candidate clusters pooled over the examined Reynolds numbers. Once selected, the thresholds are held fixed across Reynolds number. Threshold crossings are converted into synchronized binary vectors and summarized by active-tap count, height-wise occupancy, pattern probability, and side-asymmetry index.

The results are pressure-based operational states. They are not direct reconstructions of instantaneous separation or reattachment topology.

Latest implemented logic

12 taps at theta = +/-90 deg and +/-110 deg

three heights: z/D = 1, 2, 3.5

Fs = 1000 Hz, 120 s, 120000 samples per tap

candidate thresholds: TL, TR, and Tv

morphology criteria: SR and VR

tap-specific Tbasic,j, Tmod,j, and Tcore,j

thresholds pooled across Reynolds number and then fixed

representative tap values: Tbasic = -0.975, Tmod = -1.975, Tcore = -2.475

decimal pattern code used only as an identifier

SAI defined from complete-record signed side occupancy

Repository structure

src/+atbm/       reusable core functions
scripts/         end-to-end analysis and figure generation
validation/      sensitivity and robustness checks
tests/           MATLAB unit tests
examples/        executable synthetic demonstration
config/          default parameters and reviewed threshold tables
docs/            method, equations, data format, and limitations
data/raw/        raw experimental data; excluded from Git
data/processed/  processed experimental data; excluded from Git
results/         generated numerical tables; normally excluded from Git
figures/         selected validation and manuscript figures

Quick start

setup;
run("examples/demo_ATBM.m");

Run tests:

setup;
results = runtests("tests");
table(results)

For the experimental workflow, load the verified dataset and configuration according to the data format documented in this repository.

Validation

Run the standard validation suite with:

run("validation/run_all_validation.m");

The repository includes validation of:

synthetic PDF morphologies;

histogram bin-width sensitivity;

PDF smoothing sensitivity;

SR/VR modality-decision sensitivity;

finite-sample/bootstrap repeatability;

record-length convergence;

threshold perturbation;

pattern-encoding invariants;

SAI invariants;

tap-order and side-label checks.

The full-dataset 120-s record-length analysis is retained separately in validation/ because it requires the unpublished experimental dataset.

Reproducibility rules

Do not independently retune the final operational threshold at every Reynolds number.

Do not silently replace failed candidate extractions.

Store the exact tap order with every dataset.

Distinguish PDF-derived candidate thresholds from operational thresholds.

Export numerical tables in addition to figures.

Treat oil-film comparison as qualitative consistency only.

Do not interpret a near-zero SAI as proof of instantaneous bilateral symmetry.

Do not interpret binary or hierarchical pressure states as direct instantaneous separation topology.

MATLAB requirements

Core AT extraction and figure reproduction require MATLAB and Signal Processing Toolbox (findpeaks).

Some measured-data validation routines additionally use Statistics and Machine Learning Toolbox functions, including randsample, iqr, boxchart, fitgmdist, and ksdensity.

Data availability and limitations

The original synchronized experimental pressure dataset is not publicly distributed.

Raw .lvm files and standardized processed experimental datasets remain excluded from Git.

Selected validation and manuscript figures are committed to document the analyses supporting the manuscript.

The pressure-channel calibration values are retained from the original supplied MATLAB implementation.

The final histogram/SR/VR AT logic is kept separate from the earlier GMM/BIC/Otsu comparison branch.

AT-BM pressure states are operational pressure descriptors and should not be interpreted as direct reconstructions of instantaneous separation or reattachment topology.

License

No license is assigned in this draft. Add one only after author approval.
