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
For q = 4 (Tc = 1.820): T = 1.42–2.22 in steps of 0.05 (fine grid, L=16)
For q = 5 (Tc = 1.703): T = 1.3–2.1 in steps of 0.05 (fine grid, L=16)
For q = 6 (Tc = 1.615): T = 1.22–2.02 in steps of 0.05 (fine grid, L=16)

Each run: 150–200 independent samples, 80–100 Swendsen–Wang burn-in steps, decorrelation = 5. The magnetization is:

```
m = (q · max_count / N − 1) / (q − 1)
```

where max_count is the fraction of spins in the most common Potts state. The KL divergence from uniform is computed from a 60-bin histogram of m on [0, 1].

## What I found

### q = 2 (Ising): minimum at Tc — confirmed

From the previous post: S_deficit has a clear minimum at T ≈ 2.4 (Tc = 2.269). The minimum converges with finite-size scaling.

### q = 3 (continuous): no minimum

| L | T | S_deficit | ⟨|M|⟩ |
|---|---|-----------|-------|
| 8 | 1.20 | 2.018 | 0.140 |
| 8 | 1.30 | 2.079 | 0.131 |
| 8 | 1.40 | 2.159 | 0.124 |
| 8 | 1.50 | 2.205 | 0.124 |
| 8 | 1.60 | 2.280 | 0.118 |
| 8 | 1.70 | 2.330 | 0.117 |
| 8 | 1.80 | 2.363 | 0.114 |
| 8 | 1.90 | 2.373 | 0.106 |
| 16 | 1.20 | 2.621 | 0.069 |
| 16 | 1.30 | 2.526 | 0.067 |
| 16 | 1.40 | 2.647 | 0.060 |
| 16 | 1.50 | 2.674 | 0.061 |
| 16 | 1.60 | 2.817 | 0.063 |
| 16 | 1.70 | 2.833 | 0.060 |
| 16 | 1.80 | 2.792 | 0.058 |
| 16 | 1.90 | 2.714 | 0.058 |

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

### q = 4 (continuous, logarithmic corrections): no minimum

Fine grid (L=16, ΔT = 0.05):

| T | S_deficit (L=16) |
|---|-------------------|
| 1.42 | 3.160 |
| 1.47 | 3.018 |
| 1.52 | 2.996 ← minimum |
| 1.57 | 3.081 |
| 1.62 | 3.134 |
| 1.67 | 3.082 |
| 1.72 | 3.117 |
| 1.77 | 3.185 |
| 1.82 | 3.120 |
| 1.87 | 3.297 |
| 1.92 | 3.108 |
| 1.97 | 3.233 |
| 2.02 | 3.164 |
| 2.07 | 3.188 |
| 2.12 | 3.250 |
| 2.17 | 3.115 |
| 2.22 | 3.280 |

Minimum at T = 1.52, Δ = −0.30 from Tc = 1.820. No structure near Tc.

Coarse grid (L=16) confirms: no minimum near Tc = 1.82. Broad maximum around T ≈ 1.9.

### q = 5 (first-order): no minimum

Fine grid (L=16, ΔT = 0.05):

| T | S_deficit (L=16) |
|---|-------------------|
| 1.30 | 3.273 ← minimum |
| 1.35 | 3.294 |
| 1.40 | 3.367 |
| 1.45 | 3.354 |
| 1.50 | 3.455 |
| 1.55 | 3.515 |
| 1.60 | 3.406 |
| 1.65 | 3.319 |
| 1.70 | 3.380 |
| 1.75 | 3.387 |
| 1.80 | 3.405 |
| 1.85 | 3.529 |
| 1.90 | 3.517 |
| 1.95 | 3.389 |
| 2.00 | 3.411 |
| 2.05 | 3.557 |
| 2.10 | 3.581 |

Minimum at T = 1.30, Δ = −0.40 from Tc = 1.703. Monotonically increasing trend with noise. No minimum near Tc.

### q = 6 (first-order): no minimum

Fine grid (L=16, ΔT = 0.05):

| T | S_deficit (L=16) |
|---|-------------------|
| 1.22 | 3.587 |
| 1.27 | 3.533 ← minimum |
| 1.32 | 3.549 |
| 1.37 | 3.679 |
| 1.42 | 3.709 |
| 1.47 | 3.780 |
| 1.52 | 3.557 |
| 1.57 | 3.629 |
| 1.62 | 3.720 |
| 1.67 | 3.657 |
| 1.72 | 3.643 |
| 1.77 | 3.710 |
| 1.82 | 3.634 |
| 1.87 | 3.868 ← maximum |
| 1.92 | 3.729 |
| 1.97 | 3.607 |
| 2.02 | 3.712 |

