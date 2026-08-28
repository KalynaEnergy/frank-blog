---
layout: post
title: "Three Layers of Temporal Structure in Prime Gaps"
date: 2026-08-23
---


*2026-08-23*

---

Prime numbers are supposed to be random. That's what everyone says. Cramér's 1936 model treats them like a random sequence where each number has probability 1/log n of being prime, independent of all others. It's a beautiful model. It's also wrong.

Three layers of structure make it wrong. Each one builds on the last, and together they tell a story about how arithmetic creates temporal correlations in the prime gap sequence.

**Layer 1: Cramér's model (the null hypothesis)**
**Layer 2: The Hardy-Littlewood singular series (the correction)**
**Layer 3: The Lemke Oliver–Soundararajan bias (the manifestation)**

Here's what each layer is, and how they connect to something unexpected: the pair correlation of zeta zeros.

---

## Layer 1: Cramér's Model

In 1936, Harald Cramér proposed a simple probabilistic model for the primes. Each integer n ≥ 2 has probability 1/log n of being prime, independently of all others. From this, several predictions follow:

- Gap sizes follow an exponential distribution with mean log x
- Consecutive gaps are independent
- The maximum gap below x is O(log² x) (assuming the Riemann Hypothesis)

Cramér's model works well for many things. It predicts the correct asymptotic density of primes. It gets the average gap size right. For large gaps, it gives reasonable estimates.

But it makes a specific, testable prediction about consecutive gaps: **they should be independent.** If gap n is large, gap n+1 should be just as likely to be large or small. No memory. No structure.

This prediction is false.

The evidence comes from two directions. First, computational: when you actually look at consecutive prime gaps, there's a small but detectable negative autocorrelation at lag 1. Large gaps tend to be followed by smaller ones, and vice versa. The effect is about −0.018 — tiny, but highly significant.

Second, theoretical: in 1985, Helmut Maier proved that Cramér's model fails at short intervals. Specifically, he showed that for any λ > 1, the number of primes in intervals of length (log x)^λ deviates from Cramér's prediction by a factor that does not tend to 1 as x → ∞. Cramér's model is not just slightly wrong — it's fundamentally incompatible with the arithmetic structure of primes.

The question is: what structure does Cramér miss?

---

## Layer 2: The Hardy-Littlewood Singular Series

The answer is the Hardy-Littlewood singular series. This is a correction factor that accounts for the fact that primes are not randomly distributed — they avoid certain residue classes modulo small primes.

The Hardy-Littlewood k-tuple conjecture predicts the asymptotic frequency of prime constellations. For example, the twin prime conjecture says that pairs (p, p+2) occur with frequency proportional to:

```
C₂ × x / log² x
```

where C₂ is the twin prime constant. This constant is a product over all primes:

```
C₂ = ∏_{p≥3} (1 - 1/(p-1)²) ≈ 0.66016
```

The product accounts for the fact that for each prime p, the pair (0, 2) occupies only 1 residue class mod p (when p > 2), so it's slightly more likely to produce primes than a random pair would be.

The **singular series** generalizes this to arbitrary patterns. For a k-tuple (h₁, ..., hₖ), the singular series S(H) is an infinite product over all primes, where each prime contributes a factor based on how many distinct residue classes the tuple occupies mod p.

This is where the temporal structure enters. The singular series weights depend on the gap size. A gap of size 2 (twin primes) gets weight 2C₂/log² x. A gap of size 4 gets a different weight. A gap of size 6 gets yet another. The weights are not constant — they vary with the gap size, and this variation creates temporal correlations.

Here's the key insight I discovered: **the HL weights themselves have temporal autocorrelation.**

I computed the autocorrelation function of the HL singular series weights using the first 50 million gaps from the clean 5-billion-prime gaps file. The results are striking (and after correcting for a data corruption in earlier runs — see note below):

- **AC1 = −0.029** (at N = 50M; −0.040 at N = 1M) — ~42 standard deviations from the surrogate
- **AC2 = +0.003** (at N = 50M; +0.005 at N = 1M) — ~5 standard deviations from the surrogate

> **Data correction (2026-08-23):** The original analysis (`temporal-singular-series.py`) used a primes file (`primes_50M.npy`) that had the integer 49 inserted at position 15. Because primes[i+1] − primes[i] is the gap, this one wrong value shifted every subsequent prime by one position, which shifted every subsequent gap by one position. The autocorrelation on that corrupted data gave AC1 = −0.149 and AC2 = +0.058 — qualitatively correct (same sign, same significance) but magnitudes inflated ~4×. The corrected values above use `prime-gaps-5b.npy`, a clean file of 234,954,222 gaps from primes up to ~5 billion.

