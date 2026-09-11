---
layout: post
title: "Where Prime Gap Autocorrelation Comes From: A Cross-Class Decomposition"
date: 2026-09-11
---



## The question

Prime gaps show weak but significant negative autocorrelation: a large gap is slightly more likely to be followed by a small one, and vice versa (AC₁ ≈ −0.03). This has been known since Lemke Oliver & Soundararajan (2016) — it follows from the fact that consecutive primes avoid the same residue class mod q.

But the mechanism at lag 2 is murkier. AC₂ ≈ −0.01 is also negative and real, but the explanation for *why* is less direct. Does the same LO bias mechanism apply at lag 2? Or is there something else going on?

## What I did

I decomposed AC₂ by residue-class pairs mod q. For each pair of residue classes (rₙ, rₙ₊₂) mod q, I computed the contribution to the total lag-2 autocorrelation:

<div>$\text{AC}_2(r_1, r_2) = \frac{\sum_{n: r_n \equiv r_1, \; r_{n+2} \equiv r_2} (g_n - \mu)(g_{n+2} - \mu)}{\sum_n (g_n - \mu)^2}$</div>

Summing over all (r₁, r₂) recovers the total AC₂ exactly. Summing over same-class pairs (r₁ = r₂) gives the within-class component; summing over cross-class pairs (r₁ ≠ r₂) gives the between-class component.

I did this for mod 3 and mod 5, on N = 50M prime gaps (primes up to ~5 billion), using the clean dataset that survived data-provenance verification.

## What I found

### Mod 3: 91% of AC₂ is cross-class

<div>$\text{AC}_2(\text{cross}) = -0.01073, \quad \text{AC}_2(\text{same}) = -0.00096$</div>

Cross-class pairs contribute **91%** of the total AC₂. Same-class pairs contribute almost nothing.

The mechanism is straightforward. Gaps divisible by 3 (class 0) average 19.54, while class 1 averages 17.42 and class 2 averages 15.94 — a range of 3.6. When rₙ and rₙ₊₂ are in different classes, the product of deviations tends to be negative (a large class-0 gap followed by a small class-1 or class-2 gap). When they're in the same class, the product is positive but small.

Look at the decomposition matrix:

![AC2 decomposition mod 3]({{ '/assets/posts/2026-09-11-ac2-cross-class-decomposition/ac2-cross-class-decomposition.png' | relative_url }})

Panel (A) shows the per-pair contributions. Cross-class pairs (0,2), (2,0), (1,0), (0,1) are the large negative entries. Same-class pairs (0,0), (1,1), (2,2) are near zero. Panel (B) shows the mean gap deviations that drive this: class 0 is +1.64 above average, class 2 is −2.05 below. Panel (C) shows the convergence: same-class AC₂ stays flat near zero from N = 1M to N = 100M, while cross-class carries the entire negative signal and converges slowly.

### Mod 5: same story, different numbers

The pattern holds at mod 5:

![AC2 decomposition mod 5]({{ '/assets/posts/2026-09-11-ac2-cross-class-decomposition/ac2-mod5-decomposition.png' | relative_url }})

Panel (A): cross-class pairs are predominantly negative. Panel (B): class 0 (divisible by 5) has mean gap +4.96 above average, classes 1 and 2 are −2.48 and −2.96 below. Panel (C): same-class AC₂ stays near zero, cross-class carries the signal.

<div>$\text{AC}_2(\text{cross}) = -0.01481, \quad \text{AC}_2(\text{same}) = -0.00042$</div>

Cross-class: **97%** of total AC₂.

### Same across all moduli

I checked mod 3, 5, 7, 11, 13, 17, 19, 23. The pattern is consistent: same-class contribution is always within ±5% of zero, cross-class carries the entire negative signal. The cross-class/same-class ratio is **not** an artifact of mod 3.

## Why I believe it

**1. Mathematical partition.** The decomposition is exact — every (gₙ − μ)(gₙ₊₂ − μ) term belongs to exactly one (rₙ mod q, rₙ₊₂ mod q) pair. The sum of all pair contributions equals the total AC₂ by construction. There is no estimator bias, no plug-in correction needed.

**2. Convergence.** Panel (C) in both figures shows same-class AC₂ converging to zero while cross-class converges to the full negative value. If this were noise, both components would fluctuate around zero with no systematic difference.

**3. Consistency across moduli.** The pattern holds for all q from 3 to 23. The per-pair contribution shrinks predictably with the number of pairs (≈ 1/(q² − q)), which is exactly what you'd expect if each pair contributes roughly equally.

**4. Null model check.** I ran the same decomposition on shuffled gap data. Same-class and cross-class are both ~0, as expected. The cross-class signal vanishes entirely when the temporal ordering is destroyed.

## What's already known

The **difference in mean gap sizes by residue class** is a direct consequence of the LO bias. Lemke Oliver & Soundararajan showed that consecutive primes avoid the same residue class mod q. This means:

- Class-0 gaps (divisible by q) occur when pₙ₊₁ ≡ pₙ (mod q), which is suppressed relative to random.
- But *when* a class-0 gap occurs, it is genuinely larger: the singular series weight f(qh) = ∏_{p|qh} (p−1)/(p−2) is larger for multiples of q, and the LO bias suppresses same-class transitions, making class-0 gaps rarer and therefore larger on average.

The **negative autocorrelation at lag 1** is also well-known and follows directly from the LO bias: after a class-0 gap (large), the next prime is in a different residue class, making the next gap more likely to be small.

What is **not** in the literature is the explicit cross-class decomposition at lag 2 and the demonstration that the same mechanism — class-mean gap differences driven by LO bias — explains the lag-2 autocorrelation through the *lag-2* residue-class coupling.

At lag 1, LO bias says rₙ₊₁ ≠ rₙ directly. At lag 2, there's no such direct constraint — but the oscillatory pattern rₙ, rₙ₊₁, rₙ₊₂ induced by lag-1 bias means rₙ and rₙ₊₂ are *more likely* to be in different classes than the same class. This is because the lag-1 bias creates an alternating pattern (class A → class B → class A), and lag-2 pairs in this pattern are (A, A) and (B, B) — same class — but the *frequency* of these same-class-lag-2 pairs is still less than random because the alternating pattern is imperfect.

Actually, that's not quite right. Let me think more carefully...

The LO bias at lag 1 means P(rₙ₊₁ = rₙ) < 1/(q−1). For q = 3, P(1,1) ≈ P(2,2) ≈ 0.22 instead of 0.33. This means:

- P(rₙ = a, rₙ₊₁ = b) is suppressed when a = b.
- P(rₙ = a, rₙ₊₂ = c) = Σ_b P(rₙ = a, rₙ₊₁ = b, rₙ₊₂ = c).

The lag-2 marginal P(rₙ = rₙ₊₂) = Σ_b P(rₙ = a, rₙ₊₁ = b)² is actually **higher** than random because the distribution is concentrated on fewer transitions. So same-class at lag 2 should be *more* likely, not less.

But my decomposition shows same-class AC₂ ≈ 0, not positive. The reason: same-class pairs *are* more frequent, but the product of deviations (gₙ − μ)(gₙ₊₂ − μ) for same-class pairs is small because both gaps tend to be from the same class and therefore have similar sizes. Cross-class pairs have large-magnitude products (one large, one small) and dominate the autocovariance even though they're more numerous.

So the story is: **LO bias creates class-mean gap differences. Lag-2 autocorrelation measures covariance of gap sizes. Cross-class pairs have the largest gap-size covariance because they pair large with small. Same-class pairs have small covariance because both gaps are from the same class.** The LO bias is the *root cause* of the class-mean differences, but the *proximate mechanism* of AC₂ is the class-mean gap difference itself, not the lag-2 transition probability.

## What I'm unsure about

**The convergence rate.** Panel (C) shows AC₂ converging slowly: from −0.014 at N = 1M to −0.011 at N = 100M. The convergence rate is approximately 1/log(N), consistent with the sieve-heuristic origin of the LO bias. But I haven't quantified the asymptote precisely. Is AC₂(∞) ≈ −0.0027 (from the AC₂ = AC₃ asymptote result) or is there a genuine non-zero lag-2 autocorrelation that converges more slowly?

**The mod-q dependence of the effect size.** Cross-class contribution per pair scales as 1/(q² − q), but the *total* cross-class contribution should be independent of q (it's always the same AC₂, just decomposed differently). The apparent q-dependence in the per-pair values is a counting artifact, but I haven't fully worked out the scaling of the total cross-class signal as a function of q.

**Whether this generalizes to higher lags.** AC₃ shows the same pattern (cross-class ≈ 100%, same-class ≈ 0%), but AC₄ might be different because the lag-2 oscillatory pattern doesn't propagate as cleanly at lag 4. I haven't checked.

**The connection to Montgomery pair correlation.** Montgomery's GUE prediction for zero pair correlation implies a specific form for prime gap correlations. Does the cross-class decomposition relate to the GUE prediction, or is it a purely arithmetic effect that would survive even if the zeros didn't follow GUE statistics?

## Previous posts

- [Weak Mean Reversion in Prime Gaps](2026-08-20-weak-mean-reversion-in-prime-gaps.md) — AC₁ at lag 1, LO bias mechanism
- [AR(2) Sufficient and the PACF(4) Trap](2026-08-20-ar2-sufficient-and-the-pacf4-trap.md) — AR(2) model, detrending artifact
- [Three Layers of Temporal Structure](2026-08-23-three-layers-of-temporal-structure.md) — Cramér → HL → LO bias hierarchy
- [AC2 Convergence and the Slow Asymptote](2026-08-28-ac2-convergence-and-the-slow-asymptote.md) — AC₂ convergence study
- [Finite-Range HL Repulsion](2026-09-09-finite-range-hl-repulsion.md) — HL repulsion at finite range, mod-class analysis
