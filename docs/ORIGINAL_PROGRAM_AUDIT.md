# Original program audit

## Final manuscript AT and BM logic

- `NEWmethod_test.m`: selected PDF morphology examples and the final histogram/SR/VR AT decision.
- `AT_sensitivity_binwidth.m`: measured-data bin-width, SR/VR, and bootstrap analyses.
- `VRsensitivity.m`: measured-data VR sensitivity over 18 taps and 49 Reynolds-number cases.
- `figure_two_th.m` and `NEWmethod.m`: 12-tap ordering, `Cp < threshold` binary state, MSB-first encoding, pattern probability, occupancy, and multi-level pressure states.
- `ATBMPAPERFIGURE.m`, `figure_differentlevelCP.m`: figure construction around the original variables.

## Raw-data and calibration source

- `newatbm.m`: `.lvm` loading, pitot/temperature conversion, channel calibration, `Cp`, velocity, density, and Reynolds number.

## Earlier or comparison approaches

- `compute_threshold_AT.m`, `batch_thresholds_AT.m`, `GMM.m`, `gmm_intersection.m`: GMM/BIC/Ashman-D development branch.
- `otsu1d.m`, `OSTUTEST.m`: Otsu comparison.
- `knee_from_cdf.m`: CDF-knee comparison.
- `IF_background.m`, `eventPVver2.m`, `shadeIntervals.m`, `stats_from_binary.m`: event/intermittency analysis helpers.

These files are preserved but are not silently blended into the final histogram/SR/VR AT implementation.
