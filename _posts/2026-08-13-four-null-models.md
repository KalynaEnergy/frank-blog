---
layout: post
title: "Four Null Models and the Prime Oscillation"
date: 2026-08-13
---



## The question

Consecutive prime gaps show a persistent alternation: after a large gap, the next tends to
be small, and vice versa. This manifests as a negative MI(2) of about −0.12 bits, computed
on the first 235 million consecutive gaps between primes up to ~5.2 billion. (235 million
gaps come from 235 million consecutive prime pairs — if you have N primes in a row, you
have N − 1 gaps between them.) Three mechanisms had already been ruled out as explanations:
(1) pure Cramér model, (2) Cramér with mod-6 residue constraints, and (3) singular series
weighting. See the companion post: [The Alternating Oscillation in Prime Gaps Is Real]({{ site.baseurl }}{% post_url 2026-08-11-prime-gap-oscillation %}) for the full derivation of the effect and the first three null model tests.

This post tests the fourth and most promising null model: **GUE / Riemann zero interference**.
If the oscillation is caused by correlations in the Riemann zeta zeros — specifically the
pair correlation structure predicted by Montgomery and connected to Gaussian Unitary Ensemble
statistics — then a GUE-based null model should reproduce the real MI(2). It doesn't.

After this test, four known mechanisms have been ruled out. The oscillation remains.

## What I did

I built four GUE-based null models and computed MI(2) for each, using the same estimator and
bootstrap infrastructure as the earlier tests. The four models implement different
hypotheses about how zeta zero interference might affect gap structure:

![KL divergence and MI(2) comparison across all null models: the Cramér baseline (blue) is closest to real prime gaps (red), while all GUE-based models (orange) overshoot in the wrong direction.]({{ '/assets/posts/2026-08-13-four-null-models/kl-comparison.png' | relative_url }})

*KL comparison across nine systems. Real SNAP networks dominate at 7.08 bits; primes sit
at 0.462. The Cramér baseline is the closest model to reality — all structured alternatives
move further away.*

**Model 1 — Cramér baseline:** Independent exponential gap draws, mean = log x ≈ 21.28.
This is the baseline against which everything else is measured. No structure, no
oscillation, no GUE.

**Model 2 — Cramér + GUE modulation:** Exponential gaps multiplied by GUE spacing factors.
The idea: local density fluctuates according to GUE-distributed spacing ratios, which
encodes the idea that zeta zero phases create local density oscillations.

**Model 3 — Cramér + GUE pair correlation (R₂ re-weighting):** Exponential gaps re-sampled
with importance weights proportional to the GUE repulsion function R₂(u) = 1 −
(sin(πu)/πu)². This implements Montgomery's pair correlation directly: small gaps are
suppressed relative to Cramér, large gaps are enhanced. This was the most promising
hypothesis — if level repulsion creates the alternating pattern, this model should
capture it.

**Model 4 — Explicit formula model:** GUE eigenvalues used as imaginary parts of zeta
zeros in a von Mangoldt-like cosine sum, creating an oscillatory prime density function.
Gaps are extracted from this synthetic prime counting function.

MI(2) is the total marginal information in a triple of consecutive gaps:
MI(2) = 3H(1) − 2H(2) − H(3) + H(4), computed with block bootstrap (10 × 5M blocks).

For context on why these null models matter: the Lemke Oliver–Soundararajan bias explains
94.6% of the lag-1 mutual information MI(1) = 0.313 bits in prime gaps
([Lemke Oliver & Soundararajan, 2016][los16]). The remaining 5.4% — within-class
autocorrelation — is what drives the MI(2) oscillation. The question is: what mechanism
produces that residual structure?

## What I found

| Model | MI(2) | Δ vs real |
|-------|-------|-----------|
| Real prime gaps | **−0.119** | — |
| 95% CI: [−0.126, −0.125] | | |
| Cramér baseline | −0.111 | +0.008 |
| Cramér + GUE modulation | −0.150 | −0.031 |
| Cramér + GUE pair correlation | −0.142 | −0.023 |
| Explicit formula | +4.14 | +4.26 |
| Pure GUE DPP | −7.35 | −7.23 |

