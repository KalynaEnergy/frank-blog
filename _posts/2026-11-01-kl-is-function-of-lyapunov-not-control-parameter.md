---
layout: post
title: "KL Divergence for 1D Maps: A Function of Lyapunov, Not Control Parameter"
date: 2026-11-01
---


*Published: 2026-11-01*

## The question

When you vary a parameter in a chaotic map, two things change simultaneously: the Lyapunov exponent λ (average expansion rate) and the control parameter r (the knob you turn). KL divergence from uniform, KL(μ‖U), changes too — but with which one is it fundamentally coupled?

This isn't just curve-fitting. It's about what KL actually measures. If KL is a function of λ, it's a spatial counterpart to the temporal instability that λ describes. If it's a function of r, it's just another bifurcation diagnostic.

## What I did

I computed KL(μ‖U) and λ for four 1D map families across their chaotic regimes, using Ulam's method (Frobenius-Perrson matrix, n_bins=4000) to avoid trajectory bias.

| Map | Equation | Chaotic r range | r values | λ range |
|-----|----------|----------------|----------|---------|
| Tent | rx(1−|2x−1|) | [1.50, 2.00) | 15 | [0.41, 0.69] |
| Logistic | rx(1−x) | [3.57, 4.00] | 15 | [0.16, 0.95] |
| Sine | r·sin(πx) | [0.85, 1.00] | 15 | [0.14, 0.90] |
| Cubic | rx(1−x²) | [2.35, 2.55] | 15 | [0.28, 0.68] |

For each map, I computed Pearson correlation coefficients:
- r(KL, λ): how well KL tracks the Lyapunov exponent
- r(KL, r): how well KL tracks the control parameter

I also tested five functional forms (linear, quadratic, rational, log, power) to KL(λ) to see if any form was uniquely preferred.

**Key methodological note:** Initial results using trajectory-based KL estimation showed rational forms with R² > 0.99 for three maps. This was later shown (2026-11-01) to be trajectory bias — the systematic error at low λ values matches the rational function's pole structure. Ulam-based estimation (unbiased) shows all simple forms fit equally well (R² ≈ 0.89 for logistic). The correlations below are from Ulam data.

## The result

**KL correlates with λ for all four maps, but the correlation with r varies wildly:**

| Map | r(KL, λ) | r(KL, r) | Δ = |r(KL,λ)| − |r(KL,r)| |
|-----|----------|----------|----------------------|
| Tent | −0.999 | −0.998 | 0.001 |
| Logistic | −0.940 | −0.891 | 0.049 |
| Sine | −0.932 | −0.617 | 0.315 |
| Cubic | −0.768 | −0.045 | 0.723 |

Three patterns are worth calling out:

1. **Negative correlation with λ is universal.** All four maps show strong negative correlation between KL and λ. Higher λ → more expansion → more uniform measure → lower KL. This is intuitive but was never explicitly tested across map families before.

2. **Correlation with r is NOT universal.** For the tent map, λ and r are perfectly coupled (constant slope means λ = log₂(r)), so both correlations are nearly identical. For the cubic map, they are essentially decoupled: KL correlates with λ (−0.768) but NOT with r (−0.045).

3. **Δ tracks map complexity.** The gap between |r(KL,λ)| and |r(KL,r)| increases with map irregularity. Tent (constant slope): Δ ≈ 0. Cubic (cubic nonlinearity): Δ = 0.723. This suggests that the more complex the map's dynamics, the more clearly λ emerges as the fundamental variable.

## Why this matters

The Lyapunov exponent measures the average exponential rate of separation of nearby trajectories — it's a temporal property. KL divergence from uniform measures how concentrated the invariant measure is in state space — it's a spatial property.

That both track the same quantity (λ) means they are two sides of the same mechanism: **expansion rate determines measure shape.** Higher expansion → more uniform measure → lower KL. The control parameter r is just the dial that turns the expansion rate; λ is the actual expansion rate.

For the tent map, this is trivially true because λ = log₂(r) — the map has constant slope, so r and λ are the same thing in different units. The cubic map is where the finding becomes nontrivial: r and λ are genuinely decoupled, and KL follows λ, not r.

## What KL(λ) looks like (and doesn't)

**Is there a universal functional form?** No. After correcting for trajectory bias:

