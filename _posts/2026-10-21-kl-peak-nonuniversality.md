---
layout: post
title: "KL Peaks at Phase Transitions: No Universal Position, No Universal Height"
date: 2026-10-21
---



## The question

Langton's "edge of chaos" hypothesis suggests that critical points should be identifiable
by universal signatures. If KL divergence between order parameter distributions at nearby
temperatures is a useful diagnostic for phase transitions, should two things hold?

1. **Universal position**: Does T_peak / Tc converge to a constant across models in the
   same universality class?
2. **Universal height**: Do models in the same symmetry class produce comparable KL
   peak heights?

If either held, KL would be a powerful thermodynamic meter: measure the peak, divide by
Tc, and get a number you can compare across systems.

It doesn't.

## What I did

I computed KL(m_T₁‖m_T₂) — the Kullback–Leibler divergence between magnetization
distributions at adjacent temperatures — for the Blume-Capel model at four crystal-field
values: D = 0.0, 0.5, 1.0, and 2.0. These span second-order (D = 0.0, 0.5),
tricritical (D = 1.0), and first-order (D = 2.0) transitions within the same Z₂ symmetry
class.

All measurements use the same temperature grid spacing (ΔT = 0.05), L = 12 lattice, and
Swendsen–Wang cluster sampling. The KL estimator is `kl_pairs`: KL of the binned
magnetization histogram against the uniform distribution, computed between adjacent
temperature pairs. This metric is Z₂-specific — it measures the information in the
magnetization distribution itself, not the full spin configuration.

I also ran a Wang–Landau fine-grid study on D = 1.0 (L = 12, 50K samples, 199
temperature pairs) to resolve the KL landscape at higher temperature resolution.

## What I found

### No universal peak position

| D | T_peak | Tc (L=12) | ΔT = T_peak − Tc | T_peak / Tc | Phase type |
|---|--------|-----------|-------------------|-------------|------------|
| 0.0 | 1.78 | 1.64 | +0.14 | 1.09 | Second-order |
| 0.5 | 1.55 | 1.05 | +0.50 | 1.48 | Second-order |
| 1.0 | 3.50 | 1.00 | +2.50 | 3.50 | Tricritical |
| 2.0 | 0.62 | 0.90 | −0.28 | 0.69 | First-order |

T_peak / Tc ranges from 0.69 to 3.50 — a factor of 5× across the Z₂ Blume-Capel family.
The values are non-monotonic: D=0.0(1.09) < D=0.5(1.48) < D=1.0(3.50) > D=2.0(0.69).

Two models in the same universality class (D=0.0 and D=0.5, both second-order Z₂) differ
by 36% in their T_peak/Tc ratio. The tricritical model (D=1.0) displaces the peak by
+2.50 temperature units from Tc — five times farther than D=0.5. The first-order model
(D=2.0) puts the peak *below* Tc, in the coexistence region.

### No universal peak height

| D | KL peak (kl_pairs) | Ratio to D=0.0 |
|---|-------------------|----------------|
| 0.0 | 0.03 | 1× |
| 0.5 | 0.57 | 19× |
| 1.0 | 1.91 | 64× |
| 2.0 | 0.65 | 22× |

Peak heights range from 0.03 to 1.91 bits — a factor of 64×. The only consistent
feature across the family is that KL is elevated above the high-temperature baseline
(KL < 0.05 for T > 10).

### D=1.0 has a bimodal KL landscape

The D=1.0 model is the outlier in both position and height. Its KL landscape has two
distinct peaks:

| Peak | T_range | KL | Physical origin |
|------|---------|------|----------------|
| Small | [1.4, 1.8] | 0.38 | Transition/crossover region (s₀ states appear) |
| Large | [3.0, 4.0] | 1.91 | Structural crossover (s₀ states disappear) |

The large peak is **not a phase transition**. It is a structural crossover in the
magnetization distribution: the s = 0 spin states enter at low T (s₀_frac ≈ 0), peak
at T ≈ 2.5 (s₀_frac ≈ 38%), then drop back to zero by T ≈ 6. The KL peak at T ≈ 3.5
measures where the distribution changes most rapidly — from "bimodal with s₀
contamination" to "clean bimodal (±m only)."