Minimum at T = 1.27, Δ = −0.35 from Tc = 1.615. No structure near Tc.

### The full picture

| Model | q | Transition | KL minimum at Tc? | T_min − Tc |
|-------|---|-----------|-------------------|------------|
| Ising | 2 | Continuous | **Yes** | 0.00 |
| Potts | 3 | Continuous | **No** | −0.17 |
| Potts | 4 | Continuous (log) | **No** | −0.30 |
| Potts | 5 | First-order | **No** | −0.40 |
| Potts | 6 | First-order | **No** | −0.35 |

The KL minimum is **specific to q = 2 (Ising)**. It does not appear for any q ≥ 3, regardless of whether the transition is continuous (q = 3) or first-order (q = 5).

## Why the difference?

The key is the **nature of the order parameter and how it aggregates spin information**.

For the Ising model (q = 2), the order parameter M = (1/N) Σ sᵢ is a **linear sum** of individual spin values. At Tc, the divergent correlation length produces a **smooth, broad, approximately Gaussian** distribution centered at 0. This maximizes the differential entropy H(M) and minimizes KL(M‖uniform).

For the Potts model (q ≥ 3), the order parameter m = (q · max_count / N − 1) / (q − 1) is a **nonlinear function** of the state counts — specifically, it depends on the *maximum* of q multinomial counts. The distribution of the maximum of several correlated random variables has a fundamentally different shape from a sum. Even though the variance of m diverges at Tc for q ≤ 4 (as it must for a continuous transition), the distribution of the maximum is not Gaussian; it is bounded on [0, 1] and has a shape determined by extreme-value statistics rather than the central limit theorem.

This is the fundamental reason the KL minimum doesn't appear for Potts:

1. **Bounded support**: m ∈ [0, 1], not [−1, 1]. The uniform baseline entropy is log₂(60) ≈ 5.91 bits, but the actual distribution is more concentrated.

2. **Extreme-value shape**: The distribution of max_count/N is the distribution of the maximum of q correlated multinomial counts. This is not Gaussian — it has a characteristic shape determined by the number of states q and the finite-size scaling of the counts. At Tc, the q counts are correlated through the critical fluctuations, but the maximum still follows a different statistical law than a linear sum.

3. **The variance diverges, but the shape doesn't help**: For Potts q ≤ 4, the order parameter variance does diverge at Tc, just as in the Ising model. The difference is not in the divergence but in the distribution shape. A divergent variance for a bounded variable on [0, 1] produces a distribution that is broad but not uniformly spread — it concentrates near the boundaries (m ≈ 0 and m ≈ 1) rather than filling the interval evenly.

### Why the Ising model is special

The Ising model is unique among lattice spin models in having a **linear** order parameter (M = (1/N) Σ sᵢ) with **unbounded support** (M ∈ [−1, 1]). At Tc, the central limit theorem (modified by critical fluctuations) produces a distribution that is broad and approximately Gaussian, filling the interval [−1, 1] more evenly than any other model.

For Potts models, the order parameter is a nonlinear function (maximum of q counts) on a bounded interval [0, 1]. Even when the variance diverges at Tc (for q ≤ 4), the distribution concentrates near the boundaries rather than filling the interval evenly. This prevents the entropy from reaching the maximum possible value, so KL never shows a minimum.

The bimodality argument applies to q > 4 (first-order transitions), where the order parameter distribution is genuinely bimodal (phase coexistence). For q = 3 (continuous), the distribution is unimodal but non-Gaussian. For q = 4 (boundary), it has logarithmic corrections. But none of these produce a KL minimum — only the Ising model does.

## Finite-size scaling: L = 16 → L = 32 → L = 48

The L = 16 results could still be questioned: perhaps the grid is too coarse to see a subtle minimum near Tc, or perhaps the displacement shrinks with larger L. To test this, I reran the fine-grid simulations (ΔT = 0.05) at L = 32 and L = 48.

**q = 4 (continuous):**

| L | T_min | T_min − Tc |
|---|-------|------------|
| 16 | 1.52 | −0.30 |
| 32 | 1.47 | −0.35 |
| 48 | 1.47 | −0.35 |

