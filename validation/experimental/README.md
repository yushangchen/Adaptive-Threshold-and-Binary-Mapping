# Experimental validation

The authoritative measured-data validation entry points are:

- `run_original_AT_sensitivity.m`: restores the original variables and executes the supplied `AT_sensitivity_binwidth.m` unchanged;
- `run_original_VR_sensitivity.m`: restores the original variables and executes the supplied `VRsensitivity.m` unchanged.

`validate_representative_sensitivity.m` and `validate_vr_all_taps.m` provide structured, reusable summaries for programmatic use. The original wrappers are preferred when exact preservation of the supplied figure-generation logic is required.
