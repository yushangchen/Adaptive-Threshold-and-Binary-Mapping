# Data format

## Pressure array

```text
Cp: nSamples x nTaps x nRe
```

Present experiment:

```text
nSamples = 120000
nTaps = 12
Fs = 1000 Hz
record length = 120 s
```

## Tap metadata

Required columns:

| Column | Meaning |
|---|---|
| TapID | stable string identifier |
| zD | height ratio |
| thetaDeg | signed azimuth |
| Side | +1 or -1 |
| HeightGroup | lower/middle/upper integer group |
| BitIndex | exact binary-vector order |

The recommended height grouping is:

```text
b1-b4: z/D = 1
b5-b8: z/D = 2
b9-b12: z/D = 3.5
```

The azimuthal order must be verified against the actual acquisition-channel
table. It is never inferred from column position.

## Operational-threshold table

Required columns:

```text
TapID, zD, thetaDeg, Side, HeightGroup, BitIndex,
Tbasic, Tmod, Tcore
```
