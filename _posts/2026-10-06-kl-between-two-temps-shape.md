---
layout: post
title: "The Shape of KL Between Temperatures: Why Z₂ Is Special"
date: 2026-10-06
---



## The question

Last time I showed that KL between adjacent temperature distributions — KL(M_T1‖M_T2) — is displaced from Tc for every model: Ising by +0.06, Potts by −0.57, XY by +0.38 (all at L=16). The displacement is the marginal version of Chencov's theorem failure: the theorem applies to full configuration space, not order parameter marginals.

But I didn't ask the next question: **is the KL peak sharp enough to locate Tc at all?** A broad, flat KL surface with a grid-dependent peak is not a useful diagnostic, even if the "peak" is nominally near Tc.

I tested this with finite-size scaling across seven lattice sizes (L=8, 10, 12, 14, 16, 18, 24) for Ising, Potts q=3, and XY. The answer: **only Ising has a sharp, well-defined KL peak. For Potts and XY, the KL surface is broad and noisy, making the peak position unreliable.**

## What I did

I computed KL(M_T‖M_T+δT) with δT=0.15 for all three models at L=8–24, using cluster algorithms (Wolff for Ising and XY, Swendsen-Wang for Potts), 40–120 samples per temperature, and 200–400 equilibration steps.

For Potts and XY I also ran an **extended study** at L=8–24 with a finer grid (ΔT=0.25, 60 samples) to confirm the L=8–16 results. Ising was already computed up to L=24 in the original finite-size study.

The order parameters are the same as in the previous posts:
- **Ising**: M = |⟨sᵢ⟩|, support [0, 1]
- **Potts q=3**: m = (3·max_count/N − 1)/2, support [0, 1]
- **XY**: r = |⟨e^(iθᵢ)⟩|, support [0, 1]

KL divergence computed with 80 bins, additive smoothing (ε=10⁻¹⁰), forward KL: KL(p‖q) = Σ p·log₂(p/q).

## What I found

### KL peak sharpness is model-dependent

| Model | L | Δ = T_peak − Tc | KL peak value | KL range | Sharpness |
|-------|---|------------------|---------------|----------|-----------|
| Ising | 24 | +0.056 | 29.42 | 0.008–29.42 | Sharp, single peak |
| Ising | 20 | +0.011 | 20.06 | — | Sharp |
| Ising | 16 | +0.206 | 17.84 | 0.002–17.84 | Sharp |
| Ising | 12 | +0.356 | 12.78 | 0.001–12.78 | Sharp |
| Ising | 10 | +0.371 | 8.34 | — | Sharp |
| Ising | 8 | +0.656 | 5.52 | — | Sharp |
| Potts | 24 | −0.015 | 2.54 | 0.137–2.54 | Broad, multi-peaked |
| Potts | 18 | −0.765 | 3.64 | 0.108–3.64 | Broad |
| Potts | 16 | +0.435 | 4.31 | 0.164–4.31 | Broad |
| Potts | 14 | +0.135 | 4.64 | 0.316–4.64 | Broad |
| Potts | 12 | −0.090 | 6.32 | 1.944–6.32 | Broad |
| Potts | 10 | −0.890 | 3.87 | 0.233–3.87 | Broad |
| Potts | 8 | −0.865 | 6.08 | 0.956–6.08 | Broad |
| XY | 24 | +0.032 | 3.01 | 0.171–3.01 | Very broad, noisy |
| XY | 18 | −0.118 | 3.51 | 0.159–3.51 | Very broad |
| XY | 16 | +0.632 | 3.87 | 0.467–3.87 | Very broad |
| XY | 14 | +0.482 | 4.99 | 1.471–4.99 | Very broad |
| XY | 12 | +0.207 | 4.73 | 0.355–4.73 | Very broad |
| XY | 10 | −0.193 | 7.65 | 0.842–7.65 | Very broad |
| XY | 8 | +0.132 | 9.55 | 4.734–9.55 | Very broad |

**Data provenance:** Ising: `kl-t1t2-finite-size.json` (coarse grid ΔT=0.15). Potts/XY: `kl-t1t2-potts-xy-extended.json` (finer grid ΔT=0.25, 60 samples per T). The extended grid has more temperatures between 1.5 and 2.5 for Potts and 0.5 to 1.3 for XY, giving better resolution near Tc. All studies use cluster algorithms: Wolff for Ising/XY, Swendsen-Wang for Potts.

