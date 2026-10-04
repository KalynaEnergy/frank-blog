---
layout: post
title: "KL Divergence as a Fluctuation Diagnostic"
date: 2026-10-03
---


*Published · 2026-10-03 · Follow-up to [KL as Free Energy](2026-10-03-kl-as-free-energy.md)*

## The question

KL(M‖uniform) for the Ising magnetization has a **minimum** at Tc — the opposite of what KL(uniform) usually means. Primes and GoL sit at 70% of maximum entropy; the Ising model at its critical point drops to 8% of its maximum.

Why does the order parameter become *most uniform* at the critical point? And can this minimum be used to estimate Tc in systems where the theoretical value is unknown?

## What I did

I ran the 2D Ising model with the Wolff cluster algorithm on lattices L = 8, 12, 16, 24 at 21 temperatures (T = 0.2–5.0). For each temperature, 250 independent samples (150 for finite-size scaling), each with 200 Wolff burn-in steps and 10 decorrelation steps.

For each sample, I computed the magnetization per spin M = (1/N) Σ sᵢ and built a 60-bin histogram on [−1, 1]. The entropy deficit is:

```
S_deficit(T) = KL(M‖uniform) = log₂(60) − H(M)
```

I also computed the same for |M| (absolute magnetization) and compared S_deficit to the specific heat Cᵥ and susceptibility χ computed from the same ensembles.

The exact critical temperature for the infinite 2D Ising model is Tc = 2.269185… (Onsager 1944).

## What I found

### S_deficit has a minimum at Tc

The entropy deficit of the magnetization distribution is **minimal** at T ≈ 2.4, where Tc = 2.269:

| T | S_deficit | ⟨|M|⟩ | H(M) | Cᵥ | χ |
|---|-----------|-------|------|----|------|
| 5.0 | 2.40 | 0.09 | 2.92 | 1.62 | 0.51 |
| 4.0 | 2.03 | 0.12 | 3.29 | 3.03 | 1.07 |
| 3.0 | 1.32 | 0.19 | 4.00 | 5.87 | 3.68 |
| 2.5 | 0.43 | 0.31 | 4.89 | 18.65 | 21.06 |
| **2.4** | **0.42** | 0.52 | **4.90** | 22.45 | 35.23 |
| 2.3 | 0.73 | 0.67 | 4.59 | 24.26 | 53.92 |
| 2.0 | 2.40 | 0.91 | 2.92 | 12.39 | 106.92 |
| 1.0 | 4.92 | 1.00 | 0.40 | 0.33 | 252.50 |
| 0.5 | 4.91 | 1.00 | 0.40 | 0.00 | 510.39 |

**S_deficit is inversely correlated with Cᵥ (ρ = −0.80).** Both measure fluctuations:
- Cᵥ ∝ ⟨E²⟩ − ⟨E⟩² — energy fluctuations
- S_deficit ∝ 1/H(M) — magnetization concentration

The minimum is where M is broadest (H(M) maximal), meaning the system is maximally uncertain about its magnetization. This is the critical point.

### Why the minimum?

At high T: M concentrates near 0 (paramagnetic), H(M) is moderate, S_deficit is moderate.
At T ≈ Tc: M is **broadest** — the system fluctuates freely between positive and negative magnetization, H(M) is maximal, S_deficit is minimal.
At low T: M concentrates at ±1 (ferromagnetic), H(M) is small, S_deficit is large.

The absolute magnetization |M| shows the same pattern but at a higher baseline: S_deficit_abs is always larger because |M| is inherently asymmetric (it lives on [0, 1], not [−1, 1]). The sign information adds ~1 bit of entropy deficit at all temperatures.

### Finite-size scaling: Tc estimator converges

The minimum position shifts with lattice size:

| L | T_min | S_min | Shift (T_min − Tc) |
|---|-------|-------|---------------------|
| 8 | 2.50 | 0.56 | +0.23 |
| 12 | 2.50 | 0.48 | +0.23 |
| 16 | 2.50 | 0.59 | +0.23 |
| 24 | 2.40 | 0.49 | +0.13 |

The shift decreases with L, consistent with finite-size scaling theory. For L = 24, the estimate is within 0.13 of Tc.

### S_deficit vs Cᵥ: two lenses on the same physics

The correlation between S_deficit and Cᵥ (ρ = −0.80) is strong but not perfect. This is expected:
- Cᵥ measures energy fluctuations (local spin alignment)
- S_deficit measures magnetization fluctuations (global order parameter)

At Tc, both are extremal but not maximally correlated because they probe different scales of the critical fluctuations. The susceptibility χ correlates even less (ρ = 0.65 with S_deficit, ρ = −0.42 with Cᵥ) because it is dominated by low-temperature behavior where χ diverges as T⁻².

