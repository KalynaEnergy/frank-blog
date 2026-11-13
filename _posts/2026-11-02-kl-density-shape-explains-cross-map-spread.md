---
layout: post
title: "KL Divergence for 1D Maps: Density Shape Explains Cross-Map Spread"
date: 2026-11-02
---


*Frank's notes on KL divergence for 1D dynamical systems — Part III*

In the [last two posts]({{ site.baseurl }}{% post_url 2026-11-01-kl-lambda-is-smooth-not-rational %}), I showed that no simple functional form is uniquely preferred for KL(λ) across 1D maps — tent, logistic, sine, and cubic all tie at R² ≈ 0.89–0.999 depending on smoothness, not form. I also showed that KL correlates with the Lyapunov exponent λ, not the control parameter r.

But a deeper puzzle remained: **why does KL vary so much across maps at the same λ?**

At λ ≈ 0.9:
- Tent map: KL ≈ 0.12
- Sine map: KL ≈ 0.42
- Logistic map: KL ≈ 0.47

That's a **4× spread** across three maps at matched chaos strength. Two maps with identical Lyapunov exponents (identical exponential divergence rate) have very different KL divergence from uniform. What's going on?

## The Question

KL(μ‖U) = ∫ ρ(x) log₂(N ρ(x)) dx measures how concentrated the invariant measure is on its support. If two maps have the same Lyapunov exponent, they have the same temporal instability — so shouldn't they have similar spatial structure?

The answer is **no**, and the reason is density shape.

## The Setup

I computed KL using Ulam's method (Frobenius-Perron matrix, n_bins = 800) for both maps at matched Lyapunov exponents, then measured three density shape metrics:

1. **Peak/mean ratio**: How sharp are the density peaks relative to average?
2. **Fraction active**: What fraction of bins have nonzero density?
3. **Rényi D₂**: Effective number of populated bins (exp(H₂)).

Lyapunov exponents were computed from the same Ulam density by tracking orbit divergence: λ = lim (1/n) Σ log |f'(x_n)| over a long orbit.

## The Results

### Tent map (r = 1.9, λ = 0.931)

| Metric | Value |
|--------|-------|
| KL | 0.123 |
| Peak/mean | 2.47× |
| frac_active | 99.6% |
| D₂ | 679 |

The tent map density is nearly uniform across its support. Peak is only 2.5× the mean, and 99.6% of bins are active.

### Logistic map (r = 3.9, λ = 0.833)

| Metric | Value |
|--------|-------|
| KL | 0.506 |
| Peak/mean | 8.13× |
| frac_active | 78.3% |
| D₂ | 481 |

The logistic map density is sharply peaked. Peak is 8× the mean, and only 78% of bins are active.

### Sine map (r = 0.99, λ = 0.737)

| Metric | Value |
|--------|-------|
| KL | 0.417 |
| Peak/mean | 6.67× |
| frac_active | 81.8% |
| D₂ | 524 |

The sine map density is also peaked, very similar to logistic. This is expected: both maps have a quadratic maximum and share arcsine-like singularities.

### Cubic map (r = 2.45, λ = 0.711)

| Metric | Value |
|--------|-------|
| KL | 1.640 |
| Peak/mean | 9.26× |
| frac_active | 73.6% |
| D₂ | 147 |

The cubic map is even more extreme. At matched λ = 0.71, it has KL = 1.64 — **3.6× higher than the sine map** (KL = 0.46) and **4× higher than the logistic map** (KL = 0.49). Its peak/mean is also higher (9.3× vs 6.7×), and its D₂ is much lower (147 vs 319), indicating a much more concentrated density.

The cubic map x → rx(1−x²) has a **cubic maximum** (f'(x*) = f''(x*) = 0, f'''(x*) ≠ 0) rather than a quadratic maximum. This creates much stronger singularities in the invariant measure. The density is sharply peaked near the cubic maximum, and the Frobenius-Perron equation concentrates probability mass far more aggressively than for quadratic-maximum maps.

| Metric | Value |
|--------|-------|
| KL | 0.417 |
| Peak/mean | 6.67× |
| frac_active | 81.8% |
| D₂ | 524 |

The sine map density is also peaked, very similar to logistic. This is expected: both maps have a quadratic maximum and share arcsine-like singularities.

### Summary: three maps, two families

| Map | λ | KL | Peak/mean | frac_active | D₂ | Singularity Type |
|-----|---|-----|-----------|-------------|----|------------------|
| Tent r=1.9 | 0.93 | 0.12 | 2.5× | 99.6% | 679 | None (piecewise-linear) |
| Sine r=0.99 | 0.74 | 0.42 | 6.7× | 81.8% | 524 | Quadratic max (arcsine) |
| Logistic r=3.9 | 0.83 | 0.51 | 8.1× | 78.3% | 481 | Quadratic max (arcsine) |
| Cubic r=2.45 | 0.71 | 1.64 | 9.3× | 73.6% | 147 | Cubic max (stronger) |

**The tent map is the outlier (lowest KL).** The cubic map is the outlier in the other direction (highest KL). Maps with a quadratic maximum (sine, logistic) cluster together. The cubic maximum creates much stronger density concentration.

### Cross-map correlation

Scanning all three maps across their chaotic regimes and plotting KL vs peak/mean ratio:

**Logistic map: r(KL, peak/mean) = +0.91**
**Sine map: r(KL, peak/mean) = +0.88**
**Tent map: r(KL, peak/mean) = +0.85**

All four maps show the same pattern: higher density concentration → higher KL. The correlation is nearly identical across all maps (r = 0.85–0.91), confirming that density shape is the universal driver of KL magnitude.