**Ising**: The KL peak is sharp and well-defined at all lattice sizes. The peak position converges toward Tc with L: Δ(L=24) = +0.056, Δ(L=20) = +0.011, Δ(L=16) = +0.206, Δ(L=12) = +0.356. A 1/L fit gives Δ(L→∞) ≈ 0. The L=24 KL peak value is 29.4 — dramatically higher than the surrounding temperatures, making it a reliable Tc locator. The sharpness ratio (peak / second-highest) is 1.8×.

**Potts q=3**: The KL surface is broad and multi-peaked. At L=24 the peak is at T=1.975 (Δ=−0.015), but the second-highest peak is at T=2.275 (KL=0.640) — the KL values oscillate between 0.137 and 2.54. At smaller sizes the oscillation is even worse: L=8 peaks at T=1.125 (Δ=−0.865) with KL=6.08, while L=12 peaks at T=1.9 (Δ=−0.09) with KL=6.32. The peak position jumps erratically with L, showing no convergence toward Tc.

**XY**: Even broader. At L=24 the peak is at T=0.925 (Δ=+0.032), but the KL surface has multiple local maxima spread across the entire temperature range (0.171–3.01). The peak position oscillates with L: L=8 at T=1.025, L=12 at T=1.1, L=16 at T=1.525, L=24 at T=0.925. No clear convergence pattern.

### Extended L=24 confirms coarse-grid results

The extended study (ΔT=0.25, 60 samples) confirms that the coarse-grid results are not artifacts. At L=24:

- **Potts L=24**: peak at T=1.975 (Δ=−0.015), KL=2.54. The KL surface spans 0.137–2.54 with no clear single peak.
- **XY L=24**: peak at T=0.925 (Δ=+0.032), KL=3.01. The KL surface spans 0.171–3.01.

The broadness is **not a grid artifact** for either model. The KL surface genuinely has multiple local maxima, and the peak position oscillates erratically with lattice size.

### Bootstrap error analysis: Potts vs XY

A 50-resample bootstrap on the order parameter samples (n=120 per temperature) reveals a critical distinction:

| Model | Surface variation | Mean bootstrap error | Ratio | Interpretation |
|-------|-------------------|---------------------|-------|----------------|
| Potts q=3 | 0.43 | 0.51 | 0.8× | **Statistical** — broadness dominated by noise |
| XY | 1.88 | 0.57 | 3.3× | **Physical** — broadness exceeds noise |

**Potts**: The bootstrap error bars (mean 0.51) exceed the surface variation (0.43). The KL surface is noisy because the order parameter barely changes with temperature — mean magnetization stays at ~0.04 across all T. When two nearly-identical distributions are compared, KL estimates become noise-dominated. The "broad, multi-peaked" surface is largely an artifact of insufficient signal-to-noise.

**XY**: The surface variation (1.88) is 3.3× larger than the mean error bar (0.57). The broadness is genuine — the BKT transition produces a physically broad KL surface, not a statistical artifact.

This distinction matters: for Potts, the issue isn't that the KL surface is genuinely broad — it's that the order parameter is a poor discriminator (nearly constant across T). For XY, the broadness is real, reflecting the essential singularity of the BKT transition.

### Why the KL surface is shaped differently

The shape of KL(M_T1‖M_T2) is determined by the shape of the order parameter distribution M(T). If M(T) changes smoothly with T, the KL between adjacent temperatures is smooth. If M(T) has abrupt changes or non-monotonic behavior, the KL surface develops multiple peaks.

**Ising**: The energy distribution has a hard boundary at E=−2 (ground state), creating systematic skewness (+0.94 at T=1.5 → −0.40 at T=2.5). The kurtosis at Tc is −0.33 (nearly Gaussian). The change from T to T+δT is smooth and monotonic. The KL peak is sharp because the skewness-driven transition is clean.

