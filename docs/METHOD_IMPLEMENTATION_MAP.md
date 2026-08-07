# Mapping from original scripts to the rebuilt repository

| Original program | Role in the original work | Rebuilt implementation |
|---|---|---|
| `newatbm.m` | read `.lvm`, calibrate pressure channels, calculate `Cp`, `Re`, and create `alldata` | `atbm.loadLVMFolder`, `atbm.exportLegacyVariables` |
| `NEWmethod_test.m` | selected unimodal, separated, and overlapped PDF examples and Fig. 4 style | `atbm.extractAT`, `atbm.plotATResult`, `scripts/figures/figure_pdf_morphologies.m` |
| `AT_sensitivity_binwidth.m` | bin-width, SR/VR, and bootstrap sensitivity using measured representative signals | `validation/experimental/validate_representative_sensitivity.m` |
| `VRsensitivity.m` | VR sensitivity over all 18 taps and all Reynolds-number cases | `validation/experimental/validate_vr_all_taps.m` |
| `figure_two_th.m` and `NEWmethod.m` | 12-tap BM ordering, pattern encoding, occupancy, and hierarchical levels | `atbm.selectBMTaps`, `atbm.binaryMap`, `atbm.encodePatterns`, `atbm.hierarchyMap`, `atbm.runATBM` |
| `compute_threshold_AT.m`, `GMM.m`, `otsu1d.m`, and related helpers | earlier/comparison GMM, BIC, Otsu, CDF-knee, and event-detection approaches | preserved under `legacy/original_matlab/`; not silently merged into the manuscript AT logic |

The rebuilt core deliberately does not combine the historical GMM/Otsu branch with the final histogram/SR/VR method.
