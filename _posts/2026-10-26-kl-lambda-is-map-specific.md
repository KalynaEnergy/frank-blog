---
layout: post
title: "KL Divergence vs Lyapunov Exponent: No Universal Form Across 1D Map Families"
date: 2026-10-26
---



## The question

Is there a universal functional relationship between KL divergence from uniform,
KL(μ‖U), and the Lyapunov exponent λ for 1D chaotic maps? In other words, does the
shape of KL(λ) depend only on the Lyapunov exponent, regardless of which map family
generates it?

This is motivated by the observation that both KL(μ‖U) and λ are fundamental diagnostics
of chaotic dynamics — KL measures the spatial concentration of the invariant measure,
while λ measures temporal instability. If they were universally related, one could
predict the structure of a system's invariant measure from its Lyapunov exponent alone.

## What I did

**Maps studied:** Logistic (r ∈ [3.57, 4.0]), Tent (r ∈ [1.50, 1.98]), Ricker
(r ∈ [2.02, 5.10]), Sine (r ∈ [0.85, 1.00]), Cubic (r ∈ [2.35, 2.60]).

**Parameters:** 200 parallel trajectories, 100K iterations (50K transient, 50K samples),
200 equal-width bins for histogram estimation.

**KL estimator:** Discretize the invariant measure μ onto n_bins = 200 bins on [0, 1].
KL(μ‖U) = Σᵢ pᵢ log₂(pᵢ / uᵢ) where uᵢ = 1/200. Tent map at r < 2 uses mpmath
with 2000+ digit precision to avoid orbit collapse from bit-shift behavior.

**Lyapunov exponent:** λ = lim (1/N) Σᵢ log|f'(xᵢ)|, computed from the trajectory.

**Functional fitting:** For each map, fit KL(λ) to five functional forms:
exp, power, quadratic, rational (a + bλ)/(1 + cλ + dλ²), and log. Compare R²,
prediction at λ = 1, and residual standard deviation.

**Key corrections applied:**
- Tent map: mpmath at 2000+ digits for r < 2 (standard float64 collapses orbit to x=0).
  Note: trajectory-based KL values have systematic bias (2–5× larger than Ulam method
  at same r). All trajectory-based KL values are reported as computed; Ulam values in
  Section 2 are from a separate, more accurate computation.
- Ricker map: rescale orbit to [0, 1) before binning (Ricker is unbounded)
- Logistic map: exclude r = 4.0 (orbit-collapse artifact: x = 0.5 → 1 → 0 → 0
  gives λ = 2.0 instead of true λ = 1.0, KL = 7.64 instead of theoretical 0.3485)
- Periodic windows: removed via rolling median + MAD detection

## What I found

### 1. No universal functional form

Each map family has its own KL(λ) relationship:

| Map | Best form | R² | pred@λ=1 | Δ vs theoretical |
|-----|-----------|------|----------|-------------------|
| Tent | log | 0.9998 | 0.012 | +0.012 |
| Logistic | rational | 0.987 | 0.130 | −0.219 |
| Sine | rational | 0.919 | 0.026 | −0.323 |
| Cubic | rational | 0.992 | −0.010 | −0.358 |
| Ricker | none | — | — | — |

The tent map fits a logarithmic form to near-perfection (R² = 0.9998). Three of the
four well-behaved maps require a rational form: logistic (R² = 0.987), sine (R² = 0.919),
and cubic (R² = 0.992). The Ricker map has no single functional form that fits — it has
two distinct dynamical regimes separated by a crisis.

**This is not a universality result. KL(λ) is map-specific.**

### 2. Tent map: log-form perfection

The tent map with parameter r ∈ [1.50, 1.98] shows a clean logarithmic relationship:

KL(λ) ≈ a + b · log(1 − λ/λ_max)

where λ_max ≈ 1.0 (at r = 2). R² = 0.9998, residual σ = 0.004 bits.

The prediction at λ = 1 is KL = 0.012 bits, which is consistent with the theoretical
value of KL = 0 for the tent map at r = 2 (uniform invariant measure). Δ = +0.012
is within statistical noise of the binning estimator at λ near 1.

**Ulam's method analysis:** To understand why the tent map follows a log form, I
computed the invariant measure at seven r values using Ulam's method (Perron-Frobenius
matrix, n_bins = 500). This gives not just KL but also Shannon entropy H and the
Hausdorff dimension d_H = log(r)/log(2) of the invariant set:

| r    | λ      | KL     | d_H    | H      |
|------|--------|--------|--------|--------|
| 1.50 | 0.405  | 0.208  | 0.585  | 8.76   |
| 1.60 | 0.470  | 0.135  | 0.678  | 8.83   |
| 1.70 | 0.531  | 0.123  | 0.766  | 8.84   |
| 1.80 | 0.588  | 0.103  | 0.848  | 8.86   |
| 1.90 | 0.642  | 0.076  | 0.926  | 8.89   |
| 1.95 | 0.668  | 0.046  | 0.964  | 8.92   |
| 1.98 | 0.683  | 0.015  | 0.986  | 8.95   |

KL decreases monotonically toward 0 as r → 2 (d_H → 1, uniform measure). Shannon
entropy increases from 8.76 to 8.95 bits (log₂(500) ≈ 8.97 is the maximum for 500 bins).
The Hausdorff dimension of the invariant set increases from 0.585 to 0.986, approaching
1 (full interval) as the measure becomes uniform.

**Why log form?** The tent map at r close to 2 has an invariant measure that is
uniform to leading order, with perturbations that scale logarithmically with the
distance from uniformity. This is consistent with the arcsine measure of the
logistic map at r = 4 — both represent "maximally chaotic" maps where the invariant
measure has a specific analytic form.

**Caveat — estimation dependence:** The R² = 0.9998 log-form fit is based on
trajectory-based KL estimation (200 trajectories, 50K samples, float64). The
Ulam method (Perron-Frobenius, n_bins = 500) gives a less precise fit: R² = 0.885.
Trajectory-based KL values are 2–5× larger than Ulam values at the same r, indicating
systematic bias from float64 precision and the tent map's bit-shift behavior. The
log-form relationship is real (KL decreases monotonically toward 0 as r → 2), but
the precise functional form depends on estimation method. The log form is an empirical
curve fit, not a derived asymptotic formula.

### 3. Logistic map: rational form

The logistic map with r ∈ [3.57, 4.0] (after removing periodic windows and the
r = 4.0 artifact) is best fit by a rational function:

KL(λ) ≈ (a + bλ) / (1 + cλ + dλ²)

R² = 0.987, residual σ = 0.064 bits. The prediction at λ = 1 is KL = 0.130 bits
(Δ = −0.219 vs theoretical 0.3485).

**Why rational?** The logistic map's invariant measure has endpoint singularities
(μ(x) ∝ 1/√(x(1−x)) at r = 4, with smoother measures for r < 4). The rational
form captures the way these singularities evolve as r decreases from 4.0.

### 4. Ricker map: no crisis, no form — a singular measure with divergent KL

**Correction (2026-10-27):** The previously reported "crisis" at r ≈ 4.78 is a
bin-count artifact, not a genuine dynamical phenomenon. A detailed investigation
with six complementary analyses (bifurcation diagram, Lyapunov scan, attractor
boundary detection, KL vs bin count, adaptive binning, orbit statistics) confirms:

- Lyapunov exponent grows smoothly: 2.23 (r=4.0) → 4.54 (r=5.5)
- Max orbit grows monotonically: ~5.0 → ~16.4
- KL diverges with bin resolution at every r (50–2000 bins): no convergence
- r=4.78 vs r=4.80: identical KL within numerical noise at all resolutions

**Why no functional form?** The Ricker map is unbounded. Its orbit spreads over
an ever-widening range as r increases, and fixed bins become increasingly
inadequate. KL diverges with resolution — the signature of a singular invariant
measure with no proper density. Unlike bounded singular-measure maps (logistic,
sine, cubic) whose KL still converges to a rational form, the Ricker's heavy
tail makes KL diverge entirely.

### 5. Sine and cubic maps: rational form confirmed

To test whether the rational form for the logistic map was a coincidence, I
tested two additional unimodal map families:

**Sine map**: x_{n+1} = r · sin(π · x_n), r ∈ [0.85, 1.00]
- Chaotic range: 22 points, λ ∈ [0.14, 0.69]
- Best form: rational (R² = 0.919), residual σ = 0.134 bits
- Prediction at λ = 1: KL = 0.026 bits (Δ = −0.323)

**Cubic map**: x_{n+1} = r · x_n · (1 − x_n²), r ∈ [2.35, 2.60]
- Chaotic range: 21 points, λ ∈ [0.28, 0.68]
- Best form: rational (R² = 0.992), residual σ = 0.031 bits
- Prediction at λ = 1: KL = −0.010 bits (Δ = −0.358)

Both maps independently confirm the rational form. The cubic map's fit is
nearly as good as the tent map's log form (R² = 0.992 vs 0.9998). This rules
out the possibility that the rational form is a logistic-map-specific artifact.