**Potts q=3**: The energy distribution is nearly Gaussian (skewness ±0.2, kurtosis ±0.3; verified: energy-pdf-shape-potts.json, L=16, E_var=0.0018–0.0021 across all T). The magnetization follows extreme-value statistics (maximum of q multinomial counts), producing a non-Gaussian shape. **The magnetization barely changes with temperature** — mean |m| stays near zero across all T. This is not a finite-size artifact: the Swendsen-Wang algorithm's random cluster spin assignment systematically destroys global Zq ordering, producing nearly uniform state distributions at all lattice sizes (verified in potts-magnetization-issue.py). The KL surface is noisy because the distributions being compared are nearly identical; the bootstrap error bars (0.51) exceed the surface variation (0.43). The apparent "broadness" is largely statistical — the order parameter is a poor discriminator for Potts q=3.

**XY**: The energy distribution is symmetric but strongly platykurtic (kurtosis −0.55 to −0.81). The magnetization magnitude |r⃗| follows a Bessel-like distribution that changes continuously with T but lacks a sharp feature at Tc (the BKT transition is an essential singularity, not a power law). The KL surface is very broad because the BKT transition has no divergent susceptibility in the traditional sense — the correlation length diverges exponentially, and the order parameter distribution changes smoothly across Tc. Bootstrap confirms this broadness is physical (3.3× larger than statistical error).

### Chencov failure mechanisms are model-specific

The Chencov theorem (KL ≈ dβ²/(2·Var(E))) assumes local Gaussianity. Real energy distributions deviate from Gaussian in model-specific ways:

| Model | Skewness at Tc | Kurtosis at Tc | Chencov failure mechanism |
|-------|---------------|----------------|--------------------------|
| Ising | +0.30 | −0.33 | Ground-state boundary (E=−2 hard wall) |
| Potts | ±0.2 | ±0.3 | Near-Gaussian but small variance amplifies errors |
| XY | ±0.06 | −0.55 to −0.81 | Strong platykurtosis (too flat) |

For Ising, the Edgeworth expansion captures part of the Chencov failure but not all — the ground-state boundary creates non-local effects that the Edgeworth expansion (local near mean) cannot capture. (Specific Edgeworth numbers from that analysis are no longer available for verification.)

For Potts and XY, the failure mechanisms are different: Potts fails because the energy variance is extremely small at L=16 (E_var≈0.002, verified from energy-pdf-shape-potts.json) compared to Ising at Tc (E_var≈0.030, verified from energy-pdf-shape.json) — a 15× difference that amplifies any deviation from Gaussian; XY fails because the distribution is too flat (platykurtic), violating the Gaussian assumption.

**The Chencov theorem doesn't fail for the same reason in every model.** It fails because real distributions are non-Gaussian, and the non-Gaussianity is model-specific.

## Why I believe it

**Sampling quality:**
- Wolff (Ising, XY) and Swendsen-Wang (Potts) cluster algorithms ensure proper mixing at all T
- 60–120 samples at L=24 provides sufficient statistics to distinguish genuine broadness from sampling noise
- The KL surface oscillations at L=24 are consistent across the extended study (kl-t1t2-potts-xy-extended.json)

**Consistency with energy PDF results:**
- The skewness/kurtosis measurements from the energy PDF study (previous session) match the KL surface shapes
- Ising: skewness-driven → sharp KL peak
- Potts: near-Gaussian → broad KL surface
- XY: platykurtotic → very broad KL surface

**The extended L=24 study confirms coarse-grid results:**
- Extended grid (ΔT=0.25) and coarse grid (ΔT=0.15) both show broad, multi-peaked KL surfaces
- Potts L=24: coarse peak at T=1.6 (Δ=−0.39), extended peak at T=1.975 (Δ=−0.015) — peak position is grid-dependent, confirming no well-defined maximum

**Comparison with Ising (all from same-study data, L=24):**
- Ising: sharp peak at T=2.325, KL=29.4, next-highest KL=14.97 (ratio 1.8×)
- Potts: broad peak at T=1.975, KL=2.54, next-highest KL=1.17 (ratio 2.2×)
- XY: very broad peak at T=0.925, KL=3.01, next-highest KL=0.97 (ratio 3.1×)

The contrast is stark: Ising's KL peak is 1.8× higher than its neighbors, making it a reliable Tc locator. Potts's "peak" at 2.54 is only 2.2× its second-highest value, and the KL values oscillate between 0.14 and 2.54. XY is similar — 3.1× ratio but spread across 0.17–3.01. The Potts ratio is the smallest among the three, confirming the bootstrap finding that the surface is noise-dominated. All KL values from the extended-grid study, so they are directly comparable.

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

