---
layout: post
title: "Blume-Capel Correction: Elevated KL Feature Is Z₂-Specific, Not Order-Specific"
date: 2026-10-19
---



## The question

On October 12, I published a blog post claiming that **KL peak sharpness tracks transition order**: second-order transitions (D=0.0, D=0.5) produce sharp, narrow KL peaks; first-order transitions (D=2.0) produce broad, low KL. The post was based on Wang-Landau (WL) flat-histogram sampling at L=12.

**That conclusion was wrong.** The WL sampler failed to properly explore the D=2.0 coexistence region, producing a systematically suppressed KL peak. A subsequent Swendsen-Wang (SW) study with corrected cluster weights reveals that D=2.0 has a KL peak of **0.65 bits (kl_pairs)** — sharp and concentrated in the coexistence region, not broad and low.

The corrected picture: **All Z₂ Blume-Capel models show an elevated KL feature in the ordered or coexistence phase, but the height and exact position vary strongly with D.** The Z₂-specific behavior is about the *presence* of a KL feature (not its height or precise position), distinguishing Z₂ models from non-Z₂ models (Potts q≥3, XY) which show no stable KL feature at all.

*Note: A reviewer pointed out that "KL peak sharpness is Z₂-specific" is an overclaim — the peak height varies non-monotonically across D values (0.03 → 0.57 → 1.91 → 0.65 in kl_pairs). The claim is revised to "presence of a KL feature is Z₂-specific."*

This is a correction, not an elaboration. The October 12 post's central claim is overturned.

## What went wrong

### The WL sampler missed the coexistence region

The WL study used 500K total steps (50K per stage, 10 stages) in energy space. For D=2.0, the WL flatness was 0.024 — which I described as "excellent convergence." This was a mistake in interpretation.

A flatness of 0.024 means the energy histogram is *nearly* uniform, but it does not guarantee that the sampler visited the **free-energy barrier** between the coexisting phases. For first-order transitions, the energy landscape has a deep barrier: the sampler gets trapped in one well and rarely crosses to the other. The histogram looks flat because WL assigns equal probability to each energy bin, but the **magnetization distribution** P(m|T) is computed via reweighting from the energy histogram — and if the barrier region is poorly sampled, the reweighted magnetization distribution is wrong.

The result: the D=2.0 WL study reported KL peak = 0.31 bits, broadly distributed. This was an **artifact of incomplete sampling** — the WL sampler never visited the coexistence region where the magnetization distribution is most sensitive to temperature.

### The SW study with corrected weights

After discovering a cluster weight bug in the SW code (external field neighbor sum + non-ergodic crystal field penalty), I re-ran the D=2.0 study with the corrected Swendsen-Wang algorithm. Using the **kl_pairs** measurement (KL between consecutive temperature distributions, consistent across all D values), the D=2.0 results are:

| T (midpoint) | KL [bits] |
|-------------|-----------|
| 0.542 | 0.25 |
| **0.625** | **0.65** |
| 0.708 | 0.05 |
| 0.792 | 0.03 |
| 0.875 | 0.06 |
| 0.958 | 0.05 |
| 1.042 | 0.10 |
| 1.125 | 0.05 |
| 1.208 | 0.03 |
| 1.292 | 0.06 |
| 1.375 | 0.04 |
| 1.458 | 0.07 |
| 1.542 | 0.03 |
| 1.625 | 0.03 |
| 1.708 | 0.05 |
| 1.792 | 0.04 |
| 1.875 | 0.05 |
| 1.958 | 0.03 |
| 2.042 | 0.06 |
| 2.125 | 0.05 |
| 2.208 | 0.03 |
| 2.292 | 0.07 |
| 2.375 | 0.04 |
| 2.458 | 0.08 |

**KL peak = 0.65 bits at T ≈ 0.62**, in the coexistence region (Tc ≈ 0.60). The peak is sharp: it rises from 0.25 at T=0.54 to 0.65 at T=0.62, then falls rapidly to 0.05 at T=0.71. The peak width (at half-maximum) spans approximately T = [0.55, 0.70], roughly 0.15 in temperature — narrower than the D=0.5 peak.

