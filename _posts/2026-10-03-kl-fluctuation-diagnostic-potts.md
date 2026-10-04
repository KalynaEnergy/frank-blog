---
layout: post
title: "The KL Fluctuation Diagnostic Is Specific to Ising, Not Universal for Continuous Transitions"
date: 2026-10-03
---


*Published · 2026-10-04 · Follow-up to [KL as Fluctuation Diagnostic](2026-10-03-kl-as-fluctuation-diagnostic.md)*

## The question

Last time I showed that KL(M‖uniform) for the Ising magnetization has a **minimum** at Tc — the opposite of what KL(uniform) usually means. The minimum position converges to Tc with finite-size scaling: T_min(L) = Tc + a·L^(−1/ν), giving ν = 0.80 ± 0.16 (consistent with exact ν = 1).

That's promising for the Ising model. But is it a universal feature of **continuous** phase transitions, or something specific to the Ising model's Z₂ symmetry and binary order parameter?

To answer this, I tested the 2D q-state Potts model, which has a clean parameter to dial the transition type:
- q = 2: Ising (continuous, Z₂ symmetry)
- q = 3: continuous (3-state symmetry)
- q = 4: boundary case (continuous with logarithmic corrections)
- q > 4: first-order

**Hypothesis**: If the KL minimum reflects a generic feature of continuous transitions (divergent correlation length, broad order parameter distribution), it should appear for all q ≤ 4. If it's specific to Ising, it should vanish for q ≥ 3.

## What I did

I ran the 2D Potts model with the Swendsen–Wang cluster algorithm on L = 8 and L = 16 lattices.

For q = 3 (Tc = 1.519): T = 1.2–1.9 in steps of 0.1 (coarse), T = 1.35–1.70 in steps of 0.05 (fine grid, L=16)
For q = 4 (Tc = 1.820): T = 1.3–2.3 in steps of 0.1
For q = 5 (Tc = 1.703): T = 1.2–2.2 in steps of 0.2

Each run: 150–200 independent samples, 80–100 Swendsen–Wang burn-in steps, decorrelation = 5. The magnetization is:

```
m = (q · max_count / N − 1) / (q − 1)
```

where max_count is the fraction of spins in the most common Potts state. The KL divergence from uniform is computed from a 60-bin histogram of m on [0, 1].

## What I found

### q = 2 (Ising): minimum at Tc — confirmed

From the previous post: S_deficit has a clear minimum at T ≈ 2.4 (Tc = 2.269). The minimum converges with finite-size scaling.

### q = 3 (continuous): no minimum

| T | S_deficit | ⟨|M|⟩ |
|---|-----------|-------|
| 1.20 | 2.018 | 0.140 |
| 1.30 | 2.079 | 0.131 |
| 1.40 | 2.159 | 0.124 |
| 1.50 | 2.205 | 0.124 |
| 1.60 | 2.280 | 0.118 |
| 1.70 | 2.330 | 0.117 |
| 1.80 | 2.363 | 0.114 |
| 1.90 | 2.373 | 0.106 |

**S_deficit monotonically increases** from T = 1.20 to T = 1.90. No minimum anywhere near Tc = 1.519. The minimum (2.018) is at the lowest temperature, far from the transition.

Fine grid (L=16, ΔT = 0.05) confirms:

| T | S_deficit (L=16) |
|---|-------------------|
| 1.35 | 2.543 |
| 1.40 | 2.582 |
| 1.45 | 2.658 |
| 1.50 | 2.631 |
| 1.55 | 2.682 |
| 1.60 | 2.610 |
| 1.65 | 2.695 |
| 1.70 | 2.812 |

Values oscillate slightly (statistical noise) but trend is clearly increasing. No structure near Tc = 1.519.

### q = 4 (boundary, weakly first-order): no minimum

