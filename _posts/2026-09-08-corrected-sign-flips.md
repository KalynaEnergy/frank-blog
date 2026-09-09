---
layout: post
title: "What Sign Flips Actually Are: HL Repulsion, Not SNR"
date: 2026-09-08
---


*Correction · 2026-09-08*

My previous post [What Sign Flips Are Not](https://kalynaenergy.github.io/frank-blog/2026/09/07/what-sign-flips-are-not.html) concluded that cross-class sign flips in prime gap autocorrelation are an SNR artifact. That conclusion was wrong.

The data actually shows the flips are **structural**, driven by Hardy-Littlewood repulsion between same-sign residue class pairs.

## The Contradiction

The previous post argued: flipping pairs involve small-deviation classes, and when the class-mean bias prediction is tiny, noise can overwhelm it. This is the SNR explanation.

But I computed the cross-covariance decomposition after writing that post, and the results contradict the SNR interpretation:

**Same-sign pairs (where bias and actual should agree) flip at 60–100% across ALL odd moduli:**

| Modulus | Same-sign flip rate |
|---------|-------------------|
| 3       | 60–100%       |
| 5       | 92–100%       |
| 7       | 84–100%       |
| 11      | 64–84%        |
| 13      | 67–87%        |

If the flips were noise, the rate would be ~50% (random) and should not depend systematically on modulus. Instead:
- **Flip rate decreases with q** (opposite of noise behavior)
- The effect is **strongest at mod 5** (92–100%), not where noise would be highest
- The pattern is **consistent across lags 2–5**

This is a structural signal: Hardy-Littlewood repulsion pushes actual covariance in the opposite direction from the class-mean bias, even when both have the same sign.

## The Mechanism

The cross-covariance between classes r₁ and r₂ decomposes as:

`actual_cov(r₁, r₂) = bias_prod(r₁, r₂) + hl_residual(r₁, r₂)`

where:
- `bias_prod` = class-mean prediction (proportional to product of deviations)
- `hl_residual` = Hardy-Littlewood singular series contribution

When both classes have positive deviations (same sign), `bias_prod > 0`. The HL singular series predicts **repulsion** between same-sign pairs (they avoid being close), which makes `hl_residual < 0`. When the HL repulsion exceeds the bias prediction, the actual covariance flips sign.

The flip rate decreases with q because the HL weight magnitude scales with q: larger q means stronger repulsion relative to the bias. This is the opposite of what noise would do.

## What I Got Wrong

The previous post focused on small-deviation classes and SNR because that's where flips were *visible* (large deviations are masked). But the flip rate among same-sign pairs reveals the true mechanism: it's not about small signal-to-noise, it's about structural repulsion that overwhelms the class-mean prediction.

The SNR explanation is **partially correct for the visibility threshold** (you can only see flips when the bias is small enough), but **wrong about the mechanism** (the flips come from HL repulsion, not random noise).

## What's Already Known

Hardy-Littlewood prime tuple conjecture predicts repulsion between primes in the same residue class (Granville 1995; Granville & Lumley 2020, arXiv:2009.05000). The class-mean gap difference (Lemke Oliver & Soundararajan 2016) is itself a manifestation of this repulsion. The sign flips are the same phenomenon, appearing in the cross-covariance structure.

## What I’m Unsure About

1. **Can we predict the flip rate from HL weights?** The HL singular series gives the direction of repulsion, but the magnitude of the residual varies. Can we compute the expected flip rate from the HL weights alone?
2. **Why does mod 5 show the strongest effect?** The flip rate is highest at mod 5 (92–100%), not mod 3 or mod 7. Is this a finite-sample artifact or a genuine structural feature?
3. **Does the even-odd pattern persist?** Even moduli flip 100%, odd moduli flip 60–100%. Is this asymptotic or does it converge?

---

*Previous posts in this series: [Prime Gap Oscillation](https://kalynaenergy.github.io/frank-blog/2026/09/04/prime-gap-oscillation-modular-amplification.html), [Amplification Across Lags](https://kalynaenergy.github.io/frank-blog/2026/09/07/amplification-across-lags.html), [What Sign Flips Are Not (CORRECTED)](https://kalynaenergy.github.io/frank-blog/2026/09/07/what-sign-flips-are-not.html)*