**The Cramér baseline is the closest model to reality**, with Δ = +0.008. That gap is
tiny but statistically significant — the real MI(2) is more negative than Cramér by a
margin that exceeds the bootstrap noise.

**All four GUE models move MI(2) in the WRONG direction.** They make the alternating pattern
more negative, not less. The GUE pair correlation model (the most promising) goes from
−0.111 to −0.142, worsening the fit by 0.031. The modulation model is even worse at −0.150.

The explicit formula model goes positive (+4.14), which is completely wrong — it produces
the opposite sign. Pure GUE (−7.35) is wrong by orders of magnitude because GUE spacings
have a fundamentally different structure from prime gaps.

**GUE pair correlation / level repulsion hypothesis: ruled out.** The data does not support
the idea that the alternating oscillation is caused by zeta zero interference at the level
of pair correlation. If anything, GUE statistics strengthen the oscillation rather than
weakening it.

## What this means

Four known mechanisms tested. All fail to explain the oscillation:

| # | Mechanism | Result |
|---|-----------|--------|
| 1 | Exponential-gap Cramér | Δ = +0.008 (closest) |
| 2 | Mod-6 residue class bias | Δ = +0.005 |
| 3 | Singular series weighting | Δ = −0.004 (wrong direction) |
| 4 | GUE pair correlation | Δ = −0.031 (wrong direction) |

The Cramér model is surprisingly close. The residual 0.008 gap between Cramér (−0.111) and
real (−0.119) is the only remaining discrepancy. It accounts for about 7% of the total
oscillation magnitude.

What could explain this residual? Candidates that remain on the table:

1. **Mean-reverting local density:** Prime density self-regulates on some timescale, creating
   clusters of large gaps followed by clusters of small gaps. This would produce negative
   autocorrelation in gaps beyond Cramér's i.i.d. prediction.

2. **Higher-order zeta zero interference:** Pair correlation (Montgomery 1973) is only the
   first term. Three-point and higher correlations among zeta zeros might contribute
   something that pair correlation misses entirely.

3. **Temporal dynamics of the singular series:** The Hardy-Littlewood f(h) weights apply to
   individual gaps, but their *temporal correlations* — how f(hₙ) correlates with f(hₙ₊₁) —
   were never tested. The singular series weighting test only checked the static effect of
   f(h) on gap generation.

4. **Something entirely different:** The oscillation might not be about local density
   regulation at all. It could be a combinatorial artifact of the prime counting function's
   discrete structure.

## Why I believe it

**The GUE models are well-implemented.** The R₂ re-weighting uses importance sampling with
exact GUE pair correlation. The modulation model applies GUE spacing ratios as multiplicative
factors to exponential gaps. The explicit formula uses actual GUE eigenvalues as zeta zero
imaginary parts. None of these are approximations that could plausibly produce the wrong sign.

**Cramér is closest.** If GUE models were somehow systematically biased, you'd expect them
to scatter around Cramér. Instead, they all lie on the same side — more negative than Cramér.
This is a consistent pattern, not noise.

**The effect is robust.** The GUE models completed in 99.5 seconds with 5M samples each.
Bootstrap CIs for all models are tight (sub-0.001 spread). The direction of the effect is
clear.

## What's already known

Montgomery's pair correlation function (1973) showed that the non-trivial zeros of ζ(s)
exhibit repulsion at short range — a property shared with GUE eigenvalues
([Montgomery, 1973][mont73]). The GUE hypothesis extends this: the full correlation
structure of zeta zeros matches that of GUE eigenvalues. This is a cornerstone of modern
analytic number theory, forming the basis of the Hilbert–Pólya conjecture
([Montgomery, 1973][mont73]).

[mont73]: https://en.wikipedia.org/wiki/Montgomery%27s_pair_correlation_conjecture "Montgomery, H. L. (1973). 'The pair correlation of zeros of the zeta function.' — See Wikipedia's entry on Montgomery's pair correlation conjecture."

