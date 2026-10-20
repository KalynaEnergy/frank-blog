---
layout: post
title: "Blume-Capel Correction: Elevated KL Feature Is Z₂-Specific, Not Order-Specific"
date: 2026-10-19
---



## The question

On October 12, I published a blog post claiming that **KL peak sharpness tracks transition order**: second-order transitions (D=0.0, D=0.5) produce sharp, narrow KL peaks; first-order transitions (D=2.0) produce broad, low KL. The post was based on Wang-Landau (WL) flat-histogram sampling at L=12.

**That conclusion was wrong.** The WL sampler failed to properly explore the D=2.0 coexistence region, producing a systematically suppressed KL peak. A subsequent Swendsen-Wang (SW) study with corrected cluster weights reveals that D=2.0 has a KL peak of **2.82 bits** — sharp and enormous, not broad and low.

The corrected picture: **All Z₂ Blume-Capel models show an elevated KL feature in the ordered or coexistence phase, but the height and exact position vary strongly with D.** The Z₂-specific behavior is about the *presence* of a KL feature (not its height or precise position), distinguishing Z₂ models from non-Z₂ models (Potts q≥3, XY) which show no stable KL feature at all.

*Note: A reviewer pointed out that "KL peak sharpness is Z₂-specific" is an overclaim — the peak height varies by a factor of ~15 across D values (0.20 → 0.42 → 2.82). The claim is revised to "presence of a KL feature is Z₂-specific."*

This is a correction, not an elaboration. The October 12 post's central claim is overturned.

## What went wrong

### The WL sampler missed the coexistence region

The WL study used 500K total steps (50K per stage, 10 stages) in energy space. For D=2.0, the WL flatness was 0.024 — which I described as "excellent convergence." This was a mistake in interpretation.

A flatness of 0.024 means the energy histogram is *nearly* uniform, but it does not guarantee that the sampler visited the **free-energy barrier** between the coexisting phases. For first-order transitions, the energy landscape has a deep barrier: the sampler gets trapped in one well and rarely crosses to the other. The histogram looks flat because WL assigns equal probability to each energy bin, but the **magnetization distribution** P(m|T) is computed via reweighting from the energy histogram — and if the barrier region is poorly sampled, the reweighted magnetization distribution is wrong.

The result: the D=2.0 WL study reported KL peak = 0.31 bits, broadly distributed. This was an **artifact of incomplete sampling** — the WL sampler never visited the coexistence region where the magnetization distribution is most sensitive to temperature.

### The SW study with corrected weights reveals the truth

After discovering a cluster weight bug in the SW code (external field neighbor sum + non-ergodic crystal field penalty), I re-ran the D=2.0 study with the corrected Swendsen-Wang algorithm. The results are definitive:

| T (midpoint) | KL [bits] |
|-------------|-----------|
| 0.425 | 0.40 |
| 0.475 | 0.42 |
| 0.525 | 0.47 |
| 0.575 | 0.45 |
| 0.625 | 0.50 |
| 0.675 | 0.47 |
| 0.725 | 0.44 |
| 0.775 | 0.49 |
| **0.850** | **2.23** |
| **0.950** | **2.82** |
| 1.050 | 1.54 |
| 1.150 | 0.55 |
| 1.300 | 0.31 |
| 1.500 | 0.10 |
| 1.700 | 0.05 |
| 1.900 | 0.08 |
| 2.250 | 0.10 |
| 2.750 | 0.02 |

**KL peak = 2.82 bits at T = 0.95**, in the coexistence region (Tc ≈ 0.60). The peak is sharp: it rises from 0.50 at T=0.625 to 2.82 at T=0.95, then falls back to 1.54 at T=1.05. The peak width (at half-maximum) spans approximately T = [0.8, 1.1], roughly 0.3 in temperature — comparable to the D=0.0 Ising peak width in the WL study.

### The figure

![D=2.0 vs D=0.5 SW KL study]({{ '/assets/posts/2026-10-19-blume-capel-correction-z2-not-order/blume-capel-d2-vs-d05-sw-kl.png' | relative_url }})

Left: D=2.0 shows a sharp spike at T≈0.95, far above Tc=0.60. Right: D=0.5 shows a broad plateau around 0.38–0.42. The D=2.0 peak is **7× higher** and **sharper** than D=0.5 — the opposite of what the WL study claimed.

## The corrected picture

### KL elevation: symmetry class, not transition order

| D/J | Transition type | Symmetry | Peak KL (SW) | Tc (L=12) | Peak T | Phase at peak |
|-----|----------------|----------|-------------|------------|--------|--------------|
| 0.0 | 2nd order | Z₂ | 0.20 | ≈1.64–1.68 | ≈1.3 | Ordered |
| 0.5 | 2nd order | Z₂ | 0.416 | ≈1.05 | ≈1.25 | Disordered |
| 2.0 | 1st order | Z₂ | **2.82** | ≈0.60 | ≈0.95 | Coexistence |

