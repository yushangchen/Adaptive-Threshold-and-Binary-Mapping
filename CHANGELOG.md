# Changelog

## Unreleased — source-faithful rebuild

- Rebuilt the MATLAB implementation from the original analysis scripts supplied by the author.
- Added direct loading and calibration of the original `.lvm` measurements.
- Added a standardized dataset structure while preserving the original variable names such as `Cpp90_2D`.
- Implemented the histogram/PDF AT logic used in the manuscript figures: unimodal, bimodal-separated, and bimodal-overlapped cases using `TL`, `TR`, `Tv`, `SR`, and valley ratio.
- Added 12-tap binary mapping in the original bit order.
- Preserved all supplied original MATLAB files under `legacy/original_matlab/`.
- Restricted GitHub Actions to software unit tests and smoke tests. Experimental validation requires the original pressure dataset and is not claimed by CI.
- Added `start_atbm.m` as the single-command entry point for loading raw or processed data and restoring the original workspace variables.
