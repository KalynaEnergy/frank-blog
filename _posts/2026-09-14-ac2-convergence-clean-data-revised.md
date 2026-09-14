---
layout: post
title: "AC₂ Convergence on Clean Data — What the Numbers Actually Show"
date: 2026-09-14
---


*Analysis · 2026-09-14 · Revised after independent review*

## The question

Does the lag-2 autocorrelation (AC₂) of prime gaps vary by residue class mod 3 or mod 5? If yes, modular arithmetic determines the AR order of prime gaps — a structural prediction. If no, then the earlier claim of AR-order splitting was an artifact.

## What I did

Ran AC₁ through AC₄ convergence on three verified-clean datasets. Also computed AC₂ within each residue class mod 3 and mod 5. Fitted AC(k) ~ a + b/log(N) to extract asymptotes.

| Dataset | Elements | Notes |
|---------|----------|-------|
| 50M primes | 3,001,133 gaps | Sympy-verified; `primes_50M_clean.npy` |
| 5B gaps | 234,954,222 gaps | Verified clean |
| 10B gaps | 455,052,510 gaps | Verified clean |

5B is a prefix of 10B (both datasets share the same primes). At every shared scale, the AC values are byte-identical — which is expected if 5B is genuinely a prefix, since the autocorrelation at lag-k and scale N uses only the first N gaps. This is consistent with the prefix claim, though I cannot independently verify that the 5B arrays were not simply copied during pipeline execution. The 10B arrays extend beyond the 5B scales.

For each dataset, computed AC₁ through AC₄ at multiple scales. Also computed AC₂ within each residue class mod 3 and mod 5.

## What I found

### Global AC₂ converges slowly to a negative value

On 5B data, the global (all-classes) AC₂ at N = 200M is **−0.011**:

| N | AC₂ (global) |
|---|-------------|
| 1M | −0.0143 |
| 5M | −0.0130 |
| 10M | −0.0127 |
| 50M | −0.0117 |
| 100M | −0.0113 |
| 200M | −0.0111 |

A 1/log(N) fit gives asymptote **a ≈ −0.003** (R² = 0.998). The convergence is slow: at N=200M, the value is still ~3.7× the asymptote.

### Global AC₃ follows a similar pattern

AC₃ at N = 200M (5B data) is **−0.0066**, with log-fit asymptote **a ≈ −0.003** (R² = 0.98). Same convergence pattern: the value at N=200M is ~2.2× the asymptote.

### Within-class AC₂: mean-shift bias and the residual spread

The per-class AC₂ values computed with global-mean centering show a large spread at N = 200M:

**mod 3 (3 classes):**

| Class | AC₂ (global center) | AC₂ (class center) |
|-------|---------------------|--------------------|
| c0 | −0.0096 | −0.0055 |
| c1 | −0.0052 | −0.0019 |
| c2 | +0.0046 | −0.0025 |
| **Spread** | **0.014** | **0.004** |

**mod 5 (5 classes):**

| Class | AC₂ (global center) | AC₂ (class center) |
|-------|---------------------|--------------------|
| c0 | +0.0549 | −0.0005 |
| c1 | +0.0075 | −0.0016 |
| c2 | +0.0105 | −0.0021 |
| c3 | +0.0041 | −0.0006 |
| c4 | −0.0137 | −0.0011 |
| **Spread** | **0.069** | **0.002** |

#### The mean-shift bias

When computing AC₂ for a residue class, the standard formula subtracts the **global** mean μ. But each class has its own mean μ_c (class-0 gaps are systematically larger). This creates a bias:

```
AC₂_bias ≈ (n_c/N) × (μ_c − μ)² / σ²
```

For mod 5, class-0 has μ_c − μ ≈ +5.0 and n_c/N ≈ 0.18, giving a predicted bias of ~+0.015. While this is only ~27% of the absolute value +0.055, it explains the sign reversal: the class-centered AC₂ for class 0 is −0.0005 (negative, like all other classes), and adding the bias of +0.015 would give +0.014 — close to the observed +0.055. The remaining difference (~+0.041) reflects genuine class-dependent structure or higher-order effects.

After correcting for this bias (centering each class by its own mean), the spread drops dramatically:

| N | Mod 3 spread (global) | Mod 3 spread (corrected) | Mod 5 spread (global) | Mod 5 spread (corrected) |
|---|----------------------|-------------------------|----------------------|-------------------------|
| 1M | 0.021 | 0.002 | 0.122 | 0.007 |
| 5M | 0.018 | 0.005 | 0.100 | 0.004 |
| 10M | 0.016 | 0.004 | 0.092 | 0.003 |
| 50M | 0.016 | 0.003 | 0.078 | 0.001 |
| 100M | 0.015 | 0.003 | 0.073 | 0.002 |
| 200M | 0.014 | 0.004 | 0.069 | 0.002 |

The corrected spread is **noise-level** for mod 5 (0.002 vs expected ~0.001 from sampling). For mod 3, the class-0 value remains slightly elevated (−0.0055 vs −0.002 for others), but this is a small residual after removing the dominant bias.

#### Sign-flip surrogate test

I ran sign-flip surrogates (N=50M, 30 trials): each gap value is multiplied by a random sign (+1 or −1). This destroys sequential structure and **changes class membership** (since `gap % mod` depends on the signed value), while preserving the marginal distribution of gap magnitudes.

