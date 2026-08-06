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

Default operational decision:

```text
SR >= 1.5 and VR <= 0.8
```

These values are configurable criteria, not universal physical constants.

## Operational thresholds

For every tap, candidate values are pooled over Reynolds number. Candidates
associated with the upper envelope of the baseline PDF are excluded.
Transition-relevant candidates are grouped by boundary role. Median cluster
values define:

```text
Tbasic,j > Tmod,j > Tcore,j
```

These thresholds are then fixed for all Reynolds numbers.

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

It is used only for compact counting.

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

## Latest side-asymmetry index

Let:

```text
A+ = sum_t N+(t)
A- = sum_t N-(t)
```

Then:

```text
SAI = (A+ - A-) / (A+ + A-)
```

Set `SAI = 0` when the denominator is zero. A near-zero SAI can result from
alternating side preference or sparse activity and does not prove instantaneous
bilateral symmetry.

## Hierarchical pressure states

```text
Level 0: Cp >= Tbasic
Level 1: Tmod <= Cp < Tbasic
Level 2: Tcore <= Cp < Tmod
Level 3: Cp < Tcore
```
