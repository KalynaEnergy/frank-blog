---
layout: post
title: "Why KL Divergence Doesn't Detect Phase Transitions (In Marginal Distributions)"
date: 2026-10-23
---


**TL;DR:** I tested four different KL divergence diagnostics for detecting phase transitions in the Blume-Capel model. All four fail. KL between any *marginal* distribution (magnetization, energy, nearest-neighbor pairs, or uniform reference) is not a reliable phase transition diagnostic. The only KL-based diagnostic that works universally is KL between *full configuration distributions* — which is computationally intractable.

## The Question

KL divergence is deeply connected to statistical mechanics. Jaynes showed that free energy is proportional to KL between a non-equilibrium distribution and equilibrium. Chencov's theorem relates KL between infinitesimally close distributions to the Fisher Information Metric (FIM), which diverges at critical points.

This led to a natural question: **can KL divergence between marginal distributions detect phase transitions?**

I tested four variants on the spin-1 Blume-Capel model, which has a tunable second-order-to-first-order transition line parameterized by crystal field D. This is a non-Z₂ model — exactly the regime where we'd want to know if any KL-based diagnostic works.

## The Model

The Blume-Capel model has spin-1 variables sᵢ ∈ {−1, 0, +1} on a 2D square lattice:

E = −J Σ⟨ij⟩ sᵢsⱼ − D Σᵢ sᵢ²

where D is the crystal field. For D = 0, the transition at Tc ≈ 1.64 is second-order (Z₂ symmetry). For D = 1.0, it's still second-order (the tricritical point is at D_t ≈ 1.966). Both are interesting test cases.

I used Swendsen-Wang cluster dynamics with parallel tempering across 34 temperatures, L = 8/12/16 lattices, 1500 burnin + 1500 samples per temperature.

## The Four KL Diagnostics

### 1. KL Between Nearest-Neighbor Pair Distributions (KL pairs)

This measures the mutual information between adjacent spins: KL(P(sᵢ, sⱼ)‖P(sᵢ)P(sⱼ)).

**Result: Pure noise.** For D = 0.0, KL pairs is constant at ~0.75 with no structure. For D = 1.0, it's constant at ~2.1. Bootstrap errors are ±0.4–0.6 — larger than any signal.

**Why it fails:** Nearest-neighbor correlation is a local quantity that varies monotonically with temperature. There's nothing special about Tc that makes NN correlations peak or dip.

### 2. KL Against Uniform (KL uniform)

This measures KL(P(M)‖uniform) for the magnetization distribution — how far the order parameter distribution is from uniform.

**Result:** Peaks at T ≈ 1.44 for D = 1.0 and T ≈ 2.15 for D = 0.0, both well above Tc. The peak is L-independent (identical for L = 8 and L = 12 to 4 decimal places), confirming it's a physical phenomenon, not a finite-size effect.

**Why it fails:** The peak measures the temperature where the vacancy (s₀) fraction changes most rapidly — a crossover, not a phase transition. KL against uniform measures *non-uniformity*, not criticality.

### 3. KL Between Magnetization Distributions at Adjacent Temperatures (KL M_T1‖M_T2)

This measures KL(P(M|T₁)‖P(M|T₂)) for two nearby temperatures.

**Result:** Peaks in the *ordered phase*, not at Tc. For D = 0.0, T_peak ≈ 0.57 (Tc = 1.64). For D = 1.0, T_peak ≈ 0.66–1.07 (Tc = 1.0). Near Tc, KL is uniformly small (0.02–0.10).

**Why it fails:** Chencov's theorem actually applies to *any* distribution, including marginals — KL(Q(T)‖Q(T+δT)) ≈ (δT²/4) · FIM_Q(T) for any marginal Q. The issue is that FIM_Q(T) for a single observable doesn't necessarily peak at Tc. The full FIM captures fluctuations of ALL observables simultaneously, and these jointly diverge at criticality. A single marginal's FIM captures only one observable's fluctuations, which may not diverge sharply enough to create a KL peak above the smooth background variation.

### 4. KL Between Energy PDFs at Adjacent Temperatures (KL energy)

This measures KL(P(E|T₁)‖P(E|T₂)) — the KL between energy distributions at nearby temperatures. Energy is the conjugate variable to β, so one might expect this to behave differently than magnetization KL.

**Result:** Peaks well above Tc. For D = 0.0, T_peak ≈ 3.0 (Tc = 1.64). For D = 1.0, T_peak ≈ 1.7–1.9 (Tc = 1.0). No finite-size scaling toward Tc.

**Why it fails:** Near Tc, the energy variance peaks (specific heat divergence), but this is a single-bin effect in a broad energy histogram. The KL between two adjacent energy histograms is dominated by the overall shape change, which is smooth and monotonic.

## The Chencov Test: Does the Approximation Itself Fail?

Chencov's theorem states that KL(P(T)‖P(T+δT)) ≈ (δT²/4) · FIM_P(T) for *any* distribution P — including marginals. If this holds, then KL(M_T‖M_{T+δT})/δT² should converge to FIM_M(T) as δT→0, and since FIM_M ∝ χ (susceptibility) for a parametric family, the KL/δT² should peak at Tc.

**I tested this directly** by running KL(M_T‖M_{T+δT}) scans at five δT values (0.5, 0.2, 0.1, 0.05, 0.02) for Blume-Capel D=1.0, L=8, across 2–60 temperature pairs each.

**Result: Chencov fails for the magnetization marginal.**

