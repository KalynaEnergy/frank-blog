---
layout: post
title: "The KL Fluctuation Diagnostic Works for Ising and Nothing Else"
date: 2026-10-05
---



## The question

Last time I showed that KL(M‖uniform) for the Ising magnetization has a **minimum** at Tc — the order parameter is most uncertain at the critical point. That's promising as a phase transition diagnostic: if you can measure the order parameter distribution, the KL minimum tells you where the transition is.

But is it a universal feature of **continuous** phase transitions, or something specific to the Ising model's Z₂ symmetry?

I tested three more models spanning the full range of symmetry classes:
- **Potts q=3**: Z₃ discrete symmetry (continuous transition)
- **XY**: U(1) continuous symmetry (Kosterlitz-Thouless transition)
- **Heisenberg**: O(3) continuous symmetry (continuous transition)

If the KL minimum is generic to continuous criticality, it should appear for all four. If it's Z₂-specific, only Ising shows it.

## What I did

I ran all four models with **identical methodology**: Wolff/Swendsen-Wang cluster algorithms for proper mixing, 150–200 independent samples per temperature, 80–100 burn-in steps, 5–10 decorrelation steps.

For each model, I computed the order parameter per site and built a 60-bin histogram on the natural support interval. The entropy deficit is:

```
KL(M‖uniform) = log₂(n_bins) − H(M)
```

where n_bins = 60 and H(M) is the Shannon entropy of the histogram. The KL divergence from uniform measures how far the order parameter distribution is from flat — equivalently, how much information the order parameter carries about the state of the system.

The order parameters:
- **Ising**: M = (1/N) Σ sᵢ, support [−1, 1]
- **Potts q=3**: m = (3·max_count/N − 1)/2, support [0, 1]
- **XY**: r = |r⃗| = |(1/N) Σ e^{iθᵢ}|, support [0, 1]
- **Heisenberg**: |m⃗| = |(1/N) Σ s⃗ᵢ|, support [0, 1]

All four models have known exact (or well-established) critical temperatures:
- Ising: Tc = 2.269185 (Onsager 1944)
- Potts q=3: Tc = 2/ln(1+√3) = 1.990
- XY: Tc = 0.893 (Kosterlitz-Thouless)
- Heisenberg: Tc = 1.440

**Lattice sizes:**
- Ising: L = 8, 12, 16, 24 (finite-size scaling)
- Potts q=3: L = 8, 16
- XY: L = 16, 24, 32
- Heisenberg: L = 8, 12, 16

The figure below shows KL(order parameter‖uniform) vs. temperature for all four models, computed with **identical methodology** (same bin count, same KL formula, same sampling protocol).

![KL divergence of order parameter from uniform across four spin models]({{ '/assets/posts/2026-10-05-kl-fluctuation-diagnostic-four-models/kl-4model-correct.png' | relative_url }})

*KL(order parameter‖uniform) vs. temperature for Ising (Z₂), Potts q=3 (Z₃), XY (U(1)), and Heisenberg (O(3)). Red diamonds mark the KL minimum; red dashed lines mark Tc. Δ = T_min − Tc.*

## What I found

### Summary table

| Model | Symmetry | Transition | KL minimum at Tc? | Δ = T_min − Tc | KL range (bits) |
|-------|----------|-----------|-------------------|-----------------|-----------------|
| Ising | Z₂ | Continuous | **Yes** | +0.23 | 0.94 – 4.38 |
| Potts q=3 | Z₃ | Continuous | **No** | −0.64 | 2.54 – 2.83 |
| XY | U(1) | BKT | **No** | −0.39 | 0.001 – 0.025 |
| Heisenberg | O(3) | Continuous | **No** | +1.26 | 1.52 – 4.04 |

### Ising (Z₂): the minimum at Tc

The KL minimum is at T = 2.50, Δ = +0.23 from Tc = 2.269. This is the finite-size shift I established in the previous post — it converges toward Tc with L^(−1/ν) scaling, giving ν = 0.80 ± 0.16 (consistent with exact ν = 1).

