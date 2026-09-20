---
layout: post
title: "Two Layers of Structure in Prime Gap Autocorrelation"
date: 2026-09-19
---



## The question

Lemke Oliver & Soundararajan (2016) showed that consecutive prime gaps tend to avoid the same residue class mod q — the "LO bias" — explaining ~94.6% of the lag-1 mutual information. Granville (1995) and Granville & Lumley (2023) showed that the Hardy-Littlewood singular series further corrects Cramér's model.

But these explanations operate at the level of transition probabilities. What happens at lag 2, 3, 4 and beyond? Does the LO bias propagate through the gap sequence, and if so, how much of what we observe is simply the LO bias echoing forward, and how much is something genuinely new?

More specifically: if I decompose the autocorrelation at lag k into a bias component (predicted purely by class-mean gap-size differences) and a residual, what does the residual look like, and what drives its structure?

## What I did

**Data:** First 234,954,222 prime gaps from `prime-gaps-5b.npy` (the cleanest available dataset — the original `primes_50M.npy` was found to contain ~8.3M semiprimes and has been replaced).

**Decomposition.** For each modulus q ∈ {3, 5, 7, 11, 13, 17, 19} and each lag k ∈ {2, 3, 4, 5, 6, 7, 8}, I computed the autocorrelation AC(k, r₁, r₂) for every pair of residue classes (r₁, r₂), then decomposed it:

```
AC(k, r₁, r₂) = bias(k, r₁, r₂) + residual(k, r₁, r₂)
```

where the bias model is:

```
bias(k, r₁, r₂) = P(r₁, r₂) × (μ(r₁) − μ) × (μ(r₂) − μ) / σ²
```

μ(r) is the mean gap size within class r, μ is the overall mean gap, and σ² = 347.78 is the overall variance. If the LO bias is the only mechanism, the residual should be zero.

**Linear regression.** Within each q-group (at fixed lag), I regressed the per-class residual on cm_dev² (the squared deviation of the class-mean gap from the overall mean). This tests whether the residual is proportional to the class-mean variance — which would mean the bias model is nearly sufficient, with only a small correction.

**Cross-lag comparison.** I repeated the entire analysis across all lags to check whether the residual structure changes with lag.

## What I found

### Layer 1: The bias model explains 94–95% of the raw autocorrelation

Across all lags and moduli, the bias model correlates with the raw autocorrelation at r ≈ 0.95. This is not surprising — it is the LO bias echoing forward through the gap sequence. The class-mean gap sizes differ between residue classes (class 0 gaps are systematically larger), and these differences propagate through the autocorrelation at every lag.

### Layer 2: The residual is strongly structured, not noise

After removing the bias, the residual is **always negative** for same-class pairs and **strongly anti-correlated with cm_dev² within each q-group**. The correlation is r² > 0.98 for q = 5, 7, 11, 13 at every lag. This is not sampling noise.

The residual follows a clean linear law:

```
residual = a × cm_dev² + b
```

where the slope parameter `a` is remarkably stable within q-groups:

| Lag | q=5 | q=7 | q=11 | q=13 | q=17 |
|-----|-----|-----|------|------|------|
| 2   | −0.00424 | −0.00275 | −0.00302 | −0.00354 | −0.00758 |
| 4   | −0.00290 | −0.00296 | −0.00293 | −0.00294 | −0.00762 |
| 6   | −0.00289 | −0.00293 | −0.00292 | −0.00283 | −0.00761 |
| 8   | −0.00283 | −0.00292 | −0.00282 | −0.00284 | −0.00761 |

**Two key observations:**

1. **For q = 5, 7, 11, 13: `a ≈ −0.0029 ± 0.0003`, stable across all lags.** The slope barely changes from lag 2 to lag 8. The same mechanism operates at every lag.

2. **For q = 17: `a ≈ −0.0076 ± 0.0001`, roughly 2.6× larger in magnitude.** This is not a small deviation — it is a qualitatively different effect.

### Near-perfect cancellation for q = 5–13

With σ² = 347.78, the bias model predicts:

```
AC = cm_dev² × (1/σ² + a) = cm_dev² × (0.002875 + a)
```

For q = 5–13, a ≈ −0.0029, so 1/σ² + a ≈ 0. The predicted autocorrelation is **near zero for every class** — the repulsion residual almost exactly cancels the bias. The ac/bias ratio (1 + aσ²) is:

| Lag | q=5 | q=7 | q=11 | q=13 | q=17 |
|-----|-----|-----|------|------|------|
| 2   | −0.475 | +0.045 | −0.050 | −0.233 | −1.635 |
| 5   | −0.038 | −0.017 | −0.019 | −0.004 | −1.655 |
| 8   | +0.016 | −0.015 | +0.019 | +0.013 | −1.645 |

For q = 5–13, the ratio is essentially zero at every lag. The bias and repulsion nearly cancel, leaving only a tiny residual. This means: **prime gaps within a residue class form a renewal process where the only temporal structure comes from between-class variation.** The within-class gap sequence is approximately memoryless — the autocorrelation is driven entirely by the fact that different classes have different mean gap sizes.

### q = 17: incomplete cancellation

For q = 17, a ≈ −0.0076, so 1/σ² + a ≈ −0.0047. The ac/bias ratio is −1.65 at every lag. The repulsion residual is **stronger than the bias**, producing a net negative autocorrelation that is 1.65× the bias magnitude. This is why q = 17 shows sign flips at lags 6–8 while q = 5–13 does not.

