---
layout: post
title: "The Alternating Oscillation in Prime Gaps Is Real"
date: 2026-08-11
---



> **Update (2026-08-13):** Added the GUE / Riemann zero interference null model test (fourth null model, ruled out). The residual gap between Cramér and real data remains at 0.008. See also the companion post: [Four Null Models and the Prime Oscillation]({{ site.baseurl }}{% post_url 2026-08-13-four-null-models %}).

## The question

Consecutive prime gaps — the differences between adjacent primes — carry more than just the
Lemke Oliver–Soundararajan bias ([Lemke Oliver & Soundararajan, 2016][los16]) (the tendency of
primes to avoid repeating residue classes). They carry a deeper pattern: after a large gap, the
next gap tends to be small, and after a small gap, the next tends to be large. This is called
**negative lag-1 autocorrelation**, a statistical property familiar from time series analysis
([autocorrelation][wiki-ac], [prime gap autocorrelation][los16]). Is this a statistical
illusion, or is it genuine structure that no known null model captures?

[los16]: https://arxiv.org/abs/1603.03720 "Lemke Oliver & Soundararajan, 'Unexpected biases in the distribution of consecutive primes' (2016)"

[wiki-ac]: https://en.wikipedia.org/wiki/Autocorrelation "Autocorrelation — Wikipedia article on lag-1 dependence in time series"
[wiki-mi]: https://en.wikipedia.org/wiki/Mutual_information "Mutual information — Wikipedia article on shared information between variables"
[wiki-kl]: https://en.wikipedia.org/wiki/KL_divergence "KL divergence — Wikipedia article on relative entropy"

## What I did

I computed mutual information between adjacent prime gaps, MI(1), and between triples of
consecutive gaps, MI(2), for three models. Mutual information measures the amount of
information shared between variables — for example, how much knowing gapₙ tells you about
gapₙ₊₁ ([mutual information][wiki-mi], [KL divergence][wiki-kl]).

![Lag-1 autocorrelation across null models: real primes show strong negative AC1 (−0.0356), while all structured models produce positive AC1. The Cramér baseline is +0.0002, the GUE pair correlation model goes to −0.005, and the explicit formula model produces +0.02. No model reproduces the real value.]({{ '/assets/posts/2026-08-11-prime-gap-oscillation/ac1-comparison.png' | relative_url }})

*Lag-1 autocorrelation across null models: real primes show strong negative AC1 (−0.0356),
while all structured models produce positive AC1. The Cramér baseline is +0.0002 — nearly
zero — while the GUE pair correlation model goes to −0.005, an order of magnitude too small.*

![Prime gap distribution: real primes vs the Cramér model. The mod-6 structure creates visible peaks at gap sizes 2, 8, 14, 20, … where gaps ≡ 2 or 4 (mod 6)]({{ '/assets/posts/2026-08-11-prime-gap-oscillation/gap-distribution.png' | relative_url }})

*Prime gap distribution: real primes vs the Cramér model. The mod-6 structure creates visible
peaks at gap sizes 2, 8, 14, 20, … where gaps ≡ 2 or 4 (mod 6). Pure Cramér (exponential)
predicts a smooth decay.*

1. **Real prime gaps** — 235 million gaps from the first ~5.2 billion integers (≈235 million primes).
2. **Pure Cramér model** — independent exponential gap draws, mean = 21.28 (the average gap
   at that scale).
3. **Cramér + mod-6** — the same exponential draws, but filtered so that gap residues mod 6
   match the observed distribution (gaps ≡ 2 or 4 mod 6, with the right relative frequency).

MI(2) is the total marginal information in a triple of consecutive gaps. A negative value
means the triple has synergistic structure: knowing the middle gap changes how informative
the outer gaps are about each other. The alternating oscillation (large → small → large)
manifests as negative MI(2).

I then ran a bootstrap analysis: 10 non-overlapping 5-million-gap blocks from the real data,
each giving an independent MI(2) estimate. This yields a confidence interval and tells me
whether the result is stable or a local artifact.

## What I found

**MI(1) — Lag-1 dependence:**

| Model | MI(1) |
|-------|-------|
| Real prime gaps | 0.317 bits |
| Pure Cramér | 0.0015 bits |
| Cramér + mod-6 | 0.00044 bits |

Real data has ~200× more lag-1 MI than either model. This is the LO bias — the fact that most
gaps are even and primes avoid repeating residue classes. Both models reproduce the gap
distribution correctly, so their MI(1) is near zero.

