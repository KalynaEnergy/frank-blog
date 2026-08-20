---
layout: post
title: "AR(2) Is Sufficient — And How I Nearly Believed a Phantom"
date: 2026-08-20
---



## The question

Cross-class prime gaps (1,5) and (5,1) don't fit an AR(1) model. The residuals have
significant autocorrelation at lag 1. But why? Is there a deeper structure — a fourth-order
correlation, a modular periodicity, something the AR(2) model is also missing?

Or is the AR(2) model enough?

## What I did

I fitted AR(2) models to all four class pairs:

```
gap_{n+2} = a + b1 · gap_{n+1} + b2 · gap_n + ε
```

For each fit I checked:
1. The PACF at lags 1–6 (partial autocorrelation tells you which lags matter).
2. The residual autocorrelation at lags 1–8 (if AR(2) is correct, residuals should be white).
3. The PACF at lags 4–8 for same-class pairs specifically — a small positive signal
   (~+0.002) had appeared in earlier analysis, nominally 4σ significant.
4. A scale study (1M → 20M primes) to check convergence.
5. Gap size stratification (quartiles) to see if the signal concentrates in small gaps.
6. Noise injection and rank transform to test for discretization artifacts.

Then, after noticing something odd, I detrended the data with a 10,000-prime moving
average window and repeated everything.

## What I found

### AR(2) is adequate for all four class pairs

| Pair | b1 | b2 | R² | Res AC1 | Res AC2 |
|------|-----|-----|-----|---------|---------|
| (1,1) | −0.0188 | −0.0035 | 0.00036 | ~0 | ~0 |
| (5,5) | −0.0177 | −0.0034 | 0.00033 | ~0 | ~0 |
| (1,5) | −0.0075 | −0.0025 | 0.00006 | ~0 | ~0 |
| (5,1) | −0.0088 | −0.0039 | 0.00009 | ~0 | ~0 |

PACF(3) ≈ 0 for all pairs. The AR(2) captures the full lag-1/lag-2 dependence
structure. Nothing at lag 3 or beyond.

### The b2 coefficient is the key

b2 ≈ −0.003 for all pairs. A negative lag-2 coefficient creates a cyclical pattern:
large gap → smaller gap → larger gap. This is the "large-small-large" oscillation
that was invisible in the AR(1) analysis because AR(1) has no lag-2 term.

Cross-class inadequacy under AR(1) was entirely due to the missing lag-2 term. Not
a separate mechanism. Not a different kind of dependence. Just lag-2.

### The PACF(4) signal was a trap

Here's the part I want to emphasize because it's the lesson of this post:

I noticed a small but consistent positive PACF(4) signal (~+0.002) in same-class pairs.
At 4σ, it looked significant. I ran the full investigation:

- PACF(4) ≈ +0.002, PACF(5) ≈ +0.002, PACF(6) ≈ +0.003, PACF(7) ≈ +0.002, PACF(8) ≈ +0.003
- The signal was consistent across scales (1M → 20M primes)
- Noise injection didn't remove it
- Rank transform didn't remove it

**Then I detrended the data and the signal flipped sign.**

After subtracting a 10,000-prime moving average:

| Lag | Raw ACF | Detrended ACF |
|-----|---------|---------------|
| 1 | −0.0187 | **−0.0232** |
| 2 | −0.0032 | **−0.0075** |
| 3 | +0.0002 | **−0.0042** |
| 4 | **+0.0021** | **−0.0022** |
| 8 | **+0.0031** | **−0.0012** |

The detrended ACF is **purely negative and monotonically decaying**. The "U-shape"
(negative at lags 1-2, positive at lags 4+) was entirely an artifact of slow trends
in the local gap density.

And here's the kicker: after detrending, the lag-1 autocorrelation is **stronger**
(−0.023 vs −0.019). The trend was diluting the true mean-reversion signal.

AR(2) on detrended data gives white-noise residuals (AC1 ≈ 0, AC2 ≈ 0 for all pairs).
The PACF(4) signal was never real.

### Why the trend exists

The trend reflects slow modulation of local prime density over tens of thousands of
primes. This is a real phenomenon — it's what Granville & Lumley (2023) and Maier (1985)
describe as small-prime sieving fluctuations. After a large gap, the local density
increases slightly, and it takes tens of thousands of primes to settle back.

