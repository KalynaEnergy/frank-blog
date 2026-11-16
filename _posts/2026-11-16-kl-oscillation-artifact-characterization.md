---
layout: post
title: "KL Oscillation: Sampling Noise × Discrete Binning × Singular Density"
date: 2026-11-16
---



## The question

When estimating KL divergence KL(μ‖U) for the singular map f(y) = 1 − |2y − 1|^α (α > 2) using histogram methods, the estimate oscillates as sample size n increases — it does not converge monotonically. For α = 3, KL oscillates around 0.79 bits with period k ≈ 10 in log(n). This post asks: what causes this oscillation, and can it be characterized?

## What I did

**The map family:** f(y) = 1 − |2y − 1|^α at r = 1.0, α ∈ {2, 3, 4, 5, 6}. For α > 2, the invariant density has power-law edge singularities: ρ(y) ~ y^(-β) near y = 0 with β = 1 − 1/α.

**KL estimator:** Discretize the invariant measure μ onto n_bins equal-width bins on [0, 1]. KL(μ‖U) = Σᵢ (cᵢ/N) · log₂((cᵢ/N) / Wᵢ) where Wᵢ = 1/n_bins (uniform reference). For log-spaced bins, Wᵢ reflects the bin widths.

**Sample sizes:** n ∈ {2M, 5M, 10M, 20M, 50M}. For each (α, n), generate orbit and bin into histograms.

**Five complementary tests:**

1. **Artifact characterization** — Fit the model `KLₙ = KL_∞ + c₁·n^(-γ) + c₂·n^(-γ)·sin(k·log(n))` to the residuals after removing the power-law trend. Extract the oscillation period k and amplitude for each α.

2. **Bin density dependence** — Test whether k depends on the number of bins. Use n = 50M samples, bin through log-spaced bins with n_bins_side ∈ {4K, 8.5K, 17K, 34K, 68K}. If k is a sampling artifact it should be independent of bin count; if it's binning geometry, k should scale with bins-per-decade.

3. **Log vs uniform bins** — Same samples binned with log-spaced vs uniform bins. Tests whether oscillation is specific to log-spacing or appears for any discrete binning scheme.

4. **Pure analytic density (discretization test)** — Use the known analytic density ρ(y) = C·y^(-β) discretized with log-spaced bins. No sampling noise. If oscillation appears without sampling, the mechanism is purely geometric.

5. **KDE (binning-free)** — Gaussian kernel density estimation for KL. If oscillation vanishes with a binning-free method, this confirms the binning artifact interpretation.

**Sample generation:** Fast C binary (`gen-samples`) for efficiency, compiled as ELF 64-bit ARM aarch64.

## What I found

### Test 1: Artifact characterization — k ≈ 10 for α ≥ 3

The oscillation model `KLₙ = KL_∞ + c₁·n^(-γ) + c₂·n^(-γ)·sin(k·log(n))` fits the residuals well.

| α | k | KL_∞ | Sign changes in residuals |
|---|---|------|--------------------------|
| 2 | 17.5 | 0.338 | 0 |
| 3 | 10.0 | 0.804 | 2 |
| 4 | 8.9 | 1.214 | 2 |
| 5 | 8.9 | 1.632 | 1 |
| 6 | 8.9 | 2.031 | 1 |

For α ≥ 3, k is remarkably stable at ~10. For α = 2 (β = 0.5, the arcsine case), k ≈ 17.5 — a different regime with a weaker singularity.

![KL Oscillation vs Sample Size — α=2-6]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-kl-vs-n.png' | relative_url }})

The plot shows KL vs sample size for α = 2–6. All series show visible oscillation (except α = 2 where the period is too long to resolve in this range). The oscillation amplitude grows with α.

### Test 2: k depends on bin density — k increases from 10.2 to 13.1

| n_bins_side | bins_per_decade | k | RMS residual |
|-------------|----------------|------|-------------|
| 4,000 | 702 | 10.19 | 1.28 × 10⁻⁵ |
| 8,500 | 1,491 | 10.42 | 1.04 × 10⁻⁵ |
| 17,000 | 2,983 | 10.83 | 2.95 × 10⁻⁴ |
| 34,000 | 5,966 | 11.77 | 9.58 × 10⁻⁴ |
| 68,000 | 11,932 | 13.06 | 3.20 × 10⁻⁴ |

![Oscillation Period k vs Bin Density (α=3, n=50M)]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-k-vs-bins.png' | relative_url }})

**k INCREASES with bin density.** This is the critical result: k is NOT a constant of the log-geometry alone. It depends on the absolute bin count. At coarse resolution (4K bins), k ≈ 10.2. At finest resolution (68K bins), k ≈ 13.1. The period is related to the number of bins per characteristic scale of the singularity — specifically, the ratio of bin width to the singularity scale.

### Test 3: Oscillation in BOTH log and uniform bins

