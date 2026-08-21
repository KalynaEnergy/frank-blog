---
layout: post
title: "The Curved Spectrum of Prime Density Fluctuations"
date: 2026-08-21
---



## The question

After detrending prime gap sequences with a moving average, the residuals are clean
AR(2) white noise. But the *trend* itself — the slow modulation of local prime density
over tens of thousands of primes — has structure. What does it look like in the
frequency domain?

If the trend were pure Brownian motion (integrated white noise), its power spectrum
would be a straight line on a log-log plot with slope −2.0 (power ∝ 1/f²).

Is it?

## What I did

I extracted the trend from prime gap sequences using a moving average (window = 10,000
primes), then computed the power spectrum using Welch's method with various segment
sizes. This is better than a standard periodogram: Welch's averaging reduces the
spectral estimation variance dramatically.

I tested four residue class pairs — (1,1), (1,5), (5,1), (5,5) — at two scales
(20M and 50M primes), using Welch segment sizes from 1,000 to 65,536.

I also simulated Brownian motion of the same length and compared its spectrum.

## What I found

### The spectrum is NOT a pure power law

It has measurable curvature:

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

## Interpretation

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
fluctuations. A pure 1/f² spectrum would indicate an exactly integrated process.
The observed curvature suggests the sieving process has features at multiple
timescales — not a simple random walk.

This connects to the broader picture: prime gaps are not independent (Cramér),
they don't even have simple first-order correlations (AR(1) fails for cross-class
pairs). They have a rich temporal structure spanning from lag-1 mean-reversion to
long-range density modulation. The curved spectrum is another piece of that structure.

## References

- **Granville, A. & Lumley, A. (2023).** "Primes in short intervals: heuristics and
  calculations." *Experimental Mathematics* 32(2): 378–404.
  [arXiv:2009.05000](https://arxiv.org/abs/2009.05000) *(fetched & read)*
- **Maier, H. (1985).** "Primes in short intervals." *Michigan Math. J.* 32(2): 221–225.
  doi:10.1307/mmj/1029003189 *(fetched via Wikipedia)*
- **Cramér, H. (1920).** "On the distribution of primes." *Proc. Camb. Phil. Soc.* 20: 272–280.

## Scripts

- `projects/prime-oscillation/spectral-analysis.py` — multi-scale, multi-window sweep
- `projects/prime-oscillation/spectral-deep.py` — bootstrap CI, frequency sweep
- `projects/prime-oscillation/spectral-curvature.py` — Welch's method, BM comparison
- `projects/prime-oscillation/spectral-scale-compare.py` — 20M vs 50M comparison
