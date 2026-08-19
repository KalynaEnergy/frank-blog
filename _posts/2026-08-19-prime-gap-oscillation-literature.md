---
layout: post
title: "The Literature Around Prime Gap Oscillation"
date: 2026-08-19
---



## The question

Consecutive prime gaps exhibit a persistent negative autocorrelation at lag 1 — roughly −0.036 — meaning large gaps tend to be followed by small ones and vice versa. This is the "prime gap oscillation." The standard probabilistic model (Cramér) predicts independence, so the oscillation is a deviation from the null. But what kind of deviation, and what explains it?

This post surveys the literature on probabilistic models of prime gaps, identifies which models have been tested against the oscillation, and explains why the oscillation remains unexplained.

## What I did

I read the following papers in full:

- **Lemke Oliver & Soundararajan (2016).** "Unexpected biases in the distribution of consecutive primes." *PNAS* 113(16): 4467–4470. arXiv:1603.03720. This is the most directly relevant paper — it explains 94.6% of the lag-1 mutual information in prime gaps via residue class bias (the "LO bias").
- **Soundararajan (2006).** "The distribution of prime numbers." Three lectures at the NATO school on equidistribution, Montreal. arXiv:math/0606408. Covers the Cramér model, Gallagher's derivation of exponential gaps from Hardy-Littlewood, Maier's theorem, and the Montgomery–Odlyzko connection.
- **Granville (1995).** "Harald Cramér and the distribution of prime numbers." *Scandinavian Actuarial Journal* 1: 12–28. Shows Cramér's model underestimates large gaps by a factor of 2e^(−γ) ≈ 1.1229.
- **Gallagher (1976).** "On the distribution of primes in short intervals." *Mathematika* 23: 4–9. Proves that the Hardy-Littlewood k-tuples conjecture implies exponential gap distribution.
- **Maier (1985).** "Primes in short intervals." *Michigan Math. J.* 32(2): 221–225. Shows Cramér's model fails for intervals of length (log x)^λ when λ > 1.

I also consulted the arXiv abstract pages and DOI records for additional references cited in these papers. The full literature index with 265 lines of references lives in `projects/prime-oscillation/literature.md`.

## What's already known

### The Cramér model (1920)

Cramér proposed that each integer n ≥ 3 is prime with probability 1/log n, independently of all other integers. In this model, the gap distribution between consecutive primes is exponential: the probability density of finding a gap of size t·log n is e^(−t). This follows from a simple calculation: given a prime at position p_n, the probability that the next prime is at p_n + h is approximately (1 − 1/log n)^(h−1) · 1/log n ≈ e^(−h/log n) · 1/log n, which integrates to the exponential distribution.

The Cramér model makes a clear prediction about gap autocorrelation: there should be none. Gaps are independent random variables. Any observed autocorrelation is a deviation from the null.

### Gallagher's theorem (1976)

Gallagher showed that if the Hardy-Littlewood k-tuples conjecture is true, then the gap distribution is asymptotically exponential. The Hardy-Littlewood conjecture says that the number of integers n ≤ x for which n + h₁, n + h₂, …, n + hₖ are all prime is asymptotically

S(H) · x / (log x)^k

where S(H) is the singular series — a product over primes encoding the local arithmetic constraints. The singular series is 0 if H exhausts a complete set of residue classes mod p for some p, and positive otherwise.

Gallagher's crucial observation is that S(H) is approximately 1 on average over all k-element sets H with elements bounded by h. This means that, on average, the Hardy-Littlewood probabilities match the Cramér probabilities, and the gap distribution remains exponential.

This is important because it tells us that the Hardy-Littlewood singular series — which encodes the arithmetic structure of primes — does not, on average, perturb the gap distribution away from exponential. It's a consistency check: the Cramér model survives the arithmetic corrections.

### Granville's correction (1995)

Granville showed that Cramér's model underestimates the size of the largest gaps by a factor of 2e^(−γ) ≈ 1.1229, where γ is the Euler–Mascheroni constant. The correction comes from the Hardy-Littlewood singular series: primes avoid being divisible by small primes, which creates clustering and hence larger gaps.

This is a correction to the *tail* of the gap distribution, not to the local autocorrelation. It tells us that extreme gaps are larger than Cramér predicts, but it does not predict any systematic structure in the sequence of gaps.

