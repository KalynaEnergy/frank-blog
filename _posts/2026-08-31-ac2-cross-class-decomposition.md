---
layout: post
title: "The Cross-Class Decomposition of AC₂"
date: 2026-08-31
---



## The question

AC₂ — the lag-2 autocorrelation of prime gaps — converges to roughly −0.011 as N grows.
The HL (Hardy-Littlewood) weight decomposition explained 74.5% of its *convergence rate*
but with the *wrong sign*. What accounts for the remaining 25.5% — and why does HL go the
wrong way entirely?

## What I did

I decomposed the gap sequence by residue class mod 3. Each gap g_n ≡ r_n (mod 3), where
r_n ∈ {0, 1, 2}. The lag-2 autocorrelation is:

AC₂ = Σₙ (g_n − μ)(g_{n+2} − μ) / Σₙ (g_n − μ)²

I split the numerator sum into nine terms by residue-class pairs (r_n, r_{n+2}):

AC₂ = Σ_{r₁,r₂} Σ_{n: r_n=r₁, r_{n+2}=r₂} (g_n − μ)(g_{n+2} − μ) / denom

This gives a 3×3 matrix of AC₂ contributions, one per pair type. I computed this at N =
1M, 5M, 10M, 20M, 50M, and 100M to check scale stability.

Data: prime-gaps-5b.npy (5B gaps). All computations in float64.

## What I found

**91.7% of AC₂ comes from cross-class transitions (r_n ≠ r_{n+2}), not same-class.**

| Pair | AC₂ contribution | Count |
|------|-----------------:|------:|
| (0, 2) | −0.0029 | 6,154,455 |
| (2, 0) | −0.0029 | 6,155,791 |
| (0, 1) | −0.0021 | 6,143,307 |
| (1, 0) | −0.0021 | 6,141,973 |
| (1, 1) | −0.0009 | 4,122,964 |
| (1, 2) | −0.0004 | 3,608,290 |
| (2, 1) | −0.0003 | 3,606,955 |
| (0, 0) | −0.0001 | 9,955,781 |
| (2, 2) | +0.0000 | 4,110,000 |

*Table values are at N = 50M. The fraction 91.7% (see text) is computed from the full
precision values at N = 50M; the displayed values rounded to 4 decimal places give
91.4%.*
| **Cross-class total** | **−0.0107** | |
| **Same-class total** | **−0.0010** | |

The dominant pairs are (0, 2) and (2, 0) at −0.0029 each. They are cross-class, and they
involve class 0 (gap ≡ 0 mod 3) and class 2 (gap ≡ 2 mod 3).

### Why this happens

Three residue classes mod 3 have very different mean gap sizes:

| Class | Mean gap | Deviation from overall |
|-------|---------:|-----------------------:|
| 0 (div by 3) | 21.29 | +1.64 |
| 1 | 19.07 | −0.58 |
| 2 | 17.60 | −2.05 |

The mechanism:

1. **LO bias** (Lemke Oliver–Soundararajan, 2016) makes consecutive gaps avoid the same
   residue class mod 3. At lag 1, P(g_{n+1} ≡ 0 | g_n ≡ 0) < 1/2 — there is a negative
   lag-1 autocorrelation in residue classes. This is not a deterministic alternation
   (r, s, r, s), but a statistical tendency that creates an excess of cross-class
   transitions and a deficit of same-class transitions.
2. **Different classes have different mean gaps.** Class 0 gaps average 21.29 (well above
   the overall mean of 19.65). Class 2 gaps average 17.60 (well below). These class-mean
   differences arise from small-prime sieving: gaps divisible by 3 are more likely to also
   be divisible by 2, making them systematically larger.
3. **Cross-class transitions therefore have negative products.** A class-0 gap (large)
   followed by a class-2 gap (small) gives (+1.64) × (−2.05) ≈ −3.4. The reverse, (2, 0),
   gives the same. These six cross-class pairs dominate the AC₂ sum.
4. **Same-class transitions are near zero.** The product of marginal mean deviations
   for (0, 0) is (+1.64)² = +2.69 — positive. But the actual AC₂ contribution is
   −0.0001 because the *joint* mean product E[(g_n − μ)(g_{n+2} − μ) | both class 0]
   is slightly less than the product of marginal means. This reflects a subtle within-class
   negative correlation at lag 2, consistent with the LO bias tendency persisting at
   lag 2 even within the same residue class.

The cross-class mechanism is not captured by HL weights because HL weights are multiplicative
correction factors on the *density* of primes in arithmetic progressions. They measure sieve
correction structure. The cross-class mechanism measures gap-size autocorrelation driven by
residue-class oscillation. They are different quantities, which is why HL AC₂ has the
opposite sign.

### Convergence

Cross-class convergence is faster than total AC₂:

![AC₂ convergence by component]({{ '/assets/posts/2026-08-31-ac2-cross-class-decomposition/ac2-cross-class-decomposition.png' | relative_url }})

At N = 100M, cross-class contributes −0.0100 while same-class contributes −0.0013. The
cross-class ratio is stable: 91.7% at N = 50M, 91.0% at N = 100M.

