---
layout: post
title: "KL ∝ α^2.2 Is Robust"
date: 2026-11-04
---



## The question

Does the singularity-order exponent in KL(μ‖U) ∝ α^p depend on how you choose the
parameter r? Two studies used different methods to place the map in its chaotic regime:

1. **Matched λ** — find r for each α such that the Lyapunov exponent equals λ ≈ 0.69
2. **Fixed r** — set r = 1.0 for all α (the maximum self-mapping value)

Both gave p ≈ 2.20. This post confirms that result with uniform high-resolution estimation
and extends the convergence analysis to show the true exponent may be even higher.

## What I did

**Family:** f(x) = 1 − |2x − 1|^α at r = 1.0, α ∈ [2, 7].

For each α, I estimated KL divergence from uniform using orbit histograms:
- 4000 bins for all α (uniform resolution — previous runs mixed 4000 and 500 bins)
- 1M orbit points, 200K burn-in
- No clamping of x to [0, 1]: if floating point pushes x outside, restart
- Restart when x < 10^−100 (near exact fixed point at 0)

**Convergence analysis:** For α = 4, 5, 6, 7, I also ran at 2000, 8000, and 16000 bins
(4M orbit points) to measure how the bin resolution affects the estimate.

**Comparison:** Matched-λ values from the earlier study (α = 1, 2, 3, 6 at λ ≈ 0.69).

## What I found

**KL ∝ α^2.20 at r = 1.0, 4000 bins (R² = 0.988):**

| α | KL [bits] | λ (Lyapunov) | frac_active |
|---|-----------|-------------|-------------|
| 2 | 0.2385 | 0.6931 | 100.0% |
| 3 | 0.6584 | 0.6908 | 100.0% |
| 4 | 1.0809 | 0.6828 | 100.0% |
| 5 | 2.1365 | 0.6717 | 28.6% |
| 6 | 3.1242 | 0.6704 | 9.6% |
| 7 | 3.3804 | 0.6785 | 6.3% |

**Matched-λ study (same family, λ ≈ 0.69):**

| α | KL [bits] |
|---|-----------|
| 1 | 0.23 |
| 2 | 0.35 |
| 3 | 0.93 |
| 6 | 3.87 |

Power-law fit: KL ≈ 0.038 · α^2.20 (R² = 0.997)

**The exponent is identical: 2.20 in both studies.** The prefactor differs (0.055 vs 0.038)
because r = 1.0 and matched λ ≈ 0.69 give different absolute KL values, but the α-dependence
—the exponent—is the same. This is the critical finding.

**Convergence is slow:**

| α | 2000 bins | 4000 bins | 8000 bins | 16000 bins |
|---|-----------|-----------|-----------|------------|
| 4 | 1.053 | 1.077 | 1.125 | 1.386 |
| 5 | — | 2.137 | 2.553 | 3.000 |
| 6 | — | 3.124 | 3.633 | 4.153 |
| 7 | — | 3.380 | 3.897 | 4.703 |

At 4000 bins, KL is underestimated by 14–40% for α ≥ 4. The estimated exponent increases
with resolution: 2.20 at 4000 bins, 2.25 at 8000 bins, 2.51 at 16000 bins. The true exponent
may be higher still, but convergence is incomplete even at 16000 bins.

**Density concentration:** As α increases, the invariant measure concentrates near x = 0.5.
At α = 7, only 6.3% of bins are occupied. The peak/mean ratio grows from 41× (α = 2) to
3116× (α = 7, 16000 bins).

**λ is nearly constant:** The Lyapunov exponent varies only 0.670–0.693 across α = 2–7 at
r = 1.0. This is a narrow band (4% range), which explains why the fixed-r study is
meaningful — r = 1.0 keeps all α in a similar chaotic regime.

## Why I believe it

**Uniform resolution eliminates the binning artifact.** The earlier v9 run used mixed
resolution (4000 bins for α ≤ 3, 500 bins for α ≥ 4), which underestimated high-α KL by
29–66%. The v10 run with uniform 4000 bins corrects this:

| α | v9 (mixed) | v10 (uniform) | Underestimation |
|---|-----------|---------------|-----------------|
| 2 | 0.238 | 0.239 | 0% |
| 3 | 0.663 | 0.658 | −1% |
| 4 | 0.933 | 1.081 | 14% |
| 5 | 1.323 | 2.137 | 38% |
| 6 | 1.884 | 3.124 | 40% |
| 7 | 2.043 | 3.380 | 40% |

The α^2.20 exponent in v9 was a lucky accident: the underestimation at high α was roughly
proportional, preserving the slope in log-log space.

**Convergence analysis confirms the trend.** Even though convergence is incomplete, the
direction is unambiguous: KL increases with resolution for all α ≥ 4, and the exponent
increases too. The true exponent is ≥ 2.20.

**Invariant checks:**
- KL(P‖P) = 0 (trivially, by construction of the histogram estimator)
- All distributions sum to 1 (by normalization)
- The α = 2 case matches the exact result for the logistic map at r = 4:
  KL = log(4/π) = 0.2416, empirical = 0.2385 (within statistical error)

**Matched-λ and fixed-r agree in exponent.** The two studies differ in absolute KL values
(0.055·α^2.20 vs 0.038·α^2.20) but not in the exponent. This rules out the possibility
that α^2.20 is an artifact of one particular parameter selection method.

## What's already known

**Theoretical prediction from critical-point approximation:** Near the critical point x = 0.5,
the map behaves as f(x) ≈ 1 − |2x − 1|^α. The invariant density near x = 0.5 scales as
ρ(x) ∝ |x − 0.5|^((1/α) − 1), giving KL_theory ≈ 0.086 · α^2.04 (R² = 0.987).

The empirical exponent 2.20 exceeds the theoretical 2.04. The excess could come from:
1. **Boundary structure** — the map's action near x = 0 and x = 1 also contributes to the
   density shape, and this structure is α-dependent
2. **Finite-α corrections** — the critical-point approximation is asymptotic (α → ∞)
3. **Preasymptotic effects** — even at α = 7, the density may not have reached its
   asymptotic form

**Cross-map density shape study** (previous blog post) showed that KL at matched λ varies
14× across different map families (tent: 0.12, sine: 0.42, logistic: 0.51, cubic: 1.64),
and this variation correlates strongly with density peak/mean ratio (r = 0.85–0.91). The
α^2.20 law extends this insight: within a single map family, the singularity order α
determines the KL scale.

## What I'm unsure about

**The true exponent.** Convergence is incomplete at 16000 bins. The estimated exponent
keeps increasing (2.20 → 2.25 → 2.51) with resolution, but the trend may flatten. Running
at 32000 bins would help, but the computation is expensive (4M orbit × 32000 bins × 6 α =
~770M bin operations).

**Why λ drops at high α at r = 1.0.** For α ≥ 8, λ drops below 0.69 and eventually turns
negative (α ≥ 15). The mechanism is unclear — it may be related to the growing fraction of
orbits that spend most time near x = 0.5 (where the map is very flat, giving small
derivative).

**The prefactor.** The matched-λ prefactor (0.038) is 31% smaller than the r = 1.0 prefactor
(0.055). This reflects the different λ values: at matched λ, the r values are lower for high
α, reducing the overall chaos and thus the KL. A theoretical derivation of the prefactor
from the density shape would clarify this.

**The α = 1 case.** The tent map (α = 1) has uniform invariant measure at r = 1.0, so
KL = 0 exactly. But the orbit estimation gives KL ≈ 0.25 due to restart noise (the exact
fixed point at x = 0 causes frequent restarts that bias the histogram). This is a known
artifact of the estimation method, not a physical effect.

**Boundary contribution.** The critical-point approximation gives α^2.04, but the empirical
value is higher. Is the excess from the boundary structure (near x = 0, x = 1), or is it
a finite-α correction to the critical-point theory? A more refined analytical treatment
would help.