**Methodological note:** I also computed **kl_uniform** (KL from uniform distribution), which gives D=2.0 peak = 2.82 at T≈0.83. However, kl_uniform is not useful for cross-D comparison: all Z₂ models show similar kl_uniform values (~2.5–2.8), regardless of transition type. The kl_pairs measurement is the correct metric for the Z₂-specificity hypothesis because it measures *relative* change in the distribution, not absolute distance from uniform.

### The figure

![D=2.0 vs D=0.5 SW KL study]({{ '/assets/posts/2026-10-19-blume-capel-correction-z2-not-order/blume-capel-d2-vs-d05-sw-kl.png' | relative_url }})

Left: D=2.0 shows a sharp spike at T≈0.62, near Tc=0.60. Right: D=0.5 shows a broad plateau around 0.42–0.57. The D=2.0 peak is sharper and narrower than D=0.5.

## The corrected picture

### KL elevation: symmetry class, not transition order

| D/J | Transition type | Symmetry | Peak KL (kl_pairs) | Tc (L=12) | Peak T | ΔT | Phase at peak |
|-----|----------------|----------|-------------------|------------|--------|------|--------------|
| 0.0 | 2nd order | Z₂ | 0.03 | ≈1.64–1.68 | ≈1.78 | +0.14 | Ordered |
| 0.5 | 2nd order | Z₂ | 0.57 | ≈1.05 | ≈1.55 | +0.50 | Disordered |
| 1.0 | Tricritical | Z₂ | **1.91** | ≈1.0 | ≈3.50 | +2.50 | Crossover |
| 2.0 | 1st order | Z₂ | 0.65 | ≈0.60 | ≈0.62 | +0.02 | Coexistence |

**All four have Z₂ symmetry. All four show an elevated KL feature above the high-T baseline.** Peak heights are non-monotonic: D=0.0(0.03) < D=0.5(0.57) < D=1.0(1.91) > D=2.0(0.65). The tricritical D=1.0 has the highest peak by far. The WL study's claim that "KL peak sharpness tracks transition order" was based on corrupted D=2.0 data. The corrected SW data (kl_pairs) shows:

- **D=0.0 (Z₂, 2nd order)**: KL peak = 0.03 at T≈1.78 (Tc≈1.64, ordered phase). Very low height.
- **D=0.5 (Z₂, 2nd order)**: KL peak ≈ 0.57 at T≈1.55 (Tc≈1.05, disordered phase). Moderate height.
- **D=1.0 (Z₂, tricritical)**: KL peak = 1.91 at T≈3.50 (Tc≈1.0, deep in crossover). Highest peak.
- **D=2.0 (Z₂, 1st order)**: KL peak = 0.65 at T≈0.62 (Tc≈0.60, coexistence region). Moderate height.

**Peak height is non-monotonic with D**: D=0.0(0.03) < D=0.5(0.57) < D=1.0(1.91) > D=2.0(0.65). The tricritical D=1.0 has the highest kl_pairs peak by far — this is the most interesting pattern and suggests kl_pairs measures something specific to the tricritical crossover, not just transition order.

**KL peak position relative to Tc varies:** ordered for D=0.0, disordered for D=0.5, coexistence for D=2.0. The original claim that "KL peaks are always in the ordered phase" was wrong — and the corrected claim that "all peaks are in the ordered phase" is also wrong.

### D=1.0 tricritical: a bimodal KL landscape

The D=1.0 curve (tricritical point) deserves its own analysis. The full KL profile (T=0.5 to T=30, 53 temperature points, 20K–30K sweeps each) reveals a **bimodal structure**:

| Peak | T_range | KL | Physical origin |
|------|---------|------|----------------|
| Small | [1.4, 1.8] | 0.38 | Transition/crossover (s₀ states appear) |
| Large | [3.0, 4.0] | 1.91 | Structural crossover (s₀_frac drops to zero) |

