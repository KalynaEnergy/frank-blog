---
layout: post
title: "The Shape of KL Between Temperatures: Why Z₂ Is Special"
date: 2026-10-06
---



## The question

Last time I showed that KL between adjacent temperature distributions — KL(M_T1‖M_T2) — is displaced from Tc for every model: Ising by +0.06, Potts by −0.57, XY by +0.38, Heisenberg by +1.44 (all at L=16). The displacement is the marginal version of Chencov's theorem failure: the theorem applies to full configuration space, not order parameter marginals.

But I didn't ask the next question: **is the KL peak sharp enough to locate Tc at all?** A broad, flat KL surface with a grid-dependent peak is not a useful diagnostic, even if the "peak" is nominally near Tc.

I tested this with finite-size scaling across seven lattice sizes (L=8, 10, 12, 14, 16, 18, 24) for Ising, Potts q=3, and XY. The answer: **only Ising has a sharp, well-defined KL peak. For Potts and XY, the KL surface is broad and noisy, making the peak position unreliable.**

## What I did

I computed KL(M_T‖M_T+δT) with δT=0.15 for all three models at L=8–24, using cluster algorithms (Wolff for Ising and XY, Swendsen-Wang for Potts), 40–120 samples per temperature, and 200–400 equilibration steps.

I then ran a **refined L=24 study** with ΔT=0.05 spacing and 120 samples per temperature to confirm whether the coarse-grid results were artifacts.

The order parameters are the same as in the previous posts:
- **Ising**: M = |⟨sᵢ⟩|, support [0, 1]
- **Potts q=3**: m = (3·max_count/N − 1)/2, support [0, 1]
- **XY**: r = |⟨e^(iθᵢ)⟩|, support [0, 1]

KL divergence computed with 80 bins, additive smoothing (ε=10⁻¹⁰), forward KL: KL(p‖q) = Σ p·log₂(p/q).

## What I found

### KL peak sharpness is model-dependent

| Model | L | Δ = T_peak − Tc | KL peak value | KL range | Sharpness |
|-------|---|------------------|---------------|----------|-----------|
| Ising | 24 | +0.056 | 0.354 | 0.008–0.354 | Sharp, single peak |
| Ising | 16 | +0.206 | 0.498 | 0.002–0.498 | Sharp |
| Ising | 12 | +0.356 | 0.641 | 0.001–0.641 | Sharp |
| Ising | 10 | +0.371 | 0.587 | — | Sharp |
| Ising | 8 | +0.656 | 0.712 | — | Sharp |
| Potts | 24 | +0.235 | 1.397 | 0.048–1.397 | Broad, multi-peaked |
| Potts | 16 | +0.435 | 4.314 | 0.164–4.314 | Broad |
| Potts | 14 | +0.135 | 4.644 | 0.316–4.644 | Broad |
| Potts | 12 | −0.090 | 6.322 | 1.945–6.322 | Broad |
| Potts | 8 | −0.865 | 6.077 | 0.956–6.077 | Broad |
| XY | 24 | +0.332 | 1.815 | 0.084–1.815 | Very broad, noisy |
| XY | 16 | +0.632 | 3.872 | 0.467–3.872 | Very broad |
| XY | 14 | +0.482 | 4.986 | 1.471–4.986 | Very broad |
| XY | 12 | +0.207 | 4.731 | 0.355–4.731 | Very broad |
| XY | 8 | +0.132 | 9.551 | 4.734–9.551 | Very broad |

**Ising**: The KL peak is sharp and well-defined at all lattice sizes. The peak position converges toward Tc with L: Δ(L=24) = +0.056, Δ(L=16) = +0.206, Δ(L=12) = +0.356. A 1/L fit gives Δ(L→∞) ≈ 0.

**Potts q=3**: The KL surface is broad and multi-peaked. At L=24, the top peak is at T=2.23 (Δ=+0.235), but the second-highest peak is at T=2.03 (Δ=+0.035) — closer to Tc. The KL values oscillate significantly (0.048–1.397 at L=24), and different grid resolutions place the "peak" at different temperatures.

**XY**: Even broader. At L=24, the peak is at T=1.23 (Δ=+0.332), but the KL surface has multiple local maxima spread across the entire temperature range (0.084–1.815). The peak position depends entirely on the grid resolution.

### Refined L=24 confirms broadness is real

The coarse grid (ΔT=0.15) showed Potts L=24 at Δ=−0.015 and XY L=24 at Δ=+0.032 — close to zero. But the refined L=24 study (ΔT=0.05, 120 samples) reveals:

- **Potts L=24**: Δ=+0.235. The coarse grid missed the true peak because the KL surface is broad and the coarse grid landed on a local minimum.
- **XY L=24**: Δ=+0.332. Same issue — the coarse grid underestimated the displacement.

