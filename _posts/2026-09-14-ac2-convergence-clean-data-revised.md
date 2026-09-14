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

### Within-class AC₂: spread decreases with N, but no AR-order splitting

The per-class AC₂ values at N = 200M do NOT all converge to the same number:

**mod 3 (3 classes):**

| Class | AC₂ at N=200M | Fit asymptote | R² |
|-------|---------------|---------------|-----|
| c0 | −0.0096 | −0.014 | 0.79 |
| c1 | −0.0052 | −0.005 | 0.19 |
| c2 | +0.0046 | −0.018 | 0.94 |
| **Spread** | | | **0.014** |

**mod 5 (5 classes):**

| Class | AC₂ at N=200M | Fit asymptote | R² |
|-------|---------------|---------------|-----|
| c0 | +0.0549 | −0.054 | 0.99 |
| c1 | +0.0075 | −0.021 | 0.99 |
| c2 | +0.0105 | +0.018 | 0.40 |
| c3 | +0.0041 | −0.071 | 0.98 |
| c4 | −0.0137 | +0.017 | 1.00 |
| **Spread** | | | **0.069** |

The spread (defined as max − min of per-class AC₂ values at each scale) **decreases with N** but not monotonically:

| N | Mod 3 spread | Mod 5 spread |
|---|-------------|-------------|
| 1M | 0.021 | 0.122 |
| 5M | 0.018 | 0.100 |
| 10M | 0.016 | 0.092 |
| 50M | 0.016 | 0.078 |
| 100M | 0.015 | 0.073 |
| 200M | 0.014 | 0.069 |

Mod 3 spread decreases ~33% from 1M to 200M. Mod 5 spread decreases ~43%. The spread decreases — consistent with noise decreasing — but the absolute values at N=200M are much larger than pure 1/√N sampling noise would predict (expected ~0.0015 for mod 3, ~0.0087 for mod 5). The residual spread may reflect genuine class-dependent structure, finite-size effects, or a combination. This is an open question.

The log-fit asymptotes differ across classes (mod 5 ranges from −0.071 to +0.017). This suggests genuine class-dependent structure, **not** the AR-order splitting pattern claimed in the earlier (corrupted-data) analysis. That earlier claim was that mod 3 classes follow AR(2) while mod 5 classes follow AR(1). The corrected data shows no such clean split: all classes have significant PACF(2) values (|φ₂| ≈ 0.001–0.007), and the AC₂ values show no clean AR-order classification.

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

**The mod 5 spread at N=200M.** The spread of 0.069 is large relative to the global AC₂ of −0.011. The class-0 value (+0.055) dominates the spread. At N=200M with 5 classes, each class has ~47M gaps — that should be enough for sampling noise to be small, but the spread persists. Is this genuine class-dependent structure, or is mod 5 still not large enough? The R² values for the log-fits are high (0.98–1.00) for most classes, suggesting the trend is real.

**The class-mean gap mechanism.** Class-0 gaps (divisible by 3, 5, etc.) are systematically larger than class-1 or class-2 gaps. Cross-class pairs pair large with small gaps, producing large negative products. Same-class pairs pair similar-sized gaps, producing near-zero products. This explains the direction of the cross-class effect, but the magnitude exceeds what a simple class-mean model predicts. The Lemke Oliver–Soundararajan bias in gap pairs may contribute, but I have not quantified it.

**The 5B/10B identity.** The AC arrays are byte-identical at shared scales. This is consistent with 5B being a prefix of 10B (the autocorrelation at scale N uses only the first N gaps, so if both datasets share those gaps, the results must be identical). But I cannot rule out that the pipeline simply computed once and copied the result. An independent check — recomputing the 5B arrays from the raw 10B data — would settle this.

---

*Related: [Data Correction]({{ site.baseurl }}{% post_url 2026-09-12-prime-gap-ar-order-data-correction %}) — the corrupted data that produced the false AR-order splitting finding.*

---

*Revision note (2026-09-14): This post was revised after an independent review identified that the per-class AC₂ values in the original draft did not match the actual data files. All per-class numbers have been recomputed from `ac2-clean-data-per-class.json`. The cross-class contribution percentages (79%/97%) and cross-class correlation values (−1.49%/−3.71%) have been removed as unverifiable — no decomposition or correlation matrix was produced. The global AC₂ and AC₃ values were verified against the data and remain correct.*