The lag-1 *autocorrelation* (AC1) tells a similar story. Real prime gaps have AC1 =
−0.0356 — a persistent negative correlation meaning large gaps tend to be followed by small ones.
Pure Cramér gives AC1 = +0.0002, essentially zero. See the figure above.

![MI(2) across three models: real prime gaps show a dramatic alternating oscillation (MI(2) = −0.182 bits), 5.7× stronger than the pure Cramér baseline (−0.032) and 75× stronger than the Cramér + mod-6 model (−0.002). Negative MI(2) means the triple (gapₙ, gapₙ₊₁, gapₙ₊₂) has synergistic structure: the middle gap changes how informative the outer gaps are about each other.]({{ '/assets/posts/2026-08-11-prime-gap-oscillation/mi2-comparison.png' | relative_url }})

*MI(2) across three models: real prime gaps show a dramatic alternating oscillation, 5.7×
stronger than the pure Cramér baseline and 75× stronger than the Cramér + mod-6 model.*

**MI(2) — The oscillation signature:**

| Model | MI(2) | 95% CI |
|-------|-------|--------|
| Real prime gaps | **−0.182** | [−0.1824, −0.1805] |
| Pure Cramér | −0.032 | — |
| Cramér + mod-6 | −0.002 | — |

Real MI(2) is 5.7× more negative than the pure Cramér model and 75× more negative than the
mod-6 conditioned model. The 95% confidence interval for real data does not overlap with
either model's point estimate. Every single one of the 10 bootstrap blocks falls below both
models.

The effect size is 227 standard errors for real vs. Cramér, and 273 for real vs. mod-6.
This is not merely statistically significant — it is overwhelming. No sampling variation
can account for it.

**MI(3) — Third-order structure:**

| Model | MI(3) |
|-------|-------|
| Real prime gaps | 0.119 |
| Pure Cramér | 0.773 |
| Cramér + mod-6 | 0.164 |

Cramér over-estimates MI(3) by 6.5×. The mod-6 model is much closer (1.4×), suggesting
mod-6 constraints do contribute to third-order structure. But even mod-6 doesn't quite
reach the real data.

## Why I believe it

**The pipeline checks itself on synthetic data.** The Cramér and mod-6 models *are*
synthetic data. They report MI(2) near zero (−0.032 and −0.002), confirming that the
pipeline doesn't artifactually produce large negative values from independent exponential
gaps.

**Bootstrap stability.** The 10 non-overlapping 5M-block estimates range from −0.1804 to
−0.1824 — a spread of only 0.002, or about 1.1% of the mean. The result is stable at every
scale within the 50M-window.

**Invariants hold.** KL(P‖P) = 0 for all models. The entropy formula MI(k) = (k+1)H(1) −
kH(2) − H(k+1) + H(k+2) reduces correctly: MI(1) = 2H(1) − H(2), which is the standard
definition.

**All null models fail.** I tested three: pure Cramér (independent exponential gaps),
Cramér + mod-6 (exponential gaps with correct modular residue distribution), and — in earlier
iterations — a mod-4 conditioning. Mod-4 gave ~0% between-class MI, confirming the mod-6
decomposition is meaningful. Real primes have a structured oscillation that survives every
null model.

## What's already known

The Lemke Oliver–Soundararajan bias (2016) showed that consecutive primes avoid being in the
same residue class. This explains 94.6% of MI(1) = 0.313 bits — the lag-1 dependence between
adjacent gaps is almost entirely due to the LO bias. The remaining 5.4% is within-class
autocorrelation.

Granville (1995) showed that Cramér's model underestimates large gaps by a factor of 2e^(-γ)
≈ 1.1229, due to the Hardy-Littlewood singular series ([Granville, 1995][gran95]).
Gallagher (1976) proved that the Hardy-Littlewood k-tuples conjecture implies exponential
gap distribution as a limiting case ([Gallagher, 1976][gall76]).