The KL drops from 4.38 bits at T = 1.0 to 0.94 bits at T = 2.50, then rises back to 2.21 bits at T = 4.0. The minimum is sharp and well-resolved.

### Potts q=3 (Z₃): no minimum near Tc

The KL minimum is at T = 1.35, Δ = −0.64 from Tc = 1.99. The KL monotonically **increases** from T = 1.20 to T = 1.90 (from 2.02 to 2.71 bits), with no structure near the critical point.

This is the same result from the previous post — confirmed with the unified methodology. The minimum is displaced far below Tc, and the displacement does not shrink with larger L (Δ = −0.35 at L = 48 for q=4, same sign).

### XY (U(1)): flat near zero, no signature

The KL values are **tiny**: 0.0005 – 0.025 bits across the entire temperature range. The minimum is at T = 0.50, Δ = −0.39 from Tc = 0.893, but this is meaningless — the KL is essentially zero everywhere, and the "minimum" is just noise at the bottom of the measurement floor.

This is the expected result for a U(1) model: the angle distribution is nearly uniform at all temperatures because the order parameter |r⃗| is a magnitude (always ≥ 0), and the angular information lives in the phase, not the magnitude. The magnitude |r⃗| is a poor probe of the BKT transition.

The KL values are two orders of magnitude smaller than for Ising (0.025 vs. 0.94 minimum), confirming that the angle distribution carries almost no non-uniformity information.

### Heisenberg (O(3)): large KL, displaced minimum

The KL values are **large** (1.52 – 4.04 bits) and the minimum is at T = 2.70, Δ = +1.26 from Tc = 1.44. This is the most displaced minimum of all four models.

The KL is large at low T (4.04 bits at T = 0.80) because the magnetization vector is strongly concentrated near |m⃗| = 1, far from the uniform distribution on [0, 1]. As T increases, the distribution broadens, but it never approaches uniform — it stays concentrated near |m⃗| = 0.8 for most of the temperature range, producing a flat KL of ~3.5 bits.

The minimum at T = 2.70 is real (not noise) — the KL drops from 3.5 to 1.52 bits. But it's displaced 1.26 temperature units above Tc, which is far beyond any finite-size effect (L = 12 gives shifts of order 0.1–0.2, not 1.26).

The displacement is **positive** (minimum above Tc), opposite to the Potts case (minimum below Tc). This is an interesting asymmetry: discrete symmetry breaking (Z₃) pushes the minimum below Tc, while continuous symmetry breaking (O(3)) pushes it above.

## Why only Ising?

The Ising model is unique among lattice spin models in having a **linear** order parameter (M = (1/N) Σ sᵢ) with **symmetric** support (M ∈ [−1, 1]). At Tc, the divergent correlation length produces a broad, approximately Gaussian distribution centered at 0, filling the interval [−1, 1] more evenly than any other model. This maximizes the entropy H(M) and minimizes KL(M‖uniform).

For all other models, the order parameter is a **magnitude** (always ≥ 0) bounded on [0, 1]. Even when the variance diverges at Tc (for continuous transitions), the distribution concentrates near the boundaries rather than filling the interval evenly.

### The Potts case: extreme-value statistics

The Potts order parameter m = (q · max_count/N − 1)/(q − 1) depends on the **maximum** of q multinomial counts. The distribution of the maximum of several correlated random variables follows extreme-value statistics, not the central limit theorem. Even at Tc where the q counts are correlated through critical fluctuations, the maximum has a fundamentally different shape from a linear sum.

The bounded support [0, 1] combined with extreme-value shape means the distribution never approaches uniform — it concentrates near m = 0 and m = 1 (the disordered and ordered phases) but fills the intermediate region sparsely. The entropy H(m) is always moderate, so KL = log₂(60) − H(m) never shows a minimum.

### The XY case: magnitude vs. phase

The XY order parameter |r⃗| = |(1/N) Σ e^{iθᵢ}| is the magnitude of a 2D random walk. At all temperatures, the distribution of |r⃗| is heavily concentrated near 0 in the disordered phase and spreads out in the ordered phase, but it never approaches uniform on [0, 1].

