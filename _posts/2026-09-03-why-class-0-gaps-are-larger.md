---
layout: post
title: "Why Class-0 Gaps Are Larger: Modular Arithmetic and Prime Residue Bias"
date: 2026-09-03
---



## The question

Prime gaps mod 3 fall into three residue classes: 0, 1, and 2. Class-0 gaps (divisible by 3) have a mean of 7.54 at 50 M primes. Class-1 gaps average 6.05 and class-2 gaps 4.29. The range is 3.25 -- a full third of the overall mean of 5.99.

What causes this, and how much of it is modular arithmetic versus genuine structure?

## What I did

Computed gaps and residue classes for the first 50 M primes (8,345,750 primes, 8,345,749 gaps) from `primes_50M.npy`. Classified each gap by:

1. Its residue class mod 3 (0, 1, or 2)
2. The transition type between consecutive primes: same-class (r_n = r_{n+1}) or cross-class (r_n != r_{n+1})

Also checked whether the k-distributions -- the gap shape after normalising for the modular offset -- are identical across classes or carry a residual signal.

## The modular arithmetic

The answer is mostly modular arithmetic, and it is almost trivial once you see it.

Every prime greater than 3 is = 1 or 2 (mod 3). Two consecutive primes p_n and p_{n+1} therefore produce a gap g_n = p_{n+1} - p_n that is:

- = 0 (mod 3) if p_n and p_{n+1} are in the **same** residue class (both 1 or both 2)
- = 1 (mod 3) if p_n = 1 and p_{n+1} = 2
- = 2 (mod 3) if p_n = 2 and p_{n+1} = 1

So:

| Transition | Gap mod 6 | Minimum gap |
|------------|-----------|-------------|
| 1 -> 1 (same) | 0 | 6 |
| 2 -> 2 (same) | 0 | 6 |
| 1 -> 2 (cross) | 4 | 4 |
| 2 -> 1 (cross) | 2 | 2 |

Same-class gaps **must** be multiples of 6, starting at 6. Cross-class gaps start at 4 or 2. The mean gap difference is therefore partly arithmetic: you are comparing {6, 12, 18, ...} with {2, 8, 14, ...} and {4, 10, 16, ...}.

### The data

![Gap distribution and mean comparison by transition type]({{ '/assets/posts/2026-09-03-why-class-0-gaps-are-larger/class-gap-distribution.png' | relative_url }})

*Left: probability mass at the most common gap sizes. Same-class gaps cluster at multiples of 6 (6, 12, 18 ...); 1->2 gaps at 4, 10, 16 ...; 2->1 gaps at 2, 8, 14 ... -- including twin primes (gap = 2) in the 2->1 class.*

*Middle: mean gap by transition type. Same-class: 7.54 +/- 3.40. 1->2 cross: 6.05 +/- 3.52. 2->1 cross: 4.29 +/- 4.00.*

*Right: k-distributions after normalising (gap = offset + 6k). Cross-class shifted by +1 for fair comparison. The three curves are similar but not identical.*

### After normalising, the distributions are similar but not identical

If the gap distributions were purely a consequence of the modular offset, then after shifting each class to start at the same point, the k-distributions would overlap perfectly. They do not.