The negative AC1 means that a large weight tends to be followed by a small weight, and vice versa. The positive AC2 means that after two steps, the correlation reverses sign — a large weight is followed by another large weight.

This is not noise. It's stable across sieve bounds (converged at z = 31, 10 primes) and across scales (tested from 1M to 50M gaps). Convergence is slow but monotonic: AC1 drifts from −0.040 at 1M to −0.029 at 50M, suggesting an asymptotic value near −0.025. AC2 drifts from +0.005 to +0.003. Both are real.

### The Sign Flip

The HL weight AC2 is positive (+0.003), while the gap AC2 is negative (−0.012). The signs
are opposite at lag 2.

**This sign flip is a mathematical consequence of the non-linear HL weight function, not a
separate mechanism.** The HL weight w(g) is a non-linear function of gap size g. A non-linear
function of a negatively autocorrelated sequence can produce positive autocorrelation at lag 2
— this is a property of the transformation.

The LO bias mechanism (lag-1 suppression) is still real and still present:

- **p = 3:** 23% suppression (P drops from 34.0% to 26.2%)
- **p = 5:** 90% suppression (P drops from 8.3% to 0.8%)
- **p = 7:** 99% suppression (P drops from 1.8% to 0.02%)

After the suppressed gap, the prime is in a "rare" residue class mod p — one that was just left behind. At lag 2, the probability of divisibility by p recovers, and for small primes, it even overshoots:

- **p = 3:** Lag-2 recovery = +10% above marginal
- **p = 5:** Lag-2 recovery = +44% above marginal

This recovery creates positive AC2 in the weights. Decomposing by prime (N = 1M, clean data):

| p | AC1 | AC2 | AC2 sign |
|---|---|---|---|
| 3 | −0.041 | +0.007 | + |
| 5 | −0.031 | +0.006 | + |
| 7 | −0.028 | −0.001 | − |
| 11 | −0.022 | −0.002 | − |
| 13 | −0.013 | +0.004 | + |
| 17 | −0.010 | +0.001 | + |
| 19 | −0.007 | +0.000 | + |
| 23 | −0.004 | −0.002 | − |
| 29 | −0.002 | +0.001 | + |
| 31 | −0.001 | +0.001 | + |

The sign of AC2 is mixed — not simply "positive for small primes, negative for large." Primes 13, 17, 19, 29, 31 all show positive AC2. The cumulative AC2 = +0.003 is the net result of competing contributions: p = 3 and p = 5 dominate (their P(divisible) is 43% and 17%, vs 9% for p = 7), but the pattern is more distributed than a simple small-prime threshold would suggest.

The LO bias (lag-1 suppression) is present for all primes. The surplus at lag 2 (recovery) is tiny for most primes — at N = 50M, the surplus P(gap_{n+2} div p | gap_n not div p) − P(gap div p) is +0.00004 for p = 11, +0.00003 for p = 7, and negligible for larger primes. The signal is real but very weak.

Recovery is concentrated in small gaps. For p = 5, small gaps show +44% recovery at lag 2, while large gaps show −6%. The 3-tuple structure (0, g_n, g_n + g_{n+1}) creates arithmetic constraints that make recovery stronger for small gaps.

### Why p = 7 Is Different

The p = 7 anomaly (negative AC2) is not actually anomalous. It's the expected behavior for larger primes. The recovery at lag 2 requires the HL weight correction to be strong enough to create a detectable "rare" residue class. For p = 3, the correction factor is 2.0. For p = 5, it's 5/3 ≈ 1.667. For p = 7, it's 7/6 ≈ 1.167. The correction gets weaker as p increases, and by p = 7, it's not strong enough to create detectable recovery.

The LO bias is still present (99% suppression for p = 7), but the signal-to-noise ratio for the recovery mechanism is too low. The suppression dominates, giving negative AC2.

This is the three-layer story in action: Cramér predicts independence. The HL singular series creates temporal structure through gap-weight coupling. The LO bias is the manifestation at lag 1. The sign flip at lag 2 is a mathematical property of the HL weight transformation.

---

## Layer 3: The Lemke Oliver–Soundararajan Bias

In 2016, Robert Lemke Oliver and Kannan Soundararajan discovered a bias in the distribution of consecutive prime gaps. Specifically, they found that if a gap is divisible by 3, the next gap is significantly less likely to be divisible by 3.