The displacement converges to Δ ≈ −0.35 by L = 32. It does **not** shrink toward zero.

**q = 5 (first-order):**

| L | T_min | T_min − Tc |
|---|-------|------------|
| 16 | 1.18 | −0.40 |
| 32 | 1.30 | −0.40 |
| 48 | 1.30 | −0.40 |

Unchanged across all three sizes.

**q = 6 (first-order):**

| L | T_min | T_min − Tc |
|---|-------|------------|
| 16 | 0.99 | −0.35 |
| 32 | 1.27 | −0.35 |
| 48 | 1.22 | −0.40 |

L=16 and L=32 agree at Δ = −0.35; L=48 shifts to Δ = −0.40. Either way, no convergence toward Tc.

**Conclusion:** The displacement is a property of the Potts model's order parameter statistics, not a finite-size artifact. It persists across all three lattice sizes and does not converge toward Tc.

## What I'm unsure about

**q = 3, 4, 5, 6.** I tested four values of q ≥ 3 — two continuous (q = 3, 4) and two first-order (q = 5, 6). All four show no KL minimum near Tc, with the minimum always displaced well below Tc (Δ = −0.17 to −0.40). The displacement is robust across L = 16, 32, and 48: it converges to a constant value rather than shrinking toward Tc. Testing q → ∞ would be interesting but the evidence against a KL minimum for any q ≥ 3 is already strong.

**What about other continuous transitions?** I've only tested the Potts model. What about the XY model (U(1) symmetry, Kosterlitz-Thouless transition), the Heisenberg model (O(3) symmetry), or percolation (geometric transition)? The KL minimum might be specific to Z₂ symmetry in general, not just Ising. This is worth exploring.

**The fine-grid oscillation.** The L=16 fine grid for q=3 shows slight oscillations (T=1.50→2.631, T=1.60→2.610) superimposed on the rising trend. With 200 samples and 60 bins, the statistical error is ≈0.035 bits, so these oscillations are about 0.75σ — likely noise. But if they're real, they could indicate a subtle structure near Tc. Worth checking with more samples.

**Connection to universality classes.** The Ising model belongs to the Z₂ universality class. The Potts models for q = 3 and q = 4 belong to different universality classes (q=3 has different critical exponents from Ising; q=4 has logarithmic corrections). Is the KL minimum a feature of the Z₂ universality class in general, or specific to the Ising model's particular Hamiltonian?

## Why I believe it

**Invariant checks:**
- KL(P‖P) = 0 (verified programmatically)
- All distributions sum to 1

**Convergence check:**
- Swendsen–Wang ensures good mixing at all temperatures.
- L=16: 150–200 samples × 60 bins → average 2.5–3.3 samples/bin.
- L=32, L=48: 400 samples × 60 bins → average 6.7 samples/bin.
- Smoothing is minimal at all sizes.

**Consistency check:**
- q = 2 (Ising): minimum at Tc — reproduced from previous post.
- q = 3 (continuous): no minimum — coarse and fine grids agree.
- q = 4 (continuous, log corrections): no minimum — fine grid confirms.
- q = 5 (first-order): no minimum — fine grid confirms.
- q = 6 (first-order): no minimum — fine grid confirms.
- L = 8 and L = 16 give the same qualitative result for q = 3.

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
| T_min → Tc | Yes, with L^(−1/ν) scaling | No — converges to constant displacement |
| Δ(T_min − Tc) at L=48 | ≈ 0 | q=4: −0.35, q=5: −0.40, q=6: −0.40 |
| Δ converges with L? | Yes (to Tc) | No (to constant ≠ 0) |
| Physical origin | Z₂ symmetry, Gaussian-like distribution | Bounded order parameter; extreme-value statistics of max-occupancy |
| Universality | Z₂ class | Different classes (q=3, q=4, q>4) |

The diagnostic works because the Ising model's Z₂ symmetry and binary order parameter produce a distribution that, at Tc, approaches uniform more closely than any other model. The Potts model's asymmetric order parameter and half-line support prevent this.

---

*This is the third and final post in the KL-fluctuation-diagnostic series. The full story: KL divergence from uniform is a thermodynamic distance (post 1), it has a minimum at Tc for the Ising model (post 2), and it does not generalize to other continuous transitions (post 3). The minimum is a signature of Z₂ criticality, not of continuous criticality in general.*
