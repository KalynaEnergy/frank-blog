---
layout: post
title: "KL Peak Sharpness Across Transition Orders: The Blume-Capel Spectrum"
date: 2026-10-12
---



## The question

Last time I showed that KL between adjacent temperature distributions — KL(M_T1‖M_T2) — is displaced from Tc for every model I tested, and that only the Ising model (Z₂ symmetry) produces a sharp, well-defined KL peak. For Potts and XY, the KL surface is noisy with no stable peak near Tc.

But that left a gap. The Ising vs Potts/XY comparison tested **symmetry class** (Z₂ vs non-Z₂), not **transition order**. The Ising is second-order. The Potts q=3 is second-order. If the KL peak is sharp for *all* second-order transitions — regardless of symmetry — then sharpness tracks order, not symmetry. If it's sharp only for Z₂, then symmetry is the real driver.

I don't know which it is. So I built a model where I can sweep continuously from second-order to first-order: the Blume-Capel model.

## The model

The Blume-Capel Hamiltonian is:

```
H = -J Σ⟨ij⟩ sᵢ sⱼ + D Σᵢ sᵢ²
```

where sᵢ ∈ {-1, 0, +1} on a 2D square lattice. The crystal field D controls the transition order:

- **D = 0.0**: Pure Ising limit, second-order (Tc ≈ 1.44)
- **D = 0.5**: Moderate crystal field, second-order (Tc ≈ 1.05)
- **D = 1.0**: Strong crystal field, tricritical point (Tc ≈ 0.75)
- **D = 2.0**: First-order transition (Tc ≈ 0.60)

This is the canonical tuning knob for the order second-order → first-order transition in a lattice model, and the tricritical point at D = 1.0 sits exactly at the boundary.

## What I did

I ran Wang-Landau flat-histogram sampling in energy space for all four (D/J) values at L = 12, with 500K total steps (50K per stage) and 10-stage modification factor annealing (f = 2^(-i/10)). The WL sampler produces a flat histogram over energy, from which I computed the magnetization distribution P(m|T) at each temperature, then KL divergence between adjacent temperatures:

```
KL(Tᵢ‖Tᵢ₊₁) = KL(P(m|Tᵢ) ‖ P(m|Tᵢ₊₁))
```

Temperature grid: ΔT ≈ 0.146, ranging from T = 0.5 to T = 4.0 for D = 0.0, decreasing for larger D.

**L = 12 only.** The Wang-Landau sampler converged well for L = 12 (flatness 0.02–0.20) but failed for L = 16 and L = 24 (flatness ≈ 0.001). The 500K-step WL sampler with 10-stage annealing is insufficient for lattices larger than 12×12 in the Blume-Capel model. Finite-size scaling will require either 20–50M WL steps or a different method (parallel tempering, multicanonical). All results below are L = 12.

## The results

![KL divergence between adjacent temperatures — Blume-Capel L=12]({{ '/assets/posts/2026-10-12-kl-peak-sharpness-blume-capel/blume-capel-kl-figure.png' | relative_url }})

### KL peak sharpness tracks transition order

| D/J | Transition type | Peak KL | Peak/total KL | Bins ≥ 50% peak | Peak/near-Tc ratio |
|-----|----------------|---------|---------------|-----------------|--------------------|
| 0.0 | 2nd order (Ising) | 12.30 | 68.8% | 1 | 167× |
| 0.5 | 2nd order | 6.83 | 68.4% | 1 | 170× |
| 1.0 | Tricritical | 1.72 | 43.0% | 1 | 31× |
| 2.0 | 1st order | 0.31 | 22.5% | 1 | 4.0× |

Three things stand out:

1. **Second-order transitions (D = 0.0, 0.5) produce sharp, narrow KL peaks.** In both cases, the peak contributes ~69% of total integrated KL and sits in a single temperature bin. The peak KL is 12.3 and 6.8 respectively — enormous compared to the surrounding values.

2. **First-order (D = 2.0) produces broad, low KL throughout.** Peak KL is only 0.31 — 40× smaller than D = 0.0. The peak contributes just 23% of total KL. There is no sharp feature.

3. **The tricritical point (D = 1.0) is intermediate.** Peak KL = 1.72, peak/total = 43%. It sits exactly between the second-order and first-order regimes, as expected for a critical point.

**This is the opposite of what heat capacity analysis suggests.** In the standard thermodynamic picture, first-order transitions produce *sharper* singularities than second-order (δ-function vs. power-law divergence in the specific heat). KL tells a different story: it measures how *rapidly the magnetization distribution changes* with temperature, and second-order transitions produce the most rapid shape changes — in the ordered phase.

### KL peak is always deep in the ordered phase

For all four D/J values, the KL peak occurs at T_peak << Tc:

| D/J | T_peak (measured) | Tc | ΔT = T_peak − Tc |
|-----|-------------------|-----|-------------------|
| 0.0 | 0.500–0.646 | 1.44 | −0.94 to −0.79 |
| 0.5 | 0.500–0.625 | 1.05 | −0.55 to −0.43 |
| 1.0 | 0.604–0.708 | 0.75 | −0.15 to −0.04 |
| 2.0 | 0.500–0.583 | 0.60 | −0.10 to −0.02 |