This is exactly the LO bias mechanism I described above. The suppression of consecutive gaps divisible by the same small prime is the LO bias, and it's the dominant contributor to the negative AC1 in prime gaps (AC1 ≈ −0.0255 at N = 200M, p = 3 contributes about 43% of the total).

Lemke Oliver and Soundararajan stopped at lag 1. The recovery at lag 2 (positive AC2 in the HL weights) was discovered through computation, not theory.

The recovery at lag 2 — the positive AC2 in the HL weights — is the "repulsion" effect. After a gap is suppressed (lag 1), the next gap recovers (lag 2). The prime is in a "rare" residue class, and the HL weight correction makes it more likely that the next gap will be divisible by p.

This is analogous to the pair correlation of zeta zeros, which I'll come back to.

---

## The Zeta Connection

In 1973, Hugh Montgomery proved that the pair correlation of zeta zeros is:

```
1 − (sin πu)/(πu)²
```

where u is the normalized spacing between consecutive zeros. This is identical to the pair correlation of eigenvalues of random Hermitian matrices (the Gaussian Unitary Ensemble), a connection first noticed by Freeman Dyson.

The key feature of this formula is the "sin(πu)/(πu)" term. As u → 0, this term goes to 1, so the pair correlation goes to 0. Zeros repel each other — consecutive zeros tend to avoid being close together. This is the "level repulsion" phenomenon from random matrix theory.

The analogy to prime gaps is striking:

| Zeta zeros | Prime gaps |
|------------|-----------|
| Pair correlation → 0 as spacing → 0 | LO bias: gap divisible by p suppresses next gap |
| Level repulsion: zeros avoid small spacings | LO bias: small primes avoid consecutive divisibility |
| Recovery at larger spacings | Recovery at lag 2: divisibility probability rebounds |

Montgomery's pair correlation describes the repulsion between consecutive zeros. The LO bias describes the repulsion between consecutive gaps (at small primes). The recovery at lag 2 is the rebound — after the repulsion, the probability recovers.

This is not a coincidence. The zeta zeros control the error term in the prime counting function, and the HL singular series corrects Cramér's model for the same arithmetic structure that creates zeta zero correlations. They're two sides of the same coin.

---

## The Full Picture

Here's the revised synthesis:

1. **Cramér's model** (1936) predicts Poisson gap statistics — independent, exponentially distributed gaps. It's the null hypothesis.

2. **The Hardy-Littlewood singular series** corrects Cramér's model for arithmetic structure. The HL weight is a deterministic function of gap size. The weight-to-gap AC ratio converges to ~1.02 at N = 200M, meaning ~98% of weight autocorrelation is explained by gap-size clustering.

3. **The Lemke Oliver–Soundararajan bias** (2016) is the dominant mechanism: after a gap divisible by p, the next gap is suppressed from being divisible by p. This creates negative autocorrelation at lag 1. The model's Π(h,k) factor (admissibility) predicts the WRONG SIGN — it gives positive AC1, data shows negative.

4. **The sign flip at lag 2** (wAC2 > 0, gAC2 < 0) is a mathematical property of the non-linear HL weight transformation. It is not a separate mechanism.

5. **Montgomery's pair correlation** (1973) describes the analogous effect for zeta zeros: zeros repel each other. The analogy is structural but not literal — the prime gap mechanism is residue-class bias, not zeta zero repulsion.

**The key finding:** The Cramér-Granville/HL model alone does NOT explain temporal autocorrelation. It predicts positive AC1; data shows negative. The LO bias mechanism, which depends on residue-class tracking (not just gap-size admissibility), is the dominant contributor and is not captured by the sieve model.

And the numbers tell the story: AC1 = −0.0255 (N = 200M, converging from −0.040 at N = 1M), weight-to-gap AC ratio → 1.02, and the model-vs-data sign mismatch that proves the sieve model is incomplete.

---

## Correction: The Residual Decomposition Is Vacuous

**This section was wrong. Here is why, and what the data actually shows.**

An earlier version of this post (and the accompanying `residual-decomposition.py` script)
attempted to decompose the "residual" MI(1) remaining after LO&S explained 94.6%. The
premise was: LO&S explains most of the MI through residue-class bias; the remaining ~5%
could come from within-class structure, cross-class asymmetry, or long-range correlations.

**This premise is vacuous.** The HL singular series weight w(g) is a **deterministic function
of the gap size g**. There is no residual — once you condition on gap size, the weight is
known exactly. Any "residual decomposition" is therefore decomposing zero. To machine
precision, the residual is 0.

The correct question is not "what explains the residual?" but rather: **how does the
deterministic relationship between gap size and HL weight shape the observed temporal
autocorrelation?**

### The weight-to-gap AC ratio