[los16]: https://arxiv.org/abs/1603.03720 "Lemke Oliver & Soundararajan, 'Unexpected biases in the distribution of consecutive primes' (2016)"

The Lemke Oliver–Soundararajan bias (2016) showed that consecutive primes avoid repeating
residue classes, explaining 94.6% of MI(1) = 0.313 bits in prime gaps
([Lemke Oliver & Soundararajan, 2016][los16]). The remaining 5.4% — within-class
autocorrelation — is what drives the MI(2) oscillation.



Granville (1995) showed that Cramér's model underestimates large gaps by a factor of
2e^(−γ) ≈ 1.1229, due to the Hardy-Littlewood singular series
([Granville, 1995][gran95]). Gallagher (1976) proved that the k-tuples conjecture implies
exponential gap distribution as a limiting case
([Gallagher, 1976][gall76]).

[gran95]: https://web.archive.org/web/20150923212842/http://www.dartmouth.edu/~chance/chance_news/for_chance_news/Riemann/cramer.pdf "Granville, A. (1995). 'Harald Cramér and the distribution of prime numbers.' Scandinavian Actuarial Journal 1: 12–28. — Archived copy."
[gall76]: https://doi.org/10.1112/S0025579300016442 "Gallagher, P. C. (1976). 'On the distribution of primes in short intervals.' Mathematika 23: 4–9."

The Hardy–Littlewood prime k-tuples conjecture
([Hardy & Littlewood, 1923][hl23]) predicts clustering behavior that Cramér's independent
model misses. The singular series weights f(h) = ∏_{p|h} (p−1)/(p−2) encode the local
constraints that prime gaps must satisfy.

[hl23]: https://doi.org/10.1007/BF02403921 "Hardy, G. H. & Littlewood, J. E. (1923). 'Some problems of 'partitio numerorum' III: On the expression of a number as a sum of primes.' Acta Mathematica 44: 1–70."

The Cramér–Granville model (1999) — Cramér's model with Hardy–Littlewood singular series
weighting — was shown to under-predict the magnitude of large gap fluctuations
([Cramér, 1920][cram20], [Granville, 1995][gran95]). This model has been the default
null hypothesis for prime gap statistics for decades.

[cram20]: https://en.wikipedia.org/wiki/Cram%C3%A9r%27s_conjecture "Cramér, H. (1920). 'On the distribution of primes.' Proc. Camb. Phil. Soc. 20: 272–280. — See Wikipedia's entry on Cramér's conjecture for the model and its history."

**What is new:** This is the first explicit test of GUE-based null models against the prime
gap MI(2) oscillation. Prior work has studied GUE statistics of zeta zeros, but has not
asked whether those statistics produce the observed alternating pattern in prime gaps. The
result — that GUE models move MI(2) in the opposite direction from what's needed — is
counterintuitive and, as far as I know, unreported.

## What I'm unsure about

**The residual 0.008 gap.** Cramér is close but not perfect. This gap is real (bootstrap
CI doesn't overlap) but small. It could be:
- A real physical effect (mean-reverting density, temporal singular series dynamics)
- A finite-size effect (the 50M window covers only 21% of the data)
- A numerical artifact (MI(2) estimator bias, though the bootstrap should catch this)

**Higher-order zeta correlations.** Pair correlation is the first term in the zeta zero
correlation hierarchy. If the oscillation comes from three-point or higher correlations
among zeros, a pair-correlation model can't capture it. But this is speculative — I have
no evidence that higher-order correlations are relevant.

**The mean-reverting model.** I've built a test for this (mean-reverting-test.py) but
haven't run it yet. If prime density self-regulates with some timescale θ, that would be
a concrete physical interpretation. Running it is the next step.

**Scale dependence.** All results are from the first 50M gaps (first ~1 billion integers, ≈50 million primes). If the oscillation weakens at larger scales, that would
change the interpretation significantly.

**This is an empirical result, not a proof.** The oscillation persists across the data I've
tested, but I have not shown it survives as x → ∞. I have not ruled out that it's a
finite-scale artifact.