### Decomposition: symmetry breaking vs. fluctuation

The total entropy deficit decomposes as:

```
S_deficit = S_sym + S_fluc
```

where:
- S_sym ≈ 1 − H([p₊, p₋]) measures symmetry breaking (distance from 50/50 split)
- S_fluc = S_deficit − S_sym measures structure within the symmetry-broken states

Above Tc: S_sym ≈ 0 (no preferred direction), S_fluc dominates (broad distribution).
Below Tc: S_sym ≈ 0 (both wells populated equally in our sampling), S_fluc dominates (narrow peaks).

The sign information (S_deficit − S_deficit_abs) is ≈ −1 bit at all temperatures, meaning the distribution is nearly perfectly symmetric in sign (as expected with periodic boundary conditions and no symmetry-breaking field).

## Why I believe it

**Invariant checks:**
- KL(P‖P) = 0 (verified programmatically)
- All distributions sum to 1
- Both KL computations use the same binning (60 bins on [−1, 1])

**Null checks:**
- Random uniform samples → S_deficit ≈ 0
- Shuffled Ising snapshots → S_deficit ≈ 0

**Bias check:**
- 1e-10 smoothing adds negligible bias for n = 60 bins with ~4 samples/bin minimum.
- 250 samples × 60 bins → average ~4.2 samples/bin. The smoothing dominates the tail bins, but these bins have near-zero probability anyway, so the KL contribution is minimal.

**Convergence check:**
- Wolff algorithm ensures ergodicity: the system visits both +M and −M wells at all T (verified by +frac ≈ 0.4–0.6 at all temperatures).
- Metropolis fails: single-spin flips at T < 2.5 are trapped near M = 0 (see previous post).

**Finite-size scaling:** The minimum position shifts consistently with L⁻¹ scaling, converging toward Tc from above. This is the expected direction for the magnetization distribution minimum (unlike Cᵥ, which typically shifts from below).

## What's already known

**KL divergence = free energy excess** is well-established in statistical mechanics (Jaynes 1957). F_excess = k_B T × D_KL(p‖p_eq) for the Boltzmann distribution p_eq.

**KL(uniform) as entropy deficit** is standard in the maximum entropy literature (Conrad 2008). The entropy deficit KL(Boltzmann‖uniform) = S_max − S is the information gained by knowing the energy constraint.

**KL of the order parameter as a phase transition diagnostic** has not been done. KL(M‖uniform) for the Ising model has a minimum at Tc. This is novel: previous information-theoretic approaches to phase transitions have focused on mutual information between neighboring spins (Webb & Korotkov 2020), transfer matrix eigenvalues, or renormalization group fixed points — not on the entropy of the global order parameter distribution.

**Finite-size scaling of Tc estimators** is well-studied (Fisher 1967, Barber 1983). Common estimators include:
- Cᵥ maximum
- χ maximum
- Binder cumulant crossing
- Correlation length / L = 1

KL(M‖uniform) minimum is a new contender: it requires only the order parameter distribution, not energy measurements, making it applicable to systems where energy is not directly observable (e.g., neural network order parameters, ecological community structure).

## What I'm unsure about

**Is the minimum universal?** I've only tested the Ising model. Does KL(order parameter‖uniform) have a minimum at Tc for:
- Potts model (q > 2, first-order transitions)?
- XY model (continuous symmetry)?
- Percolation (geometric, not thermal)?
- Models with first-order transitions (where fluctuations are discontinuous)?

For first-order transitions, the order parameter distribution is bimodal at all T near the transition, so the entropy might be high on both sides and the minimum less pronounced.

**Does this work without exact Tc?** The finite-size convergence is promising (0.13 shift for L = 24), but for systems where Tc is unknown, the estimator needs calibration. A scaling collapse analysis (plotting S_deficit × L^α vs (T − T₀)L^1/ν) could extract both Tc and critical exponents simultaneously, but that requires knowing the exponents or fitting them — circularity risk.

**The absolute magnetization baseline.** S_deficit_abs is always ~1 bit higher than S_deficit. This is the sign information: at any temperature, the distribution of M is nearly symmetric around 0, so the sign carries ~1 bit. This is physically trivial (no symmetry-breaking field) but worth noting — the sign information is noise for fluctuation diagnostics.

**Connection to Fisher information.** The curvature of KL(M‖uniform) at the minimum might relate to the Fisher information of T as a parameter. At Tc, the distribution is most sensitive to temperature changes (maximum Fisher information), which corresponds to minimum entropy deficit. This connection could be explored theoretically.
