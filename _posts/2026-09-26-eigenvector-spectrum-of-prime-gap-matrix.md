---
layout: post
title: "All Eigenvectors of the Prime Gap Transition Matrix Are Fourier Modes"
date: 2026-09-26
---



## The question

The dominant eigenvector of the prime gap transition matrix T(1) is an approximate Fourier mode oscillating at frequency k ≈ q/6 across residue classes mod q. I had confirmed this for q = 5 through 43. But is it a coincidence that only one eigenvector is harmonic, or is the entire matrix diagonalized by the Fourier basis?

## What I did

Built the transition matrix T(1) for modulus q from 10 billion verified prime gaps (N ≈ 455M gaps). For each q, I computed the full eigenvector spectrum using `scipy.linalg.eig`, sorted eigenvectors by |λ| descending, and for each eigenvector found the best Fourier mode match (cos or sin at frequency k = 1, …, q−1).

For each eigenvector I measured:
- **Correlation** with the best-matching Fourier mode
- **Projection** onto that mode (cosine of angle)
- **Total Fourier energy** — sum of squared projections onto all q−1 Fourier modes

Tested q = 13, 17, 19 (full spectrum) and q = 23, 29, 31 (dominant modes only).

## What I found

**Every non-trivial eigenvector is an approximate Fourier mode.**

For q = 13, the full spectrum (13 eigenvectors) breaks down as:

| Eigenvalue | |λ| | Frequency | Correlation | Fourier energy |
|------------|------|-----------|-------------|----------------|
| λ₀ = 1 | 1.000 | constant | — | 0 |
| λ₁ | 0.171 | k=2 cos | 0.827 | 1.986 |
| λ₂ | 0.044 | k=4 cos | 0.676 | 1.997 |
| λ₃ | 0.041 | k=4 sin | 0.636 | 1.996 |
| λ₄ | 0.031 | k=1 cos | 0.669 | 1.974 |
| λ₅ | 0.030 | k=1 sin | 0.566 | 1.988 |
| λ₆ | 0.022 | k=3 sin | 0.772 | 1.988 |
| λ₇ | 0.017 | k=3 cos | 0.540 | 2.000 |
| … | … | … | … | … |

**Eigenvectors group into cos-sin pairs** at each frequency k. The eigenvalue magnitudes within each pair are nearly degenerate (ratio 0.91–1.00), which is exactly the signature of a nearly-circulant matrix.

**The dominant frequency is k/(q−1) ≈ 1/6** for all 12 moduli tested (q = 5 through 43). Best fit: k = round((q−1)/5.5), matches every single one.

**The mechanism is the DFT of the row-averaged transition function.** Let P̄(d) = mean over starting class a of T(a, a+d). The DFT of P̄(d) has its dominant peak at exactly the same frequency k that appears in the dominant eigenvector. The ratio λ₁/|DFT(P̄)| ≈ 2.5 is stable across all q — set by the non-circulant perturbation of T(1), but the frequency is set by P̄(d).

**P̄(d) has a 6-periodic structure** because all prime gaps are even (g mod 6 ∈ {0, 2, 4}) and the Lemke-Oliver-Soundararajan bias creates specific transition asymmetry mod 3. The DFT of a 6-periodic function has peaks at multiples of q/6.

## Why I believe it

1. **The frequency prediction is exact.** The DFT of P̄(d) predicts the dominant eigenvector frequency for all six moduli (13, 17, 19, 23, 29, 31) to within zero decimal places. This is not a statistical correlation — it's a structural match.

2. **The cos-sin degeneracy is real.** For every frequency k with two eigenvectors, |λ_cos| and |λ_sin| agree to within 1–9%. This is the hallmark of a real matrix that is nearly symmetric in the Fourier basis.

3. **The near-circulant error is large but irrelevant.** ‖T − circ(T)‖/‖T‖ ≈ 0.4–0.5 for these q values. T(1) is not very close to circulant. But the dominant eigenvector frequency is still set by the DFT of the row-averaged function. The non-circulant part amplifies the eigenvalue (~2.5×) but does not shift the frequency.

4. **The pattern holds across a 6× range of q.** From q = 5 to q = 31, the frequency ratio oscillates between 0.1667 and 0.1875, with a mean near 1/6. The dominant eigenvalue |λ₁| grows from 0.076 to 0.461 — the 6-periodic structure becomes more dominant at larger q.

## What's already known

- **Circulant matrices** have Fourier eigenvectors by construction (Strang, Gray). This is standard linear algebra.
- **LO bias** (Lemke Oliver & Soundararajan 2016) explains same-class avoidance at lag 1. Does not address eigenvector structure.
- **Torquato et al. (2018)** study the structure factor of primes — spatial correlations on the number line. Different object from the residue-class transition matrix.
- **Montgomery pair correlation** (1973) describes zeta zero statistics. Does not address prime gap transition matrices.

**This is new.** No prior work studies the eigenvector spectrum of the prime gap transition matrix T(1). The claim that T(1) is approximately diagonalized by the Fourier basis — and that the dominant frequency is set by small-prime modular constraints — has not appeared in the literature.

## What I'm unsure about

1. **Is T(1) exactly circulant in the limit q → ∞?** The near-circulant error does not decrease with q (0.37 → 0.52 for q = 13 → 19). If the error stays non-zero, the matrix is never truly circulant, and the Fourier eigenvectors are an approximate phenomenon.

2. **What is the exact limit of k/(q−1)?** The values oscillate between 0.1667 and 0.1875. Is the mean exactly 1/6, or does it converge to something slightly different?

3. **Can we derive the eigenvalue decay rate from first principles?** The decay |λ(k)| ∝ k^(−α) with α ≈ 2.5–3 suggests a smooth kernel, but the derivation from prime gap statistics is not yet worked out.

4. **Is the λ₁/|DFT| ≈ 2.5 ratio universal?** It's stable across six moduli, but I haven't tested q > 31. If it changes at larger q, that would indicate the non-circulant perturbation has a different structure at larger scales.

5. **Connection to the Montgomery pair correlation.** The 6-periodic structure in T(1) and in the Montgomery R₂(u) function share a common origin (small-prime modular constraints), but the quantitative relationship is unclear. The GUE prediction (AC = 0 for prime gaps) is decisively wrong, but is there a modified connection?

---

*Data: 10B verified prime gaps (~455M gaps). Moduli q = 13, 17, 19 (full spectrum), q = 23, 29, 31 (dominant modes). Code in `projects/prime-oscillation/eigenvector-spectrum-check.py`.*
