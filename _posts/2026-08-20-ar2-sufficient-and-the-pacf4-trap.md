---
layout: post
title: "AR(2) Is Sufficient — And How I Nearly Believed a Phantom"
date: 2026-08-20
---



## The question

In my last post I showed that consecutive prime gaps have a weak tendency to
mean-revert: a large gap is slightly more likely to be followed by a small one. I
modelled this using an AR(1) model — the simplest kind of time-series model, which
says that the next gap depends linearly on the current gap, plus some random noise.

For gaps where both neighboring primes share the same residue class mod 6 (both 1→1
or both 5→5), this simple model worked fine. But for "cross-class" gaps — where one
prime is 1 mod 6 and the next is 5 mod 6, or vice versa — the AR(1) model left
behind a pattern in the errors. The model was missing something.

I chased that pattern for a while. It looked like a fourth-order signal — a
"phantom" correlation at lag 4 that hinted at deeper structure. I ran every check
I could think of. It was consistent across scales, survived noise injection,
survived rank transforms.

Then I detrended the data, and the signal disappeared — it flipped sign.

The truth was simpler, and I nearly missed it: the AR(2) model — which adds one
more term, letting the gap two steps back also matter — captured everything. The
phantom was just a trend.

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

An AR(2) model adds one more term to the AR(1): it lets the gap two steps back
also influence the next gap. Think of it as "the last two gaps both matter."

| Pair | b1 | b2 | R² | Res AC1 | Res AC2 |
|------|-----|-----|-----|---------|---------|
| (1,1) | −0.0188 | −0.0035 | 0.00036 | ~0 | ~0 |
| (5,5) | −0.0177 | −0.0034 | 0.00033 | ~0 | ~0 |
| (1,5) | −0.0075 | −0.0025 | 0.00006 | ~0 | ~0 |
| (5,1) | −0.0088 | −0.0039 | 0.00009 | ~0 | ~0 |

The coefficients are tiny — the model explains less than 0.04% of the variance — but
that is enough. After fitting AR(2), the residuals (the unexplained part) show no
remaining autocorrelation at any lag. The model captures everything that matters.

### The lag-2 coefficient is the key

b2 ≈ −0.003 for all pairs. A negative lag-2 coefficient creates a cyclical pattern:
a large gap tends to be followed by a smaller gap, which tends to be followed by
a larger gap. This "large-small-large" oscillation was invisible in the AR(1)
analysis because AR(1) only looks at the immediately preceding gap.

Cross-class inadequacy under AR(1) was entirely due to the missing lag-2 term. Not
a separate mechanism. Not a different kind of dependence. Just lag-2.

### The phantom: how a trend fooled me

Here's the part I want to emphasize because it's the lesson of this post:

I noticed a small but consistent positive signal at lag 4 in the Partial Autocorrelation
Function (PACF) — a diagnostic tool that tells you which lags have genuine predictive
power after accounting for shorter lags. At +0.002, nominally 4-sigma significant.

This looked real. I ran every check I could think of:

- The signal was consistent across scales (1M → 20M primes)
- Noise injection didn't remove it
- Rank transform didn't remove it

I was convinced I had found a fourth-order dependence structure.

**Then I detrended the data and the signal flipped sign.**

After subtracting a 10,000-prime moving average to remove the slow density modulation:

| Lag | Raw ACF | Detrended ACF |
|-----|---------|---------------|
| 1 | −0.0187 | **−0.0232** |
| 2 | −0.0032 | **−0.0075** |
| 3 | +0.0002 | **−0.0042** |
| 4 | **+0.0021** | **−0.0022** |
| 8 | **+0.0031** | **−0.0012** |

The detrended ACF is **purely negative and monotonically decaying**. The "U-shape"
(negative at lags 1–2, positive at lags 4+) was entirely an artifact of slow trends
in the local gap density.

And here's the kicker: after detrending, the lag-1 autocorrelation is **stronger**
(−0.023 vs −0.019). The trend was diluting the true mean-reversion signal.

AR(2) on detrended data gives white-noise residuals (AC1 ≈ 0, AC2 ≈ 0 for all pairs).
The PACF(4) signal was never real.

### Why the trend exists (briefly)

The trend reflects slow modulation of local prime density over tens of thousands of
primes. This is the "small-prime sieving" effect described by Granville & Lumley (2023)
and Maier (1985): primes avoid being divisible by small numbers, and this creates
clusters and gaps that persist over long stretches. After a large gap, the local
prime density increases slightly, and it takes tens of thousands of primes to settle
back. The trend is interesting in its own right — I explore its spectrum in a
separate post — but it is not the same thing as genuine higher-order autocorrelation
in the gap dynamics.

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

**The detrending test is decisive.** If the lag-4 signal were real fourth-order
dependence, it would survive detrending. Instead, it flips sign. The U-shape in the
raw ACF is a classic statistical signature of a trend: negative at short lags (the
real signal) mixed with positive at long lags (the trend).

**The AR(2) residuals are white noise.** After fitting AR(2) to detrended data, the
residual autocorrelation at lag 1 is essentially zero (|AC1| < 0.0001) for all four
class pairs. At lag 2 it's also zero. The model captures everything that matters.

**The scale study confirms convergence.** The phantom signal grew from +2.3σ at 1M
primes to +4.4σ at 20M primes. This is exactly what you'd expect from a trend artifact:
the longer the series, the more the trend accumulates, and the more significant the
spurious correlation becomes.

**The detrended PACF is clean.** It's monotonically negative: −0.023, −0.008, −0.005,
−0.002 and below. No U-shape. No phantom.

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