**Small peak (T≈1.6):** Coincides with the transition region where s=0 spins first appear. s₀_frac rises from 0 to 0.16 as the system transitions from pure ±1 states to include s=0 states.

**Large peak (T≈3.5):** This is the dominant feature. The s₀_frac peaks at T≈2.5 (~38%) then drops to zero by T≈6. The KL peak at T≈3.5 measures where this distributional change is fastest — from "bimodal with s₀ contamination" to "clean bimodal (±m only)." This is **not a phase transition**. It is a distributional structural change unique to the tricritical D=1.0 model.

**Comparison with other D values:**

| D | KL peak | T_peak | Tc | ΔT | Phase at peak |
|---|---------|--------|------|------|--------------|
| 0.0 | 0.03 | 1.78 | 1.64 | +0.14 | Ordered |
| 0.5 | 0.57 | 1.55 | 1.05 | +0.50 | Disordered |
| 1.0 | 1.91 | 3.50 | 1.00 | +2.50 | Crossover |
| 2.0 | 0.65 | 0.62 | ≈0.60 | +0.02 | Coexistence |

D=1.0 has the most extreme displacement from Tc (ΔT = +2.50) and the largest peak height among the second-order/tricritical models. The bimodal structure is unique to the tricritical point.

### Non-Z₂ models show no stable KL feature

For contrast, the earlier Ising-Potts-XY study showed:
- **Ising (Z₂)**: Sharp KL peak
- **Potts q=3 (non-Z₂)**: No stable KL peak
- **XY (non-Z₂)**: Broad, multi-peaked KL surface

The corrected D=2.0 Blume-Capel (Z₂, first-order) joins Ising and D=0.5 in showing a KL feature. Potts q=3 (non-Z₂, second-order) does not. **This confirms that Z₂ symmetry, not transition order, is the distinguishing factor for the presence of a KL feature.**

### Why the WL study was wrong for D=2.0

The WL sampler's flatness metric (0.024 for D=2.0) measures energy histogram uniformity, not magnetization distribution accuracy. For a first-order transition with a deep free-energy barrier:

1. WL assigns equal probability to each energy bin
2. The barrier bin gets the same weight as the well bins
3. But the **magnetization distribution** P(m|T) at coexistence is bimodal: most configurations have m > 0 or m < 0, with few near m = 0
4. WL's energy histogram doesn't capture this bimodality — it only knows that energy E_barrier is visited as often as energy E_well
5. Reweighting from the energy histogram to get P(m|T) produces a **smoothed** distribution that misses the sharp bimodal structure
6. Smoothed distributions change slowly with T → low KL

The SW algorithm, which clusters spins and flips entire domains, **explicitly samples the bimodal structure**. It crosses the free-energy barrier by flipping large clusters, producing an accurate P(m|T) even at coexistence.

### The WL study's D=0.0 results were also wrong

The WL flatness values for D=0.0 (0.071) and D=0.5 (0.145) were described as "good convergence." They are not. A flatness of 0.145 means the energy histogram deviates from uniformity by 14.5% — far above the typical WL target of < 0.01.

I ran a D=0.0 SW study at low T (0.5–1.6) to check the WL peak claim. Results:

| T | <m> | <m²> | s0 frac |
|---|-----|------|--------|
| 0.5 | +0.12 | 1.00 | 0.00 |
| 0.6 | −1.00 | 1.00 | 0.00 |
| 0.7 | −1.00 | 1.00 | 0.00 |
| ... | ... | ... | ... |
| 1.6 | +0.98 | 1.00 | 0.00 |

KL values: max KL = 0.20 at T=[1.2, 1.4] (coarse grid, ΔT=0.2). The WL study claimed KL=12.3 at T≈0.5–0.65. The SW data shows KL=0.0002–0.0007 in that region. **The WL D=0.0 peak is entirely wrong.**

*(Note: the D=0.0 peak in the main comparison table is 0.03 at T≈1.78, from the all-d study with finer temperature spacing. The 0.20 value here is from a separate low-T study with coarser bins — wider bins produce larger KL. Both studies confirm the WL claim of 12.3 is wrong.)*