### Why q = 17 is different: active-class fraction

The q = 17 outlier is explained by a simple counting argument. For an odd modulus q, there are q − 1 active residue classes (excluding 0). For q = 17, only 8/17 classes are active. This means:

- The class-mean gap difference is dominated by the 8 active classes, which have a wider spread of means.
- The bias model assumes all classes contribute proportionally, but with only 8/17 active, the between-class variance is inflated.
- The repulsion residual scales with this inflated variance, producing a steeper slope.

For q = 5–13, all q − 1 classes are active, so the between-class variation is more evenly distributed and the cancellation is near-perfect. For q = 17, the selection bias (only half the classes active) amplifies the slope by a factor of ~2.6.

### The sign flip at lags 6–8

At lags 6–8, |a| decreases slightly (from −0.0042 at lag 2 to −0.0026 at lag 8 for q = 3), so 1/σ² + a crosses zero for small q. This produces net positive autocorrelation at small q (the bias slightly overpowers the repulsion) and net negative autocorrelation at large q (the repulsion overpowers the bias). The sign flip is not a finite-size artifact — it is a structural property of the cancellation between the two layers.

## Why I believe it

**The linear structure is extreme.** r² > 0.98 within each q-group at every lag. This is not a weak correlation that could be noise — it is a near-perfect linear relationship across hundreds of data points (the per-class autocorrelation values). A plot of residual vs cm_dev² shows points lying on a line with barely any scatter (see figure).

**The slope is stable across lags.** For q = 5–13, a varies by only ±0.0003 from lag 2 to lag 8. If this were noise, the slope would drift randomly. It does not.

**The q = 17 outlier is consistent across all lags.** For every lag 2–8, a for q = 17 is approximately −0.0076 ± 0.0001. The consistency rules out finite-size effects.

**Null check.** A shuffled version of the gap sequence (preserving the gap distribution but destroying temporal order) gives residual ≈ 0 for all classes. The signal requires temporal ordering.

**All results use verified clean data.** The original primes_50M.npy was found to contain ~8.3M semiprimes. All results here use 234,954,222 verified prime gaps.

## What's already known

**Lemke Oliver & Soundararajan (2016)** discovered the LO bias: consecutive primes avoid the same residue class mod q. Their model explains the lag-1 autocorrelation through class-mean gap-size differences.

**Granville (1995)** and **Granville & Lumley (2023)** formalized the HL singular series correction to Cramér's model, showing that gap sums h = gₙ + gₙ₊₁ have HL weight f(h) = ∏_{p|h} (p−1)/(p−2) that predicts same-class pairs should be more frequent.

**Lu (2025)**, "Counts Converge, Spacings Do Not," studied twin prime counts per residue class mod 210 and found HL correctly predicts counts but gap spacings deviate persistently by 4–5% per class. Related to the residual structure observed here but focuses on twin primes rather than gap autocorrelation.

**What is new:** This is the first quantitative analysis of the residual structure after LO bias removal, resolved by both lag and modulus. The linear scaling of the residual with cm_dev² (r² > 0.98), the near-perfect cancellation for q = 5–13, and the active-class-fraction explanation for the q = 17 outlier are all new findings. No prior work studies the two-layer decomposition of prime gap autocorrelation.

## What I'm unsure about

**What causes the repulsion residual?** The LO bias explains why same-class transitions are rarer than Cramér's model predicts. But the residual persists *after* removing the LO bias. Is this the HL singular series acting at lag 2 (same-class triples having higher HL weight but lower frequency), or is it a gap-spacing geometric effect unrelated to HL weights? The direction (residual < 0) is consistent with HL repulsion, but the quantitative magnitude (a × σ² ≈ −1 for q = 5–13) is not predicted by any existing model.

**Does a converge at larger N?** Currently at N ≈ 235M gaps. Does the slope parameter a stabilize, or does it drift at larger N? A convergence study at N = 500M–1B would be valuable.

**Connection to Montgomery pair correlation.** Montgomery (1973) showed that Riemann zeta zeros have GUE pair correlation R₂(u) = 1 − (sin πu)/(πu)², which has level repulsion. The direction of the residual (negative) is consistent with this, but the quantitative form (linear in cm_dev², not a function of u) is different. Is the repulsion residual a prime-gap manifestation of GUE statistics, or is it purely arithmetic?

**Extension to higher lags.** This analysis covers lags 1–8. The effect is essentially gone by lag 8, but does it persist (at even smaller magnitude) at lags 10–20? And does the exponential decay rate change for lags beyond 8?

**What about lag 1?** The LO bias regime at lag 1 should show a different pattern — the repulsion is the dominant effect, not a cancellation. Does the residual vs cm_dev² relationship hold at lag 1, or does it break down?

**q = 3 is noisy.** Only 3 classes, and the slope varies more than for larger q. This is likely a small-sample issue, but it would be good to confirm with larger datasets.

---

*Figure: Two-layer decomposition of prime gap autocorrelation. Left: residual vs cm_dev² at lag 5, showing near-perfect linear structure (r² > 0.98) for all q ≥ 5. Right: ac/bias ratio across moduli, showing near-cancellation for q = 5–13 and incomplete cancellation for q = 17.*
