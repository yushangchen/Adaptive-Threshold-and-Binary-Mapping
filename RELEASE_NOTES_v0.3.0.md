# AT-BM repository v0.3.0 — third revision

Release date: 2026-08-07

## Added

- executable SR/VR criterion-sensitivity validation;
- executable 200-realization m-out-of-n bootstrap repeatability validation;
- reviewed 12-tap baseline-reference threshold table;
- representative hierarchical-threshold table;
- threshold-table documentation;
- an SAI unit test that distinguishes the manuscript time-averaged definition
  from the aggregate complete-record occupancy diagnostic.

## Changed

- validation runner now executes the two new validation scripts;
- README validation claims now match the scripts that are actually present;
- `atbm.computeMetrics` and the SAI documentation now follow the manuscript
  time-averaged normalized definition;
- aggregate complete-record side occupancy remains available as a separate
  diagnostic;
- bootstrap terminology now specifies sampling with replacement;
- repository version updated from 0.2.0 to 0.3.0.

## Scientific boundaries

- bootstrap repeatability is a numerical extraction check, not a stationarity
  test;
- hierarchy values shown for one representative tap are not universal;
- AT-BM states remain pressure-based operational descriptions.

## Release actions still requiring repository-owner access

1. copy this overlay into the repository root or publish it to a review branch;
2. run MATLAB validation and confirm all tests pass;
3. merge the reviewed branch;
4. create GitHub release `v0.3.0`;
5. archive the release in Zenodo if a DOI is required.
