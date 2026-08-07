# Rebuild verification status

## Completed in the rebuild environment

- All 19 supplied original MATLAB files were copied byte-for-byte to
  `legacy/original_matlab/`; SHA-256 equality was checked against the uploaded
  source files.
- The reusable source tree contains no laboratory `Diskstation` path outside
  the preserved legacy programs.
- Raw data and processed MAT files are excluded from Git.
- The GitHub Actions workflow is limited to software unit and smoke tests.
- Existing manuscript images are not replaced by the application script.

## Requires the author's MATLAB computer

The rebuild environment does not contain MATLAB or the unpublished pressure
dataset. Therefore, the following items are not yet runtime-verified:

- parsing all original `.lvm` files;
- exact numerical equality of calibrated `Cp` and `Re` arrays;
- execution of the full measured-data bin-width, SR/VR, and bootstrap scripts;
- exact reproduction of the existing manuscript figure pixels;
- a green GitHub Actions run.

These checks must be completed before the rebuilt repository is committed as a
formal release.