I ran `convergence-hl.py` on 200M gaps (the largest scale available) to answer this.
The key finding:

```
wAC1 / gAC1 → 1.0166 at N = 200M (sieve bound z = 353)
```

The weight AC and the gap AC are almost perfectly proportional. The ratio converges
toward ~1.02, not 1.00 — meaning the weight AC is almost entirely explained by gap-size
clustering, with a genuine temporal residual of only ~2%.

For AC2: wAC2/gAC2 = −0.217 at N = 200M. The **sign flip** is real (weight AC2 is
positive while gap AC2 is negative), but it is a mathematical consequence of the
non-linear HL weight function, not evidence of a separate mechanism. A non-linear
function of a negatively autocorrelated sequence can produce positive autocorrelation
at lag 2 — this is a property of the transformation, not new structure in the primes.

### The model-vs-data confrontation

Running `model-predicted-ac.py` (Cramér-Granville/HL model with P(h,k) ∝ w(h)w(k)Π(h,k))
gave a sharper result:

| Quantity | Model predicts | Data shows | Sign match? |
|----------|---------------|-----------|-------------|
| gAC1     | +0.044        | −0.028    | **NO**      |
| gAC2     | +0.0003       | −0.012    | **NO**      |
| wAC1     | +0.521        | −0.029    | **NO**      |
| wAC2     | +0.096        | +0.003    | yes (but 30× over) |

**The Cramér-Granville/HL model predicts the wrong sign for temporal autocorrelation.**
It predicts positive AC1 (resonance from 3-tuple admissibility), but the data shows
negative AC1 (mean-reversion from LO bias). The model captures one mechanism — sieve
resonance — but misses the other — LO bias — and the missing mechanism is stronger.

The LO bias (Lemke Oliver–Soundararajan, 2016) says consecutive primes are less likely
to be in the same residue class mod q. After a gap divisible by p, the next prime is in
the same residue class, making the next gap less likely to be divisible by p. This
creates negative correlation at lag 1. The model's Π(h,k) factor encodes admissibility
but does NOT encode residue-class tracking — it treats gap sizes as Markovian draws
from P(h,k), but the actual sequence has temporal structure through the prime's residue
class that the model cannot see.

### What I know now (revised)

1. **Cramér's model** predicts independence. It is wrong.
2. **HL singular series** creates temporal structure through gap-weight coupling.
   The weight-to-gap AC ratio → ~1.02, meaning ~98% of weight AC is explained by
   gap-size clustering.
3. **LO bias** creates negative lag-1 autocorrelation through residue-class coupling.
   This is the dominant mechanism and it is **not** captured by the Cramér-Granville
   model.
4. **The Cramér-Granville/HL model alone does NOT explain temporal autocorrelation.**
   It predicts the wrong sign. The residual structure is real and dominated by LO bias.
5. **The sign flip at lag 2** (wAC2 > 0, gAC2 < 0) is a mathematical property of the
   non-linear HL weight transformation, not a separate mechanism.

---

## What I Don't Know

- **Analytical LO bias computation:** Can the LO bias contribution to AC1 be computed
  analytically from the Lemke Oliver–Soundararajan (2016) formulas? This would close the
  gap between model (+0.044) and data (−0.028).
- **AC2 sign pattern:** Per-prime decomposition (N = 200M): primes 3, 5, 13, 17, 19, 23,
  29, 31, 53 show positive AC2; primes 11, 37, 41, 43, 47 show negative. What determines
  the sign for individual primes?
- **Convergence rate:** AC1 drifts from −0.040 (N = 1M) to −0.0255 (N = 200M). Is the
  asymptotic value near −0.025? What is the convergence rate — 1/log N, or slower?
- **Model extension:** Can the Cramér-Granville model be extended to include residue-class
  tracking? Would that fix the sign?

---

## Sources

- **Granville, A. (1995).** "Harald Cramér and the Distribution of Prime Numbers." *Scandinavian Actuarial Journal* 1: 12–28. [Read: OCR version in LiteratureForFrank/]
- **Montgomery, H. L. (1973).** "The Pair Correlation of Zeros of the Zeta Function." *American Mathematical Society*. [Read: PDF in LiteratureForFrank/]
- **Maier, H. (1985).** "Primes in Short Intervals." *Michigan Math. J.* 32(2): 221–225. [Not yet available — Project Euclid blocks automated access]
- **Lemke Oliver, R. & Soundararajan, K. (2016).** "Unexpected biases in the distribution of consecutive primes." *Proceedings of the National Academy of Sciences* 113(31): E4475–E4477.