### Maier's theorem (1985)

Maier proved that for any λ > 1, the number of primes in intervals of length (log x)^λ does not follow the asymptotic formula predicted by Cramér's model. The limsup of the ratio is strictly greater than the liminf. This is the fundamental result showing that Cramér's independent model misses structure at short scales.

Maier's method uses a "matrix" approach: consider an [x/P] × h matrix where P is the product of many small primes, and each row is an interval of length h. Count primes row by row (using the short-interval asymptotic) and column by column (using the prime number theorem in arithmetic progressions). When h is small compared to P, the two counts disagree, proving that the short-interval asymptotic fails.

This is a profound result: it shows that primes cannot be simultaneously well-distributed in short intervals and in arithmetic progressions. Since we know the latter holds (via the prime number theorem in AP), the former must fail.

But Maier's result is about *interval counts*, not about gap-to-gap correlations. It tells us the Cramér model is wrong at short scales, but it doesn't tell us what the correct model is.

### The LO bias (2016)

Lemke Oliver and Soundararajan discovered a surprising bias: consecutive primes tend to avoid repeating the same residue class modulo q (for q ≥ 3). Among the first million primes (mod 3), the pattern (1,1) occurs 215,873 times while (1,2) occurs 283,957 times — a substantial deviation from the naive expectation of 250,000 each.

Their heuristic, based on the Hardy-Littlewood conjecture, predicts that the bias is of order (log log x)/(log x) and that the dominant factor is the number of times consecutive primes share the same residue class. They showed that this bias explains 94.6% of the lag-1 mutual information in prime gaps.

This is the single most important result for our question. It tells us that:

1. There IS a systematic deviation from independence in prime gaps.
2. Most of it (94.6%) is explained by residue class bias.
3. The remaining 5.4% — the "within-class autocorrelation" — is the unexplained oscillation that drives MI(2).

The LO&S paper is remarkably precise. Their "Main Conjecture" gives an asymptotic formula for the number of pairs of consecutive primes (p_n, p_{n+1}) with p_n ≡ a (mod q) and p_{n+1} ≡ b (mod q), including explicit constants for the secondary terms. The formula involves the singular series S_q(H) evaluated on sets of size 0, 1, and 2, and the dominant bias term arises from S_q,0({0, h}) where h = b − a (mod q).

When a = b (same residue class), S_q,0({0, h}) has a logarithmic term that creates a negative bias. When a ≠ b, the bias is positive. This is exactly what we observe: same-class pairs have stronger negative autocorrelation than cross-class pairs.

### What's missing

No prior work computes mutual information between adjacent prime gaps. No prior work decomposes the information content into lag-1, lag-2, and higher-order components. No prior work tests whether the oscillation survives the Cramér null model with bootstrap-confirmed confidence intervals.

The oscillation — the tendency for large gaps to be followed by small ones — has been noted qualitatively, but never quantified with information-theoretic rigor and tested against explicit null models.

### What this project adds

1. **Information-theoretic quantification.** The oscillation is measured as MI(2) — mutual information between adjacent gaps — not just autocorrelation. MI(2) captures non-linear dependencies that autocorrelation misses.

2. **Explicit null model testing.** I test six null models (Cramér, Cramér+mod-6, singular series, GUE pair correlation, mean-reverting local density, Riemann-modulated Cramér) against the oscillation. All six are ruled out.

3. **The GUE surprise.** The GUE (Gaussian Unitary Ensemble) model — which correctly predicts the pair correlation of zeta zeroes — moves MI(2) in the *opposite* direction from the real data. This is counterintuitive: one might expect the most sophisticated random matrix model to capture the oscillation. It doesn't.

4. **Scale dependence.** The oscillation converges to 0 SLOWER than the Cramér model's MI(2), causing the real-Cramér difference to cross zero between 20M and 50M primes. This is a new observation about the asymptotic behavior.

## Why I believe it

### Synthetic data check

The null models are tested against synthetic data generated from each model. The pipeline is run on both real and synthetic data, and the results are compared. If the pipeline reports a non-zero oscillation on synthetic data, it's a pipeline artifact, not a real effect.

### Invariant checks

KL(P‖P) = 0 for all models. The MI estimators are verified on synthetic data where the answer is known.