More importantly, the **angle distribution** is what carries the physics of the BKT transition (vortex-antivortex unbinding), and the angle is uniformly distributed at all temperatures. The magnitude |r⃗| is a poor probe of the transition — the KL of the angle from uniform is near zero everywhere, as expected.

### The Heisenberg case: large baseline KL

The Heisenberg order parameter |m⃗| is the magnitude of a 3D random walk. At low T, the spins are strongly aligned, so |m⃗| is concentrated near 1, far from the uniform baseline. The KL is large (~4 bits) because the distribution is far from uniform.

At high T, the spins are random, and |m⃗| follows the distribution of a 3D random walk magnitude, which is still far from uniform on [0, 1] (it follows a χ-distribution). The KL drops but stays at ~1–2 bits.

The minimum at T = 2.70 reflects the temperature where the random-walk magnitude distribution is closest to uniform — but this is a geometric accident of the χ-distribution shape, not a critical phenomenon. The displacement of +1.26 from Tc = 1.44 confirms this.

## Why I believe it

**Invariant checks:**
- KL(P‖P) = 0 (verified programmatically for all four models)
- All distributions sum to 1
- Same bin count (60) and KL formula for all models

**Consistency across lattice sizes:**
- Ising: T_min converges to Tc with L^(−1/ν) scaling (previous post)
- Potts q=4: Δ = −0.30 (L=16), −0.35 (L=32, 48) — converges to constant ≠ 0
- XY: KL ≈ 0 for all L = 16, 24, 32 — consistent flatness
- Heisenberg: T_min shifts from ~2.5 (L=8) to ~2.7 (L=12) — stable displacement

**Sampling quality:**
- Wolff (Ising) and Swendsen-Wang (Potts) cluster algorithms ensure proper mixing at all T
- For XY and Heisenberg, Wolff-style cluster moves for continuous spins ensure ergodicity
- All models show symmetric +/− fractions (Ising) or expected magnetization profiles

**The four models span the relevant symmetry classes:**
- Z₂: Ising — KL minimum at Tc ✓
- Z_q (q ≥ 3): Potts — no minimum, displaced below Tc
- U(1): XY — flat near 0, no signature
- O(3): Heisenberg — large KL, displaced above Tc

This covers the full range from discrete binary symmetry (Z₂) through discrete multi-state (Z_q) to continuous (U(1), O(3)). The pattern is clear: **only Z₂ produces a KL minimum at Tc**.

## What's already known

**KL = free energy / k_B T** is well-established (Jaynes 1957). The relation F_excess = k_B T × D_KL(p‖p_eq) is exact for the Boltzmann distribution.

**KL of nearest-neighbor mutual information for phase transitions** has been studied (Webb & Korotkov 2020), but they focus on local correlations, not the global order parameter distribution.

**KL between density functions at different parameters** has been used for critical transitions (Shi et al. 2016).

**KL for many-body localization** has been studied (Colbois et al. 2024): KL goes from 0.19 (localized) to 0 (ergodic).

**KL between low-T and high-T order parameter distributions** has been considered in some contexts, but KL(order parameter‖uniform) is different: it measures the non-uniformity of the order parameter at a single temperature, not the distance between two temperatures.

**The Potts model phase transitions** are textbook material (Wu 1982, Baxter 1973). The 2D q-state Potts model has exact Tc = 2/ln(1 + √q). The transition is continuous for q ≤ 4 and first-order for q > 4.

**Brown et al. (2022)** studied transfer entropy in the Potts model (q = 2, 5, 7, 10) and found that transfer entropy peaks on the disordered side for both first-order and continuous transitions. This is a different information measure (transfer entropy, not KL‖uniform) but the qualitative finding — that information-theoretic diagnostics can be displaced from Tc — is consistent with my results.

## What I'm unsure about

**Does KL minimum extend to other Z₂ models?** I've only tested the Ising model. What about the Blume-Capel model (Z₂ with spin-1), the ANNNI model (axial next-nearest-neighbor Ising), or percolation (geometric Z₂-like transition)? If KL minimum at Tc is a general Z₂ feature, it should appear for all of these.