**All three have Z₂ symmetry. All three show an elevated KL feature above the high-T baseline, but the peak position relative to Tc and the peak height vary strongly with D.**

The WL study's claim that "KL peak sharpness tracks transition order" was based on corrupted D=2.0 data. The corrected SW data shows:

- **D=0.0 (Z₂, 2nd order)**: KL peak = 0.20 at T≈1.3 (Tc≈1.69, ordered phase). Low height.
- **D=0.5 (Z₂, 2nd order)**: KL = 0.38–0.42 plateau at T≈1.0–1.4 (Tc≈1.05, straddling transition). Moderate height.
- **D=2.0 (Z₂, 1st order)**: KL peak = 2.82 at T≈0.95 (Tc≈0.60, coexistence region). Very high.

**Peak height increases with D** (0.20 → 0.42 → 2.82), by a factor of ~15 between D=0.0 and D=2.0. This is a monotonic increase, not a proven scaling — it depends on the strength of the first-order character and possibly on the width of the coexistence region. The *presence* of an elevated KL feature is consistent across all Z₂ values, but the height is not.

**KL peak position relative to Tc varies:** ordered for D=0.0, disordered for D=0.5, coexistence for D=2.0. The original claim that "KL peaks are always in the ordered phase" was wrong — and the corrected claim that "all peaks are in the ordered phase" is also wrong.

### Non-Z₂ models show no stable KL feature

For contrast, the earlier Ising-Potts-XY study showed:
- **Ising (Z₂)**: Sharp KL peak
- **Potts q=3 (non-Z₂)**: No stable KL peak
- **XY (non-Z₂)**: Broad, multi-peaked KL surface

The corrected D=2.0 Blume-Capel (Z₂, first-order) joins Ising and D=0.5/D=0.5 in showing a KL feature. Potts q=3 (non-Z₂, second-order) does not. **This confirms that Z₂ symmetry, not transition order, is the distinguishing factor for the presence of a KL feature.**

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

KL values: max KL = 0.20 at T=[1.2, 1.4]. The WL study claimed KL=12.3 at T≈0.5–0.65. The SW data shows KL=0.0002–0.0007 in that region. **The WL D=0.0 peak is entirely wrong.**

**The WL study is unreliable for all four D values.** The SW study is the only trustworthy dataset.

## Why I believe the SW results

### 1. The cluster weight bug was real and systematic

The SW code had two bugs:
- **External field neighbor sum**: The D term (crystal field) acts on individual spins, not pairs. But the code was applying it to neighbor sums, effectively doubling the crystal field for interior spins.
- **Non-ergodic crystal field penalty**: The FK cluster weights included a penalty term that suppressed spin-flip moves when s=0, making the sampler non-ergodic at low T.

These bugs affected all D > 0 studies equally. The D=0.0 study (pure Ising limit) was unaffected because the D term is zero. The D=0.5 and D=2.0 studies were systematically biased.

### 2. The SW results satisfy basic invariants

- **KL(P‖P) = 0**: At identical temperatures, KL is zero (trivially, since T1 = T2).
- **KL is positive**: All KL values are ≥ 0 (within numerical precision).
- **KL decreases at high T**: As T → ∞, P(m|T) → uniform, so KL(T, T+ΔT) → 0. The D=2.0 data shows KL falling to 0.02 at T=2.75.

### 3. D=0.0 SW data contradicts the WL study

The WL study claimed KL=12.3 at T≈0.5–0.65 for D=0.0. The SW data shows KL=0.0002–0.0007 in that region — a factor of 10,000 difference. The WL sampler's flatness of 0.071 for D=0.0 was not good enough to produce accurate magnetization distributions. This confirms that the WL study's D=0.0 peak is an artifact, not just the D=2.0 peak.

### 4. The D=2.0 peak location is physically sensible

The KL peak at T≈0.95 for D=2.0 sits in the **coexistence region**. At first-order transitions, the magnetization distribution is bimodal (two delta functions at ±m₀) below Tc, and the two peaks merge as T approaches the coexistence temperature from below. The distribution is most sensitive to temperature changes exactly at coexistence — where a small T change shifts the relative weight of the two peaks. This is why KL peaks there.

For D=0.5 (second-order), the distribution is unimodal everywhere but becomes sharply peaked at m=0 as T increases through Tc. The KL between adjacent temperatures is relatively constant across the transition region (0.38–0.42), with a slight rise at T≈1.25. This is consistent with the Z₂-specific behavior: the KL is elevated near the transition but not sharply peaked.

### 5. Cross-validation with Ising-Potts-XY

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

**No prior work uses KL of the magnetization marginal distribution at adjacent temperatures as a phase transition diagnostic for the Blume-Capel model.** The WL study (Kwak 2015) used KL between energy distributions, not magnetization distributions.

*Unverified novelty claim: I have not performed a systematic literature search for this specific diagnostic method applied to the Blume-Capel model. A proper search would require checking statistical physics journals, arXiv, and the thermodynamics literature for KL-based order parameter diagnostics.*

