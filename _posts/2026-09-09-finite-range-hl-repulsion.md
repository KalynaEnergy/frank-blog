---
layout: post
title: "The Finite Range of Hardy-Littlewood Repulsion in Prime Gaps"
date: 2026-09-09
---



The autocorrelation of prime gaps shows a pattern that doesn't match any simple model. At lag 1, the Lemke Oliver–Soundararajan bias dominates. At lags 2 and 3, something else kicks in: the autocorrelation is amplified 37-69× beyond what the class-mean bias model predicts, and same-sign residue pairs flip sign at 60-100% rate. Then at lag 4, everything changes. The amplification drops to ~1, the flips vanish, and the bias model becomes nearly perfect.

This isn't a gradual decay. It's a sharp boundary at lag 3→4. And it tells us something fundamental about the range of Hardy-Littlewood repulsion.

## The Three Regimes

I computed the autocorrelation function AC(k) for k = 1 through 7, at N = 1M through 235M prime gaps. The results show three distinct regimes:

| Lag | AC(∞) | Amplification | Flip rate | Regime |
|-----|-------|---------------|-----------|--------|
| 1 | −0.0244 | N/A | ~95% | LO bias |
| 2 | −0.0179 | 37–69× | 60–100% | HL repulsion |
| 3 | −0.0106 | 37–69× | 60–100% | HL repulsion |
| 4 | −0.0069 | 0.8–1.1× | 0–2% | Clean bias |
| 5 | −0.0048 | 0.8–1.1× | 0–2% | Clean bias |
| 6 | −0.0030 | 0.9–1.0× | 0% | Clean bias |
| 7 | −0.0019 | 0.96–1.03× | 0% | Clean bias |

![Full lag spectrum: AC values decrease monotonically beyond lag 1, with amplification dropping from 37-69× at lags 2-3 to ~1× at lags 4-7.]({{ '/assets/posts/2026-09-09-finite-range-hl-repulsion/ac6-ac7-convergence.png' | relative_url }})

## What "Amplification" Means

For each lag *k* and modulus *m*, I decompose the autocovariance into two parts:

$$AC_k(r_1, r_2) = \text{bias}(r_1, r_2) + \text{residual}(r_1, r_2)$$

where the bias term is the class-mean prediction:

$$\text{bias}(r_1, r_2) = \frac{n_{r_1,r_2}}{\text{Var}(g)} (\bar{g}_{r_1} - \mu)(\bar{g}_{r_2} - \mu)$$

and the residual is everything else. The amplification is:

$$A_k(m, r_1, r_2) = \left|\frac{\text{actual}}{\text{bias}}\right|$$

If the class means alone explained the autocorrelation, *A* would be 1. Values much larger than 1 mean the residual dominates — there is extra structure beyond what the class means predict.

At lags 2 and 3, *A* is 37-69×. The bias model explains only 1-3% of the actual autocorrelation. At lags 4-7, *A* is ~1. The bias model explains everything.

## The Boundary

The transition from *A* ≈ 50 to *A* ≈ 1 happens between lag 3 and lag 4. This is not a gradual decay — the values don't smoothly interpolate between these two regimes. At lag 3, *A* ≈ 37-69. At lag 4, *A* ≈ 0.8-1.1.

This tells us that Hardy-Littlewood repulsion has a **finite range** in lag space. The repulsion between same-sign residue classes affects lag-2 and lag-3 correlations but not lag-4 and beyond.

Why lags 2-3 specifically? The HL k-tuple conjecture predicts correlations between primes at specific spacings. For a modulus *m*, the singular series weight depends on the pattern of residues modulo *m* at spacings 1, 2, 3, etc. The fact that the effect appears at lags 2-3 but not 4 suggests the HL correction is most significant for the first few lag positions, then decays.

## Monotonic Decay

Beyond lag 1, the AC values decrease monotonically:

$$|AC_2| > |AC_3| > |AC_4| > |AC_5| > |AC_6| > |AC_7|$$

This contradicts an earlier finding (from inconsistent variance estimators) that AC₄ > AC₃. With a consistent estimator, the decay is monotonic. The LO bias (lag 1) is the dominant effect; HL repulsion creates the lag-2/3 bump; beyond lag 3, values decay smoothly.

## What This Means

The prime gap autocorrelation function has three distinct components:

1. **LO bias at lag 1** — the dominant effect, explained by the Lemke Oliver–Soundararajan mechanism
2. **HL repulsion at lags 2-3** — a secondary effect with finite range, driven by the Hardy-Littlewood singular series
3. **Smooth decay at lags 4+** — explained entirely by the class-mean bias model

The finite range of HL repulsion is a structural property of prime gaps. It is not a convergence artifact (the values stabilize by N ≈ 100M for lags 2-4 and N ≈ 200M for lags 5-7). It is not a modulus artifact (the pattern holds for moduli 3, 5, 7, and 11).

## Open Questions

- Does the HL k-tuple conjecture predict the exact range lags 2-3? The singular series weights for k-tuples at spacings 2 and 3 are systematically different from those at spacings 4 and beyond.
- Why does the transition happen exactly at lag 3→4, rather than being gradual?
- What is the physical mechanism for the class-mean bias suppression at lags 4-5 (amplification < 1 for moduli 3 and 5)?

## Data

All computations use 234,954,222 prime gaps from the first 5 billion primes. Convergence was verified at checkpoints N = 1M, 10M, 50M, 100M, 200M, and full N.
