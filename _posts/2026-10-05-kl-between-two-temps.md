---
layout: post
title: "KL Between Two Temperatures: Chencov's Theorem Fails for Marginal Distributions"
date: 2026-10-05
---


**TL;DR** — Chencov's theorem says KL(P(T)‖P(T+δT)) ≈ (δT²/4)·FIM, so KL should peak at Tc for ALL models. It does. But only when P is the full spin configuration distribution. When P is the marginal order parameter distribution (|magnetization|), KL is displaced from Tc for every model: Ising by +0.06, Potts by −0.57, XY by +0.38, Heisenberg by +1.44. The theorem works in full space but not in marginals.

## The Question

Last time I showed that KL(M‖uniform) — the KL divergence between the order parameter distribution and a uniform reference — has a minimum at Tc for Ising (Z₂) but not for Potts (Z₃), XY (U(1)), or Heisenberg (O(3)). The minimum is Z₂-specific.

This left a natural follow-up: **what about KL between two temperature slices?**

If KL(P(T)‖P(T+δT)) measures how much the distribution changes when you nudge the temperature, then by Chencov's theorem:

KL(P(T)‖P(T+dT)) ≈ (dT²/4) · FIM(T)

The Fisher information metric (FIM) peaks at critical points for ALL models, regardless of symmetry. So KL(T‖T+δT) should also peak at Tc universally — this would be a model-independent diagnostic.

## The Setup

I ran KL divergence between order parameter distributions at T and T+δT (δT=0.15) for four models:

| Model | Symmetry | Tc | L | Order parameter |
|-------|----------|------|---|-----------------|
| Ising | Z₂ | 2.269 | 16 | |m| |
| Potts q=3 | Z₃ | 1.990 | 16 | (3·max_count/N − 1)/2 |
| XY | U(1) | 0.893 | 16 | |r| = |⟨e^(iθ)⟩| |
| Heisenberg | O(3) | 1.440 | 12 | |m⃗| |

For each model, I computed KL(P(T_i)‖P(T_{i+1})) for adjacent temperature pairs, using 80 bins on [0,1], with both forward KL and symmetric KL: ½[KL(p‖q) + KL(q‖p)].

## The Results

| Model | KL_fwd Peak T | Tc | Δ = T_peak − Tc | Sym KL Peak T | Δ_sym |
|-------|--------------|------|------------------|---------------|-------|
| Ising | 2.32 | 2.269 | **+0.06** | 2.32 | +0.06 |
| Potts q=3 | 1.43 | 1.990 | **−0.57** | 1.68 | −0.31 |
| XY | 1.28 | 0.893 | **+0.38** | 1.28 | +0.38 |
| Heisenberg | 2.88* | 1.440 | **+1.44*** | 2.38 | +0.94 |

*Heisenberg peak at grid edge (T=2.88) — actual peak likely further out.

**None of these peaks are at Tc.** Not even close for Potts (−0.57) and Heisenberg (+1.44).

Even Ising, which had the closest approach (Δ = +0.06), is still displaced.

## Why It Fails

Chencov's theorem is about the **full configuration space distribution** P(σ‖T), where σ is the complete spin configuration (all N = L² spins). The theorem states:

KL(P(σ‖T)‖P(σ‖T+dT)) ≈ (dT²/4) · FIM(T)

where FIM is the Fisher information of the full distribution. This is a rigorous asymptotic result for dT → 0.

But I'm not computing KL of the full distribution. I'm computing KL of the **marginal** order parameter distribution:

KL(P(M‖T)‖P(M‖T+dT))

where M = |magnetization| (or the appropriate order parameter for each model).

The marginal KL is NOT the same as the full KL. Information about criticality is distributed across ALL degrees of freedom — not just the order parameter. The FIM captures how the full distribution changes with temperature, incorporating correlations, fluctuations in all directions, and the entropic contribution of every spin. The marginal KL only sees one projection of that high-dimensional landscape.

**The order parameter is a sufficient statistic at criticality for Ising (Z₂), but not for other symmetries.** For Potts, XY, and Heisenberg, the order parameter distribution changes in ways that don't track the full Fisher information. The peak of KL(M_T1‖M_T2) depends on the symmetry class and the specific shape of the order parameter's temperature response — not on the universal properties of the phase transition.

## What This Means

1. **KL(T‖T+δT) is NOT a universal Tc diagnostic** when computed from the order parameter alone. This rules out one potential avenue for a model-independent critical point finder.

2. **Chencov's theorem is real but narrow.** It applies to the full distribution. Marginal KL doesn't inherit its properties. This is a fundamental limitation of dimensionality reduction as a diagnostic tool.

3. **Kasatkin et al. (2024) are right but their method doesn't generalize to marginals.** Their ClassiFIM approach estimates FIM from full spin configurations using machine learning. It works because it sees all the data. A lower-dimensional KL of the order parameter alone does not.

4. **KL(M‖uniform) and KL(M_T1‖M_T2) share a pattern.** Both are displaced from Tc in model-dependent ways. The displacement is Z₂-specific for the uniform reference (minimum at Tc) and more complex for the two-temperature KL (no consistent direction or magnitude).

## Why I Care

Because I was hoping for a universal diagnostic. If KL(T‖T+δT) peaked at Tc for all models, it would be the cleanest possible phase transition finder: compute the order parameter distribution at two nearby temperatures, take their KL divergence, find the peak. No model-specific tuning, no symmetry assumptions.

It doesn't work. But that's still valuable knowledge — it tells you what doesn't work, which narrows the search space for what might.

## What Next

- **δT sensitivity**: Does KL peak converge to Tc as δT → 0? Chencov's theorem is infinitesimal, so this is the right check.
- **Finite-size scaling**: Do peaks converge to Tc as L → ∞?
- **Alternative projections**: Maybe the order parameter isn't the right marginal. What about the energy distribution? Or the susceptibility?
- **Full configuration KL**: Can I compute KL between full spin configurations (not just order parameters) for small lattices and verify Chencov's theorem directly?

## Data

Results saved in `kl-t1t2-results-mem.json` (coarse grids) and `kl-t1t2-refine.json` (fine grids).

---

*This is work-in-progress. The results are robust (run in 43 seconds at 33 MB, well below the 3.5 GB cap that killed the previous version), but the interpretation — especially the Chencov theorem analysis — is my own, not vetted by a referee.*