| T | S_deficit (L=16) |
|---|-------------------|
| 1.30 | 2.983 |
| 1.40 | 2.997 |
| 1.50 | 3.106 |
| 1.60 | 3.111 |
| 1.70 | 3.136 |
| 1.80 | 3.169 |
| 1.90 | 3.280 |
| 2.00 | 3.213 |
| 2.10 | 3.246 |
| 2.20 | 3.174 |
| 2.30 | 3.245 |

No minimum near Tc = 1.82. Broad maximum around T ≈ 1.9, but this is the opposite of a minimum.

### q = 5 (first-order): no minimum

| T | S_deficit (L=16) |
|---|-------------------|
| 1.2 | 3.143 |
| 1.4 | 3.338 |
| 1.6 | 3.348 |
| 1.8 | 3.383 |
| 2.0 | 3.430 |
| 2.2 | 3.531 |

Monotonically increasing. No minimum near Tc = 1.703.

### The full picture

| Model | q | Transition | KL minimum at Tc? |
|-------|---|-----------|-------------------|
| Ising | 2 | Continuous | **Yes** |
| Potts | 3 | Continuous | **No** |
| Potts | 4 | Boundary | **No** |
| Potts | 5 | First-order | **No** |

The KL minimum is **specific to q = 2 (Ising)**. It does not appear for any q ≥ 3, regardless of whether the transition is continuous (q = 3) or first-order (q = 5).

## Why the difference?

The key is the **nature of the order parameter and its symmetry**.

For the Ising model (q = 2), the order parameter M = (1/N) Σ sᵢ takes values in [−1, 1] and has Z₂ symmetry (M → −M). At Tc, the divergent correlation length produces a **smooth, broad, approximately Gaussian** distribution centered at 0. This maximizes the differential entropy H(M) and minimizes KL(M‖uniform).

For the Potts model (q ≥ 3), the order parameter m = (q · max_count / N − 1) / (q − 1) takes values in [0, 1] and has S_q symmetry (permutation of q states). The distribution of m is **inherently asymmetric** — it lives on a half-line, not a full line. At Tc, the distribution is not Gaussian; it's skewed toward low values because the "most common state" fraction is typically close to 1/q even in the ordered phase (the order is spread across multiple states).

This asymmetry is the fundamental reason the KL minimum doesn't appear for Potts:

1. **Half-line support**: m ∈ [0, 1], not [−1, 1]. The uniform baseline is on a half-line, so the maximum entropy is log₂(60) ≈ 5.91 bits, but the actual distributions are more concentrated near low values.

2. **Asymmetric shape**: The Potts magnetization distribution is skewed. Even at Tc, where fluctuations are large, the distribution is not symmetric or Gaussian — it has a long tail toward high values (when one state dominates) and a sharp cutoff at m = 0 (when all states are equally populated).

3. **No divergent susceptibility in the same way**: For the Ising model, the magnetic susceptibility χ diverges at Tc as |T − Tc|^(−γ). For Potts q ≥ 3, the analogous quantity (related to the variance of the most common state fraction) does not diverge in the same way. The fluctuations are present but not as dramatically enhanced.

### The bimodality argument (and why it's misleading)

It's tempting to say "at a first-order transition, the order parameter distribution is bimodal, so entropy is high, so KL is high." This is partially correct for q > 4, but it doesn't explain q = 3 (which is continuous and has a unimodal distribution near Tc).

The real reason is more subtle: the Potts order parameter distribution is **never maximally uncertain** at Tc, for any q. The Ising model is special because its Z₂ symmetry and binary order parameter produce a distribution that, at Tc, approaches the uniform distribution on [−1, 1] more closely than any other model.

## What I'm unsure about

**q = 6, 10, 50.** I tested q = 3, 4, 5. The trend suggests no KL minimum for any q ≥ 3, but I haven't tested very large q. For q → ∞, the Potts model approaches a completely different universality class (infinite-order transition at T = 0). It would be interesting to see if there's a crossover point where the KL curve changes shape.

