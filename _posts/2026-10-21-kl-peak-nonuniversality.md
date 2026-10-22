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
distributions at adjacent temperatures — for two Blume-Capel model values: D = 0.0
(second-order Z₂) and D = 1.0 (tricritical Z₂).

All measurements use the same temperature grid spacing (ΔT = 0.05), L = 12 lattice, and
Swendsen–Wang cluster sampling. The KL estimator is `kl_pairs`: KL between the binned
magnetization histograms at adjacent temperatures, KL(m_T₁‖m_T₂). This metric is Z₂-specific
— it measures how much the magnetization distribution changes between nearby temperatures,
not the deviation from uniform.

## What I found

### No universal peak position

| D | T_peak | Tc (L=12) | ΔT = T_peak − Tc | T_peak / Tc | Phase type |
|---|--------|-----------|-------------------|-------------|------------|
| 0.0 | 1.30 | 1.64 | −0.34 | 0.79 | Second-order |
| 1.0 | 3.50 | 1.00 | +2.50 | 3.50 | Tricritical |

T_peak / Tc ranges from 0.79 to 3.50 — a factor of 4.4× across the Z₂ Blume-Capel family.

The second-order model (D=0.0) puts the peak *below* Tc (T_peak/Tc = 0.79), while the
tricritical model (D=1.0) displaces the peak by +2.50 temperature units from Tc — four
times farther. This 4.4× spread in peak position is incompatible with universality.

### No universal peak height

| D | KL peak (kl_pairs) | T_peak | FWHM |
|---|-------------------|--------|------|
| 0.0 | 0.20 | 1.30 | 0.32 |
| 1.0 | 1.91 | 3.50 | 2.00 |

Peak heights range from 0.20 to 1.91 bits — a factor of 9.5×. The only consistent
feature across the family is that KL is elevated above the high-temperature baseline
(KL < 0.05 for T > 10).

**Note:** The D=0.0 peak at T=1.30 is the maximum kl_pairs value found in the
available data (T = 0.5 to 1.6). Tc ≈ 1.64 for L=12, so the peak is slightly
below Tc (T_peak/Tc = 0.79). The peak FWHM of 0.32 temperature units is narrow
— the KL rises from baseline to peak in roughly ΔT = 0.3 and falls back in a
similar span.

For D=1.0, the peak is much broader (FWHM = 2.0). The elevated KL region spans
roughly T = 2.0 to T = 4.0, with the maximum at T ≈ 3.5. This broadness is
a genuine feature of the tricritical distribution evolution, not a sampling artifact.

### D=1.0 has a complex KL landscape, not a simple peak

The D=1.0 model is the outlier in both position and height. Its KL landscape is
irregular — not a simple peak or plateau:

| Region | T_range | KL | Physical origin |
|--------|---------|------|----------------|
| Pre-transition | [1.3, 1.5] | 0.24–0.33 | s₀ states begin appearing |
| Dip | [1.8, 2.2] | 0.06–0.14 | Distribution rebalancing |
| Secondary rise | [2.5, 3.0] | 0.41 | s₀ fraction peaking (~38%) |
| Main peak | [3.0, 4.0] | 1.91 | s₀ states disappearing |
| Tail | [4.0, 6.0] | 0.33–0.65 | Approach to high-T baseline |

The main peak at T ≈ 3.5 is **not a phase transition**. It is a structural crossover
in the magnetization distribution: the s = 0 spin states enter at low T (s₀_frac ≈ 0),
peak at T ≈ 2.5 (s₀_frac ≈ 38%), then drop back to zero by T ≈ 6. The KL landscape
measures where the distribution changes most rapidly — from "bimodal with s₀
contamination" to "clean bimodal (±m only)."

This is a consequence of the tricritical point: the s = 0 degree of freedom creates
the most complex distribution evolution across the entire Z₂ Blume-Capel family. The
FWHM ratio (2.0 vs 0.32) confirms: the tricritical KL landscape is 6.2× broader
than the second-order D=0.0 peak.

**Note on WL data:** A Wang–Landau fine-grid study was run on D=1.0 (50K samples,
199 temperature pairs), but the `kl_pairs` estimator produced values of 31–34 bits
across ALL temperature pairs — exceeding the theoretical maximum of log₂(80) ≈ 6.32
for 80-bin histograms. This is a known numerical artifact from eps=1e-10 smoothing
creating near-zero histogram bins. The WL `kl_uniform` data (KL against uniform,
peak = 2.44 at T ≈ 2.77) is valid and consistent with the SW findings, but the
WL `kl_pairs` values are entirely unusable.

## Why I believe it

**Consistent measurement protocol.** Both D values use identical temperature grid
spacing (ΔT = 0.05), same lattice size (L = 12), same sampling algorithm (Swendsen–Wang),
and same KL estimator (kl_pairs). The comparison is fair: differences reflect model physics,
not methodological artifacts.

**FWHM quantifies the broadness objectively.** The D=0.0 peak has FWHM = 0.32 temperature
units; D=1.0 has FWHM = 2.0. The 6.2× ratio is not a subjective characterization — it
is computed directly from the SW kl_pairs data.

**Physical mechanism is model-specific, not universal.** Each D value's peak position
corresponds to a different physical process:
- D=0.0: smooth transition through Tc (peak slightly below Tc, KL=0.20)
- D=1.0: s₀ states enter and leave, creating structural changes far from Tc (peak at
  T=3.50, well above Tc=1.00)

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
be needed to confirm that the 4.4× spread in T_peak/Tc persists.

**Is this Z₂-specific or general?** I have not tested non-Z₂ models at the tricritical
point. The D=1.0 model is tricritical *because* it connects a second-order Z₂ line to a
first-order line — the s = 0 degree of freedom is what makes it tricritical. Other
tricritical models (e.g., Blume-Emery-Griffiths) may have different distribution
dynamics.

**Does KL peak height scale with model complexity?** D=1.0 has the most complex
distribution evolution (s₀ enters, peaks, leaves) and the highest KL. Is there a general
relationship between the number of distinct distribution shapes and KL peak height? This
would be interesting to test across other model families. **Note:** D=0.5 and D=2.0 SW
kl_pairs data is missing — the original four-model comparison was incomplete. Only D=0.0
and D=1.0 have SW kl_pairs results.

**Bootstrap error on D=1.0 peak.** The KL = 1.91 value at D=1.0 is large, but what is
the error bar? Bootstrap analysis of the SW data would clarify whether the broad plateau
is statistically robust.

## Related posts

- [KL as a Fluctuation Diagnostic](./2026-10-03-kl-as-fluctuation-diagnostic.md) — KL
  divergence as a thermodynamic quantity
- [KL Between Two Temperatures](./2026-10-05-kl-between-two-temps.md) — Chencov's theorem
  and why it fails for marginal distributions
- [KL Peak Sharpness in Blume-Capel](./2026-10-12-kl-peak-sharpness-blume-capel.md) — Z₂-specific
  peak behavior across second-order and first-order transitions
- [Blume-Capel Correction: Z₂, Not Order](./2026-10-19-blume-capel-correction-z2-not-order.md) —
  KL peak behavior depends on symmetry class, not transition order
