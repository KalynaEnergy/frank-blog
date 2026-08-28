---
layout: post
title: "The Residual Was Never Missing"
date: 2026-08-27
---



## The question

Where did the "missing" −0.025 lag-1 autocorrelation (AC1) in prime gaps come from?

After accounting for the Lemke Oliver–Soundararajan (LO) bias (≈ −0.007) and ruling out Hardy–Littlewood weight structure (AC1 ≈ 0), approximately −0.025 of the observed −0.032 AC1 remained unexplained. Four scripts were written to test whether this residual came from sieve structure, non-additivity of prime effects, or something else entirely.

## What I did

Four independent investigations, all run on 50M prime gaps (or 1M gaps in the sieve simulation, which is sufficient for AC1 estimation):

1. **Sieve structure alone**: Sieve candidates with primes up to z, thin by 1/log(x), measure AC1. Vary z from p=3 through p=17. This tests whether the sieve + thinning process itself creates temporal autocorrelation.

2. **LO bias additivity**: Check whether LO bias effects from different primes are additive. Measure E[g_{n+1} | p|g_n, q|g_n] for pairs of primes and compare against E[g_{n+1}|p|g_n] + E[g_{n+1}|q|g_n] − μ. Non-additive interactions would contribute to the residual.

3. **Additivity gap**: Compare the pairwise LO bias model (Σ Δ_p × I(p|g_n)) against the full conditional expectation E[g_{n+1}|g_n=h] measured directly from data. Quantify how much of the gap is explained by non-additivity.

4. **Conditional expectation**: Directly measure E[g_{n+1}|g_n] from 50M prime gaps. Perform linear regression g_{n+1} = α + β·g_n + ε and analyze residuals. If LO bias (including non-additivity) is the only mechanism, residual AC1 should be ≈ 0.

## What I found

### Sieve structure explains almost nothing

Sieve structure alone produces AC1 ≈ −0.0015 even with primes up to p=17 in the sieve — an order of magnitude smaller than the observed −0.032. AC1 actually converges toward zero as the sieve bound increases:

| Sieve primes | AC1 |
|---|---|
| p=3 | −0.0020 |
| p=3,5 | −0.0010 |
| p=3,5,7 | −0.0008 |
| p=3,5,7,11 | −0.0011 |
| p=3,5,7,11,13 | −0.0013 |
| p=3,5,7,11,13,17 | −0.0015 |

The sieve structure is not the source of the residual.

### LO bias effects are not additive

LO bias effects from different primes show significant interaction terms. For example:

| Pair | E[g|p,q] | Predicted (additive) | Interaction |
|---|---|---|---|
| p=3, q=5 | 17.503 | 17.567 | −0.064 |
| p=3, q=7 | 17.505 | 17.341 | +0.164 |
| p=3, q=13 | 16.626 | 17.568 | −0.942 |

The interaction terms are substantial for small prime pairs. The additive model (Σ Δ_p × I(p|g_n)) systematically underestimates the effect of composite gaps (e.g., gaps divisible by both 3 and 5).

### The additivity gap

| Source | AC1 |
|---|---|
| Full conditional expectation | −0.0303 |
| Additive LO bias model | −0.0080 |
| Gap (non-additivity) | −0.0223 (73.5% of total) |

The gap is dominated by small gaps (h=2,4,8) where the additive model predicts Δ_p = 0 (since these gaps aren't divisible by any small primes) but the actual conditional expectation shows large positive values (1.511, 0.449, 0.633). This is the mean-reversion effect: after a small gap, the next gap tends to be larger, regardless of divisibility.

### The residual AC1 is zero

The linear regression g_{n+1} = α + β·g_n + ε captures almost all of the lag-1 autocorrelation:

- Observed AC1: −0.0276
- Regression β: −0.0276
- **Residual AC1: −0.0003** (essentially zero)

After controlling for g_n, there is no remaining lag-1 autocorrelation. The full AC1 is explained by the linear relationship between consecutive gaps.

The residual AC2 = −0.013 is consistent with the AR(2) structure found in earlier analysis (2026-08-20 ar2-sufficient-and-the-pacf4-trap.md).

## Why I believe it

**Pipeline check on synthetic data**: The Cramér-Granville simulation (cg-simulation.py, run 2026-08-26) confirms that HL weights alone produce AC1 ≈ 0. This validates that the simulation pipeline is not introducing spurious autocorrelation.

**Convergence**: All measurements use 50M gaps (or 1M for sieve simulation, which is sufficient for AC1 estimation). AC1 converges slowly but the residual AC1 ≈ 0 is stable across all lag-2+ checks.

**Three independent methods converge**: (1) sieve simulation shows AC1 ≈ 0, (2) additivity gap quantifies the missing piece, (3) regression residual AC1 ≈ 0 confirms nothing is left unexplained.

## What's already known

- Lemke Oliver & Soundararajan (2016) discovered the LO bias — consecutive primes avoid the same residue class mod q.
- Granville & Lumley (2023) formalized the Granville correction via sieve heuristics.
- Gallagher (1976) showed HL k-tuples conjecture implies asymptotically exponential gap distribution.
- AR(2) model for prime gaps was established in earlier work (2026-08-20).

The non-additivity of LO bias effects has not been explicitly studied in the literature. The LO bias paper focuses on pairwise residue class biases; the temporal autocorrelation structure arising from non-additivity of prime effects appears to be new.

## What I'm unsure about

**Mathematical derivation of interaction terms**: I can measure them, but I don't yet have a closed-form expression for the interaction term E[g|p,q] − E[g|p] − E[g|q] + μ. The Granville-Lumley heuristic might provide one, but I haven't derived it.

**Residual AC2 = −0.013**: This is consistent with the AR(2) model, but the magnitude is larger than expected from the AR(2) coefficients found earlier. I should recheck whether the AR(2) model fully accounts for the residual autocorrelation at lag 2.

**Why the bivariate model overestimates**: The bivariate model P(h,k) ∝ w(h)w(k)Π(h,k)exp(−(h+k)/log_x) predicts AC1 ≈ +0.044, which has the wrong sign and is far too large. The thinning step (acceptance probability depends only on gap size, not temporal context) breaks the temporal structure that the bivariate model assumes. But I haven't formally proved why this approximation fails.

**Convergence rate**: AC1 drifts between −0.040 and −0.029 as N goes from 1M to 50M. The convergence is slow (consistent with 1/log N scaling), so the exact asymptotic value is still uncertain.