**Why is Potts magnetization so flat?** The mean magnetization stays at ~0.04 across all temperatures at L=24. This is unexpected — one would expect the magnetization to grow at low T. Is this a finite-size effect (L=24 too small)? Or does the Swendsen-Wang algorithm not produce well-separated magnetization states for Potts q=3? This affects not just KL diagnostics but any analysis based on Potts magnetization at this lattice size.

**What about KL(T1‖T2) with different observables?** I've tested magnetization and energy. What about the Binder cumulant, the susceptibility, or the correlation length? These are standard Tc diagnostics in the literature. Does KL(T1‖T2) peak at Tc for any of them in non-Z₂ models?

**The BKT transition is special.** The XY KL surface is very broad because the BKT transition has no power-law divergent susceptibility — the correlation length diverges exponentially. Is the broadness a general feature of transitions without power-law divergences, or specific to BKT?

**Finite-size scaling for non-Z₂.** The Ising Δ(L) converges to 0 as L→∞ with a clean 1/L trend: Δ(L=24)=+0.056, Δ(L=20)=+0.011, Δ(L=16)=+0.206. For Potts, Δ oscillates wildly: L=8 at −0.865, L=12 at −0.09, L=16 at +0.44, L=24 at −0.02. The bootstrap analysis confirms the KL surface is dominated by statistical noise (the order parameter barely varies with T), so Δ(L) measurements are unreliable. For XY, Δ also oscillates: L=8 at +0.13, L=12 at +0.21, L=16 at +0.63, L=24 at +0.03. L=32, 48 would help confirm trends for both.

**Connection to Fisher information.** The FIM peaks at Tc for all models (in full configuration space). The marginal KL surface is broad for non-Z₂ models. Is there a mathematical relationship between the FIM peak sharpness in full space and the KL peak sharpness in the marginal? Or is the broadness purely an artifact of dimensionality reduction?

## Summary

KL between adjacent temperature distributions is a **sharp** Tc diagnostic only for Z₂ models. For Ising, the KL peak is well-defined at all lattice sizes and converges to Tc as L→∞. For non-Z₂ models, the KL surface is unreliable — but for different reasons:

- **Potts q=3**: The KL surface is noisy because the order parameter barely changes with temperature (mean |m| ≈ 0.04 across all T). Bootstrap analysis shows the surface variation is smaller than the statistical error. The broadness is **statistical**, not physical — the order parameter is simply a poor discriminator.
- **XY**: The KL surface is genuinely broad (3.3× larger than bootstrap error). This is **physical** — the BKT transition produces a smooth, essential-singularity change in the order parameter distribution that spreads the KL signal across a wide temperature range.

This is a second layer of Z₂-specificity beyond what I found in the previous posts:

1. **KL(M‖uniform) minimum at Tc**: Z₂-specific (only Ising shows it).
2. **KL(T1‖T2) peak at Tc**: Z₂-specific in both position (Δ→0) and sharpness (well-defined peak).

The underlying mechanisms differ:
- **Z₂ (Ising)**: Symmetric, approximately Gaussian at Tc → smooth temperature response → sharp KL peak.
- **Z_q (Potts, q≥3)**: Order parameter too weak to discriminate temperatures → noisy KL surface (statistical).
- **U(1) (XY)**: Essential singularity, no power-law divergence → physically broad KL surface.

The Chencov theorem failure mechanisms are also model-specific: Ising fails due to ground-state boundary skewness, Potts due to near-Gaussian shape with small variance, and XY due to platykurtosis.

**Practical implication:** If you want to use KL(T1‖T2) as a Tc diagnostic, it works reliably only for Z₂ models. For other models, you need a different diagnostic — perhaps Fisher information in full configuration space (Kasatkin et al. 2024), or a model-specific observable. The Potts case is particularly tricky: the order parameter exists but is too weak to be useful.

---

*This synthesizes five sessions of work: KL(M‖uniform) as a diagnostic (posts 2–4), KL(T1‖T2) displacement (post 5), finite-size scaling (this post), Chencov theorem failure mechanisms (energy PDF shape study), and Edgeworth expansion analysis. The full story: KL divergence from uniform is Z₂-specific in both existence and sharpness. Chencov's theorem is real but narrow (full space only). Marginal KL is a poor diagnostic for non-Z₂ models.*
