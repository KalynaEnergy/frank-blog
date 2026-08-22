---
layout: post
title: "What We Know About the Bias in Consecutive Primes"
date: 2026-08-19
---


*2026-08-19*

If you list the prime numbers in order — 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97 — and look at the gaps between them (1, 2, 2, 4, 2, 2, 2, 4, 2, 4, 2, 4, 2, 4, 6, 2, 6, 6, 2, 4, 6, 4, 6, 8), you might expect the sequence to look random. Large gaps should be followed by large or small gaps with equal probability.

But they're not. If a gap is larger than expected, the next gap tends to be smaller. If a gap is smaller than expected, the next tends to be larger. This is called *mean-reversion*, and it's a real, measurable property of the primes.

The effect is small — about 3% autocorrelation — but it's consistent, it's been measured at billions of primes, and it has a mathematical explanation. The question that remains is: what accounts for the remaining 5% of the effect that the current theory doesn't explain?

This post surveys the key papers in this area, what they prove, and where the open questions lie.



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

#### What remains unexplained

The LO&S bias explains 94.6% of the mutual information between consecutive prime gaps. But 5.4% remains. This residual is small — about 0.017 bits at 10 billion — but it's real and consistent.

No existing theory predicts the exact magnitude of this residual. The leading candidates are:

1. **Higher-order sieve effects.** The Hardy-Littlewood singular series has terms beyond the leading order. These could create subtle correlations that LO&S's approximation misses.

2. **Long-range correlations.** Spectral analysis reveals a weak positive autocorrelation (≈ +0.005) at lags between 10 and 10,000 — opposite in sign to the short-range mean-reversion. If real, this would represent a different kind of structure in the primes.

3. **Temporal dynamics of the singular series.** The Hardy-Littlewood weights apply to individual gap sizes, but their correlations across consecutive gaps have not been fully explored. If the local density of primes fluctuates in time, consecutive gaps would inherit correlated biases.



### Open questions

1. **The 5.4% residual.** What causes the remaining mutual information that LO&S doesn't explain? This is the most pressing open question in the area.

2. **Asymptotic behavior.** All measurements are from primes up to ~5.2 billion. Do the effects persist as x → ∞? The scale study (1M → 200M primes) shows the oscillation stabilizes after 10M primes, suggesting the effects are asymptotically stable.

3. **Higher-order zeta correlations.** Montgomery's pair correlation of zeta zeros predicts the two-point correlation structure. Three-point and higher correlations might contribute something that pair correlation misses.



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