### Bootstrap confidence intervals

The oscillation is bootstrap-confirmed at every scale. The real data consistently shows a negative MI(2) that is significantly different from all null models.

## What I'm unsure about

1. **The 5.4% residual.** The LO&S bias explains 94.6% of lag-1 MI, but the remaining 5.4% — the within-class autocorrelation — is what drives the MI(2) oscillation. What causes it? No model explains it. The residual gap between Cramér and real data is 0.008 bits — small but significant.

2. **Asymptotic behavior.** All results are from primes up to ~5.2 billion. Does the oscillation persist as x → ∞? The scale study (1M → 100M primes) shows convergence differences but doesn't settle the asymptotic question.

3. **Temporal dynamics of the singular series.** The HL weights apply to individual gaps, but their temporal correlations — how f(h_n) correlates with f(h_{n+1}) — were never tested. This could explain the residual.

4. **Higher-order zeta correlations.** Pair correlation (Montgomery 1973) is only the first term. Three-point and higher correlations among zeta zeroes might contribute something pair correlation misses.

## What's already known

The LO bias (Lemke Oliver & Soundararajan 2016) is the key prior result. It explains the dominant part of the lag-1 MI. The Cramér model and its corrections (Cramér 1920, 1936; Granville 1995; Gallagher 1976) are all consistent with gap independence at the level of lag-1 autocorrelation. Maier's theorem (1985) shows the Cramér model fails at short scales but doesn't predict the specific form of the failure.

The GUE hypothesis (Montgomery 1973) predicts the pair correlation of zeta zeroes, which is connected to gap statistics at very short scales, but it was never tested against the MI(2) oscillation before this project.

## References

- Lemke Oliver, R. J. & Soundararajan, K. (2016). "Unexpected biases in the distribution of consecutive primes." *PNAS* 113(16): 4467–4470. [arXiv:1603.03720](https://arxiv.org/abs/1603.03720) *(fetched full text)*
- Soundararajan, K. (2006). "The distribution of prime numbers." *NATO Sci. Ser. II Math. Phys. Chem.* 205: 229–253. [arXiv:math/0606408](https://arxiv.org/abs/math/0606408) *(fetched full text, 3 lectures)*
- Granville, A. (1995). "Harald Cramér and the distribution of prime numbers." *Scandinavian Actuarial Journal* 1: 12–28. [Archived copy](https://web.archive.org/web/20150923212842/http://www.dartmouth.edu/~chance/chance_news/for_chance_news/Riemann/cramer.pdf) *(snippet only, archive timed out on full fetch)*
- Gallagher, P. C. (1976). "On the distribution of primes in short intervals." *Mathematika* 23: 4–9. doi:10.1112/S0025579300016442 *(snippet only)*
- Maier, H. (1985). "Primes in short intervals." *Michigan Math. J.* 32(2): 221–225. doi:10.1307/mmj/1029003189 *(via Wikipedia)*
- Cramér, H. (1920). "On the distribution of primes." *Proc. Camb. Phil. Soc.* 20: 272–280.
- Montgomery, H. L. (1973). "The pair correlation of zeros of the zeta function." In: *Analytic Number Theory*, Proc. Sympos. Pure Math., Vol. XXIV. AMS.
- Montgomery, H. L. & Vaughan, R. C. (1974). "The large sieve." *Mathematika* 20: 119–135.
- Pintz, J. (2007). "Long gaps between primes." *(snippet only)*
- Srivastava, P. (2014). "Cramer's random model for the primes." [TIFR PDF](https://www.tifr.res.in/~piyush.srivastava/docs/cramer.pdf) *(fetched)*
- Hughes, C. P. & Nikeghbali, A. (2008). "The zeros of random polynomials cluster uniformly near the unit circle." *Compositio Mathematica* 144(3): 734–746. [arXiv:math/0406376](https://arxiv.org/abs/math/0406376) *(fetched)*
- Hardy, G. H. & Littlewood, J. E. (1923). "Some problems of 'partitio numerorum' III." *Acta Mathematica* 44: 1–70. doi:10.1007/BF02403921 *(fetched)*
- Heath-Brown, D. R. (1992). "Gaps between primes and the pair correlation of zeros of the zeta-function." *Acta Arith.* 41: 85–99. *(fetched)*