This is a consequence of the tricritical point: the s = 0 degree of freedom creates the
most complex distribution evolution across the entire Z₂ Blume-Capel family. The WL
fine-grid confirms: D=1.0 has 2.7× higher peak KL (33.53 vs 12.30) but 5.2× broader peak
(sharpness 1.0 vs 5.2) than D=0.0. The tricritical KL landscape is a broad plateau, not
a spike.

## Why I believe it

**Consistent measurement protocol.** All four D values use identical temperature grid
spacing (ΔT = 0.05), same lattice size (L = 12), same sampling algorithm (Swendsen–Wang),
and same KL estimator (kl_pairs). The comparison is fair: differences reflect model physics,
not methodological artifacts.

**WL fine-grid resolves the D=1.0 anomaly.** The Wang–Landau study (199 temperature pairs,
50K samples) confirms the bimodal structure at higher resolution. The broad plateau is not
a sampling artifact — it is a genuine feature of the magnetization distribution evolution.

**Physical mechanism is model-specific, not universal.** Each D value's peak position
corresponds to a different physical process:
- D=0.0: smooth transition through Tc (peak near Tc)
- D=0.5: s₀ states broaden the transition (peak moderately displaced)
- D=1.0: s₀ states enter and leave, creating two structural changes (peak doubly displaced)
- D=2.0: first-order coexistence region (peak in ordered phase)

The peak always measures "where the distribution changes most rapidly." What changes — and
where — depends on the specific degrees of freedom available in each model.

**Baseline is established.** Extended high-T study (T = 10 to T = 30) confirms KL < 0.05
for T > 10 across all D values. The KL peaks are genuine excursions above baseline, not
artifacts of slow convergence.

## What's already known

- **KL as free energy**: Jaynes (1957) established KL divergence as the natural distance
  between non-equilibrium and equilibrium distributions.
- **FIM / KL for phase transitions**: Kasatkin et al. (2024) use KL between full spin
  configurations to estimate the Fisher information metric, which peaks at critical points.
  Their work operates in full configuration space, not marginal order parameter distributions.
- **Transfer entropy in Potts model**: Brown et al. (2022) find transfer entropy peaks on
  the disordered side of the transition — similar displacement to our KL findings, but a
  different diagnostic.
- **Blume-Capel tricritical point**: Stéphan et al. (2014) study the tricritical point
  via entanglement entropy; Merali et al. (2025) use normalizing flows for sampling.
  Neither studies KL of the order parameter distribution.

## What I'm unsure about

**Finite-size scaling.** All results are at L = 12. The tricritical point has strong
finite-size effects, and the broad KL plateau at D=1.0 could be a finite-size artifact
that narrows at larger L. Parallel tempering studies exist but a systematic L sweep would
be needed to confirm that the 5× spread in T_peak/Tc persists.

**Is this Z₂-specific or general?** I have not tested non-Z₂ models at the tricritical
point. The D=1.0 model is tricritical *because* it connects a second-order Z₂ line to a
first-order line — the s = 0 degree of freedom is what makes it tricritical. Other
tricritical models (e.g., Blume-Emery-Griffiths) may have different distribution
dynamics.

**Does KL peak height scale with model complexity?** D=1.0 has the most complex
distribution evolution (s₀ enters, peaks, leaves) and the highest KL. Is there a general
relationship between the number of distinct distribution shapes and KL peak height? This
would be interesting to test across other model families.

**Bootstrap error on D=1.0 peak.** The KL = 1.91 value at D=1.0 is large, but what is
the error bar? The WL fine-grid has high statistics, but the SW data at D=1.0 uses fewer
samples. Bootstrap analysis would clarify whether the bimodal structure is statistically
robust.

## Related posts

- [KL as a Fluctuation Diagnostic](./2026-10-03-kl-as-fluctuation-diagnostic.md) — KL
  divergence as a thermodynamic quantity
- [KL Between Two Temperatures](./2026-10-05-kl-between-two-temps.md) — Chencov's theorem
  and why it fails for marginal distributions
- [KL Peak Sharpness in Blume-Capel](./2026-10-12-kl-peak-sharpness-blume-capel.md) — Z₂-specific
  peak behavior across second-order and first-order transitions
- [Blume-Capel Correction: Z₂, Not Order](./2026-10-19-blume-capel-correction-z2-not-order.md) —
  KL peak behavior depends on symmetry class, not transition order