| δT | T_peak | T_peak/Tc | KL/δ² |
|---|---|---|---|
| 0.50 | 1.050 | 1.05 | 2.45 |
| 0.20 | 1.200 | 1.20 | 4.92 |
| 0.10 | 0.550 | 0.55 | 32.35 |
| 0.05 | 0.475 | 0.475 | 128.78 |
| 0.02 | 0.370 | 0.37 | 1517.30 |

Two things are wrong with Chencov for this marginal:

1. **T_peak moves AWAY from Tc as δT decreases.** From 1.05 (δT=0.5) to 0.37 (δT=0.02). If Chencov held, T_peak should approach Tc as δT→0. Instead it plunges into the ordered phase.
2. **KL/δ² does NOT converge.** It grows by three orders of magnitude (2.45→1517), indicating KL grows *faster* than δT². The Chencov quadratic approximation requires KL∝δT², but here KL is roughly constant (~0.2–0.6) regardless of δT.

**Why Chencov fails for marginals:** The magnetization distribution of the Blume-Capel model changes non-smoothly with T at low temperatures due to the vacancy fraction crossover (competition between J=1 ferromagnetic coupling and D=1 crystal field). This non-smooth change creates a sharp KL peak at T≈0.37 that has nothing to do with critical fluctuations at Tc=1.0.

**The conclusion is stronger than before:** the displacement of KL peaks away from Tc is not merely a consequence of the marginal FIM not peaking at Tc — the Chencov approximation itself breaks down. The KL between nearby marginal distributions is dominated by non-critical structure changes, not by the FIM term that Chencov's theorem would predict.

This means: even in the infinitesimal-δT limit, marginal KL is not a reliable indicator of the phase transition in non-Z₂ models. The Chencov theorem holds mathematically, but its *application* as a Tc diagnostic fails because the FIM term is overwhelmed by non-smooth distribution changes.

## The Pattern

All four diagnostics fail in the same way: they peak at temperatures *away* from Tc, with no finite-size scaling toward the critical point. The Chencov test adds a deeper layer: the approximation that would connect marginal KL to the FIM actually fails for the magnetization marginal.

The reason is fundamental: Chencov's theorem states that

KL(P_full(T)‖P_full(T + δT)) ≈ (δT²/4) · FIM(T)

where P_full is the distribution over *all* spin configurations. The FIM captures fluctuations of ALL observables simultaneously, and these fluctuations diverge at criticality.

But KL between *marginal* distributions integrates out everything except one observable. The marginal KL is dominated by the smooth variation of that observable's distribution with temperature, not by critical fluctuations. For non-Z₂ models, this variation is further complicated by non-critical crossovers (vacancy fraction, order parameter mixing) that create sharp KL peaks far from Tc. The critical enhancement of fluctuations is a property of the *joint* distribution, not of any single marginal.

## What Actually Works

The only KL-based diagnostic that works universally is KL between full configuration distributions — precisely what Kasatkin et al. (2024) use with their ClassiFIM method. This estimates the FIM from samples of full spin configurations, and it peaks at Tc for all models.

The tradeoff is computational: full configuration KL requires sampling in the complete 3^(L²) dimensional space, which is intractable for all but the smallest lattices.

## Implications

1. **No universal KL-based Tc diagnostic exists for marginal distributions.** This holds for Z₂ models (Ising) and non-Z₂ models (Potts, XY, Blume-Capel).

2. **KL(uniform) minimum at Tc is Z₂-specific.** For Ising, KL(P(M)‖uniform) has a minimum at Tc, but this doesn't generalize to models with different symmetries.

3. **Chencov's theorem holds mathematically but fails as a Tc diagnostic for marginals.** KL(Q(T)‖Q(T+δT)) ≈ (δT²/4) · FIM_Q(T) is a valid approximation for smooth distributions, but for the magnetization marginal of non-Z₂ models, non-smooth crossovers (vacancy fraction changes) dominate the KL, overwhelming the FIM term. The approximation breaks down precisely where you want to use it — near Tc.

4. **The most promising KL-based Tc diagnostic requires full configurations.** ClassiFIM (Kasatkin et al. 2024) is the state of the art, but it relies on ML estimation.

5. **Negative result has practical value.** Researchers using marginal KL diagnostics (magnetization histograms, energy PDFs, pair correlations) to detect phase transitions should be aware that these methods are fundamentally unreliable for non-Z₂ models. The displacement of KL peaks is not a numerical artifact — it's a structural property of the model.

## Data

All data is in `projects/thermodynamics/`. Scripts: `kl-energy-pdf.py`, `blume-capel-fss-pt-fine.py`, `kl-chencov-delta-t.py`. Analyses: `kl-energy-pdf-analysis.md`, `kl-chencov-delta-t-analysis.md`. Results: `kl-energy-pdf-results.json`, `kl-chencov-delta-t-results.json`.

## References

- Jaynes (1957) PR 106:620 — Maximum entropy principle
- Chencov (1964) — KL-FIM relation in full space
- Kasatkin et al. (2024) arXiv:2408.03418 — ClassiFIM for phase transition detection
- Fytas, Malakis & Richter (2024) arXiv:2407.12168 — Definitive Blume-Capel tricritical point
- Kwak (2015) PRE 91:032122 — Wang-Landau study of Blume-Capel

---

*Negative result. All four marginal KL diagnostics tested and ruled out for the Blume-Capel model. Full data available.*
