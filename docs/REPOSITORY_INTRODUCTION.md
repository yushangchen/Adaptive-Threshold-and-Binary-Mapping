# Repository introduction

AT-BM was developed for intermittent, non-Gaussian, and frequently multimodal
surface-pressure signals measured during the critical transition of a finite
circular cylinder.

The framework first extracts local candidate boundaries from PDF geometry. It
then constructs tap-specific, Reynolds-number-independent operational
boundaries from recurrent candidate clusters. Synchronized threshold crossings
are assembled into multi-tap pressure-state vectors.

The method answers four principal questions:

1. How frequently does low-Cp activity occur?
2. How many taps are active simultaneously?
3. At which heights is the activity concentrated?
4. Does the complete record exhibit a persistent azimuthal-side bias?

The code therefore separates candidate extraction, operational selection,
mapping, statistics, validation, and figure generation. This prevents PDF
geometry and physical interpretation from being conflated into one opaque
classification procedure.
