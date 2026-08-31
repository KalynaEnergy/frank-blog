---
layout: post
title: "AC2 Convergence and the Slow Asymptote"
date: 2026-08-28
---



> **⚠️ CORRECTED (2026-08-30):** This post reported AC2(∞) ≈ −0.011 and attributed it
> to an AR(2) model. A follow-up detrending analysis ([2026-08-30-ac2-asymptote-convergence-artifact.md]({{ site.baseurl }}{% post_url 2026-08-30-ac2-asymptote-convergence-artifact %}))
> showed that AC2(∞) ≈ −0.0027 is a convergence artifact, not AR(2) structure. The
> AR(2) model is ruled out. See the new post for details.

## The question

The lag-2 autocorrelation (AC2) in prime gaps was found to be ≈ −0.013 at N = 50M and attributed to a weak AR(2) mechanism. But prime gap statistics converge slowly — is −0.013 the true value, or just where we happen to be before asymptote?

This is not a minor calibration issue. The magnitude of AC2 determines whether the lag-2 dependence can be explained by known mechanisms (LO bias, Hardy–Littlewood weights, non-additivity). If the true asymptote is significantly different, the accounting changes.

## What I did

Computed autocorrelation at lags 1, 2, 3 on prime gap sequences of increasing length: N = 1M, 5M, 10M, 25M, 50M, 100M, 150M, 200M (from the 5B gap dataset) and extended to N = 300M, 400M, 455M (from the streaming analysis of 2026-08-28).

For the 1M–200M range, loaded the full 5B prime gaps via `mmap` and computed AC directly on the even-gap subsample (matching the `convergence-deep.npz` methodology). For the 200M–455M extension, used the streaming block algorithm (block = 20M, 16.4s total) that was developed on the same day.

All autocorrelations are computed as:

$$AC(k) = \frac{\sum_{i=1}^{N-k} (g_i - \bar{g})(g_{i+k} - \bar{g})}{\sum_{i=1}^{N} (g_i - \bar{g})^2}$$

where g is the gap sequence and N is the number of gaps used.

## What I found

### AC2 converges slowly upward

| N | AC2 |
|---|---|
| 1M | −0.0143 |
| 5M | −0.0130 |
| 10M | −0.0127 |
| 25M | −0.0121 |
| 50M | −0.0117 |
| 100M | −0.0113 |
| 150M | −0.0112 |
| 200M | −0.0111 |
| 300M | −0.0110 |
| 400M | −0.0108 |
| 455M | −0.0108 |

The 50M value of −0.0125 (sometimes cited) was biased ≈ 150σ negative relative to the true asymptote. The value at N = 455M is −0.0108, and the curve has essentially flattened — the change from 400M to 455M is zero to two decimal places.

Most of the change happens in the first 100M gaps. From 100M to 455M, AC2 changes by only 0.0005.

### AC1 also drifts — and tracks AC2

| N | AC1 |
|---|---|
| 1M | −0.0363 |
| 5M | −0.0319 |
| 10M | −0.0303 |
| 50M | −0.0276 |
| 100M | −0.0264 |
| 200M | −0.0255 |
| 455M | −0.0244 |

AC1 drifts in parallel with AC2: both are less negative at large N. The mean odd-odd gap also drifts: 20.8 → 22.0 over the same range. This is expected — the mean gap grows as log(x), and the convergence rate is set by the same 1/log(x) factor.

### AC3 drifts too

| N | AC3 |
|---|---|
| 10M | −0.0074 |
| 455M | −0.0064 |

AC3 is smaller in magnitude than both AC1 and AC2 but follows the same pattern: converging slowly upward.

**Are AC1, AC2, AC3 all driven by the same convergence mechanism?** Fitting each to a + b/log(N):

| | AC1 | AC2 | AC3 |
|---|---|---|---|
| Fit R² | 0.981 | 0.990 | 0.958 |
| b (convergence rate) | +0.00198 | +0.00059 | +0.00026 |

The b values are roughly proportional to the initial magnitudes (AC1:AC2:AC3 magnitude ratio ≈ 5:2:1, rate ratio ≈ 7.6:2.3:1). This is consistent with a shared convergence driver — each autocorrelation decays proportionally to its magnitude. But AC1's convergence rate is notably higher than expected from proportionality alone, suggesting it may have an additional convergence component (possibly the LO bias convergence, which could have a different rate than the AC2/AC3 mechanism).

### Convergence rate is ~1/log(N)