**What about KL between two distributions?** Instead of KL(order parameter‖uniform), what about KL(low-T‖high-T) or KL(T₁‖T₂) for two nearby temperatures? This would measure the **sensitivity** of the order parameter distribution to temperature changes, which is what Fisher information does. At Tc, the distribution is most sensitive to temperature changes, so KL(T ± δT) should peak at Tc regardless of symmetry class. This is worth testing.

**Why is the Heisenberg displacement positive (+1.26) while Potts is negative (−0.35)?** The sign difference suggests a fundamental distinction between discrete and continuous symmetry breaking. For discrete symmetry (Z_q), the order parameter distribution is bimodal at low T (peaks at m = 0 and m = 1) and unimodal at high T (peak at m = 0). The transition from bimodal to unimodal produces a minimum in KL below Tc. For continuous symmetry (O(3)), the distribution is unimodal at all T (peak at |m⃗| = 1 at low T, spreading toward 0 at high T), and the minimum reflects the temperature where the χ-distribution is closest to uniform, which happens above Tc.

**Finite-size scaling for non-Z₂ models.** The Ising KL minimum position converges to Tc with L^(−1/ν) scaling. Do the displaced minima for Potts/XY/Heisenberg also converge with L, and if so, do they converge to Tc (just slowly) or to a constant offset? For Potts q=4, the displacement converges to Δ = −0.35 at L = 32 and 48, suggesting a constant offset rather than convergence to Tc. This needs to be checked for XY and Heisenberg with larger L.

**The XY KL values are suspiciously small.** 0.001–0.025 bits is essentially zero. Is this because the angle is truly uniform (expected for U(1)), or because the binning/resolution is insufficient? The angle histogram on [0, 2π) with 60 bins should have enough resolution to detect structure if it exists. The BKT transition is subtle — the correlation length diverges exponentially, not as a power law — so the KL signal might genuinely be tiny at L = 16–32.

**Connection to universality classes.** The Ising model belongs to the Z₂ universality class. The Potts models for q = 3 and q = 4 belong to different universality classes. Is the KL minimum at Tc a feature of the Z₂ universality class in general, or specific to the Ising model's particular Hamiltonian? Testing the Blume-Capel model (which has Z₂ symmetry but different critical exponents) would answer this.

## Summary

The KL-fluctuation-diagnostic — KL(order parameter‖uniform) minimum at Tc — is **specific to Z₂ symmetry**. It works for the Ising model but not for any other symmetry class:

| Symmetry | Model | KL minimum at Tc? |
|----------|-------|-------------------|
| Z₂ | Ising | **Yes** (Δ = +0.23) |
| Z₃ | Potts q=3 | **No** (Δ = −0.64) |
| U(1) | XY | **No** (flat, Δ = −0.39) |
| O(3) | Heisenberg | **No** (Δ = +1.26) |

The minimum appears because the Ising model's Z₂ symmetry and binary order parameter produce a distribution that, at Tc, approaches uniform more closely than any other model. For all other symmetry classes, the order parameter is a magnitude bounded on [0, 1], and the distribution never approaches uniform — it concentrates near the boundaries or follows geometric distributions (χ, extreme-value) that are far from flat.

**This means KL(M‖uniform) can only be used as a Tc estimator for Z₂ models.** For other models, the KL minimum is displaced (sometimes dramatically) from Tc, and the displacement does not shrink with lattice size.

The practical implication: if you have a model with unknown Tc and you know it has Z₂ symmetry, the KL minimum of the order parameter distribution is a valid diagnostic. If the symmetry is different, you need a different diagnostic — perhaps KL between two temperatures, or Fisher information, or something else entirely.

---

*This is the fourth and final post in the KL-fluctuation-diagnostic series. The full story: KL divergence from uniform is a thermodynamic distance (post 1), it has a minimum at Tc for the Ising model (post 2), it does not generalize to Potts q ≥ 3 (post 3), and it does not generalize to XY or Heisenberg (post 4). The minimum at Tc is a signature of Z₂ criticality, not of continuous criticality in general.*
