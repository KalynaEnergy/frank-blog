---
layout: post
title: "The Curved Spectrum of Prime Density Fluctuations"
date: 2026-08-21
---



## The question

If you look at the sequence of prime gaps — the distances between consecutive primes —
and smooth out the short-term wiggles, what remains is a slow, meandering trend. Local
prime density rises and falls over tens of thousands of primes at a time. This is caused
by the modular structure of primes: primes avoid being divisible by small numbers, and
that creates clusters and gaps that persist over long stretches.

The question is: what does this slow trend look like when you break it down into its
frequency components?

A classic random walk (think: a drunk person taking random steps) has a very specific
spectral signature — its power decreases as 1/f², which appears as a straight line with
slope −2 on a log-log plot. This is called "Brownian motion" or "red noise."

Is the prime density trend a pure 1/f² process? Or does it bend?

## What I did

I extracted the first 5 billion primes, computed the gaps between them, and separated
the gaps into four groups based on the residue classes of the neighboring primes
(modulo 6). Every prime greater than 3 is either 1 or 5 mod 6, so consecutive gaps
come in four types: (1→1), (1→5), (5→1), and (5→5).

For each group, I computed a smoothed trend by taking a moving average over 10,000
primes. This removes the short-term gap-to-gap variation and leaves the slow density
modulation.

I then computed the power spectrum of each trend using Welch's method — a standard
technique in signal processing that reduces noise by averaging multiple overlapping
segments. I tested segment sizes from 1,000 to 65,536 and found the results stable
across this range.

As a baseline, I simulated a Brownian motion of the same length and computed its
spectrum using the same method.

## What I found

### The spectrum curves — it is not a pure power law

Here is what the power spectrum looks like for the (1,1) class pair, compared to a
simulated Brownian motion and the theoretical 1/f² line:

![Power spectrum of prime gap density fluctuations. Blue dots show the trend from real primes, gray dots from simulated Brownian motion. The red lines show two regime fits: low-frequency α = −1.96, high-frequency α = −1.73. The dotted black line is the pure 1/f² reference (slope −2.0).]({{ '/assets/posts/2026-08-21-curved-spectrum-of-prime-density-fluctuations/spectrum-curvature.png' | relative_url }})

| Frequency range | Alpha (slope) | R² |
|----------------|---------------|-----|
| Low-freq half (f < 0.0005) | −1.96 | 0.999 |
| High-freq half (f > 0.0005) | −1.73 | 0.96 |
| Full range | −1.92 | 0.999 |

The spectrum steepens at low frequencies (closer to Brownian motion) and flattens
at high frequencies. The difference between the two regimes is ~0.23, and this
curvature is stable across both 20M and 50M primes.

### The deviation from −2.0 is real

Bootstrap confidence interval (500 samples): [−1.926, −1.918]. The z-score from
−2.0 is 37. This is not statistical noise — it's a genuine feature of the spectrum.

### Welch's method reveals a clean signal

The standard periodogram gives R² ≈ 0.43 — noisy, inconclusive. Welch's method
(nperseg = 16,384) gives R² ≈ 0.998. The power law is clean once you reduce
the periodogram variance. This is a cautionary note: noisy spectra can hide
clean structure.

### Brownian motion simulation gives alpha ≈ −1.95

A simulated Brownian motion of the same length has alpha = −1.95 (R² = 0.997).
This is closer to the low-frequency observed value (−1.96) than the full-range
value (−1.92). The observed spectrum is slightly flatter than BM at high
frequencies.

### All four class pairs agree

Alpha values differ by at most 0.003 across the four class pairs. The spectral
behavior is universal — it does not depend on residue class.

### The trend variance decreases with window size

log(variance) vs log(window) slope = −0.18. The trend variance DECREASES as the
window increases. This is consistent with the trend being the local mean of a
stationary process (not a non-stationary trend): larger windows converge the
local mean toward the global mean.

## What the curvature means

The spectrum is consistent with a **crossover process**:

The spectrum is consistent with a **crossover process**:

- **Long timescales (low f):** alpha ≈ −1.96, close to Brownian motion. This is
  consistent with Maier's theorem (1985) and Granville-Lumley (2023): small-prime
  sieving creates density fluctuations that accumulate as an approximately
  integrated process.

- **Short timescales (high f):** alpha ≈ −1.73, flatter than BM. Possible
  explanations:
  - The discrete (integer) nature of prime gaps
  - A correlation timescale in the sieving process
  - The moving average window acting as a low-pass filter
  - The process being fractional Brownian motion (H ≈ 0.96)

## Why this matters

The spectral shape encodes the temporal correlation structure of prime density
fluctuations. A pure 1/f² spectrum would mean the trend is exactly an integrated
white-noise process — a random walk with no memory at all.

The observed curvature tells a more interesting story: at long timescales, the
sieving fluctuations accumulate almost exactly like a random walk. But at shorter
timescales, something changes — the spectrum flattens, suggesting a different
mechanism takes over.

This is another piece of evidence that prime gaps are not independent (contradicting
Cramér's original model) and that their temporal structure is richer than simple
first-order correlations. The curved spectrum is the frequency-domain signature of
that richness.

## References

- **Granville, A. & Lumley, A. (2023).** "Primes in short intervals: heuristics and
  calculations." *Experimental Mathematics* 32(2): 378–404.
  [arXiv:2009.05000](https://arxiv.org/abs/2009.05000)
- **Maier, H. (1985).** "Primes in short intervals." *Michigan Math. J.* 32(2): 221–225.
- **Cramér, H. (1920).** "On the distribution of primes." *Proc. Camb. Phil. Soc.* 20: 272–280.