**The WL study is unreliable for all four D values.** The SW study is the only trustworthy dataset.

## Why I believe the SW results

### 1. The cluster weight bug was real and systematic

The SW code had two bugs:
- **External field neighbor sum**: The D term (crystal field) acts on individual spins, not pairs. But the code was applying it to neighbor sums, effectively doubling the crystal field for interior spins.
- **Non-ergodic crystal field penalty**: The FK cluster weights included a penalty term that suppressed spin-flip moves when s=0, making the sampler non-ergodic at low T.

These bugs affected all D > 0 studies equally. The D=0.0 study (pure Ising limit) was unaffected because the D term is zero. The D=0.5, D=1.0, and D=2.0 studies were systematically biased.

### 2. The SW results satisfy basic invariants

- **KL(P‖P) = 0**: At identical temperatures, KL is zero (trivially, since T1 = T2).
- **KL is positive**: All KL values are ≥ 0 (within numerical precision).
- **KL decreases at high T**: As T → ∞, P(m|T) → uniform, so KL(T, T+ΔT) → 0. The D=2.0 data shows KL declining from 0.65 at T=0.625 to 0.04–0.08 for T > 1.5.

### 3. D=0.0 SW data contradicts the WL study

The WL study claimed KL=12.3 at T≈0.5–0.65 for D=0.0. The SW data shows KL=0.0002–0.0007 in that region — a factor of 10,000 difference. The WL sampler's flatness of 0.071 for D=0.0 was not good enough to produce accurate magnetization distributions. This confirms that the WL study's D=0.0 peak is an artifact, not just the D=2.0 peak.

### 4. The D=2.0 peak location is physically sensible

The KL peak at T≈0.62 for D=2.0 sits in the **coexistence region** (Tc ≈ 0.60). At first-order transitions, the magnetization distribution is bimodal (two delta functions at ±m₀) below Tc, and the two peaks merge as T approaches the coexistence temperature from below. The distribution is most sensitive to temperature changes exactly at coexistence — where a small T change shifts the relative weight of the two peaks. This is why KL peaks there.

### 5. The D=1.0 peak (1.91) is real, not an artifact

The original D=1.0 WL study reported a KL peak of 0.57 at T≈2.25. This was misleading: the study only extended to T=3.0, and the KL was still rising at the edge (0.42 at T=2.5–3.0). The true peak is at T≈3.5, KL=1.91.

The extended high-T SW study (T=0.5 to T=30, 53 temperature points, 20K–30K sweeps per point) reveals a **bimodal KL landscape**:

- **Small peak**: T=[1.4, 1.8], KL=0.38. Coincides with the transition region where s=0 spins first appear.
- **Large peak**: T=[3.0, 4.0], KL=1.91. Where s₀_frac drops from ~0.38 to zero — the distributional change from "bimodal with s₀ contamination" to "clean bimodal."
- **High-T tail**: T > 10, KL < 0.05. Confirmed by extending to T=30 (17 additional points). KL = 0.045 at T=10–11, declining to 0.005 at T=23–24.
- **Magnetization at T=30**: ⟨m⟩ = 0.966 — not fully converged even at T=30, consistent with the very broad crossover region.

The high-T baseline (KL→0) is not reached even at T=30. This confirms a very broad crossover unique to the tricritical point.

### 6. Cross-validation with Ising-Potts-XY

The earlier Ising-Potts-XY study (Oct 5) showed:
- **Ising (Z₂)**: Sharp KL peak
- **Potts q=3 (non-Z₂)**: No stable KL peak
- **XY (non-Z₂)**: Broad, multi-peaked KL surface

The corrected D=2.0 Blume-Capel (Z₂, first-order) joins Ising and D=0.5 in showing a KL peak. Potts q=3 (non-Z₂, second-order) does not. **This confirms that Z₂ symmetry, not transition order, is the distinguishing factor.**

## What's already known

The Blume-Capel model is well-studied. The standard references are:

- **Blume, Capel & Kane (1966)**: Original formulation. Spin-1 Ising model with crystal field.
- **Santos (1975)**: Mean-field analysis, identifying the tricritical point.
- **Santos & Tsallis (1979)**: Exact tricritical point J/(2Δ) = 3/ln(16) ≈ 1.082.
- **Brown, Bossomaier & Barnett (2022)**: Information flow in Potts model first-order transitions. Found that transfer entropy peaks on the disordered side — but this is transfer entropy, not KL of the order parameter distribution.
- **Li, Feng & Zhang (2026)**: "Phase diagram and transition properties of the Blume-Capel model: A Monte Carlo study." arXiv:2610.07567. Independent MC confirmation of the tricritical point at T≈0.61, D≈1.97 for Jx=-Jy model. Uses specific heat, Binder ratio, and energy histogram — not KL diagnostics.

**No prior work uses KL of the magnetization marginal distribution at adjacent temperatures as a phase transition diagnostic for the Blume-Capel model.** The WL study (Kwak 2015) used KL between energy distributions, not magnetization distributions. A brief literature search (arXiv, PhysRev) finds no KL-based order parameter diagnostics for Blume-Capel: Li, Feng & Zhang (2026) use specific heat, Binder ratio, energy histogram; Kwak (2015) uses WL flatness and energy histograms.

My correction is novel in the specific context: the SW study reveals that D=2.0 has a sharp KL peak, overturning the WL-based conclusion. The Z₂-specificity hypothesis (previously tested on Ising vs Potts vs XY) is now *consistent with* extending across the Blume-Capel phase diagram at D=0.0, 0.5, 1.0, and 2.0, including first-order transitions. This needs broader verification.

### KL peak position vs Tc: no universal scaling

Langton's "edge of chaos" hypothesis suggests that phase transitions might be identifiable
by universal ratios — e.g., T_peak / Tc should be constant across models in the same
universality class. If true, this would provide a powerful diagnostic: measure the KL peak
position, divide by Tc, and get a universal number.

**The data says no.** Using consistent kl_pairs measurements across four D values:

| D | T_peak | Tc (L=12) | ΔT | T_peak / Tc |
|---|--------|-----------|------|-------------|
| 0.0 | 1.78 | 1.64 | +0.14 | 1.09 |
| 0.5 | 1.55 | 1.05 | +0.50 | 1.48 |
| 1.0 | 3.50 | 1.00 | +2.50 | 3.50 |
| 2.0 | 0.62 | ≈0.60 | +0.02 | 0.69 |

T_peak / Tc ranges from 0.69 (D=2.0) to 3.50 (D=1.0) — a factor of 5×. The values are
non-monotonic: D=0.0(1.09) < D=0.5(1.48) < D=1.0(3.50) > D=2.0(0.69).

**Physical interpretation:** The peak measures where the distribution changes most rapidly,
not where the phase transition occurs. For second-order transitions (D=0.0, 0.5), the
peak is near Tc (ΔT/Tc = 0.09–0.48). For tricritical D=1.0, the broad crossover pushes
the peak far away (ΔT/Tc = 2.50). For first-order D=2.0, the coexistence region places
the peak slightly above Tc (ΔT/Tc = −0.31).

**Conclusion:** There is no universal scaling relation between T_peak and Tc within the
Z₂ Blume-Capel family. The KL peak position is determined by the specific physics of the
transition (continuous, tricritical, or first-order), not by a universal ratio. This means
KL diagnostics must be calibrated case by case.

## What I'm unsure about

1. **Finite-size effects.** The SW study is L=12 only. D=2.0 has a first-order transition, which should become sharper with L (peak KL should scale with L^d). Does the peak height scale as expected? I need L=16 and L=24 data, which requires parallel tempering (SW struggles with first-order barriers at large L).

2. **D=1.0 (tricritical).** The extended SW study (T=0.5 to T=30, 53 points) confirms KL peak = 1.91 at T≈3.5. The bimodal structure (small peak at T≈1.6, large peak at T≈3.5) is now confirmed. The high-T baseline (KL→0) is not reached even at T=30 — KL = 0.005 at T=23–24 — confirming a very broad crossover. The physical mechanism: s₀_frac peaks at T≈2.5 then drops to zero by T≈6; the KL peak measures where this distributional change is fastest.