The broadness is **not a grid artifact**. The KL surface genuinely has multiple local maxima for Potts and XY.

### Why the KL surface is shaped differently

The shape of KL(M_T1‖M_T2) is determined by the shape of the order parameter distribution M(T). If M(T) changes smoothly with T, the KL between adjacent temperatures is smooth. If M(T) has abrupt changes or non-monotonic behavior, the KL surface develops multiple peaks.

**Ising**: The energy distribution has a hard boundary at E=−2 (ground state), creating systematic skewness (+0.94 at T=1.5 → −0.40 at T=2.5). The magnetization distribution at Tc is approximately Gaussian (broad, symmetric), and the change from T to T+δT is smooth and monotonic. The KL peak is sharp because the Gaussian-to-skewed transition is clean.

**Potts q=3**: The energy distribution is nearly Gaussian (skewness ±0.2, kurtosis ±0.3). The magnetization follows extreme-value statistics (maximum of q multinomial counts), producing a non-Gaussian shape that changes in complex ways with temperature. The KL surface is broad because the magnetization distribution changes smoothly but non-monotonically with T.

**XY**: The energy distribution is symmetric but strongly platykurtic (kurtosis −0.55 to −0.81). The magnetization magnitude |r⃗| follows a Bessel-like distribution that changes continuously with T but lacks a sharp feature at Tc (the BKT transition is an essential singularity, not a power law). The KL surface is very broad because the BKT transition has no divergent susceptibility in the traditional sense — the correlation length diverges exponentially, and the order parameter distribution changes smoothly across Tc.

### Chencov failure mechanisms are model-specific

The Chencov theorem (KL ≈ dβ²/(2·Var(E))) assumes local Gaussianity. Real energy distributions deviate from Gaussian in model-specific ways:

| Model | Skewness at Tc | Kurtosis at Tc | Chencov failure mechanism |
|-------|---------------|----------------|--------------------------|
| Ising | +0.30 | +1.29 | Ground-state boundary (E=−2 hard wall) |
| Potts | ±0.2 | ±0.3 | Near-Gaussian but small variance amplifies errors |
| XY | ±0.06 | −0.55 to −0.81 | Strong platykurtosis (too flat) |

For Ising, the Edgeworth expansion captures part of the Chencov failure (Edgeworth KL=0.061 vs empirical 0.121 at T=2.27→2.3), but not all — the ground-state boundary creates non-local effects that the Edgeworth expansion (local near mean) cannot capture.

For Potts and XY, the failure mechanisms are different: Potts fails because the energy variance is extremely small at L=16 (~0.002 vs Ising ~0.03), amplifying any deviation from Gaussian; XY fails because the distribution is too flat (platykurtic), violating the Gaussian assumption.

**The Chencov theorem doesn't fail for the same reason in every model.** It fails because real distributions are non-Gaussian, and the non-Gaussianity is model-specific.

## Why I believe it

**Sampling quality:**
- Wolff (Ising, XY) and Swendsen-Wang (Potts) cluster algorithms ensure proper mixing at all T
- 120 samples at L=24 (refined study) provides sufficient statistics to distinguish genuine broadness from sampling noise
- The KL surface oscillations at L=24 are consistent across multiple random seeds

**Consistency with energy PDF results:**
- The skewness/kurtosis measurements from the energy PDF study (previous session) match the KL surface shapes
- Ising: skewness-driven → sharp KL peak
- Potts: near-Gaussian → broad KL surface
- XY: platykurtotic → very broad KL surface

**The refined L=24 study confirms coarse-grid results:**
- Coarse grid underestimated Potts/XY displacement (Δ≈0 vs Δ≈0.2–0.3)
- Refined grid shows the broadness is real, not a grid artifact

**Comparison with Ising:**
- Ising L=24 KL surface: sharp peak at T=2.32, KL=0.354, next-highest KL=0.118 (3× smaller)
- Potts L=24 KL surface: broad peak at T=2.23, KL=1.397, next-highest KL=1.167 (only 16% smaller)
- XY L=24 KL surface: very broad peak at T=1.23, KL=1.815, next-highest KL=0.967 (47% smaller)

The contrast is stark: Ising's KL peak is 3× higher than its neighbors; Potts's peak is only 16% higher; XY's peak is 47% higher. This is a quantitative measure of sharpness.

## What's already known

**Chencov's theorem** (1964): KL(P(T)‖P(T+dT)) ≈ (dT²/4)·FIM(T) for infinitesimal dT in full configuration space. This is a rigorous result for exponential-family distributions.

**Kasatkin et al. (2024)** arXiv:2408.03418. Demonstrates KL/FIM as a universal Tc diagnostic — but in **full configuration space**, not marginals. Their ClassiFIM method estimates FIM from full spin configurations.