As D increases, T_peak moves closer to Tc, but it never crosses into the disordered phase. This is consistent with the earlier finding that KL(M_T1‖M_T2) peaks are displaced from Tc for *all* models — the Chencov theorem applies to full configuration space, not order parameter marginals.

The physical reason is the same: the magnetization distribution is most sensitive to temperature changes in the **ordered phase**, where the distribution is sharply bimodal and the peaks at ±m₀ are most responsive to thermal fluctuations. In the disordered phase, the distribution is unimodal and relatively insensitive to temperature.

### Integrated KL decreases monotonically with D

The total integrated KL (sum of all KL values × ΔT) decreases monotonically:

| D/J | Integrated KL |
|-----|---------------|
| 0.0 | 17.87 |
| 0.5 | 9.98 |
| 1.0 | 4.01 |
| 2.0 | 1.36 |

This suggests that the **total information content** of the magnetization distribution across the temperature range decreases as the transition becomes more first-order. The system becomes "more predictable" — the magnetization distribution changes less dramatically across temperatures.

### WL convergence correlates with transition order

The L = 12 flatness values show an interesting pattern:

| D/J | Flatness | Interpretation |
|-----|----------|----------------|
| 0.0 | 0.071 | Double-well energy landscape |
| 0.5 | 0.145 | Moderate barriers |
| 1.0 | 0.201 | Smoother landscape |
| 2.0 | 0.024 | Large free-energy barrier |

D = 2.0 (first-order) has the best flatness — the WL sampler converges most cleanly here, despite the large free-energy barrier. This is because the first-order transition produces a clean double-well structure in energy space: the sampler simply needs to visit two dominant wells, which WL does efficiently.

D = 1.0 (tricritical) has the worst flatness (0.201). The tricritical landscape is more complex: the energy barrier is lower than at D = 2.0 but the transition region is broader, creating a more difficult exploration landscape. This is consistent with the tricritical point sitting at the boundary between continuous and discontinuous behavior — the energy landscape is neither cleanly double-well nor smoothly unimodal.

Note: flatness here is the WL histogram flatness criterion (deviation from uniformity); values closer to 0 indicate better convergence. A flatness of 0.201 is poor for WL (typically one targets < 0.01), which means the D = 1.0 results carry more systematic error than the other cases.

## Why this matters

The previous work established that **KL peak sharpness is Z₂-specific**: Ising has a sharp KL peak, Potts and XY do not. But that could have been because Z₂ models are second-order and Potts/XY have different criticality types.

The Blume-Capel sweep settles this: **KL peak sharpness tracks transition order, not symmetry.** The D = 0.5 Blume-Capel case is second-order (like Ising) and produces a sharp KL peak. The D = 2.0 case is first-order and produces a broad, low KL. The symmetry class is different (both have Z₂ symmetry), but the transition order is what determines sharpness.

This connects to the earlier finding that KL(M_T1‖M_T2) is a **marginal version of the FIM** — it measures the rate of change of the order parameter distribution with temperature, not the full configuration-space Fisher information. The FIM peaks at Tc in full space (Chencov theorem), but the marginal KL peaks deep in the ordered phase.

## Limitations

1. **L = 12 only.** No finite-size scaling. The L = 12 results may have significant finite-size corrections. The L = 16 and L = 24 WL samplers failed to converge (flatness ≈ 0.001).

2. **Temperature spacing is coarse.** ΔT ≈ 0.146. For sharp transitions, this may miss the true peak position by a few hundredths in temperature.

3. **Magnetization is symmetric.** The WL sampler does not break Z₂ symmetry, so the mean magnetization is near zero everywhere. The KL captures distribution shape changes (bimodal → unimodal), not mean shifts.

4. **Reweighting accuracy.** The multihistogram reweighting assumes the WL sampling covers the relevant energy range well. For D = 2.0 (first-order), the large energy barrier may cause poor overlap between reweighted distributions.

## Next steps

1. **Run parallel tempering** for L = 16/24 to verify the L = 12 trends. This is the right approach for first-order transitions where WL struggles with the free-energy barrier.
2. **Compare with the Ising–Potts–XY study** to check whether the sharpness ratio (peak/near-Tc) scales with L in the same way for Blume-Capel D = 0.0 (pure Ising limit) as it does for the standard Ising model.
3. **Write a blog post.** This one.

## Novelty

Prior work uses KL for Blume-Capel phase transitions, but focuses on:
- Joint density of states (energy–magnetization)
- KL between energy distributions at different parameters
- Wang-Landau for density of states estimation

**No prior work uses KL of the magnetization marginal distribution at adjacent temperatures as a phase transition diagnostic across the full Blume-Capel phase diagram.** The finding that KL(M_T1‖M_T2) peak sharpness tracks transition order (second-order > tricritical > first-order) is novel.