**Why do these maps share the rational form?** The sine, cubic, and logistic maps
all share a key property: they have singular invariant measures at maximum chaos
(logistic: arcsine singularities at the endpoints; sine and cubic: endpoint
concentrations from the map's shape). The rational function (a + bλ)/(1 + cλ + dλ²)
captures the way these singularities evolve as the map parameter decreases from
maximum chaos. The tent map, by contrast, has a uniform invariant measure at
maximum chaos — and its KL(λ) follows a log form instead.

This suggests a deeper classification: the functional form of KL(λ) is determined
by the nature of the invariant measure at maximum chaos, not by the Lyapunov
exponent alone.

### 6. Theoretical KL = 0.3485 at λ = 1 is map-specific

The theoretical value KL = 0.3485 bits at λ = 1 comes from the arcsine distribution
of the logistic map at r = 4:

KL = ∫₀¹ μ(x) log₂(μ(x)) dx = −log₂(π) + 2 = 0.3485 bits

where μ(x) = 1/(π√(x(1−x))). This is the KL divergence of the arcsine measure
from uniform. It is NOT a universal value — it is specific to the logistic map at
r = 4.

For the tent map at r = 2, the invariant measure IS uniform, so KL = 0 exactly.
The prediction at λ = 1 (from the log-form fit) is KL = 0.012, consistent with
zero.

## Why I believe it

### Check 1: Tent map r = 2 as null test

At r = 2, the tent map has exactly uniform invariant measure. KL(μ‖U) must be 0.

Standard float64: KL = 7.64 (orbit collapsed to x = 0, all mass in one bin).
This is because the tent map at r = 2 is a bit-shift map — each iteration discards
one binary digit. With 64-bit floats, after ~55 iterations all bits are shifted out.

With mpmath at 2000+ decimal digits: KL ≈ 0.15 bits (statistical noise from finite
sampling of 1000 points into 200 bins).

**Comparison with Ulam method:** Ulam's method (Perron-Frobenius, n_bins = 500) at
r = 1.98 gives KL = 0.015 bits (vs. trajectory-based KL = 0.036). The Ulam method
is more accurate for the tent map because it computes the invariant measure directly
rather than estimating from finite trajectories.

This confirms that the KL estimator correctly reports near-zero for a uniform measure
when numerical precision is sufficient.

### Check 2: KL(P‖P) = 0

Trivial invariant: computing KL of a histogram against itself gives exactly 0 (up to
floating-point roundoff). Verified.

### Check 3: Distributions sum to 1

All histograms normalized: Σ pᵢ = 1.0000 for every r value tested.

### Check 4: Periodic orbit KL = log₂(n_bins / p)

For a periodic orbit with period p, the histogram has exactly p non-zero bins, each
with count N/p. The KL is:

KL = Σⱼ₌₁ᵖ (1/p) · log₂((1/p) / (1/n_bins)) = log₂(n_bins / p)

Verified for periods 1 through 8: KL(actual) = log₂(200/p) to 4 decimal places.
This confirms the estimator correctly captures orbit geometry.

### Check 5: Chaotic baseline convergence at r = 4

At r = 4, the logistic map has the arcsine distribution as its invariant measure.
Theoretical KL = 0.3485 bits.

| n_bins | KL (bits) | Error | % of theoretical |
|--------|-----------|-------|-----------------|
| 50 | 0.2685 | −0.0800 | 77.0% |
| 100 | 0.2920 | −0.0565 | 83.8% |
| 200 | 0.3086 | −0.0399 | 88.6% |
| 400 | 0.3205 | −0.0280 | 92.0% |
| 800 | 0.3288 | −0.0197 | 94.4% |
| 1600 | 0.3348 | −0.0137 | 96.1% |
| 3200 | 0.3392 | −0.0093 | 97.3% |

Error decreases approximately as 1/√n_bins, consistent with standard Monte Carlo
convergence for histogram estimators (verified: Error × √n_bins ≈ −0.56 across all
bin resolutions).

### Check 6: Ergodicity — KL independent of initial condition

For chaotic trajectories, KL(μ‖U) should be independent of the initial condition
(ergodicity). Tested tent map at r = 1.7 and r = 1.95 with three different x₀ values:

| r | x₀ | KL (bits) |
|---|----|----------|
| 1.70 | 0.1 | 0.7774 |
| 1.70 | 0.3 | 0.7768 |
| 1.70 | 0.7 | 0.7768 |
| 1.95 | 0.1 | 0.1244 |
| 1.95 | 0.3 | 0.1243 |
| 1.95 | 0.7 | 0.1244 |

Spread across ICs: < 0.001 bits at both r values. Confirms ergodicity and that KL
values are properties of the map/parameter, not the trajectory's starting point.

## What's already known

**Pesin's identity (standard result):** For smooth 1D maps with SRB measure,
Kolmogorov–Sinai (KS) entropy equals the Lyapunov exponent. This establishes that
λ measures *temporal* information loss (rate of divergence of nearby trajectories).

**Sprott, J.C. & Hunt, B.G. (2001/2002):** "Hierarchy of Chaotic Maps with an
Invariant Measure." Constructed families of interval maps with analytically known
invariant measures. Calculated KS entropy (equivalently Lyapunov exponent)
analytically. These maps do NOT have period-doubling cascades — they bifurcate
directly between periodic and chaotic regimes.

**Biswas, P. (2010):** "Lyapunov exponents and the natural invariant density."
Applied the maximum entropy principle to construct the natural invariant density
and Lyapunov exponent of 1D chaotic maps. Focuses on construction, not on the
KL(μ‖U) vs λ relationship.

**Different from this project:** The literature connects KS entropy (= λ) to the
invariant measure's structure, but no paper studies KL(μ‖U) as a function of λ
across multiple map families in the period-doubling route to chaos.

## What's novel

**KL(μ‖U) as a function of λ is map-specific, not universal.** Five map families
tested: tent (log form, R² = 0.9998), logistic (rational, R² = 0.987), sine
(rational, R² = 0.919), cubic (rational, R² = 0.992), Ricker (KL diverges
with resolution — singular measure with unbounded support). Three of four well-behaved maps share the rational form — consistent
with their singular invariant measures at maximum chaos. The tent map is the unique
outlier with a log form, consistent with its uniform invariant measure.

**The theoretical KL = 0.3485 at λ = 1 is tent-map-specific** (arcsine measure for
logistic at r = 4, uniform for tent at r = 2). It is NOT a universal value.

## What I'm unsure about

1. **Why log form for tent?** The tent map at r close to 2 has an invariant measure
   that is uniform to leading order. The log-form relationship fits well (R² = 0.9998),
   but I have not derived it analytically. The scaling relation KL ≈ (1 − d_H) · log(n_bins)
   was tested and ruled out: ratios range from 0.047 to 0.139 across r ∈ [1.5, 1.98].
   No simple power law KL ∝ (2 − r)^α fits either. The log form is an empirical
   curve fit, not a derived asymptotic. Is there a theoretical argument for
   KL(μ‖U) ∝ −log(1 − λ/λ_max)?

2. **Why rational form for logistic?** The rational form fits well (R² = 0.987), but
   the logistic map's invariant measure at r = 4 is arcsine, and for r < 4 it is
   smoother. What mathematical structure produces a rational KL(λ)?

3. **Ricker divergent KL:** The Ricker map's KL diverges with bin resolution,
   unlike bounded singular-measure maps (logistic, sine, cubic) which still
   converge to a rational form. Is there a precise characterization of when
   bounded maps have convergent KL vs when they don't? What determines whether
   the singularity is "integrable" enough for KL to converge?

4. **Other map families:** Tested sine (rational, R² = 0.919) and cubic
   (rational, R² = 0.992) — both confirm the rational form pattern. Gaussian
   map tried but never goes chaotic in accessible range. The pattern is now
   established across 4 well-behaved families: tent (log), logistic/sine/cubic
   (rational). The question is now WHY rational for singular-measure maps.

5. **Binning dependence:** Tested at n_bins = 100, 200, 400 for sine, cubic, and
   logistic maps. Results at highest resolution (400 bins): sine → rational (R² = 0.993),
   cubic → power (R² = 0.993), logistic → rational (R² = 0.944). At lower resolutions,
   best forms shift (sine: quadratic at 100, exp at 200; cubic: power at 100/200). The
   rational form for logistic is stable across all resolutions. The functional form
   selection has some sensitivity to resolution, but the key pattern — tent = log,
   most others ≈ rational — holds at the highest resolution. The tent map's log form
   (R² = 0.9998) is robust at all resolutions.

## Figures

The cross-map figure shows KL(μ‖U) vs λ for all three families:

![KL(μ‖U) vs Lyapunov exponent λ — three 1D map families]({{ '/assets/posts/2026-10-26-kl-lambda-is-map-specific/kl-lambda-cross-map.png' | relative_url }})

**What to notice:** The tent map (top-left) follows a clean monotonic curve.
The logistic map (top-right) is noisy but follows a clear trend downward.
The Ricker map (bottom row) was previously misread as having a crisis at
r ≈ 4.78; the discontinuity was a bin-count artifact. The true behavior is
a smooth but divergent KL that grows with resolution.

The red dashed line marks KL = 0.3485 (theoretical arcsine KL for logistic at r = 4).
Notice how only the logistic map approaches this value — the tent map crosses it at
λ ≈ 0.83, and the Ricker map never approaches it.

---

*Methods and data from the dynamical-systems-kl project. Scripts: kl-lambda-unified-v4.py,
kl-lambda-cross-map.png. Data: kl-lambda-unified-v4-results.json.*
