# Method and equations

## PDF morphology

For each tap and Reynolds number, estimate the normalized local pressure PDF.

### Unimodal PDF

Two chord-distance knee candidates are obtained around the dominant peak:

```text
TL: low-Cp candidate
TR: high-Cp candidate
```

### Bimodal-separated PDF

The PDF is split into two local peak-valley segments. One chord-distance
candidate is retained from each segment.

### Bimodal-overlapped PDF

When two peaks are not sufficiently separated, the inter-peak valley is used:

```text
Tv: conservative single candidate
```

## Separation criteria

```text
SR = |Cp,2 - Cp,1| / mean(FWHM1,FWHM2)
VR = f(Cp,v) / min[f(Cp,1),f(Cp,2)]
```

Default decision:

```text
SR >= 1.5 and VR <= 0.8  -> bimodal-separated
otherwise                -> bimodal-overlapped
```

These are configurable admissibility criteria, not universal physical
constants.

## Operational thresholds

For each tap, candidate values are pooled over Reynolds number. Candidates
associated with the upper envelope of the baseline PDF are excluded.
Transition-relevant candidate groups are summarized by their median values:

```text
Tbasic,j > Tmod,j > Tcore,j
```

The resulting operational thresholds are fixed across Reynolds number.

## Binary mapping

```text
b_j(t) = 1  when Cp,j(t) < Tbasic,j
b_j(t) = 0  otherwise
```

The synchronized vector is:

```text
B(t) = [b1(t),...,b12(t)]
```

## Decimal pattern identifier

```text
PatternID(t) = sum_j b_j(t) 2^(12-j)
```

The decimal code is used only for compact counting.

## Mean active-tap count

```text
Nactive(t) = sum_j b_j(t)
meanNactive = mean_t[Nactive(t)]
```

## Height-wise occupancy

```text
Oh = sum_t sum_(j in height h) b_j(t) / (Nt Nh)
```

## Pattern probability

```text
P(q) = count[PatternID(t)=q] / Nt
```

## Side-asymmetry index

At each sample, let `N+(t)` and `N-(t)` be the numbers of active taps on the
positive- and negative-theta sides. Define

```text
s(t) = [N+(t)-N-(t)] / [N+(t)+N-(t)]
```

with `s(t)=0` when no tap is active. The primary SAI follows the manuscript
definition:

```text
SAI = mean_t[s(t)]
```

This is a time-averaged signed side-bias measure. Its sign indicates the
record-averaged preferred side. A value near zero may result from bilateral
balance, inactive samples, or alternating positive- and negative-side
preference; it does not prove instantaneous symmetry.

For comparison, `atbm.computeMetrics` also returns an aggregate occupancy
diagnostic:

```text
A+ = sum_t N+(t)
A- = sum_t N-(t)
SAIAggregateOccupancy = (A+ - A-) / (A+ + A-)
```

with a value of zero when the denominator is zero. In general, this aggregate
quantity is not equal to the manuscript SAI and is not used as its replacement.

## Hierarchical pressure states

```text
Level 0: Cp >= Tbasic
Level 1: Tmod <= Cp < Tbasic
Level 2: Tcore <= Cp < Tmod
Level 3: Cp < Tcore
```

The level labels describe instantaneous pressure intensity. Temporal
persistence must be evaluated from consecutive samples or dwell intervals, not
from threshold depth alone.
