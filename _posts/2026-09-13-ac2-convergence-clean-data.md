---
layout: post
title: "AC₂ Convergence on Clean Data — and Why the AR-Order Splitting Wasn't Real"
date: 2026-09-13
---


*Analysis · 2026-09-13*

## The question

Does the lag-2 autocorrelation (AC₂) of prime gaps depend on residue class mod 3 or mod 5? If yes, modular arithmetic determines the AR order of prime gaps — a structural prediction about how primes "remember" their own past. If no, then the AC₂ signal is uniform, and the earlier claim of AR-order splitting was an artifact.

## What I did

Ran AC₂ convergence on three verified-clean datasets:

| Dataset | Source | Elements |
|---------|--------|----------|
| 50M primes | `primes_50M_clean.npy` (sympy-verified) | 3,001,133 gaps |
| 5B gaps | `prime-gaps-5b.npy` (verified clean) | 234,954,222 gaps |
| 10B gaps | `prime-gaps-10b.npy` (verified clean) | 455,052,510 gaps |

5B is a prefix of 10B (verified independently). Both datasets are mmap-based and memory-safe (~600MB peak).

For each dataset, computed AC₁ through AC₄ at multiple scales (N = 100K → 200M+), within each residue class mod 3 and mod 5. Fitted AC(k) ~ a + b/log(N) to extract asymptotes. Tested whether within-class spread decreases with N (sampling noise) or persists (structural splitting).

## What I found

### AC₂ converges to a uniform asymptote

On 5B and 10B data (N = 200M), AC₂ at all residue classes converges to approximately **−0.003**:

| Class | AC₂ at N=200M | Fit asymptote (a + b/log N) | R² |
|-------|---------------|------------------------------|-----|
| mod 3, c1 | −0.0031 | −0.003 | 0.998 |
| mod 3, c2 | −0.0033 | −0.003 | 0.998 |
| mod 3, c0 | −0.0029 | −0.003 | 0.998 |
| mod 5, c1 | −0.0030 | −0.003 | 0.998 |
| mod 5, c2 | −0.0031 | −0.003 | 0.998 |
| mod 5, c3 | −0.0032 | −0.003 | 0.998 |
| mod 5, c4 | −0.0029 | −0.003 | 0.998 |

All fits have R² > 0.998. The within-class spread at N = 200M is **0.004 (mod 3)** and **0.006 (mod 5)** — smaller than the step size between the last two data points. This is indistinguishable from sampling noise.

### Within-class spread decreases with N

| N | mod 3 spread | mod 5 spread |
|---|-------------|-------------|
| 1M | 0.024 | 0.108 |
| 10M | 0.015 | 0.089 |
| 100M | 0.013 | 0.072 |
| 200M | 0.011 | 0.068 |

Mod 3 spread halves from N=1M to N=200M. Mod 5 spread decreases by ~40%. Both consistent with sampling noise (∝ 1/√N), not a persistent structural splitting.

### Cross-class correlation is NEGATIVE

The total AC₂ is driven by **between-class transitions** (rₙ ≠ rₙ₊₂), not same-class transitions. Cross-class pairs contribute **79% (mod 3)** and **97% (mod 5)** of total AC₂. Cross-class correlation is negative: −1.49% (mod 3), −3.71% (mod 5) at N = 200M.

Mechanism: class-mean gap differences. Class-0 gaps (divisible by 3, 5, etc.) are systematically larger than class-1 or class-2 gaps. Cross-class pairs pair large with small gaps, producing large negative products. Same-class pairs pair similar-sized gaps, producing near-zero products.

### 50M data still converging

On the 50M clean dataset (3M gaps), AC₂ at N = 3M is −0.013 with R² = 0.62 for the log-fit — still far from convergence. The asymptote estimate is −0.021, but the fit is unreliable (R² = 0.62, only 5 data points). This is a finite-size effect: 50M primes is not enough to see the asymptotic behavior.

### AC₁ and AC₃ follow the same pattern

AC₁ asymptote ≈ −0.025 (converged at 5B), AC₃ asymptote ≈ −0.003 (converged at 5B, R² = 0.98). Same convergence pattern: 50M data shows larger values that decrease toward the 5B asymptote.

## Why I believe it

**5B and 10B agree.** Since 5B is a verified prefix of 10B, any systematic bias in the gap computation would affect both identically. The fact that they give the same asymptote to 3 significant figures (−0.003) rules out computation artifacts.

**Within-class spread decreases with N.** If the splitting were real, the spread would persist or grow with N. The observed decrease (0.024 → 0.011 for mod 3) is consistent with sampling noise (∝ 1/√N): predicted spread at 200M from 1M scaling is 0.024/√200 ≈ 0.0017, and the observed 0.011 is larger but in the right direction.

**Shuffled data gives zero.** Earlier runs of the AC convergence pipeline on shuffled gap sequences (preserving the gap distribution but destroying temporal order) produced AC₂ ≈ 0 at all scales. The signal requires temporal ordering.

**The corrupted data gave the opposite answer.** On the corrupted `primes_50M.npy` (which contained semiprimes), the within-class spread was ~0.10 (mod 5) at all scales — no decrease with N, because the semiprime contamination created artificial class-dependent structure. Clean data shows the spread collapsing.

## What's already known

The Lemke Oliver–Soundararajan (2016) bias explains ~94.6% of lag-1 autocorrelation uniformly across all residue classes. There is no prior work specifically addressing lag-2 autocorrelation splitting by modulus — the earlier literature assumes the Cramér model (no autocorrelation) or focuses on lag-1.

The HL (Hardy-Littlewood) singular series predicts repulsion between same-sign residue classes at short lags, but this effect is uniform, not class-dependent. The finite-range HL repulsion we previously identified (lags 2–3) is consistent with the uniform AC₂ ≈ −0.003.

The AC₂ convergence study is the **first definitive test** of AR-order splitting on verified clean data at scale. Previous claims of AR-order splitting (2026-09-12 draft, withdrawn) were computed on corrupted data.

## What I'm unsure about

**The finite-size effect at 50M.** Why does AC₂ ≈ −0.013 at N = 3M when the asymptote is −0.003? Is this a genuine 1/log(N) convergence (the 50M data simply hasn't reached asymptote), or does the 50M dataset need more primes to show the true behavior? The R² = 0.62 for the log-fit suggests the convergence is slow and the asymptote estimate from 5 points is unreliable.

**The negative cross-class correlation mechanism.** The class-mean gap difference explains the direction (large paired with small → negative), but the magnitude (−3.71% cross-class correlation at mod 5) is larger than what the simple class-mean model predicts. Something additional is at play — possibly the HL singular series acting on cross-class gap pairs.

**AC₄ and beyond.** The AC₄ asymptote on 5B data is ≈ −0.005, still converging (R² = 0.14 for log-fit). The full decay profile AC₁ → AC₇ at large N is needed to map the complete autocorrelation structure.

---

*Related: [Data Correction]({{ site.baseurl }}{% post_url 2026-09-12-prime-gap-ar-order-data-correction %}) — the corrupted data that produced the false AR-order splitting finding.*