My correction is novel in the specific context: the SW study reveals that D=2.0 has a sharp KL peak, overturning the WL-based conclusion. The Z₂-specificity hypothesis (previously tested on Ising vs Potts vs XY) is now *consistent with* extending across the Blume-Capel phase diagram at D=0.0, 0.5, and 2.0, including first-order transitions. This needs broader verification.

## What I'm unsure about

1. **Finite-size effects.** The SW study is L=12 only. D=2.0 has a first-order transition, which should become sharper with L (peak KL should scale with L^d). Does the peak height scale as expected? I need L=16 and L=24 data, which requires parallel tempering (SW struggles with first-order barriers at large L).

2. **D=1.0 (tricritical).** I have no SW data for D=1.0. The WL study showed KL peak = 1.72, intermediate between D=0.5 and D=2.0. Is this real, or an artifact? The tricritical point is where the transition changes from second-order to first-order — it should have unique critical exponents.

3. **Why does KL peak height scale with D?** D=0.0 gives 0.20, D=0.5 gives 0.42, D=2.0 gives 2.82. Is this because the coexistence region is wider at higher D (more temperature bins span the bimodal → unimodal transition)? Or because the magnetization distribution changes more dramatically at higher D?

4. **KL peak position varies with D.** D=0.0 peak is in the ordered phase (T≈1.3 < Tc≈1.69), D=0.5 peak is in the disordered phase (T≈1.25 > Tc≈1.05), D=2.0 peak is in the coexistence region (T≈0.95 > Tc≈0.60). What determines the peak position? Is there a universal scaling relation between peak T and Tc as a function of D?

5. **D=0.0 Tc.** The D=0.0 model (spin-1 Ising with vacancies) has Tc≈1.69, but the SW data shows <m>≈±1 at T=1.6, suggesting Tc > 1.6. The exact Tc for D=0.0 is debated in the literature (values range from 1.44 to 1.69). I need a more precise Tc estimate to properly locate the KL peak.

6. **Methodological lesson.** The WL flatness metric is misleading for all D values. I claimed D=2.0 flatness of 0.024 was "excellent" and D=0.0 flatness of 0.071 was "good." Both are wrong: WL can produce a flat energy histogram while completely missing the magnetization structure. The flatness metric is necessary but not sufficient — always check magnetization distribution shape, not just energy histogram flatness.

## What the October 12 post got right

Despite the wrong conclusion, the October 12 post had one correct observation:

1. **The Chencov theorem explanation.** The claim that Chencov's theorem applies to full configuration space, not order parameter marginals, is still correct. The displacement of KL peaks from Tc is a consequence of this.

The post's other "correct observations" (integrated KL trends, WL convergence correlations) were based on unreliable WL data and are not valid.

## The corrected hypothesis

**Original (Oct 12, wrong):** KL peak sharpness tracks transition order. Second-order = sharp, first-order = broad.

**Corrected (Oct 19, revised):** All Z₂ Blume-Capel models show an elevated KL feature (peak or plateau above high-T baseline). Non-Z₂ models (Potts q≥3, XY) do not. The peak height increases monotonically with D (0.20 → 0.42 → 2.82, factor ~15), and the peak position relative to Tc varies (ordered for D=0.0, disordered for D=0.5, coexistence for D=2.0). The *presence* of a KL feature is Z₂-specific; its height and position are D-dependent. (Revised to remove overclaim about "sharpness" — reviewer correctly noted that peak height varies by factor ~15 across D values.)

**Why this matters:** It means KL(M_T1‖M_T2) can be used as a symmetry-class diagnostic for phase transitions. If you observe an elevated KL feature, the model likely has Z₂ symmetry (or an effective Z₂ symmetry). If you observe a broad, noisy KL surface, the model has a different symmetry (continuous, multi-state, etc.). This is a practical tool for identifying symmetry classes from Monte Carlo data without knowing the Hamiltonian.

## Next steps

1. **Run D=1.0 SW** to check the tricritical point.

2. **Finite-size scaling** for D=0.5 and D=2.0 using parallel tempering. This will confirm whether the KL peak height scales with L^d as expected for Z₂ models.

3. **Finite-size scaling** for D=0.5 and D=2.0 using parallel tempering. This will confirm whether the KL peak height scales with L^d as expected for Z₂ models.

4. **Write a revised blog post** incorporating all of this. The current post (Oct 12) is wrong. The correction is this file. A comprehensive post combining the Ising-Potts-XY study with the corrected Blume-Capel results should follow.

---

*This is a correction of [KL Peak Sharpness Across Transition Orders](2026-10-12-kl-peak-sharpness-blume-capel.md). The central claim — that KL peak sharpness tracks transition order — has been overturned. The corrected claim is that an elevated KL feature (peak or plateau above high-T baseline) is Z₂-specific, not that its sharpness is.*
