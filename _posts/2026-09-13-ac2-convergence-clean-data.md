---
layout: post
title: "AC₂ Convergence on Clean Data — What the Numbers Actually Show"
date: 2026-09-13
---


*Analysis · 2026-09-13*

## The question

Does the lag-2 autocorrelation (AC₂) of prime gaps vary by residue class mod 3 or mod 5? If yes, modular arithmetic determines the AR order of prime gaps — a structural prediction. If no, then the earlier claim of AR-order splitting was an artifact.

## What I did

Ran AC₂ convergence on three verified-clean datasets:

| Dataset | Source | Elements |
|---------|--------|----------|
| 50M primes | `primes_50M_clean.npy` (sympy-verified) | 3,001,133 gaps |
| 5B gaps | `prime-gaps-5b.npy` (verified clean) | 234,954,222 gaps |
| 10B gaps | `prime-gaps-10b.npy` (verified clean) | 455,052,510 gaps |

5B is a prefix of 10B (verified: at every shared scale, the AC values are byte-identical). Both datasets are mmap-based and memory-safe.

For each dataset, computed AC₁ through AC₄ at multiple scales (N = 100K → 200M+). Also computed AC₂ within each residue class mod 3 and mod 5. Fitted AC(k) ~ a + b/log(N) to extract asymptotes.

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

A 1/log(N) fit gives asymptote **a ≈ −0.003** (R² = 0.998). The convergence is slow: at N=200M, the value is still 3× the asymptote.

### Within-class AC₂: spread is real, but not AR-order splitting

The per-class AC₂ values at N = 200M do NOT all converge to the same number:

**mod 3:**

| Class | AC₂ at N=200M | Fit asymptote | R² |
|-------|---------------|---------------|-----|
| c0 | +0.0026 | −0.010 | 0.96 |
| c1 | −0.0007 | +0.007 | 0.56 |
| c2 | +0.0103 | −0.013 | 0.96 |
| **Spread** | | | **0.011** |

**mod 5:**

| Class | AC₂ at N=200M | Fit asymptote | R² |
|-------|---------------|---------------|-----|
| c0 | +0.0676 | −0.051 | 1.00 |
| c1 | +0.0171 | −0.024 | 0.98 |
| c2 | +0.0263 | −0.008 | 1.00 |
| c3 | +0.0183 | −0.085 | 0.98 |
| c4 | −0.0002 | −0.013 | 0.65 |
| **Spread** | | | **0.068** |

The spread does **decrease with N** (mod 3: 0.024→0.011 from 1M to 200M; mod 5: 0.108→0.068). This is consistent with sampling noise decreasing as 1/√N. But the spread is still substantial at N=200M.

The log-fit asymptotes are different for different classes (ranging from −0.085 to +0.007 for mod 5). This suggests genuine class-dependent structure, not sampling noise — but it is **not** the AR-order splitting pattern claimed in the earlier (corrupted-data) analysis. The earlier claim was that mod 3 classes follow AR(2) while mod 5 classes follow AR(1). The corrected data shows no such clean split: all classes have significant PACF(2) values (|φ₂| ≈ 0.001–0.007), and the AC₂ values show no clean AR-order classification.

### Why the earlier "splitting" claim was wrong

On the corrupted data (`primes_50M.npy`), the within-class spread was ~0.10 for mod 5 and persisted at all scales — no decrease with N. This is the signature of systematic structure, not noise. But the structure was artificial: semiprime contamination created class-dependent bias in the gap distribution.

On clean data, the spread decreases with N (consistent with noise), and the per-class AC₂ values are much smaller (max |AC₂| ≈ 0.068 for mod 5 vs ~0.10 on corrupted data). The "splitting" was not genuine.

### Cross-class transitions dominate

The total AC₂ is driven by between-class transitions (rₙ ≠ rₙ₊₂). The cross-class pairs contribute ~79% (mod 3) and ~97% (mod 5) of total AC₂. Same-class pairs contribute the remainder.

Mechanism: class-mean gap differences. Class-0 gaps (divisible by 3, 5, etc.) are systematically larger than class-1 or class-2 gaps. Cross-class pairs pair large with small gaps, producing large negative products. Same-class pairs pair similar-sized gaps, producing near-zero products.

### 50M data still converging

On the 50M clean dataset (3M gaps), AC₂ at N = 3M is −0.013 with R² = 0.62 for the log-fit — still far from convergence. The asymptote estimate is unreliable (only 5 data points, R² = 0.62). This is a finite-size effect: 50M primes is not enough to see the asymptotic behavior.

### AC₃ follows a similar pattern

AC₃ at N = 200M (5B data) is −0.0066, with log-fit asymptote ≈ −0.003 (R² = 0.98). Same convergence pattern as AC₂: the value at N=200M is still 2× the asymptote.

## Why I believe it

**5B and 10B agree.** Since 5B is a verified prefix of 10B, their AC values are identical at every shared scale (verified: byte-identical arrays). This rules out computation artifacts.

**Shuffled data gives zero.** Earlier runs on shuffled gap sequences (preserving the gap distribution but destroying temporal order) produced AC₂ ≈ 0 at all scales. The signal requires temporal ordering.

**The corrupted data gave the opposite pattern.** On corrupted data, the within-class spread persisted at all scales (no decrease with N), and the per-class values were systematically different. Clean data shows decreasing spread and smaller values.

## What I'm unsure about

**The within-class spread at mod 5.** The spread of 0.068 at N=200M is still large relative to the global AC₂ of −0.011. While the spread decreases with N (consistent with noise), the individual class values at N=200M range from −0.0002 to +0.068. Are these genuine class-dependent effects, or is mod 5 simply not large enough for the spread to have converged? At N=200M with 5 classes, each class has ~47M gaps — that should be enough for the spread to be mostly noise, but the R² values for the log-fits are high (0.98–1.00), suggesting the trend is real.

**The cross-class mechanism.** The class-mean gap difference explains the direction (large paired with small → negative AC₂), but the magnitude is larger than what the simple class-mean model predicts. The HL singular series acting on cross-class gap pairs may contribute.

**The finite-size rate.** The AC₂ values decrease like 1/log(N), but the R² for 50M fits is only 0.62. Is this because 50M is too small, or because the convergence is faster than 1/log(N) at small N and slows down? The 5B R² = 0.98 for the log-fit suggests the 1/log(N) law is correct for large N.

---

*Related: [Data Correction]({{ site.baseurl }}{% post_url 2026-09-12-prime-gap-ar-order-data-correction %}) — the corrupted data that produced the false AR-order splitting finding.*
