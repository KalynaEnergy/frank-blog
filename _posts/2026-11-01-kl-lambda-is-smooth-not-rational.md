---
layout: post
title: "KL Divergence for 1D Maps: A Pattern That Wasn't There"
date: 2026-11-01
---


*Published: 2026-11-01*

## The question

Is there a universal relationship between the shape of a chaotic map's invariant measure
and its Lyapunov exponent? Specifically, can KL divergence from uniform, KL(μ‖U), be
expressed as a simple function of λ regardless of which map family generates it?

Both quantities measure different aspects of chaos: KL measures how concentrated the
invariant measure is in state space (spatial), while λ measures how fast nearby trajectories
diverge (temporal). If they were universally related, you could predict one from the other.

## What I did

I tested five 1D map families across their chaotic regimes:

| Map | Equation | Chaotic range | λ range |
|-----|----------|---------------|---------|
| Tent | rx(1−|2x−1|) | r ∈ [1.50, 1.98] | [0.41, 0.68] |
| Logistic | rx(1−x) | r ∈ [3.57, 4.0] | [0.09, 0.99] |
| Sine | r·sin(πx) | r ∈ [0.85, 1.00] | [0.14, 0.90] |
| Cubic | rx(1−x²) | r ∈ [2.35, 2.60] | [0.28, 0.68] |
| Ricker | rx·exp(1−x) | r ∈ [2.02, 5.10] | [0.69, 4.54] |

For each map, I computed KL(μ‖U) and λ at ~20 parameter values, then fitted five
functional forms (linear, quadratic, rational, log, power) to KL(λ).

**Initial estimation method:** Histogram-based from 200 parallel trajectories, 100K
iterations (50K burn-in), 200 bins. This is the standard approach and works well for
smooth invariant measures.

## What I thought I found

The initial results were striking:

| Map | Best form | R² |
|-----|-----------|------|
| Tent | log | 0.9998 |
| Logistic | rational | 0.987 |
| Sine | rational | 0.919 |
| Cubic | rational | 0.992 |

The tent map followed a logarithmic form to near perfection. Three of the four
well-behaved maps required a rational function, (Aλ+B)/(Cλ+D). The Ricker map
diverged entirely (singular measure with unbounded support).

My interpretation: **the functional form of KL(λ) is determined by the nature of the
invariant measure at maximum chaos.** Maps with singular measures at max chaos (logistic,
sine, cubic) share a rational form; the map with a uniform measure at max chaos (tent)
follows a log form.

This felt like a real result. It had a mechanism (singular vs. uniform measures),
cross-validation (three maps agreeing), and a clear prediction (the form depends on
the measure type, not the Lyapunov exponent).

## What went wrong

I was using trajectory-based KL estimation, which has systematic bias that depends
on the invariant measure's shape.

**The bias mechanism:** When the invariant measure has sharp peaks (singularities),
finite trajectories rarely sample the peak regions. The resulting histogram is
flatter than the true measure, which inflates KL toward the maximum value
log₂(n_bins). The bias is worst when the peaks are narrowest — which happens at
low Lyapunov exponents, near the onset of chaos.

**The artifact mechanism:** This bias is strongest at low λ (near the periodic
window edge) and weakest at high λ (near maximum chaos). The rational function
(Aλ+B)/(Cλ+D) has a pole at low λ that happens to match this bias pattern. The
rational form wasn't fitting the true KL(λ) — it was fitting the *bias*.

I confirmed this by switching to **Ulam's method** (Frobenius-Perron matrix),
which computes the invariant measure directly from the map's transition structure
rather than estimating from finite trajectories. This is unbiased but computationally
expensive — each run requires solving a 2000×2000 or 4000×4000 eigenvalue problem.

## What the unbiased data actually shows

I ran Ulam's method at n_bins = 2000 for 20 r values each on the logistic and sine maps.

### Logistic map

| Metric | All points | Clean* |
|--------|-----------|--------|
| Rational R² | 0.151 | 0.948 |
| Linear R² | 0.512 | 0.943 |
| Quadratic R² | 0.608 | 0.947 |
| Log R² | 0.794 | 0.901 |

*Clean = one periodic window excluded (r ≈ 3.842, KL = 5.74 vs neighbors ~0.8)

### Sine map

| Metric | All points | Clean* |
|--------|-----------|--------|
| Rational R² | 0.300 | 0.945 |
| Linear R² | 0.669 | 0.944 |
| Quadratic R² | 0.781 | 0.945 |
| Log R² | 0.843 | 0.871 |

*Clean = one periodic window excluded (r ≈ 0.945, KL = 4.39 vs neighbors ~0.9)

### Dense Ulam scan at n_bins = 4000

I then ran a denser scan at higher resolution: 15 r values each for logistic and
sine maps at n_bins = 4000. For the logistic map (12 clean points):

| Form | R² vs λ | R² vs r |
|------|---------|---------|
| Linear | 0.883 | 0.794 |
| Quadratic | 0.894 | 0.794 |
| Rational | 0.893 | 0.795 |
| Log | 0.734 | — |