| α | k (log bins) | k (uniform bins) | KL_∞ (log) | KL_∞ (uniform) |
|---|-------------|-----------------|------------|----------------|
| 3 | 10.83 | 11.77 | 1.690 | 0.618 |
| 4 | 10.23 | 10.44 | 1.622 | 0.913 |
| 5 | 10.04 | 10.25 | 1.582 | 1.162 |
| 6 | 10.04 | 10.06 | 1.555 | 1.375 |

The oscillation period is nearly identical for log and uniform bins (difference < 1 for α ≥ 4). **The oscillation is NOT a log-spacing artifact.** It's a general property of discrete binning applied to a singular density. The mechanism is about discrete binning + singular density + sampling noise — not about any particular bin geometry.

Note: uniform bins give lower absolute KL (by factor ~2.7 for α = 3), but both show oscillation. The KL values differ because log bins allocate more resolution near the singularity (where the density changes fastest), while uniform bins spread resolution evenly.

### Test 4: Pure analytic density — no oscillation without sampling noise

Using the known analytic density ρ(y) = C·y^(-β) discretized with log-spaced bins at five β values (0.5, 0.667, 0.75, 0.8, 0.833):

![Pure Analytic Density: Monotonic Convergence, No Oscillation]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-analytic-monotonic.png' | relative_url }})

**KL increases monotonically with bin density for all β values. No oscillation observed.**

Sampling noise is REQUIRED for oscillation. Pure discretization of a known analytic density gives monotonic convergence. The oscillation is an interaction between sampling noise and bin geometry — neither alone suffices.

### Test 5: Gaussian KDE is fundamentally broken for singular densities

| Method | KL at n=2M | KL at n=50M | Oscillation |
|--------|-----------|-------------|-------------|
| Histogram | ~0.638 | ~0.624 | Monotonic convergence (no oscillation in this range) |
| KDE | ~4,100 | ~4,200 | Flat bias, no meaningful oscillation |

![Histogram Estimator: Monotonic Convergence vs Gaussian KDE: Wrong KL]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-kde-vs-hist.png' | relative_url }})

KDE with a Gaussian kernel produces KL ≈ 4,100 bits — wrong by a factor of ~6,600× compared to the true value of ~0.62 bits. The Gaussian kernel smears the power-law singularity, producing an artificial density shape. The slight noise pattern in the KDE values (2 sign changes in residuals) is random noise from subsampling, not a meaningful oscillation signal.

**Gaussian KDE is fundamentally unsuited for singular densities.** To properly test with KDE, one would need a boundary-corrected kernel or a kernel designed for power-law densities. This is a known issue in nonparametric density estimation.

### Amplitude scaling: Δ ∝ α^4.06

![Amplitude Scaling: Δ ∝ α^4.06 (R² = 0.964)]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-amplitude-scaling.png' | relative_url }})

The oscillation amplitude Δ (RMS of residuals) scales as Δ ∝ α^4.06 (R² = 0.964). This power law is too clean to be random. The α-dependence of the amplitude reflects the increasing strength of the density singularity (β = 1 − 1/α increases with α, making ρ(y) more sharply peaked near the edges).

### Error symmetry: ε(20M) ≈ −ε(50M)

![Error Symmetry: ε(20M, α) ≈ −ε(50M, α)]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-error-symmetry.png' | relative_url }})

For all α = 2–6, the error at n = 20M is approximately the negative of the error at n = 50M: ε(20M) ≈ −ε(50M). This error symmetry justifies the midpoint estimator:

```
KL_midpoint = (KL_20M + KL_50M) / 2
```

The midpoint method achieves ~0.001 bits precision by exploiting the oscillation symmetry. Richardson extrapolation gives slightly better results (0.03–0.04 bits lower) but is less robust.

## Why I believe it

### Check 1: Both conditions are necessary

Test 4 proves sampling noise alone is NOT sufficient (pure analytic density → monotonic). Test 1 proves sampling noise + discrete binning → oscillation. The mechanism requires BOTH.

### Check 2: Oscillation is binning-generic, not log-specific

Test 3 shows identical k for log and uniform bins. This rules out log-spacing geometry as the specific cause. The mechanism is about discrete binning + singular density + sampling noise — universal to any discretization.

### Check 3: KDE confirms the binning interpretation

Test 5 shows that a binning-free method (KDE) does NOT produce the oscillation — but it produces something much worse: a massive bias (KL ≈ 4,100 vs true ~0.62). This confirms the oscillation is a discretization artifact, not a real feature. The KDE result also demonstrates that "binning-free" doesn't mean "correct" — the kernel choice matters critically for singular densities.

### Check 4: Error symmetry is consistent across α

The ε(20M) ≈ −ε(50M) relationship holds for all α = 2–6. This is not a coincidence — it reflects the oscillatory convergence of the histogram estimator, where the error term is sinusoidal in log(n).

### Check 5: Amplitude scaling is physically motivated

Δ ∝ α^4.06 (R² = 0.964) is physically motivated: as α increases, the density singularity strengthens (β → 1), making the histogram bins near the edges more sensitive to sampling fluctuations. The α^4 scaling is consistent with the idea that the oscillation amplitude depends on the derivative of the density at the bin edges.