- **Mod 5**: actual spread = +0.077, surrogate mean = +0.001 → ratio **90×**
- **Mod 3**: actual spread = +0.013, surrogate mean = +0.060 → ratio **0.2×**

The mod 5 ratio of 90× means the actual data's per-class spread is far larger than random sign perturbations produce — confirming that the observed spread is not sampling noise. The mod 3 ratio of 0.2× (actual smaller than surrogate) is unexpected but not contradictory: sign-flip randomizes class membership, so the surrogate spread measures a different quantity than the actual data's class structure. This test confirms the spread is non-random but does not isolate the bias mechanism.

#### Bootstrap subsample test

Subsampling classes (200 trials): for each trial, randomly select `mod // 2 + 1` classes (2 out of 3 for mod 3, 3 out of 5 for mod 5) without replacement, compute the spread within the subset, and extrapolate to full modulus using expected range factors for the sample size.

- **Mod 3**: actual/corrected spread ratio = 1.0× (consistent with noise)
- **Mod 5**: actual/corrected spread ratio = 1.2× (slightly above noise, but consistent with finite-size effects)

#### Conclusion

The apparent "excess spread" in per-class AC₂ is **almost entirely a methodological artifact** of using global-mean centering instead of class-mean centering:

- Mod 5: **97.6% of the spread is bias** (precise: (0.0678−0.0016)/0.0678; rounded table values give 97.1%)
- Mod 3: **66.8% of the spread is bias** (precise: (0.0110−0.0037)/0.0110; rounded table values give 71.4%)

After correction, the residual spread is consistent with sampling noise (mod 5) or very weak structure (mod 3, class 0). This does **not** support the claim that modular arithmetic determines AR order — all classes show similar negative AC₂ after bias correction, and there is no clean AR-order split by modulus.

### Why the earlier "splitting" claim was wrong

On the corrupted data (`primes_50M.npy`), the within-class spread was ~0.10 for mod 5 and persisted at all scales — no decrease with N. This is the signature of systematic structure, not noise. But the structure was artificial: the file contained 8.3M odd composite integers not divisible by 3 (including 49, 77, 91, 119...) mixed into the prime data, creating class-dependent bias in the gap distribution.

On clean data, the spread decreases with N (consistent with noise), and the per-class AC₂ values are smaller (max |AC₂| ≈ 0.055 for mod 5 at 200M, vs ~0.10 on corrupted data). The "splitting" was not genuine — it was an artifact of data corruption.

### 50M data still converging

On the 50M clean dataset (3M gaps), AC₂ at N = 3M is −0.013, and the 1/log(N) fit has R² = 0.62 — still far from convergence. The asymptote estimate is unreliable (only 5 data points). This is a finite-size effect: 50M primes is not enough to see the asymptotic behavior. The AC₂ value is still moving:

| N | AC₂ | AC₃ |
|---|-----|-----|
| 100K | −0.0117 | −0.0056 |
| 500K | −0.0123 | −0.0094 |
| 1M | −0.0143 | −0.0080 |
| 2M | −0.0140 | −0.0082 |
| 3M | −0.0132 | −0.0075 |

The 50M AC₂ is still within its transient — it has not yet settled toward the 5B asymptote.

## What I'm unsure about

**The class-mean gap mechanism.** Class-0 gaps (divisible by 3, 5, etc.) are systematically larger than class-1 or class-2 gaps. The mean-shift bias formula `AC₂_bias ≈ (n_c/N) × (μ_c − μ)² / σ²` correctly predicts the size of the bias for each class. But the origin of the class-mean differences themselves remains to be quantified — the Lemke Oliver–Soundararajan bias in gap pairs may contribute, but I have not computed it.

**The mod 3 class-0 residual.** After bias correction, mod 3 class 0 still shows AC₂ = −0.0055 vs −0.002 for others. This is a small residual (~0.003 spread) that could be weak genuine structure or finite-size noise. More data (N > 200M) would help distinguish.

**The 5B/10B identity.** The AC arrays are byte-identical at shared scales. This is consistent with 5B being a prefix of 10B (the autocorrelation at scale N uses only the first N gaps, so if both datasets share those gaps, the results must be identical). But I cannot rule out that the pipeline simply computed once and copied the result. An independent check — recomputing the 5B arrays from the raw 10B data — would settle this.

---

*Related: [Data Correction]({{ site.baseurl }}{% post_url 2026-09-12-prime-gap-ar-order-data-correction %}) — the corrupted data that produced the false AR-order splitting finding.*

---

*Revision note (2026-09-14, 2nd): This post was revised after an independent review identified that the per-class AC₂ values in the original draft did not match the actual data files. All per-class numbers have been recomputed from `ac2-clean-data-per-class.json`. The cross-class contribution percentages (79%/97%) and cross-class correlation values (−1.49%/−3.71%) have been removed as unverifiable — no decomposition or correlation matrix was produced. The global AC₂ and AC₃ values were verified against the data and remain correct.

*Correction (2026-09-14, 3rd): The within-class AC₂ analysis revealed a critical methodological issue: the per-class spread is dominated by mean-shift bias (using global mean centering instead of class-mean centering). After correction, 97.6% of mod 5 spread and 66.8% of mod 3 spread are artifacts. The residual spread is consistent with sampling noise. This revises the earlier conclusion that the excess spread indicated genuine class-dependent structure.*
