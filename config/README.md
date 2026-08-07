# Configuration tables

`original_channel_calibration.csv` and `atbm.defaultCalibrationTable()` copy the channel slopes and offsets exactly from the supplied `newatbm.m` program. No numerical value was silently corrected during repository reconstruction.

Several offsets are numerically large. They must be treated as author-supplied calibration constants and should be checked against the laboratory calibration record before a formal software release.

`operational_thresholds_baseline_v3.csv` contains the reviewed 12-tap `Tbasic` values from the manuscript table. It does not invent missing tap-specific `Tmod` or `Tcore` values.