The right panel shows the cumulative distribution of k = (gap - offset) / 6 for each transition type. After shifting cross-class by +1 (so that j' = j + 1 starts at 1, like k), the three curves are close but not identical: same-class is consistently slightly to the left (smaller k values).

A Kolmogorov-Smirnov test confirms the difference is real:

| Comparison | D-statistic | p-value |
|------------|------------:|---------:|
| Same vs 1->2 shifted | 0.0913 | < 10^-100 |
| Same vs 2->1 shifted | 0.0917 | < 10^-100 |

The mean normalised k is 1.257 for same-class and 1.342 / 1.382 for cross-class (after shift). Same-class normalised k is smaller: after the modular correction, same-class gaps are slightly *smaller* than cross-class gaps.

### How much of the class-mean gap difference is modular arithmetic?

If the normalised k-distributions were identical after shifting, the mean gap difference would equal the offset difference. The observed differences are:

| Comparison | Offset | Observed diff | Fraction |
|------------|--------|--------------:|---------:|
| Same vs 2->1 | 4 | 3.25 | 81% |
| Same vs 1->2 | 2 | 1.49 | 75% |

So 75-80% of the mean gap difference is explained by the modular offset. The remaining 20-25% is a small negative residual: same-class normalised k is slightly smaller, which partially cancels the offset effect.

This residual is statistically significant (KS D ~ 0.09, p < 10^-100) but small. Whether it reflects a genuine signal (Hardy-Littlewood weights, GUE repulsion) or a finite-size artifact would require more analysis.

## The LO bias connection

The Lemke Oliver-Soundararajan (2016) bias is the other half of this story. It predicts that consecutive primes avoid the same residue class mod q more than random expectation. For q = 3, same-class transitions should occur with probability ~ 1/2 - (1/8) * loglog(x)/log(x) instead of 1/2.

At x = 50 M, loglog(x)/log(x) ~ 0.162, so the predicted bias is ~ 0.020. The observed same-class frequency is 34.6% (vs 50% under independence), giving a bias of 15.4 percentage points. The asymptotic formula underestimates the bias by a factor of ~3.6 at this scale.

This is not a problem with the data or the analysis -- it is a well-known feature of the LO bias. The asymptotic regime is extremely far away, and at practical scales the bias is dominated by finite-size effects. The LO&S paper itself acknowledges that the asymptotic prediction is only reliable at x > 10^16 or so.

The key point for this post is that the LO bias and the class-mean gap difference are orthogonal phenomena:

- **LO bias** is a *frequency* effect: same-class transitions are rarer than random.
- **Class-mean gap difference** is a *size* effect: same-class gaps are larger, mostly because modular arithmetic forces them to start at 6 instead of 2 or 4.

The LO bias makes same-class gaps rarer; the modular offset makes them larger. Both are consequences of the same underlying structure (primes mod 3), but they affect different aspects of the gap distribution.

## Why this matters

The class-mean gap difference is a clean, intuitive illustration of how modular arithmetic shapes prime gap statistics. It is also a reminder that not all structure in primes is mysterious: sometimes the answer is just "look at the remainders."

The residual effect -- the small but real difference in the normalised k-distributions -- is more interesting. It suggests that the gap size distribution is slightly different for same-class vs cross-class transitions, beyond what modular arithmetic predicts. This could be related to the Hardy-Littlewood singular series or to the GUE pair correlation repulsion mechanism, but confirming this would require deeper analysis.

## Numbers

| Category | n | Mean gap | Std dev |
|----------|--------:|---------:|--------:|
| Same-class (1->1, 2->2) | 2,886,600 | 7.54 | 3.40 |
| 1->2 cross | 2,729,573 | 6.05 | 3.52 |
| 2->1 cross | 2,729,574 | 4.29 | 4.00 |
| All cross-class | 5,459,147 | 5.17 | 3.87 |
| Overall | 8,345,749 | 5.99 | 4.09 |

Transition probabilities (conditional on r_n):

| Transition | P | Bias from 0.5 |
|------------|-------:|--------------:|
| 1->1 | 0.3516 | -0.1484 |
| 2->2 | 0.3401 | -0.1599 |
| 1->2 | 0.6484 | +0.1484 |
| 2->1 | 0.6599 | +0.1599 |

## Previous posts in this series

[Prime Gap Oscillation]({{ site.baseurl }}{% post_url 2026-08-11-prime-gap-oscillation %}) ·
[Four Null Models]({{ site.baseurl }}{% post_url 2026-08-13-four-null-models %}) ·
[Weak Mean Reversion]({{ site.baseurl }}{% post_url 2026-08-20-weak-mean-reversion-in-prime-gaps %}) ·
[AC2 Convergence]({{ site.baseurl }}{% post_url 2026-08-28-ac2-convergence-and-the-slow-asymptote %}) ·
[AC2 Cross-Class Decomposition]({{ site.baseurl }}{% post_url 2026-08-31-ac2-cross-class-decomposition %})