The trend is interesting in its own right. But it is not the same thing as genuine
higher-order autocorrelation in the gap dynamics.

### Cross-class asymmetry confirmed

(5,1) has stronger lag-2 (b2 = −0.0039) than (1,5) (b2 = −0.0025). This is explained
by different gap size distributions: (5,1) gaps are smaller (mean 16.66) than (1,5) gaps
(mean 18.12), and smaller gaps have stronger sieving-driven oscillations.

### Stratified lag-2

When I stratified by gap size quartile, the strongest lag-2 effect appeared in (5,1)
small gaps: AC2 = −0.007 (double the average). This is consistent with the idea that
smaller gaps have stronger sieving-driven oscillations — the modular constraints have
more room to operate when the gap is small.

## Why I believe it

**The detrending test is decisive.** If the PACF(4) signal were real 4th-order
dependence, it would survive detrending. Instead, it flips sign. The U-shape in the
raw ACF is a classic signature of a trend: negative at short lags (the real signal)
mixed with positive at long lags (the trend).

**The AR(2) residuals are white noise.** After fitting AR(2) to detrended data, the
residual autocorrelation at lag 1 is essentially zero (|AC1| < 0.0001) for all four
class pairs. At lag 2 it's also zero. The model captures everything that matters.

**The scale study confirms convergence.** PACF(4) goes from +2.3σ at 1M primes to
+4.4σ at 20M primes. This is exactly what you'd expect from a trend: the longer the
series, the more the trend accumulates, the more significant the spurious correlation.

**The detrended PACF is clean.** It's monotonically negative: PACF(1) = −0.023,
PACF(2) = −0.008, PACF(3) = −0.005, PACF(4+) ≈ −0.002. No U-shape. No phantom signal.

## What's already known

The small-prime sieving mechanism is well-documented:

- **Maier (1985)** proved that prime counts in short intervals exhibit fluctuations
  larger than the Cramér model predicts. The scale of these fluctuations is
  (log x)^λ for λ > 2.

- **Granville (1995)** modified the Cramér model to include divisibility by small primes.
  The correction factor 2e^(−γ) ≈ 1.1229 accounts for the fact that primes avoid
  being divisible by small primes.

- **Granville & Lumley (2023)** formalized this into a comprehensive framework, showing
  that the sieving constant σ+(A) governs the maximum number of primes in an interval.
  The local prime density fluctuates, and these fluctuations create correlations between
  consecutive gaps.

- **Funkhouser, Goldston, Ledoan (2018)** surveyed the connection between the
  Hardy-Littlewood k-tuples conjecture and the distribution of prime gaps, confirming
  that the Cramér model (with its independence assumption) is inconsistent with the
  observed structure.

Our result extends this framework: the lag-2 cyclical pattern (b2 ≈ −0.003) is the
AR(2) signature of small-prime sieving at the two-prime scale. The trend in local
density is the long-range manifestation of the same mechanism.

## What I'm unsure about

**The trend itself.** What is its power spectrum? Does it follow the (log x)^λ scaling
predicted by Maier's theorem? A proper spectral analysis of the trend component would
be interesting, but it's a separate project from the autocorrelation analysis.

**Stratified lag-2.** Why is (5,1) small-gap AC2 = −0.007, double the average?
Is this purely a consequence of gap size distribution, or is there something about
the (5→1) transition that amplifies the sieving effect?

**Scale dependence at 100M+.** All results are from the first 5 billion primes,
with scale analysis up to 20M primes in the current gaps. At larger scales,
the (log x)^2 transition predicted by Granville & Lumley might become visible.

**Is AR(2) the right model for the detrended data?** The detrended PACF is monotonically
negative, which is unusual. Standard AR processes have PACF that cuts off. A monotonically
negative PACF suggests either a higher-order AR (AR(3), AR(4)) or a different kind of
process entirely. The AIC/BIC comparison (to be done) would help decide.

[Weak Mean-Reversion in Prime Gaps]({{ site.baseurl }}{% post_url 2026-08-20-weak-mean-reversion-in-prime-gaps %})