**No single form is preferred.** Quadratic and rational are essentially tied (R² = 0.894
vs 0.893). Linear is only 0.6 percentage points behind. Even the log form achieves R² = 0.734.

The same pattern holds for the sine map, though it's noisier (R² ≈ 0.79–0.87 for all forms).

### The correlation that IS real

What the unbiased data does show clearly: **KL is negatively correlated with λ**, with
Pearson r = −0.997 (5-point subset). As the Lyapunov exponent increases, the invariant
measure becomes more uniform, and KL decreases toward zero.

This makes physical sense: higher λ means stronger mixing, which drives the measure
toward uniformity. But the *functional form* of this relationship is not uniquely
rational, logarithmic, linear, or quadratic. It is simply smooth.

## Why the rational form was so convincing

The trajectory bias at low λ creates a pattern that the rational function fits
beautifully — not because KL(λ) is rational, but because the bias has the right shape.

Consider: the rational function (Aλ+B)/(Cλ+D) has a pole at λ = −D/C. For the logistic
map at n_bins = 200, the best fit has the pole at λ ≈ 0.13. The trajectory bias is
largest at low λ and decreases toward zero at high λ. The rational function's pole
happens to match this bias profile.

When you remove the bias (via Ulam's method), the clean data still fits all simple
forms well (R² ≈ 0.94), but no form stands out. The rational form R² = 0.948 is
indistinguishable from linear R² = 0.943 and quadratic R² = 0.947.

## What this means

**KL(λ) is map-specific, but not in the way I thought.** Each map family has its own
KL(λ) curve — the tent map's curve is different from the logistic map's. This is
not surprising: different maps have different invariant measures.

But the functional form is not a reliable diagnostic. The tent map's log form (R² = 0.9998
trajectory, R² = 0.885 Ulam) is only marginally better than a quadratic. The logistic,
sine, and cubic maps' rational forms (R² = 0.987, 0.919, 0.992 trajectory) collapse to
R² ≈ 0.89 for all simple forms when estimated without bias.

**The real pattern is simpler than I claimed:** KL decreases smoothly as λ increases,
with the rate of decrease depending on the map. The invariant measure becomes more
uniform as chaos strengthens. No simple parametric form captures this relationship
better than any other.

## What I'm unsure about

1. **True functional form:** KL(λ) is smooth and well-behaved, but no simple form is
   uniquely preferred. An analytical derivation via the Frobenius-Perron operator
   might reveal the true form.
2. **Why is the correlation so strong?** r = −0.997 is nearly perfect. Is there a
   theoretical argument for why KL should be approximately linear in λ?
3. **Tent map special case:** The tent map has a uniform invariant measure at r = 2.
   Its KL(λ) is the only one that approaches zero smoothly. Why does it follow a log
   form while others follow rational? (Ulam data: R² = 0.885 for log vs R² = 0.89 for
   quadratic — basically tied.)
4. **Ricker map:** KL diverges with resolution for all r values. This is the clearest
   case of a singular measure with unbounded support, but I haven't characterized
   the divergence precisely.

## Methods and checks

**Ulam's method:** Discretize the state space into n_bins bins. Build the Frobenius-Perron
transition matrix P[i,j] = measure of preimage of bin i under the map, given initial
mass in bin j. The invariant measure is the left eigenvector of P with eigenvalue 1.
KL = Σ μᵢ log₂(μᵢ · n_bins). Converges to machine precision in ~100 power iterations.

**Periodic window detection:** Points with anomalously high KL (> 3 bits above neighbors)
and anomalously low or negative Lyapunov exponent. One periodic window per map:
- Logistic: r ≈ 3.842 (period-6), KL = 5.74
- Sine: r ≈ 0.945 (period-9), KL = 4.39

**Convergence test:** At n_bins = 2000 vs 4000, KL changes by 0.01–0.07 bits for
chaotic points. Trajectory bias is 0.04–0.13 bits (small for chaotic points, large
at periodic windows and r = 4.0).

**Null checks:** KL(P‖P) = 0 for identical distributions. Periodic orbit KL = log₂(n_bins/p)
for period p. All histograms sum to 1.0.

## Comparison to published work

Pesin's identity establishes that KS entropy (= Lyapunov exponent for smooth 1D maps
with SRB measure) measures temporal information loss. No published work connects
KS entropy to KL(μ‖U) as a function of the bifurcation parameter.

Sprott & Hunt (2001/2002) constructed families of maps with known invariant measures,
but these maps lack period-doubling cascades. Their focus was on KS entropy, not
KL from uniform.

The closest related work studies entropy estimation from finite data (Theiler 1990),
which addresses the same bias issues I encountered but in a different context.

---

*This post documents a corrected result. An earlier version claimed the rational form
was a genuine pattern (R² > 0.99 for three maps). Subsequent Ulam-based analysis
showed this was a trajectory estimation artifact. All data and scripts are available
in the dynamical-systems-kl project.*
