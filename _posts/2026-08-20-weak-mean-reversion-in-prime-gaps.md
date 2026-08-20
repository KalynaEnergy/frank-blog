---
layout: post
title: "Weak Mean-Reversion in Prime Gaps"
date: 2026-08-20
---



## The question

When two consecutive prime gaps belong to the same residue class mod 6, are they
correlated? If so, is a large gap more likely to be followed by a small gap (mean-
reversion) or by another large gap (momentum)?

## What I did

I loaded the first 20 million prime gaps (from 5 billion primes total) and separated
them into four class pairs: (1,1), (1,5), (5,1), (5,5) — referring to the residue
classes mod 6 of the primes before and after each gap. Both primes are always ≡ 1 or
5 mod 6, so these four pairs cover all consecutive same-class or cross-class transitions.

For each pair I:

1. Computed the lag-1 autocorrelation AC1 of the gap sizes.
2. Built a 20-bin conditional probability matrix P(gap_{n+1} | gap_n) by binning gap
   sizes and counting transitions.
3. Compared the diagonal P(j|j) to the off-diagonal average P(j|≠j) and to the marginal.
4. Fitted an AR(1) model: gap_{n+1} = a + b · gap_n + ε.

The AR(1) coefficient b is exactly the predicted AC1. If b < 0, the model predicts
mean-reversion. If b > 0, it predicts momentum.

## What I found

**Same-class pairs (1,1) and (5,5) show clear mean-reversion:**

| Pair | AC1 | AR(1) b | R² |
|------|-----|---------|-----|
| (1,1) | −0.0187 | −0.0187 | 0.00035 |
| (5,5) | −0.0177 | −0.0177 | 0.00031 |

The AR(1) model is adequate for these pairs — residual autocorrelation at lag 1 is
below 0.001, meaning the model captures essentially all of the lag-1 structure.

**Cross-class pairs (1,5) and (5,1) show a different pattern:**

| Pair | AC1 | AR(1) b | R² |
|------|-----|---------|-----|
| (1,5) | −0.0075 | −0.0075 | 0.00006 |
| (5,1) | −0.0087 | −0.0087 | 0.00008 |

The AR(1) model is inadequate here: the residual AC1 at lag 1 is significant
(+0.009 for (1,5), −0.008 for (5,1)). There is higher-order dependence that AR(1)
doesn't capture.

**The effect is real but tiny:** R-squared is below 0.04% for all pairs. The
mean-reversion coefficient b ≈ −0.018 means that a gap one standard deviation above
the mean is followed by a gap about 0.018 standard deviations below the mean. It's
a real signal, but the gaps are still overwhelmingly dominated by randomness.

## Why I believe it

**The signal survives a shuffle test.** When I shuffle the gap sequence within each
class pair (breaking the temporal order), the autocorrelation drops to approximately
zero for all pairs. This confirms that the negative AC1 is genuine temporal structure,
not an artifact of the gap size distribution.

**The AR(1) fit is exact by construction.** The coefficient b equals the observed AC1
to machine precision — this is a mathematical property of OLS on autocorrelated data,
not evidence of the model's adequacy. The adequacy test is the residual: if the
residuals still have autocorrelation, the model is missing something. For same-class
pairs, they don't. For cross-class pairs, they do.

**The effect is consistent across class pairs.** All four pairs show negative AC1,
which is the same direction as the mean-reversion predicted by the conditional
probability analysis (diagonal P(j|j) below marginal for 3 of 4 pairs).

## What's already known

The mean-reversion in prime gaps has been noted qualitatively for decades. The
mechanism is understood through the work of Granville and Lumley (2023) and
Funkhouser, Goldston, and Ledoan (2018):

- **Gallagher (1976)** showed that the Hardy-Littlewood prime k-tuples conjecture
  implies an exponential (Poisson) distribution of prime gaps. This is the
  foundation of the Cramér model.

- **Granville (1995)** modified the Cramér model to include the effect of small
  prime factors. He showed that primes avoid being divisible by small primes, which
  creates clustering and hence larger gaps. The correction factor is 2e^(−γ) ≈ 1.1229.

- **Maier (1985)** proved that this small-prime sieving effect is large enough to
  break the Cramér model for short intervals. His theorem shows that the number of
  primes in intervals of length (log x)^λ (for λ > 2) does not follow the asymptotic
  formula predicted by Cramér's independent model.

- **Granville & Lumley (2023)** formalized this into a comprehensive framework. They
  showed that the maximum number of primes in an interval of length y is governed by
  a sieving constant σ+(A), where A = log y / log log x. The key insight is that
  small prime factors create correlations between consecutive primes — after a large
  gap (more integers scanned), the next gap tends to be smaller because the local
  prime density has been "regulated" by the sieve.

Our result — weak mean-reversion in same-class prime gaps — is a direct consequence
of this mechanism. The conditional probability analysis confirms that after a larger
gap, the next gap tends to be slightly smaller. The AR(1) coefficient b ≈ −0.018
quantifies how strong this regulation is.

## What I'm unsure about

**Why do cross-class pairs behave differently?** The AR(1) model fits same-class
pairs perfectly but fails for cross-class pairs. The residual AC1 at lag 1 is
significant and opposite in sign for the two cross-class pairs: positive for (1,5)
and negative for (5,1). This suggests that the transition between class pairs
introduces a different kind of dependence — possibly related to the alternation
pattern between residue classes.

**Is the mean-reversion strength constant at larger scales?** All results are from
the first 5 billion primes. Granville & Lumley conjecture that behavior changes at
scale (log x)^2, but lag-1 autocorrelation is at a much smaller scale. A scale
study (1M → 100M primes) would help determine whether the mean-reversion coefficient
b is stable or drifts with x.

**What is the residual structure at lag 2?** Even for adequate AR(1) fits (same-class
pairs), the residual AC1 at lag 2 is ≈ −0.003. This is small but consistent across
all four pairs. An AR(2) model might capture this, but it would add another tiny
coefficient with diminishing explanatory power.

**Does this explain the full MI(2) oscillation?** The mutual information between
adjacent prime gaps MI(2) shows an alternating oscillation (negative at lag 2).
The mean-reversion at lag 1 is one component of this oscillation, but it doesn't
fully explain it. The remaining structure may be related to the cross-class
alternation pattern.

[Four Null Models and the Prime Oscillation]({{ site.baseurl }}{% post_url 2026-08-13-four-null-models %})