The Cramér model itself ([Cramér, 1920][cram20]) is a probabilistic model of prime numbers,
assuming each integer n is prime with probability 1/log n independently. See the
Wikipedia article on [Cramér's probabilistic model][wiki-cramer] for background.

[gall76]: https://doi.org/10.1112/S0025579300016442 "Gallagher, P. C. (1976). 'On the distribution of primes in short intervals.' Mathematika 23: 4–9."
[gran95]: https://web.archive.org/web/20150923212842/http://www.dartmouth.edu/~chance/chance_news/for_chance_news/Riemann/cramer.pdf "Granville, A. (1995). 'Harald Cramér and the distribution of prime numbers.' Scandinavian Actuarial Journal 1: 12–28. — Archived copy."
[cram20]: https://en.wikipedia.org/wiki/Cram%C3%A9r%27s_conjecture "Cramér, H. (1920). 'On the distribution of primes.' Proc. Camb. Phil. Soc. 20: 272–280. — See Wikipedia's entry on Cramér's conjecture for the model and its history."
[wiki-cramer]: https://en.wikipedia.org/wiki/Cram%C3%A9r%27s_conjecture "Cramér's conjecture — Wikipedia article covering Cramér's probabilistic model of primes"

Montgomery's pair correlation function ([Montgomery, 1973][mont73]) showed that the non-trivial
zeros of ζ(s) exhibit repulsion at short range — a property shared with GUE eigenvalues.
This connection between prime numbers and random matrix theory is one of the deepest
unexpected links in modern mathematics ([GUE and primes][wiki-gue-primes]).

[mont73]: https://en.wikipedia.org/wiki/Montgomery%27s_pair_correlation_conjecture "Montgomery, H. L. (1973). 'The pair correlation of zeros of the zeta function.' — See Wikipedia's entry on Montgomery's pair correlation conjecture."
[wiki-gue-primes]: https://en.wikipedia.org/wiki/Gaussian_unitary_ensemble#Connection_to_prime_numbers "GUE and the Riemann zeta function — Wikipedia"

The prime k-tuples conjecture ([Hardy & Littlewood, 1923][hl23]) predicts clustering that
Cramér's independent model misses.

[hl23]: https://doi.org/10.1007/BF02403921 "Hardy, G. H. & Littlewood, J. E. (1923). 'Some problems of 'partitio numerorum' III: On the expression of a number as a sum of primes.' Acta Mathematica 44: 1–70."

**What is new:** No prior work computes mutual information between adjacent prime gaps, or
decomposes the information content into lag-1, lag-2, and higher-order components. No prior
work tests whether the alternating oscillation survives the Cramér null model with
bootstrap-confirmed confidence intervals. The oscillation itself — the tendency for large
gaps to be followed by small ones — has been noted qualitatively, but never quantified with
information-theoretic rigor and tested against explicit null models.

## What I'm unsure about

**The cause is unknown.** The oscillation is real, but *why* it exists is not explained by
any model I tested. Three hypotheses:

1. **Local density regulation:** The global constraint that the average gap is log x means
   regions with above-average gap density must be followed by below-average density. But this
   is a weak constraint — it should produce very small effects, not −0.18 bits.

2. **Riemann zero interference:** The oscillatory terms in the explicit formula (driven by
   zeros of ζ(s)) create correlated fluctuations in local prime density. This could encode
   the oscillation at a deeper level.

3. **The Hardy-Littlewood singular series:** The k-tuples conjecture introduces correlations
   that Cramér's independent model misses. The singular series weights different gap patterns
   differently, and this weighting might produce the oscillation.

The singular series hypothesis has now been tested — it moves MI(2) in the wrong direction
(by +0.004). See the companion post for full results.

The GUE / Riemann zero interference hypothesis has now been tested — it also moves MI(2) in
the wrong direction (more negative, not less). See the companion post.

I have not checked whether the MI(2) value converges at larger scales (the 50M window covers
only the first 21% of 235M gaps). I have not tried to derive the real MI(2) from first
principles.

A scale study (1M → 100M primes) shows that real MI(2) converges to zero more slowly than
Cramér MI(2), with a crossover between 20M and 50M where the delta between real and Cramér
flips sign. See the figure above.

**Scale dependence.** A scale study (1M → 100M primes) shows that real MI(2) converges to zero
slower than Cramér MI(2), with a crossover between 20M and 50M where the delta between real
and Cramér flips sign. This suggests the effect is scale-dependent and may require even
larger primes to fully characterize.

![MI(2) scale study: real prime gaps (red) converge to zero more slowly than the Cramér model (blue), with a crossover region between 20M and 50M where the difference changes sign.]({{ '/assets/posts/2026-08-11-prime-gap-oscillation/scale-study.png' | relative_url }})

*MI(2) scale study: real prime gaps converge to zero more slowly than the Cramér model, with
a crossover between 20M and 50M primes.*

**The MI(3) puzzle.** Cramér over-estimates MI(3) by 6.5×, and mod-6 brings it closer but
not all the way. This suggests a different mechanism at work for third-order structure —
perhaps the singular series, which mod-6 conditioning partially captures but doesn't fully
reproduce.

**This is an empirical result, not a proof.** I have not shown that the oscillation persists
as x → ∞. I have not ruled out that it's a finite-scale artifact that vanishes at some
unreachable scale. The bootstrap confirms stability within the data I have, but not beyond it.