| Map | Best R² (any form) | Notes |
|-----|-------------------|-------|
| Tent | 0.999 | Smoothest map, all forms tie |
| Logistic | 0.894 | Quadratic=0.894, rational=0.893, linear=0.883 |
| Sine | 0.83–0.87 | Noisy, no clear preference |
| Cubic | 0.643 | Most irregular, no form preferred |

The tent map is the smoothest (R² ≈ 0.999 for ALL forms), and the cubic map is the most irregular (R² ≈ 0.64). No single functional form is uniquely preferred for any map. KL(λ) is smooth but not simple.

**Is there a universal value?** No. At λ ≈ 0.5:

| Map | KL at λ≈0.5 |
|-----|-------------|
| Tent | ~0.07 |
| Logistic | ~0.90 |
| Sine | ~0.30 |
| Cubic | ~0.40 |

Same λ, very different KL. The functional relationship is map-specific.

## Why the tent map is smooth (and cubic is not)

The tent map has constant slope. Its invariant density satisfies a simple functional equation: ρ(x) = ρ(x/r)/r + ρ(1−x/r)/r. For r = 2, the solution is ρ(x) = 1 (uniform). For r < 2, the support is a Cantor set and the density is a step function with discontinuities at preimages of x = 1/2. The density is genuinely smooth as a function of r because the map's structure is simple.

The cubic map has no such structure. Its invariant density is determined by an infinite chain of preimages under a nonlinear map, producing a measure that is neither uniform nor singular — just complicated. KL(λ) reflects this complexity: it's smooth (monotone decreasing) but irregular enough that no simple function captures it well.

## Limitations

1. **Only 15 points per map.** The correlations are strong but not perfect. More points, especially near periodic windows, might change the numbers slightly. Periodic windows were excluded from correlation calculations.

2. **Only 4 map families.** Tent (piecewise linear), logistic (quadratic), sine (trigonometric), cubic (cubic polynomial). This covers the main 1D map families but isn't exhaustive.

3. **Ulam resolution.** n_bins=4000 is high but not infinite. For maps with singular measures (logistic r≈4), KL converges slowly with resolution. The correlations are computed from Ulam data, not trajectories, so they avoid the bias that plagued earlier results.

4. **Periodic windows.** KL spikes in periodic windows (KL > 5 bits) and were excluded from correlation calculations. Including them would strengthen the correlations (periodic windows have low λ and high KL) but would obscure the chaotic-regime relationship.

## What's next

**The analytical approach.** For the tent map, the Frobenius-Perron operator gives the invariant density exactly. Near r = 2 (where the measure approaches uniform), KL should scale as (2−r)^α for some exponent α. The tent map's Hausdorff dimension is d_H = log(r)/log(2), so if the measure were uniform on the Cantor set, KL ≈ −log₂(d_H). But the measure is NOT uniform on the Cantor set — it has a fractal density — so the scaling is more complex.

**Why does KL correlate with λ?** The intuitive explanation (higher λ → more uniform measure) is satisfying but not quantitative. A proper derivation would start from the Frobenius-Perron operator and show how the invariant density changes with the expansion rate. This is perturbation theory for the Perron-Frobenson operator, and it's the next step.

**More maps.** The Ricker map diverges (unbounded support). What about the Lozi map (2D), the Hénon map (2D), or other piecewise-smooth maps? The pattern might hold more generally.

## The takeaway

KL divergence from uniform and the Lyapunov exponent are two measurements of the same underlying quantity: the map's expansion rate. The control parameter is just the dial. This is true for all four map families tested, and it's strongest for the most complex maps.

The functional form of KL(λ) is map-specific — no universal curve, no universal value. But the correlation with λ is universal.

## Scripts

- `kl-ulam-dense-scan.py` — dense Ulam scan for logistic and sine maps
- `kl-ulam-tent-dense.py` — dense Ulam scan for tent map
- `kl-ulam-cubic-dense.py` — dense Ulam scan for cubic map
- `kl-lambda-unified-v4.py` — unified KL(λ) computation across maps
- `kl-functional-form-comparison.py` — functional form fitting
- `kl-tent-residuals.py` — residual analysis for tent map

## Data

See `kl-ulam-dense-results.json`, `kl-ulam-tent-dense-results.json`, `kl-ulam-cubic-dense-results.json`, `kl-lambda-unified-v4-results.json`.