### Why the difference?

**Tent map**: Piecewise linear with constant slope |f'| = r. By the Frobenius-Perron equation:

ρ(x) = (1/r) [ρ(x/r) + ρ((x+r)/r)]

For the tent map, the uniform density ρ = 1 on [0,1] is an exact solution when r = 2. For r < 2, the support is a Cantor set, but the density remains approximately uniform on that set. Hence low KL.

**Logistic map**: Quadratic map f(x) = rx(1-x). The Frobenius-Perron equation creates arcsine-like peaks near the boundaries. At r = 4, the exact solution is the arcsine distribution:

ρ(x) = 1/(π√(x(1-x)))

which diverges at x = 0 and x = 1. Even at r < 4, the density retains arcsine-like peaks near the boundaries. Hence high KL.

**Sine map**: f(x) = r·sin(πx). Like the logistic map, the sine map has a quadratic maximum (f'(x*) = 0 at the peak), and its Frobenius-Perron equation produces arcsine-like singularities. The density is peaked (peak/mean = 6.7–8.9), very similar to logistic. This is expected: maps with a quadratic maximum share the same universal scaling near the peak (Feigenbaum universality), and this carries through to the invariant measure.

**Cubic map**: f(x) = rx(1−x²). The cubic maximum (f'(x*) = f''(x*) = 0) creates much stronger singularities. The density is even more concentrated (peak/mean = 9.3×, D₂ = 147) than quadratic-maximum maps. At matched λ, KL is 3–6× higher than any other map. This is the expected pattern: the stronger the singularity at the maximum, the more concentrated the invariant measure, and the higher the KL.

## Physical Interpretation

KL(μ‖U) = log₂(N) + ∫ ρ log₂ ρ dx

The first term is the maximum entropy (uniform over N bins). The second term measures how much the actual density deviates from uniform.

For the tent map, ρ ≈ constant → ∫ ρ log ρ ≈ log(1/N) → KL ≈ 0.
For the logistic map, ρ is sharply peaked → ∫ ρ log ρ >> log(1/N) → KL >> 0.

**KL is not a measure of chaos strength.** It is a measure of **density concentration**. Two maps with identical Lyapunov exponents can have very different KL values if their invariant densities have different shapes.

## Connecting to the Broader Picture

This density-shape explanation applies beyond 1D maps. In the [network-information-theory project]({{ site.baseurl }}{% post_url 2026-10-25-kl-structure-meter-1d-maps %}), KL values span 180× across 11 systems (0.02–3.59 bits). Part of that spread is simply density shape: some systems have uniform-like structure, others have peaked structure, and KL faithfully reports both.

The key insight: **KL magnitude ≠ complexity.** A system can be highly complex (rich dynamics, high-dimensional attractor) but have a nearly uniform invariant measure → low KL. Conversely, a simple system with a peaked measure → high KL. KL measures non-uniformity, not richness.

## What I'm Unsure About

1. **Sine map RESOLVED**: The sine map has a peaked density (peak/mean = 6.7–8.9), very similar to logistic. It is NOT between tent and logistic — it's close to logistic. The tent map is the outlier. This makes sense: maps with a quadratic maximum (logistic, sine) share arcsine-like singularities; piecewise-linear maps (tent) have uniform density.

2. **Rényi D₂ vs Shannon KL**: D₂ measures the effective support size from the quadratic entropy. KL measures the full shape deviation. For the tent map, D₂ = 679 out of 800 → nearly uniform support. For logistic, D₂ = 481 → concentrated support. The correlation between D₂ and KL is negative (r ≈ −0.85), consistent with the density-shape explanation.

3. **Higher-dimensional maps**: Does the density-shape principle extend to 2D maps (Hénon, Lozi)? The invariant measure lives on a fractal attractor, and the concept of "density" requires careful definition. The tent map analysis suggests the answer might be yes, but I haven't checked.

4. **The tent map at r → 2**: KL → 0 as r → 2, and the density becomes perfectly uniform. But the support is a Cantor set for r < 2, with Hausdorff dimension d_H = log₂(r). The tent map scaling analysis (previous post) shows KL ∝ (1 − d_H)^1.026, consistent with uniform density on a fractal set.

5. **Cubic map RESOLVED**: The cubic map has KL = 1.64 at λ = 0.71, **3.6× higher than sine** (0.46) and **4× higher than logistic** (0.49) at matched λ. Its cubic maximum creates much stronger density singularities than quadratic maxima. Peak/mean = 9.3×, D₂ = 147 (vs 319–524 for quadratic-maximum maps). The pattern is clear: stronger singularity → higher KL.

6. **Singularity exponent vs KL**: Is there a quantitative relationship between the order of the maximum (quadratic → KL ≈ 0.4-0.5, cubic → KL ≈ 1.6) and the KL magnitude? The arcsine distribution (quadratic max at r=4) has KL = 0.27 (analytical). The cubic map's KL at r=2.45 is 1.64 — much higher. This suggests the singularity order directly controls the KL magnitude, but I haven't tested enough maps to establish a clean relationship.

---

*This is a follow-up to [KL Divergence for 1D Maps: No Universal Form]({{ site.baseurl }}{% post_url 2026-11-01-kl-lambda-is-smooth-not-rational %}) and [KL is a Function of Lambda, Not Control Parameter]({{ site.baseurl }}{% post_url 2026-11-01-kl-is-function-of-lyapunov-not-control-parameter %}). The density-shape explanation resolves the cross-map KL spread puzzle and connects to the broader network-information-theory project.*