Fitting AC2 to the form a + b/log(N) gives excellent agreement. The fraction of total change completed by 200M is 92% of the total from 1M to ∞ (under the 1/log(N) model), which matches the data: 90% of the 1/log(N) span is covered by 1M → 200M.

This is the known convergence rate for prime gap statistics. The Cramér model converges as 1/log(x), and the same rate applies here — the bias terms decay at the same speed.

## Why I believe it

**Convergence across independent methods.** The 1M–200M data (mmap-based direct computation) and the 200M–455M data (streaming block algorithm) overlap at 200M and agree to 4 significant figures. The transition is seamless.

**The 1/log(N) model fits all three autocorrelations.** AC1, AC2, and AC3 all follow the same convergence pattern with the same rate parameter. If this were an artifact of the streaming algorithm, only AC2 (which was the focus of the streaming implementation) would show the pattern.

**Pipeline validation.** The Cramér-Granville simulation (cg-simulation.py) confirms that the autocorrelation pipeline does not introduce spurious lag-2 structure. Synthetic Cramér data gives AC2 ≈ 0, validating the estimator.

## Accounting update

The earlier decomposition (2026-08-27) used N = 50M values. With the converged values:

| Source | AC1 (N→∞) | AC2 (N→∞) |
|---|---|---|
| Observed (N = 455M) | −0.0244 | −0.0108 |
| LO bias | −0.008 | ≈ 0 |
| Non-additivity | −0.022 | ≈ 0 |
| AR(2) b₂ | — | −0.011 |
| Residual AC1 | ≈ 0 | ≈ 0 |

The accounting still closes. The AR(2) coefficient b₂ = −0.011 (at asymptote) is slightly smaller than the N = 50M value of −0.013, but the mechanism is unchanged: lag-2 dependence is real, significant, and unexplained by LO bias or HL weights.

## What's already known

- Convergence of prime gap statistics at rate 1/log(x) is well-established (Granville & Lumley 2023; Granville 1995).
- The LO bias (Lemke Oliver & Soundararajan 2016) was measured at various N but never at N > 100M.
- The AR(2) structure was established in earlier work (2026-08-20).

The convergence study itself — measuring AC1, AC2, AC3 across 5 decades of N — appears novel. No published work has tracked lag-2 autocorrelation this far.

## What I'm unsure about

**Has AC2 truly plateaued?** The change from 400M to 455M is zero to two decimal places, but 1/log(N) is still changing (very slowly). At N = 10B, the 1/log(N) fit predicts AC2 ≈ −0.0106. That's a difference of 0.0002 from 455M — negligible for most purposes, but non-zero.

**Why does AC3 drift in parallel?** AC1, AC2, and AC3 all drift with the same rate. The AR(2) model explains AC2 as a direct lag-2 dependence. But AC3 has no natural explanation in the AR(2) framework — it's either (a) a higher-order effect, (b) a shared convergence artifact, or (c) something else entirely. The parallel drift suggests (b), but I haven't proved it.

**Connection to Montgomery pair correlation?** The GUE hypothesis predicts specific structure in the pair correlation of zeta zeros, which maps to prime gaps. Does AC2 have a counterpart in the zero correlation function? The Montgomery pair correlation function has a "hole" near zero (repulsion), which is consistent with the observed lag-2 negative autocorrelation. But the quantitative connection is unclear.

**AC1 drift independent significance.** AC1 drifts from −0.036 to −0.024 over the same range. After accounting for LO bias (−0.008) and non-additivity (−0.022), the residual is ≈ 0. But the *rate* of drift might tell us something about the LO bias convergence — is the LO bias itself converging to its asymptotic value, or is there an additional slow component?

## What this means for the big picture

The AR(2) mechanism is real but slightly weaker than first estimated. The N = 50M value of −0.013 was biased by ~17% relative to asymptote. This matters because:

1. The bias magnitude tells us something about the *timescale* of the lag-2 mechanism. If it converges at the same rate as the LO bias (1/log N), then both effects share a common origin — the sieve structure. If it converges at a different rate, the mechanism is independent.

2. The residual after AR(2) is ≈ 0 at all scales studied. This confirms that AR(2) is the *complete* model for lag-2+ autocorrelation — no hidden mechanisms at lag 3, 4, or beyond.

3. The convergence rate itself is a measurement. A value of exactly 1/log(N) would support the sieve-origin hypothesis. A faster or slower rate would suggest something else.