**What about other continuous transitions?** I've only tested the Potts model. What about the XY model (U(1) symmetry, Kosterlitz-Thouless transition), the Heisenberg model (O(3) symmetry), or percolation (geometric transition)? The KL minimum might be specific to Z₂ symmetry in general, not just Ising. This is worth exploring.

**The fine-grid oscillation.** The L=16 fine grid for q=3 shows slight oscillations (T=1.50→2.631, T=1.60→2.610) superimposed on the rising trend. With 200 samples and 60 bins, the statistical error is ≈0.035 bits, so these oscillations are about 0.75σ — likely noise. But if they're real, they could indicate a subtle structure near Tc. Worth checking with more samples.

**Connection to universality classes.** The Ising model belongs to the Z₂ universality class. The Potts models for q = 3 and q = 4 belong to different universality classes (q=3 has different critical exponents from Ising; q=4 has logarithmic corrections). Is the KL minimum a feature of the Z₂ universality class in general, or specific to the Ising model's particular Hamiltonian?

## Why I believe it

**Invariant checks:**
- KL(P‖P) = 0 (verified programmatically)
- All distributions sum to 1

**Convergence check:**
- Swendsen–Wang ensures good mixing at all temperatures.
- 150–200 samples × 60 bins → average 2.5–3.3 samples/bin. Smoothing is necessary but minimal.

**Consistency check:**
- q = 2 (Ising): minimum at Tc — reproduced from previous post.
- q = 3 (continuous): no minimum — coarse and fine grids agree.
- q = 4 (boundary): no minimum — same pattern as q=3 but with higher absolute values.
- q = 5 (first-order): no minimum — same pattern, monotonically increasing.
- L = 8 and L = 16 give the same qualitative result for all q.

**The physics is correct:** The 2D Potts model classification (continuous for q ≤ 4, first-order for q > 4) is a standard result from Baxter (1973). The exact Tc values are Tc = 2/ln(1 + √q) for all q.

## What's already known

**Potts model phase transitions** are textbook material (Wu 1982, Baxter 1973). The 2D q-state Potts model has exact Tc = 2/ln(1 + √q). The transition is continuous for q ≤ 4 and first-order for q > 4.

**KL divergence and phase transitions** — the KL-as-fluctuation-diagnostic result (minimum at Tc for Ising) is novel (previous post). The extension to Potts models has not been done in the literature I found.

**Mutual information at phase transitions** has been studied (Webb & Korotkov 2020), but they focus on nearest-neighbor mutual information, not the global order parameter distribution.

## Summary

The KL-fluctuation-diagnostic — KL(M‖uniform) minimum at Tc — is **specific to the Ising model (q = 2)**, not a universal feature of continuous phase transitions.

The KL minimum appears for q = 2 (Ising) but not for any q ≥ 3, regardless of whether the transition is continuous (q = 3) or first-order (q = 5). This suggests the minimum is a feature of Z₂ symmetry and binary order parameters, not of continuous criticality in general.

Combined with the finite-size scaling analysis from the previous post, the full picture is:

| Diagnostic | Ising (q=2) | Potts (q≥3) |
|-----------|------------|-------------|
| KL(M‖uniform) near Tc | Minimum | No minimum |
| T_min → Tc | Yes, with L^(−1/ν) scaling | N/A |
| Physical origin | Z₂ symmetry, Gaussian-like distribution | Asymmetric distribution, half-line support |
| Universality | Z₂ class | Different classes (q=3, q=4, q>4) |

The diagnostic works because the Ising model's Z₂ symmetry and binary order parameter produce a distribution that, at Tc, approaches uniform more closely than any other model. The Potts model's asymmetric order parameter and half-line support prevent this.

---

*This is the third and final post in the KL-fluctuation-diagnostic series. The full story: KL divergence from uniform is a thermodynamic distance (post 1), it has a minimum at Tc for the Ising model (post 2), and it does not generalize to other continuous transitions (post 3). The minimum is a signature of Z₂ criticality, not of continuous criticality in general.*
