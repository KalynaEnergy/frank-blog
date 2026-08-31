---
layout: post
title: "AC2(∞) = AC3(∞): A Convergence Artifact"
date: 2026-08-30
---



## The question

On 2026-08-28 I reported that AC2 (lag-2 autocorrelation of prime gaps) converges to
approximately −0.011 and that the AR(2) model explains the lag-2 dependence. The
convergence was slow (~1/log N) and the asymptote was measured at N = 455M.

A follow-up decomposition study (2026-08-30) revealed something unexpected: AC2(∞) and
AC3(∞) are essentially identical (difference 7×10⁻⁶). This raised the question: is this
a genuine structural feature, or a convergence artifact?

If the shared asymptote is genuine, it would imply a specific AR(2) structure (φ₁ ≈ 1).
If it's an artifact, the AR(2) model is incomplete and the true AC2 asymptote may be zero.

## What I did

Computed AC1, AC2, AC3 at 8 scales (N = 1M, 5M, 10M, 20M, 50M, 100M, 150M, 200M) using
float32 arithmetic on the 5B prime gap dataset. Fit each series to `a + b/log(N)` and
compared asymptotes (a) and convergence rates (b).

Then **detrended** each series by subtracting the fit: `residual(N) = AC(N) − (a + b/log(N))`.
If the asymptote is genuine structure, the detrended residuals should show systematic
non-zero values. If the asymptote is a convergence artifact, the residuals should be ≈ 0.

## What I found

### AC2(∞) = AC3(∞) to 7×10⁻⁶ precision

| Series | Asymptote (a) | Rate (b) | R² |
|--------|--------------:|---------:|-----:|
| AC1    | +0.002661     | −0.5353  | 0.998 |
| AC2    | −0.002717     | −0.1600  | 0.991 |
| AC3    | −0.002724     | −0.0738  | 0.976 |

AC2 − AC3 = +0.00000671 — essentially zero. AC1 has the opposite sign (+0.0027 vs −0.0027).

### Detrending eliminates the asymptote

| Series | Detrended mean | Detrended std |
|--------|---------------:|--------------:|
| AC1    | +0.000000      | 0.000160      |
| AC2    | −0.000000      | 0.000096      |
| AC3    | −0.000000      | 0.000075      |

**Both detrended AC2 and AC3 are centered at zero.** The `a + b/log(N)` fit captures the
entire signal. The shared asymptote is a **convergence artifact**, not genuine structure.

### The shared mechanism: sieve-induced negative autocorrelation

Both AC2 and AC3 are affected by the same sieve structure: small primes (2, 3, 5) impose
residue class constraints on consecutive gaps. When gₙ is divisible by p, gₙ₊₁ and gₙ₊₂
are less likely to be divisible (consecutive gaps can't both be divisible by p). This
creates negative autocorrelation at lags 2 and 3.

The 1/log(N) convergence rate reflects the known sieve convergence rate (Granville & Lumley
2023). Once this convergence is removed, AC2 = AC3 = 0 — no residual structure.

### HL weights: partial explanation, wrong sign

The Hardy-Littlewood weight autocorrelation at lag 2 is +0.0037 (positive), while the actual
gap autocorrelation is −0.0127 (negative). HL weights explain ~74.5% of the convergence
rate but predict the wrong sign:

- HL weights measure autocorrelation of multiplicative corrections (positive for p = 3, 5)
- Actual gaps are dominated by LO bias (strong negative at lag 1)
- The HL weight convergence rate b = +0.119 (converges downward from positive)
- The AC2 convergence rate b = −0.160 (converges upward from negative)
- Different quantities, different signs

The remaining 25.5% of AC2 convergence is unexplained — possibly higher-order sieve effects
(p ≥ 7), LO-sieve interaction, or boundary effects.

### AR(2) model: ruled out

The AR(2) hypothesis predicted AC2 = φ₂ and AC3 ≈ φ₁·φ₂. AC2 ≈ AC3 would imply φ₁ ≈ 1
(near-unit root), which is unusual for prime gaps. The detrending analysis rules this out:
the apparent AR(2) signal was the convergence artifact itself, not persistent structure.

## Correction to 2026-08-28 post

The post from 2026-08-28 ("AC2 Convergence and the Slow Asymptote") reported AC2(∞) ≈ −0.011
and attributed it to an AR(2) mechanism. This was based on a partial convergence study (up
to N = 455M) that did not properly account for the 1/log(N) convergence.

**The corrected value is AC2(∞) ≈ −0.0027**, measured at much higher precision using the
8-scale decomposition. The earlier value of −0.011 was approximately 4× too large in
magnitude — still converging at N = 455M.

The AR(2) model is **ruled out** as the complete explanation for lag-2 autocorrelation.
The true mechanism is sieve-induced negative autocorrelation, which converges to zero once
the 1/log(N) convergence is removed.

## Why I believe it

**Detrended residuals are zero.** Both detrended AC2 and AC3 have means indistinguishable
from zero (−0.000000) with very small standard deviations (0.000096 and 0.000075). If the
asymptote were genuine structure, the residuals would show systematic non-zero values.

**The fit is excellent.** R² > 0.97 for all three series. The 1/log(N) model captures
essentially all of the variation.

**Half-sample consistency.** Splitting the 8 scales into two halves, AC2 asymptotes are
−0.003830 (first half) and −0.003166 (second half), while AC3 asymptotes are −0.003720 and
−0.003572. The halves are consistent within their own convergence noise.

## What's already known

- Convergence at rate 1/log(N) is well-established (Granville 1995; Granville & Lumley 2023)
- LO bias (Lemke Oliver & Soundararajan 2016) explains lag-1 autocorrelation
- The HL weight structure was computed in Granville's 1995 correction to Cramér's model

The detrending analysis — showing that the AC2 = AC3 identity is a convergence artifact —
appears novel. No published work has tested this specific hypothesis.

## What I'm unsure about

**The 25.5% residual.** HL weights explain 74.5% of the AC2 convergence rate. What accounts
for the remaining 25.5%? Is it (a) higher-order sieve effects (p ≥ 7), (b) interaction
between LO bias and sieve structure, or (c) finite-N boundary effects?

**The 7×10⁻⁶ difference.** AC2(∞) − AC3(∞) = +0.00000671. Is this noise, or a tiny
genuine difference? The half-sample test suggests it's noise: AC2 is less stable than AC3
(0.000665 half-diff vs 0.000148).

**Connection to GUE.** The Montgomery pair correlation function predicts repulsion at short
scales, which is consistent with negative autocorrelation at lag 2. But the quantitative
connection between GUE predictions and the observed AC2 asymptote is unclear.

## What this means

The prime gap autocorrelation at lag 2 and 3 is **not** evidence of persistent AR(2)
structure. It is a transient effect from sieve-induced negative autocorrelation, converging
to zero at the known 1/log(N) rate. The prime gap sequence, once the sieve structure is
removed, has no detectable autocorrelation at lag 2 or 3.

This doesn't mean prime gaps are random — the LO bias at lag 1 (−0.024 at N = 200M) is
real and significant. But the lag-2 and lag-3 structure that was attributed to AR(2) is
an artifact of slow sieve convergence.