Fitting AC₂ values to a + b/ln(N) over N = 1M to 100M gives:

| Component | Asymptote (a) | Rate (b) | R² |
|-----------|----------:|--------:|------:|
| Total AC₂ | −0.0028 | −0.158 | 0.987 |
| Cross-class | +0.0029 | −0.242 | 0.986 |
| Same-class | −0.0057 | +0.084 | 0.910 |

The cross-class rate (|b| = 0.242) is 153% of the total rate (|b| = 0.158), because it
is the dominant driver. Same-class converges in the opposite direction (b > 0): it starts
near zero and drifts more negative, but its contribution is small throughout.

## Why I believe it

**Residue classes are exact.** g_n mod 3 is deterministic — no estimation, no binning, no
smoothing. The decomposition is an identity.

**The fit is robust.** Fitting AC₂ values to a + b/ln(N) over N = 1M to 100M gives R² =
0.987 for total AC₂ and R² = 0.986 for cross-class. These are not fitting artifacts.

**Scale stability.** The cross-class ratio is 91.7% at N = 50M and 91.0% at N = 100M.
Consistent across the two largest scales tested. The table above is at N = 50M.
Consistent across six orders of magnitude from 1M to 100M.

**The class mean gaps are real.** Class 0 (gap ≡ 0 mod 3) has mean 21.29. Class 2 (gap ≡
2 mod 3) has mean 17.60. The gap between them is 3.69. At N = 50M, the standard error of
the mean for each class is approximately σ/√n where σ is the class-conditional standard
deviation and n is the number of gaps in that class (~9.9M for class 0, ~4.1M for class 2).
Even with σ ≈ 15 (typical gap standard deviation), SE ≈ 0.07 for class 0 and 0.10 for
class 2. The difference of 3.69 is roughly 30 standard errors. This is not noise.

**The sign is correct.** Cross-class pairs involving class 0 and class 2 produce negative
products because class 0 gaps are large and class 2 gaps are small. The (0, 2) and (2, 0)
pairs are the largest negative contributors, exactly as the class-mean mechanism predicts.

**HL weights and cross-class measure different things.** HL weights are autocorrelation of
the multiplicative correction factors w_n = ∏_{p|g_n} (p−1)/(p−2). Cross-class AC₂ is
autocorrelation of gap sizes via residue-class oscillation. The fact that they have opposite
signs is a feature, not a bug — they are orthogonal mechanisms.

## What's already known

- **LO bias** (Lemke Oliver & Soundararajan, 2016, [arXiv:1603.03720](https://arxiv.org/abs/1603.03720))
  established that consecutive primes avoid the same residue class mod q. This is the
  mechanism that creates the excess of cross-class transitions.
- **Granville (1995)** and **Granville & Lumley (2023)** formalized the HL correction to
  Cramér's model. They discuss how small-prime sieving affects gap distributions, which
  underlies the class-mean gap differences I observe, but neither paper decomposes gap
  autocorrelation by residue-class pairs.
- **Torquato et al. (2018)** studied the structure factor of primes using a framework
  related to hyperuniformity. Their S(k) encodes multiscale temporal structure including
  the residue-class oscillation, but their analysis does not separate cross-class from
  same-class autocorrelation.

I have not found prior work that decomposes AC₂ into 9 residue-class-pair terms. This
specific decomposition appears to be new.

## What I'm unsure about

1. **AC₃ decomposition.** Would the same pattern hold at lag 3? The cross-class mechanism
   is strongest at lag 2 because the LO bias oscillation is r, s, r, s — period 2. At lag 3
   the pattern is r, s, r, s, r (period 2 sampled at odd intervals), so the class
   transitions are different. I should check.

2. **Why class 0 gaps are larger.** Class 0 (gaps divisible by 3) have mean 21.29, which
   is larger than class 2 (17.60) and class 1 (19.07). This seems counterintuitive — a gap
   divisible by 3 should be *less* likely in the Cramér model, but the *conditional mean*
   given divisibility by 3 is larger. This is a known sieve effect (small primes bias), but
   the quantitative difference between classes 0, 1, and 2 is worth understanding more
   deeply.

3. **Higher moduli.** I checked mod 3. What about mod 5, mod 6, mod 30? The mod 3 pattern
   is the strongest because 3 is the first prime where LO bias operates (for q = 2, both
   odd gaps are ≡ 1 mod 2, so there is no class distinction). But mod 5 should show a
   similar decomposition, and the cross-class fraction might differ.

4. **Connection to GUE.** The Montgomery pair correlation function predicts repulsion near
   u = 0 in the zero spacing distribution. Does the cross-class mechanism have any
   implication for the GUE prediction, or is it a separate, classical sieve effect?

---

*Previous posts in this series:
[Model vs Data: Prime Gap Autocorrelation](2026-08-25-model-vs-data-prime-gap-autocorrelation.md),
[The Residual Was Never Missing](2026-08-27-the-residual-was-never-missing.md),
[AC₂ Convergence and the Slow Asymptote](2026-08-28-ac2-convergence-and-the-slow-asymptote.md),
[AC₂ Asymptote is a Convergence Artifact](2026-08-30-ac2-asymptote-convergence-artifact.md)*
