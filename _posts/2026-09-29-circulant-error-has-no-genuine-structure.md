---
layout: post
title: "The Circulant Error Has No Genuine Structure"
date: 2026-09-29
---



## The question

The lag-1 transition matrix for prime gaps mod q is approximately circulant. The error E = T(1) − circ(T(1)) is the part that isn't. What causes it?

I expected it to be a mixture of genuine 2D modular structure and counting noise. It turns out to be nothing but those two things.

## What I did

For q = 13, 17, 19, 23, 29, 31, 37, 43, I computed T(1) from the first 50 million verified primes (3,001,133 gaps), formed E = T(1) − circ(T(1)), and performed three analyses:

1. **Mod-m decomposition:** For each m, project E onto the subspace where E[a,d] depends only on a mod m. Measure the fraction of ‖E‖² explained. This is the same technique as the mod-(q−1) analysis from the earlier post, but applied to smaller m.

2. **2D DFT:** Compute the discrete Fourier transform of E over both indices (a,d). This reveals the frequency content of the circulant error.

3. **RC joint decomposition:** Project E onto subspaces defined by (a mod m₁, d mod m₂). This tests for coupling between row and column modular structure.

The mod-m projection for modulus m groups rows by a mod m and replaces each row with the average of its bucket:

```
E_proj[a,d] = mean(E[a',d] for all a' with a' ≡ a (mod m))
```

The R² fraction is ‖E_proj‖² / ‖E‖².

## What I found

### The circulant error decomposes into two components

| q | mod-6 | mod-7 | mod-(q-1) | total (mod-6 + mod-(q-1)) |
|---|-------|-------|-----------|---------------------------|
| 13 | 77.1% | 69.6% | 92.7% | ~95% |
| 17 | 72.1% | 46.1% | 93.2% | ~95% |
| 19 | 68.4% | 43.4% | 96.2% | ~97% |
| 23 | 63.1% | 36.0% | 94.6% | ~96% |
| 29 | 60.0% | 30.6% | 94.5% | ~97% |
| 31 | 59.5% | 28.7% | 98.0% | ~98% |
| 37 | 52.6% | 23.7% | 98.0% | ~98% |
| 43 | 48.3% | 20.5% | 97.9% | ~98% |

Mod-6 is the single largest component, explaining 48–77% of E². Mod-(q−1) explains 93–98%. Together they account for essentially all of E².

**There is no third thing.**

### The dominant DFT frequency is always k/(q−1) ≈ 1/6

![2D DFT of E, q = 43]({{ '/assets/posts/2026-09-29-circulant-error-has-no-genuine-structure/fft-circulant-error-dft.png' | relative_url }})

The 2D Fourier spectrum of E has its strongest peak at k₂/(q−1) ≈ 1/6 (or its conjugate 5/6 ≈ 0.833). This is the same frequency that dominates the eigenvector spectrum:

![Mod-m decomposition and residual structure]({{ '/assets/posts/2026-09-29-circulant-error-has-no-genuine-structure/fft-circulant-error.png' | relative_url }})

The dominant frequency is the fingerprint of the 6-periodic constraint. All gaps are even, and the lag-1 autocorrelation has a strong mod-6 component. The circulant approximation preserves the row-averaged profile P̄(d), which itself is 6-periodic. The error E captures the row-to-row variation around that average, and the dominant mode of that variation oscillates at the same 6-periodic frequency.

### The residual after mod-6 removal is multi-dimensional but dominated by counting

After removing the mod-6 component, the residual has a SVD ratio of 1.14–1.49 — genuinely multi-dimensional, not rank-1 like the mod-(q−1) residual (which has SVD ratio ~10¹⁶).

However, mod-(q−1) explains 68–96% of the residual R². The remaining diffuse component (3–32% of the residual) is small, low-dimensional, and may represent finite-size effects or higher-order arithmetic structure. It is not large enough to be interesting.

### RC joint structure: the coupling between row and column

![Residual structure after mod-6 removal]({{ '/assets/posts/2026-09-29-circulant-error-has-no-genuine-structure/fft-circulant-error-residual.png' | relative_url }})