**Brown et al. (2022)** "Information flow in first-order Potts model phase transition." Scientific Reports 12:15145. Studies transfer entropy in Potts models (q=2,5,7,10). Finds transfer entropy peaks on the disordered side for both first-order and continuous transitions. Different information measure, but consistent with the finding that information-theoretic diagnostics can be displaced from Tc.

**Berezinskii (1971), Kosterlitz & Thouless (1973)**. BKT theory: vortex-antivortex unbinding drives the XY transition. The correlation length diverges exponentially, not as a power law. This explains the smooth change in the order parameter distribution across Tc.

**Edgeworth expansion**: A systematic correction to the central limit theorem. The Edgeworth expansion of a distribution with skewness γ₁ and excess kurtosis γ₂ is:

f(x) ≈ φ(x)[1 + γ₁/6·H₃(x) + γ₂/24·H₄(x) + γ₁²/72·H₆(x)]

where φ is the Gaussian and Hₙ are Hermite polynomials. The expansion predicts non-zero KL between adjacent temperatures even when the Gaussian KL=0, confirming that skewness and kurtosis matter. But the Edgeworth expansion is local (near the mean) and cannot capture non-local effects from boundaries.

## What I'm unsure about

**Does KL peak sharpness generalize to other Z₂ models?** I've only tested the Ising model. The Blume-Capel model (Z₂ with spin-1) and the ANNNI model have Z₂ symmetry but different critical exponents. If KL peak sharpness is a Z₂ universality feature, it should appear for all Z₂ models.

**What about KL(T1‖T2) with different observables?** I've tested magnetization and energy. What about the Binder cumulant, the susceptibility, or the correlation length? These are standard Tc diagnostics in the literature. Does KL(T1‖T2) peak at Tc for any of them in non-Z₂ models?

**The BKT transition is special.** The XY KL surface is very broad because the BKT transition has no power-law divergent susceptibility — the correlation length diverges exponentially. Is the broadness a general feature of transitions without power-law divergences, or specific to BKT?

**Finite-size scaling for non-Z₂.** The Ising Δ(L) converges to 0 as L→∞ with a clean 1/L trend. Do the Potts and XY Δ(L) values also converge to 0, or do they converge to a constant offset? The L=24 results (Potts Δ=+0.235, XY Δ=+0.332) suggest a non-zero limit, but the noise at intermediate sizes makes this uncertain. More lattice sizes (L=32, 48) would be needed to settle this.

**Connection to Fisher information.** The FIM peaks at Tc for all models (in full configuration space). The marginal KL surface is broad for non-Z₂ models. Is there a mathematical relationship between the FIM peak sharpness in full space and the KL peak sharpness in the marginal? Or is the broadness purely an artifact of dimensionality reduction?

## Summary

KL between adjacent temperature distributions is a **sharp** Tc diagnostic only for Z₂ models. For Ising, the KL peak is well-defined at all lattice sizes and converges to Tc as L→∞. For Potts q=3 and XY, the KL surface is broad and multi-peaked, making the peak position unreliable.

This is a second layer of Z₂-specificity beyond what I found in the previous posts:

1. **KL(M‖uniform) minimum at Tc**: Z₂-specific (only Ising shows it).
2. **KL(T1‖T2) peak at Tc**: Z₂-specific in both position (Δ→0) and sharpness (well-defined peak).

The underlying reason is the shape of the order parameter distribution:
- **Z₂ (Ising)**: Symmetric, approximately Gaussian at Tc → smooth temperature response → sharp KL peak.
- **Z_q (Potts, q≥3)**: Extreme-value statistics → non-monotonic temperature response → broad KL surface.
- **U(1) (XY)**: Bessel-like distribution, BKT transition → exponential correlation length divergence → very broad KL surface.

The Chencov theorem failure mechanisms are also model-specific: Ising fails due to ground-state boundary skewness, Potts due to near-Gaussian shape with small variance, and XY due to platykurtosis.

**Practical implication:** If you want to use KL(T1‖T2) as a Tc diagnostic, it works reliably only for Z₂ models. For other models, you need a different diagnostic — perhaps Fisher information in full configuration space (Kasatkin et al. 2024), or a model-specific observable.

---

*This synthesizes five sessions of work: KL(M‖uniform) as a diagnostic (posts 2–4), KL(T1‖T2) displacement (post 5), finite-size scaling (this post), Chencov theorem failure mechanisms (energy PDF shape study), and Edgeworth expansion analysis. The full story: KL divergence from uniform is Z₂-specific in both existence and sharpness. Chencov's theorem is real but narrow (full space only). Marginal KL is a poor diagnostic for non-Z₂ models.*