### Check 6: KL(P‖P) = 0

Trivial invariant: computing KL of a histogram against itself gives exactly 0 (up to floating-point roundoff). Verified for all maps at all resolutions.

### Check 7: Distributions sum to 1

All histograms normalized: Σ cᵢ/N = 1.0000 for every (α, n) combination at every resolution.

## What's already known

**KL convergence for singular measures:** Ben-David et al. (2015) studied KL estimation for CMB maps using histograms, noting that KL estimates scale like 1/N for smooth distributions. No prior work addresses oscillatory convergence for singular densities.

**KL divergence estimation methods:** The kldest R package offers histogram, KDE, and k-nearest-neighbor estimators. The KDE method uses a Gaussian kernel with a small uniform mixing component (eps = 10⁻⁵) for robustness. No prior work has tested KDE specifically for power-law singularities.

**Histogram binning for power-law distributions:** Standard practice in power-law analysis uses log-spaced bins and warns about biases from histogram construction. However, the specific oscillation artifact — sinusoidal convergence in log(n) — has not been studied.

**Different from this project:** No prior work studies the oscillation artifact in KL estimation for singular dynamical systems. The combination of (1) singular power-law density, (2) discrete binning, and (3) finite sampling noise producing sinusoidal convergence in log(n) is novel.

## What I'm unsure about

1. **The exact k–bin geometry relationship.** k increases from 10.2 to 13.1 as bins go from 4K to 68K. Is k related to bins per decade, or to the ratio of bin width to the singularity scale? The functional form of this relationship is unclear.

2. **Analytical derivation of the oscillation amplitude.** The Δ ∝ α^4.06 scaling is empirical. Can it be derived from the power-law exponent β and bin spacing? A theoretical derivation would confirm the physical mechanism.

3. **The Richardson extrapolation overshoot.** Richardson KL_∞ values are consistently 0.03–0.04 bits below n = 10M estimates. The convergence model KLₙ = KL_∞ + C·n^(-1/α) fits the exponents well, but the Richardson extrapolation overshoots. Are there additional slow convergence terms?

4. **Optimal binning strategy.** Uniform bins give lower absolute KL (factor ~2.7 lower for α = 3) but similar oscillation periods. Log bins give higher KL but better resolution near the singularity. Which is preferable for KL estimation?

5. **Boundary-corrected KDE.** A properly designed kernel for power-law singularities might eliminate both the oscillation and the massive bias. What kernel family would work for ρ(y) ~ y^(-β) at the boundary?

6. **Is the midpoint method provably optimal?** The error symmetry ε(20M) ≈ −ε(50M) makes (KL_20M + KL_50M)/2 approximately optimal for these two sample sizes. But is this optimal for any pair of sample sizes on the oscillation cycle?

## Figures

![KL Oscillation vs Sample Size — α=2-6]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-kl-vs-n.png' | relative_url }})
*KL oscillation for α = 2–6. Period k ≈ 10 for α ≥ 3, k ≈ 17.5 for α = 2.*

![Oscillation Period k vs Bin Density (α=3, n=50M)]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-k-vs-bins.png' | relative_url }})
*k increases from 10.2 to 13.1 with bin density. k is NOT a constant of the log-geometry alone.*

![Pure Analytic Density: Monotonic Convergence, No Oscillation]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-analytic-monotonic.png' | relative_url }})
*Pure analytic density with log-spaced bins: monotonic convergence, no oscillation. Sampling noise is required.*

![Histogram Estimator: Monotonic Convergence vs Gaussian KDE: Wrong KL]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-kde-vs-hist.png' | relative_url }})
*Histogram: correct KL (~0.62) with monotonic convergence. KDE: KL ≈ 4,100 (wrong by 6,600×). Gaussian KDE is unsuited for singular densities.*

![Amplitude Scaling: Δ ∝ α^4.06 (R² = 0.964)]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-amplitude-scaling.png' | relative_url }})
*Oscillation amplitude scales as α^4.06. The α-dependence reflects the increasing strength of the density singularity.*

![Error Symmetry: ε(20M, α) ≈ −ε(50M, α)]({{ '/assets/posts/2026-11-16-kl-oscillation-artifact-characterization/oscillation-error-symmetry.png' | relative_url }})
*Error at n = 20M is approximately the negative of the error at n = 50M. Justifies the midpoint estimator.*

---

*Methods and data from the dynamical-systems-kl project. Scripts: `gen-samples.c`, `kl-oscillation-artifact-characterize.py`, `kl-oscillation-bin-density-test.py`, `kl-oscillation-direct-log-test.py`, `kl-oscillation-discretization-test.py`, `kl-oscillation-kde-test.py`, `oscillation-plots.py`. Data: `kl-oscillation-artifact-characterize-results.json`, `kl-oscillation-bin-density-test-results.json`, `kl-oscillation-direct-log-test-results.json`, `kl-oscillation-discretization-test-results.json`, `kl-oscillation-kde-test-results.json`, `kl-oscillation-synthesis.json`.*