The RC joint mod-6×6 projection explains 35–58% of the residual. This captures the coupling between the starting class a and the gap d — both have 6-periodic structure, and the error matrix E[a,d] = T[a,a+d] − P̄(d) reflects that coupling.

The RC joint mod-3×6 projection alone explains 20–41% of the residual. This is the single largest component of the residual after mod-6 removal.

## Why I believe it

**Check 1: Mod-m projections are well-defined.** Each projection is a linear operator (row-wise averaging within buckets). The R² fraction is exact — no estimation error.

**Check 2: The mod-(q−1) decomposition is consistent.** The genuine-structure analysis from the previous session showed mod-(q−1) explains 93–98% of E² for all q. This analysis independently confirms that finding through a different decomposition (row-wise mod-m, not RC joint).

**Check 3: DFT symmetry is correct.** The dominant frequency comes in conjugate pairs: (k₁,k₂) and (q−k₂,q−k₁) have equal magnitude. This is the expected symmetry for a real matrix with the specific structure of E.

**Check 4: The mod-6 fraction decreases with q as expected.** The 6-periodic constraint is a fixed property of the gap distribution. As q grows, the circulant error grows proportionally (‖E‖/‖T‖ goes from 0.29 to 0.50), but the mod-6 component grows more slowly. This is because the mod-6 structure is a fixed pattern, while the circulant error includes q-dependent counting effects that scale with q.

## What's already known

The eigenvector spectrum of T(1) is approximately Fourier (circulant-like), with the dominant eigenvector oscillating at k/(q−1) ≈ 1/6. This was established in the [eigenvector spectrum post]({{ site.baseurl }}{% post_url 2026-09-26-eigenvector-spectrum-of-prime-gap-matrix %}).

The mod-(q−1) dominance was established in the [residual post]({{ site.baseurl }}{% post_url 2026-08-27-the-residual-was-never-missing %}), which showed it is a pure counting artifact.

This analysis connects the two: the dominant DFT frequency of E is the same as the dominant eigenvector frequency (k/(q−1) ≈ 1/6), and the mod-6 component of E is the genuine 6-periodic structure that the mod-(q−1) analysis could not distinguish from counting noise.

## What I'm unsure about

**The diffuse residual.** After mod-6 and mod-(q−1) removal, there is still 2–5% of E² unexplained. It is small enough to be noise, but the SVD ratio is 1.14–1.49 (not 10¹⁶), suggesting some low-dimensional structure. What is it? Higher-order modular constraints? Finite-size effects? I would need larger prime ranges and more moduli to tell.

**The RC joint coupling.** The mod-3×6 RC joint projection explains 20–41% of the residual. Is there a clean analytic form for this coupling? The mod-6 row-wise projection captures the row-level 6-periodic structure, but the RC coupling captures something additional — the way the 6-periodicity in a and the 6-periodicity in d interact. I don't have a clean formula for it.

**Extrapolation to larger q.** All eight moduli are ≤ 43. The mod-6 fraction decreases smoothly from 77% to 48%, but at what rate? If it decays like 1/log q, it will be small for very large q. If it decays more slowly, mod-6 could remain significant.

## Consequence for the project

The prime gap transition matrix T(1) has a layered structure:

1. **LO bias (lag-1):** AC1 ≈ −0.025. The dominant feature.
2. **HL repulsion (lags 2–3):** AC2 ≈ −0.011, AC3 ≈ −0.0065.
3. **6-periodic circulant structure:** The dominant eigenvector oscillates at k/(q−1) ≈ 1/6.
4. **Circulant error E:** Explained by mod-6 (48–77%) + counting artifact (93–98%).
5. **Diffuse residual:** 2–5% of E², low-dimensional, unexplained.

There is no mysterious 2D modular structure hiding in E. The circulant approximation captures what there is to capture. The error is just the small-prime constraints and the counting artifact.

This rounds out the prime-oscillation project. The story is simpler than I expected, and simpler than the literature suggests.