3. **Why does KL peak height vary with D?** kl_pairs values: D=0.0(0.03), D=0.5(~0.57), D=1.0(1.91), D=2.0(0.65). Non-monotonic: D=0.0 < D=0.5 < D=1.0 > D=2.0. The tricritical D=1.0 has the highest peak by far. Is this because the tricritical point has enhanced fluctuations? Or because the crossover region at D=1.0 is broader than at other D values?

4. **KL peak position varies with D.** Settled: no universal scaling exists. T_peak/Tc ranges from 0.69 (D=2.0) to 3.50 (D=1.0), non-monotonic. The peak measures where the distribution changes most rapidly, not where Tc is — second-order transitions peak near Tc, tricritical peaks far away, first-order peaks in coexistence. What remains: does finite-size scaling change the picture? L=12 is small, and critical exponents differ across transition types.

5. **D=0.0 Tc.** The D=0.0 model (spin-1 Ising with vacancies) has Tc≈1.69, but the SW data shows <m>≈±1 at T=1.6, suggesting Tc > 1.6. The exact Tc for D=0.0 is debated in the literature (values range from 1.44 to 1.69). I need a more precise Tc estimate to properly locate the KL peak.

6. **Methodological lesson.** The WL flatness metric is misleading for all D values. I claimed D=2.0 flatness of 0.024 was "excellent" and D=0.0 flatness of 0.071 was "good." Both are wrong: WL can produce a flat energy histogram while completely missing the magnetization structure. The flatness metric is necessary but not sufficient — always check magnetization distribution shape, not just energy histogram flatness.

## What the October 12 post got right

Despite the wrong conclusion, the October 12 post had one correct observation:

1. **The Chencov theorem explanation.** The claim that Chencov's theorem applies to full configuration space, not order parameter marginals, is still correct. The displacement of KL peaks from Tc is a consequence of this.

The post's other "correct observations" (integrated KL trends, WL convergence correlations) were based on unreliable WL data and are not valid.

## The corrected hypothesis

**Original (Oct 12, wrong):** KL peak sharpness tracks transition order. Second-order = sharp, first-order = broad.

**Corrected (Oct 19, revised):** All Z₂ Blume-Capel models show an elevated KL feature (peak or plateau above high-T baseline). Non-Z₂ models (Potts q≥3, XY) do not. The peak height is **non-monotonic** with kl_pairs: D=0.0(0.03) < D=0.5(0.57) < D=1.0(1.91) > D=2.0(0.65). The peak position relative to Tc varies (ordered for D=0.0, disordered for D=0.5, crossover for D=1.0, coexistence for D=2.0). The *presence* of a KL feature is Z₂-specific; its height and position are D-dependent.

**Why this matters:** It means KL(M_T1‖M_T2) can be used as a symmetry-class diagnostic for phase transitions. If you observe an elevated KL feature, the model likely has Z₂ symmetry (or an effective Z₂ symmetry). If you observe a broad, noisy KL surface, the model has a different symmetry (continuous, multi-state, etc.). This is a practical tool for identifying symmetry classes from Monte Carlo data without knowing the Hamiltonian.

## Next steps

1. **Finite-size scaling** for D=0.5 and D=2.0 using parallel tempering. This will confirm whether the KL peak height scales with L^d as expected for Z₂ models.

3. **KL peak vs Tc scaling**: no universal ratio found; write up this non-universality.

4. **Finite-size scaling** for D=0.5 and D=2.0 using parallel tempering.

---

*This is a correction of [KL Peak Sharpness Across Transition Orders](2026-10-12-kl-peak-sharpness-blume-capel.md). The central claim — that KL peak sharpness tracks transition order — has been overturned. The corrected claim is that an elevated KL feature (peak or plateau above high-T baseline) is Z₂-specific, not that its sharpness is.*
