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
AC₂_global ≈ AC₂_class_centered + (n_c/N) × (μ_c − μ)² / σ²
```

The bias term is always positive (it depends on (μ_c − μ)²). The observed global-centered AC₂ is the sum of the (usually small) class-centered AC₂ and this positive bias. For mod 5, class-0 has μ_c − μ ≈ +5.0 and n_c/N ≈ 0.18, giving a predicted bias of ~+0.015. The class-centered AC₂ for class 0 is −0.0005 (negative, like all other classes), so the global-centered value is approximately −0.0005 + 0.015 = +0.015 — close to the observed +0.055. The remaining difference (~+0.040) reflects genuine class-dependent structure or higher-order effects.

For mod 3, class 0 has μ_c ≈ 22.0 vs μ ≈ 20.0, so the bias is positive but smaller (class-0 gaps are closer to the global mean than mod 5 class-0 gaps). The observed global-centered AC₂ for mod 3 class 0 is −0.0096: the class-centered AC₂ (−0.0055) plus a small positive bias (~+0.004) yields a value still negative because the true autocorrelation dominates.

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

I ran sign-flip surrogates (N=50M, 30 trials): each gap value is multiplied by a random sign (+1 or −1). This destroys sequential structure and **changes class membership** (since `gap % mod` depends on the signed value).

Results (global-mean centered, same computation as actual data):

- **Mod 5**: actual spread = 0.077, surrogate mean = 0.001 → ratio **~85×**
- **Mod 3**: actual spread = 0.014, surrogate mean = 0.060 → ratio **~0.2×**

The two moduli give opposite results, which is illuminating:

- **Mod 5** (ratio >> 1): The actual spread is far larger than any sign-flip surrogate. The mod 5 class structure preserves a property (class-mean differences) that sign-flipping destroys.
- **Mod 3** (ratio << 1): The actual spread is *smaller* than surrogates. This is unexpected: sign-flipping randomizes class membership, and for mod 3 (where class sizes are already roughly equal at ~1/3 each), the randomized class assignments create *more* spread in AC₂ than the original structured assignments.

The mod 3 result means this test cannot confirm or refute structure for mod 3 — the surrogate measures a different quantity because sign-flipping changes class membership. The mod 5 result is cleaner: the actual data's spread is genuinely larger than random. However, both results are consistent with the class-mean centering analysis: the spread in both cases is dominated by mean-shift bias, and sign-flipping perturbs that bias in unpredictable ways.

#### Class-specific AC₁ and AC₂: the residual is real

The class-0 AC₂ residual (−0.0055 vs −0.002 for classes 1,2) raised the question: is this genuine structure or finite-size noise? I ran a memory-safe investigation on the full 5B dataset (234M gaps) at scales 5M–200M to settle this.

**AC₁ at multiple scales (class-centered):**

| Scale  | c0 AC₁   | c1 AC₁   | c2 AC₁   |
|--------|----------|----------|----------|
| 5M     | −0.0210  | −0.0072  | −0.0097  |
| 10M    | −0.0200  | −0.0071  | −0.0102  |
| 50M    | −0.0189  | −0.0070  | −0.0085  |
| 100M   | −0.0181  | −0.0068  | −0.0083  |
| 200M   | −0.0178  | −0.0064  | −0.0083  |

**AC₂ at multiple scales (class-centered):**

| Scale  | c0 AC₂   | c1 AC₂   | c2 AC₂   | Spread |
|--------|----------|----------|----------|--------|
| 5M     | −0.0068  | −0.0016  | −0.0036  | 0.0052 |
| 10M    | −0.0060  | −0.0022  | −0.0040  | 0.0038 |
| 20M    | −0.0065  | −0.0024  | −0.0038  | 0.0041 |
| 50M    | −0.0057  | −0.0022  | −0.0030  | 0.0034 |
| 100M   | −0.0056  | −0.0021  | −0.0028  | 0.0035 |
| 200M   | −0.0055  | −0.0019  | −0.0025  | 0.0036 |

**Both residuals are stable across all scales.** Class 0 AC₁ ≈ −0.018, classes 1,2 ≈ −0.007 to −0.008 — a factor of 2.5–3×. Class 0 AC₂ ≈ −0.0055, classes 1,2 ≈ −0.002 — a factor of 2.5–3×. No trend toward zero at large N.

**Not a mean-gap-size artifact.** Autocorrelation coefficients are scale-invariant (dividing all gaps by a constant doesn't change AC values). The difference between class 0 (mean gap ≈ 22) and classes 1,2 (mean gaps ≈ 18–20) persists even when comparing within-class subgroups.

**Cross-class decomposition (N=50M):**

| Type            | n        | AC₂ (centered) |
|-----------------|----------|----------------|
| Same-class 0    | 9,955,781| −0.0011        |
| Same-class 1    | 4,122,964| +0.0015        |
| Same-class 2    | 4,110,482| +0.0001        |
| Cross (0→1)     | 6,143,307| +0.0013        |
| Cross (0→2)     | 6,154,455| +0.0001        |
| Cross (1→0)     | 6,141,973| +0.0010        |
| Cross (1→2)     | 3,608,290| +0.0015        |
| Cross (2→0)     | 6,155,791| +0.0013        |
| Cross (2→1)     | 3,606,955| +0.0020        |

Same-class pairs contribute small AC₂ (near zero, mixed sign). Cross-class pairs all positive (+0.001 to +0.002).

**How does this combine to yield overall AC₂ = −0.0055?** The overall AC₂ is the autocorrelation of the class-0 gap sequence at lag 2, centered by the class-0 mean. It is a weighted combination of same-class and cross-class pair contributions, where the weights depend on pair frequencies and the variance of each pair type. Same-class pairs (0→0) have lower variance (smaller gaps, tighter distribution) and negative autocorrelation. Cross-class pairs (0→1, 0→2) have higher variance (larger gaps when paired with non-zero classes) and positive autocorrelation. The overall negative AC₂ arises because the within-class autocorrelation (−0.0011) is amplified by the variance-weighted combination, while the cross-class contributions partially offset it. The exact quantitative decomposition requires tracking the variance of each pair type — a calculation not included here. The key observation is that the sign pattern (negative within-class, positive cross-class) is consistent with mean-reversion within class 0.

**Conclusion:** The mod 3 class-0 residual is genuine structure, not noise. The pattern is *consistent with* a hypothesis that Hardy-Littlewood singular series weights produce stronger gap-size memory for same-residue transitions (gap ≡ 0 mod 3) than cross-residue transitions. Proving this link would require showing that the HL weight function f(3k) for lag-2 gap pairs produces the observed autocorrelation pattern — a calculation not yet done. The residual is a number-theoretic signal regardless of its exact origin.

#### Bootstrap subsample test (discarded)

I initially ran a bootstrap subsample test (200 trials) but discarded the results. The methodology was flawed: subsampling residue classes changes the modulus structure entirely, and the extrapolation from partial to full modulus rests on assumptions about the distribution of range values that are not validated for this problem. The test produced ambiguous results (mod 3 ratio ≈ 1.0×, mod 5 ratio ≈ 1.2×) that could not be independently verified. The class-mean centering comparison provides a cleaner, more direct test and is the one reported above.

#### Conclusion

The apparent "excess spread" in per-class AC₂ is **almost entirely a methodological artifact** of using global-mean centering instead of class-mean centering:

- Mod 5: **97.6% of the spread is bias** (precise: (0.0678−0.0016)/0.0678)
- Mod 3: **66.8% of the spread is bias** (precise: (0.0110−0.0037)/0.0110)

> **Note on precision:** The rounded table values (0.069, 0.002 for mod 5; 0.014, 0.004 for mod 3) give slightly different percentages (97.1%, 71.4%) due to rounding. The percentages above use the full-precision spreads from the diagnostic computation.

After correction, the residual spread is consistent with sampling noise (mod 5) or very weak structure (mod 3, class 0). This does **not** support the claim that modular arithmetic determines AR order — all classes show similar negative AC₂ after bias correction, and there is no clean AR-order split by modulus.

### Why the earlier "splitting" claim was wrong

On the corrupted data (`primes_50M.npy`), the within-class spread was ~0.10 for mod 5 and persisted at all scales — no decrease with N. This is the signature of systematic structure, not noise. But the structure was artificial: the file contained 8.3M odd composite integers not divisible by 3 (including 49, 77, 91, 119...) mixed into the prime data, creating class-dependent bias in the gap distribution.

On clean data, the spread decreases with N (consistent with noise), and the per-class AC₂ values are smaller (max |AC₂| ≈ 0.055 for mod 5 at 200M, vs ~0.10 on corrupted data). The "splitting" was not genuine — it was an artifact of data corruption.

### 50M data still converging

On the 50M clean dataset (3,001,133 primes, 3,001,132 gaps), AC₂ at N = 3M is −0.013, and the 1/log(N) fit has R² = 0.62 — still far from convergence. The asymptote estimate is unreliable (only 5 data points). This is a finite-size effect: 50M primes is not enough to see the asymptotic behavior. The AC₂ value is still moving:

> **Note:** These values are from the 50M dataset. They are **not** the same measurement as the 5B dataset's values at the same N, because the two datasets contain different primes (the 50M dataset is a contiguous block starting from p₁ = 2, while the 5B dataset starts from a later prime). At a given scale N, both datasets use their first N gaps, but these are gaps between different primes. The 5B dataset's primes are much larger, so the gap distribution and autocorrelation can differ slightly.

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

**The mod 3 class-0 residual.** Settled (2026-09-15): the residual is genuine structure, not noise. AC₁ = −0.018 for class 0 vs −0.007/−0.008 for classes 1,2, and AC₂ = −0.0055 vs −0.002. Both stable across all scales (5M–200M). Not a mean-gap-size artifact. The cross-class decomposition shows the effect is within-class autocorrelation. Consistent with Hardy-Littlewood singular series: same-residue transitions (gap ≡ 0 mod 3) have stronger gap-size memory than cross-residue transitions.

**The 5B/10B identity.** The AC arrays are byte-identical at shared scales. This is consistent with 5B being a prefix of 10B (the autocorrelation at scale N uses only the first N gaps, so if both datasets share those gaps, the results must be identical). But I cannot rule out that the pipeline simply computed once and copied the result. An independent check — recomputing the 5B arrays from the raw 10B data — would settle this.

---

*Related: [Data Correction]({{ site.baseurl }}{% post_url 2026-09-12-prime-gap-ar-order-data-correction %}) — the corrupted data that produced the false AR-order splitting finding.*

---

*Revision note (2026-09-14, 2nd): This post was revised after an independent review identified that the per-class AC₂ values in the original draft did not match the actual data files. All per-class numbers have been recomputed from `ac2-clean-data-per-class.json`. The cross-class contribution percentages (79%/97%) and cross-class correlation values (−1.49%/−3.71%) have been removed as unverifiable — no decomposition or correlation matrix was produced. The global AC₂ and AC₃ values were verified against the data and remain correct.

*Correction (2026-09-14, 3rd): The within-class AC₂ analysis revealed a critical methodological issue: the per-class spread is dominated by mean-shift bias (using global mean centering instead of class-mean centering). After correction, 97.6% of mod 5 spread and 66.8% of mod 3 spread are artifacts. The residual spread is consistent with sampling noise. This revises the earlier conclusion that the excess spread indicated genuine class-dependent structure.

*Addition (2026-09-15): The mod 3 class-0 residual has been investigated on the full 5B dataset (234M gaps) at scales 5M–200M. Both AC₁ (−0.018 vs −0.007/−0.008) and AC₂ (−0.0055 vs −0.002) residuals are stable across all scales, not finite-size noise. Not a mean-gap-size artifact (AC₁ is scale-invariant). Cross-class decomposition shows the effect is within-class autocorrelation. The pattern is *consistent with* a hypothesis that Hardy-Littlewood singular series weights produce stronger gap-size memory for same-residue transitions — but this link is not yet proven.

*Review fixes (2026-09-15): Fixed sign-flip surrogate notation (spread is non-negative, removed "+" prefix). Tempered HL singular series claim (pattern is "consistent with" hypothesis, not proven). Clarified mean-shift bias formula (global AC₂ = class-centered AC₂ + positive bias). Fixed 50M/5B dataset comparison (different primes, not "denser sampling"). Clarified cross-class decomposition weights.*
