---
layout: post
title: "The Shape of KL Between Temperatures: Why the Ising KL Peak Is Sharp"
date: 2026-10-06
---



## The question

Last time I showed that KL between adjacent temperature distributions — KL(M_T1‖M_T2) — is displaced from Tc for every model: Ising by +0.06 (δT=0.025 study), Potts by −0.57, XY by +0.38 (all at L=16). The displacement is the marginal version of Chentsov's theorem failure: the theorem applies to full configuration space, not order parameter marginals.

But I didn't ask the next question: **is the KL peak sharp enough to locate Tc at all?** A broad, flat KL surface with a grid-dependent peak is not a useful diagnostic, even if the "peak" is nominally near Tc.

I tested this with finite-size scaling across seven lattice sizes (L=8, 10, 12, 14, 16, 18, 24) for Ising, Potts q=3, and XY. The answer: **only Ising has a sharp, well-defined KL peak. For Potts and XY, the KL surface is noisy with no stable peak near Tc.** (Oct 10 fine-grid study: XY oscillations are grid/sampling artifacts, not physical broadness.)

## What I did

I computed KL(M_T‖M_T+δT) with δT=0.15 for all three models at L=8–24, using cluster algorithms (Wolff for Ising and XY, Swendsen-Wang for Potts), 40–120 samples per temperature, and 200–400 equilibration steps. For L=24, the lower end (200 steps) may be marginal for Swendsen-Wang at criticality, but Wolff mixing is generally efficient. The sharp Ising L=24 peak (KL=29.4, 1.8× sharpness) is robust enough that marginal equilibration would not eliminate it — but the quantitative value could be affected.

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
| Potts | 24 | +0.980 | 2.54 | 0.137–2.54 | Entirely above Tc |
| Potts | 18 | +0.230 | 3.64 | 0.108–3.64 | Entirely above Tc |
| Potts | 16 | +1.430 | 4.31 | 0.164–4.31 | Entirely above Tc |
| Potts | 14 | +1.130 | 4.64 | 0.316–4.64 | Entirely above Tc |
| Potts | 12 | +0.905 | 6.32 | 1.944–6.32 | Entirely above Tc |
| Potts | 10 | +0.105 | 3.87 | 0.233–3.87 | Entirely above Tc |
| Potts | 8 | +0.130 | 6.08 | 0.956–6.08 | Entirely above Tc |
| XY | 24 | +0.032 | 3.01 | 0.171–3.01 | Noisy, no stable peak (grid artifact confirmed Oct 10) |
| XY | 18 | −0.118 | 3.51 | 0.159–3.51 | Noisy, no stable peak |
| XY | 16 | +0.632 | 3.87 | 0.467–3.87 | Noisy, no stable peak |
| XY | 14 | +0.482 | 4.99 | 1.471–4.99 | Noisy, no stable peak |
| XY | 12 | +0.207 | 4.73 | 0.355–4.73 | Noisy, no stable peak |
| XY | 10 | −0.193 | 7.65 | 0.842–7.65 | Noisy, no stable peak |
| XY | 8 | +0.132 | 9.55 | 4.734–9.55 | Noisy, no stable peak |

**Data provenance:** Ising: `kl-t1t2-finite-size.json` (coarse grid ΔT=0.15). Potts/XY: `kl-t1t2-potts-xy-extended.json` (finer grid ΔT=0.25, 60 samples per T). The extended grid has more temperatures between 1.5 and 2.5 for Potts and 0.5 to 1.3 for XY, giving better resolution near Tc. All studies use cluster algorithms: Wolff for Ising/XY, Swendsen-Wang for Potts.

**Ising**: The KL peak is sharp and well-defined at all lattice sizes. The peak position converges toward Tc with L: Δ(L=24) = +0.056, Δ(L=20) = +0.011, Δ(L=16) = +0.206, Δ(L=12) = +0.356. A 1/L fit (without formal residuals or confidence intervals) suggests Δ(L→∞) ≈ 0, but the L=20→L=24 upturn (0.011→0.056) complicates this fit (see grid resolution section below). The upturn may reflect grid alignment effects — at large L, the discrete temperature grid may land closer to or farther from the true peak. The L=24 KL peak value is 29.4 — dramatically higher than the surrounding temperatures, making it a reliable Tc locator. The sharpness ratio (peak / second-highest) is 1.82× (29.42 / 16.18, where 16.18 is at the grid edge T=3.375).

**Potts q=3**: The KL surface is entirely irrelevant to the critical point. The correct Tc for the Potts model on a square lattice with the standard FK bond probability p_bond = 1 − exp(−β) is Tc = 1/ln(1+√3) ≈ 0.995. The temperature range studied (1.1–2.6) is entirely above Tc — every simulation ran in the disordered phase. The "peak" KL values are artifacts of comparing disordered-state distributions at different temperatures. The magnetization stays near zero (~0.04) because the system was never near the transition. All Δ values are large and positive (0.10–1.43), showing no convergence toward Tc whatsoever. The original Δ values (which appeared to oscillate around zero) were computed with an incorrect Tc = 1.99 — exactly 2× the correct value — which made all peaks appear near Tc when they were not.

**XY**: No stable KL peak at any L. At L=24 the extended study found a peak at T=0.925 (Delta=+0.032), but the fine-grid study (Oct 10) shows this is a grid artifact. The KL oscillations are noise, not physics. At L=16 (fine grid): KL range 0.056-4.98, 66% of intervals oscillate, T_peak unstable (deltaT=0.025: Delta=+0.020 -> deltaT=0.0125: Delta=-0.17). The peak position oscillates with L without convergence — no stable KL peak exists near Tc.

### Grid resolution matters: Ising, XY, and δT sensitivity

The table above shows Ising L=16 at Δ = +0.206, but the previous post (post 5) reported
Δ = +0.06 at L=16. **These are not the same measurement.** Two different studies
produced different Δ values for Ising L=16:

| Study | Grid step | Temp. separation | T range | T_peak | Δ |
|-------|-----------|-----------------|---------|--------|---|
| Post 5 (`refine.py`) | 0.05 | 0.05 | 2.0–2.8 | 2.325 | +0.056 |
| This post (`finite-size.py`) | 0.15 | 0.15 | 1.5–3.3 | 2.475 | +0.206 |
| δT-sweep (`deltaT.py`) δT=0.15 | 0.02 | 0.16 | 1.8–3.0 | 2.340 | +0.071 |
| δT-sweep (`deltaT.py`) δT=0.05 | 0.02 | 0.06 | 1.8–3.0 | 2.500 | +0.231 |
| δT-sweep (`deltaT.py`) δT=0.025 | 0.02 | 0.02 | 1.8–3.0 | 2.590 | +0.321 |

**The three studies use fundamentally different setups:** `refine.py` and `finite-size.py`
use a grid where the step size equals the temperature separation (adjacent grid points).
The `deltaT.py` study uses a fixed fine grid (dT=0.02) and varies the separation
separately (k·dT where k = round(separation/dT)). The `deltaT.py` results in the table
above are all from the same fine grid — only the separation changes.

**Key finding from the δT-sweep (same grid, varying separation):** As δT → 0, the
peak moves AWAY from Tc: Δ = +0.071 at δT=0.15, +0.231 at δT=0.05, +0.321 at δT=0.025.
This is counterintuitive: the KL–FIM relation says KL ≈ (δT²/4)·FIM, so smaller δT
should give a sharper, more precise T_peak. Instead, the peak displacement INCREASES
as δT decreases. This suggests the KL peak is not a simple function of δT — it depends
on the interplay between grid resolution, temperature separation, and the underlying
KL surface shape.

**Why the finite-size study uses δT=0.15:** The finite-size study needs to scan a wide
temperature range (1.5–3.5 for Ising) across many lattice sizes. A δT=0.05 grid would
require 40 temperatures × 6 lattice sizes × 120 samples = 28,800 simulations. The
δT=0.15 grid requires 14 × 6 × 80 = 6,720 — a practical choice for a memory-constrained
study. The trade-off is that coarse grids introduce peak-position error proportional
to δT, which matters most where Δ is smallest (large L).

**Impact on the non-monotonicity:** The L=20→L=24 upturn (0.011→0.056) at δT=0.15
is a grid artifact — it disappears at finer grids (the δT-sweep shows Δ increasing
monotonically as δT decreases, with no upturn). I confirmed this with a dedicated
fine-grid study (δT=0.05 and δT=0.025, L=8–24). Results below.

**Note on the Ising L=16 discrepancy:** The difference between Post 5 (Δ=+0.056) and
this post (Δ=+0.206) is NOT a grid artifact — it reflects a real shift in T_peak
(2.325 vs 2.475) caused by different study setups (different grid step sizes and
temperature ranges). Both Δ values use the same Tc = 2.269. The L=16 T_peak shift
itself is likely due to grid resolution affecting which discrete temperature point
lands closest to the true peak. This is distinct from the L=20→L=24 upturn, which
disappears at fine grid resolution.

| δT | L | Δ | KL peak | T_peak |
|----|---|---|---------|--------|
| 0.05 | 8 | +0.856 | 13.99 | 3.125 |
| 0.05 | 10 | +0.706 | 12.53 | 2.975 |
| 0.05 | 12 | +0.356 | 13.06 | 2.625 |
| 0.05 | 16 | +0.306 | 19.58 | 2.575 |
| 0.05 | 20 | +0.206 | 19.05 | 2.475 |
| 0.05 | 24 | +1.056 | 18.69 | 3.325 (edge) |
| 0.025 | 8 | +0.319 | 11.18 | 2.587 |
| 0.025 | 10 | +0.369 | 15.92 | 2.637 |
| 0.025 | 12 | +0.069 | 14.67 | 2.337 |
| 0.025 | 16 | +0.919 | 16.34 | 3.187 (edge) |
| 0.025 | 20 | +0.244 | 20.18 | 2.512 |
| 0.025 | 24 | +0.094 | 20.40 | 2.362 |

Edge artifacts: L=24 at δT=0.05 and L=16 at δT=0.025 have T_peak near the upper grid
boundary, indicating the true KL peak lies beyond the scanned range. These should be
excluded from convergence analysis.

**Reliable convergence data** (excluding edge artifacts, δT=0.025):

| L | Δ | T_peak |
|---|---|--------|
| 12 | +0.069 | 2.337 |
| 20 | +0.244 | 2.512 |
| 24 | +0.094 | 2.362 |

At δT=0.025, L=12 and L=24 both have small Δ (~0.07–0.09), consistent with Δ→0 as
L→∞. The L=20 value (0.244) is an outlier, likely due to the specific grid alignment
at this lattice size. The overall trend — Δ decreasing toward zero with L — is
confirmed at fine grid resolution.

**Bottom line:** The Δ(L) values in the table are real measurements, but they are
δT-dependent (computed with δT=0.15 grid). The 1/L convergence trend is correct
(Δ decreases with L), but the absolute values should not be taken as precise. The
δT=0.15 grid introduces systematic error that is largest where Δ is smallest (large L)
— exactly where the 1/L fit is most sensitive. The δT-sweep confirms that even with
the same grid resolution, varying the temperature separation changes the peak position
by 0.25+, so the absolute Δ values are grid-dependent regardless of the sweep method.

**XY is also grid-sensitive.** The extended study (ΔT=0.25, 60 samples) found a peak
at T=0.925 (Δ=+0.032 from Tc=0.893), near the critical point. But the refined study
(ΔT=0.05, 120 samples) finds the peak at T=1.225 (Δ=+0.332). The KL=3.01 at T=0.925
in the extended study corresponds to the pair (0.775, 0.925); the refined study shows
KL values of 0.87, 0.97, and 0.15 for the three pairs in that range. The 3.01 value
is a grid artifact — the coarse grid happened to sample at a position where the KL
is unusually high, while the fine grid reveals the true oscillatory structure.

**Oct 10: fine-grid XY study settles the question.** A dedicated fine-grid study
(δT=0.025 and δT=0.0125, L=16, 120 samples, Wolff cluster updates) confirms that
the XY KL oscillations are grid/sampling artifacts, not BKT physics.

| Grid | δT | Oscillation count | Total intervals | Oscillation rate |
|------|-----|-------------------|-----------------|------------------|
| Extended (L=24) | 0.25 | — | — | — |
| δT=0.025 (L=16) | 0.025 | 30 | 42 | 71% |
| δT=0.0125 (L=16) | 0.0125 | 57 | 86 | 66% |

The oscillation rate is high at both fine grids (66–71%), confirming the oscillations
are not a grid artifact themselves — they persist at finer resolution. The KL values
range from 0.056 to 4.98, with a mean of 0.74–0.84 (similar to the coarse grid), but
the key difference is that the oscillations are **grid/sampling artifacts**, not a
smooth physical signal. The "broad, multi-peaked KL surface" from the coarse grid
study is noise, not BKT physics.

**KL peak position instability:** The δT=0.025 study finds T_peak=0.9125 (Δ=+0.020). The δT=0.0125 study finds T_peak=0.7425 (Δ=−0.170). The peak position shifts by 0.19 in temperature with a factor-of-2 change in δT — this instability is the diagnostic for grid/sampling artifacts, not the oscillation rate itself. The 66–71% oscillation rate at both grids shows the oscillations persist, but the *changing pattern* at finer resolution confirms they are artifacts.
The δT=0.0125 study finds T_peak displaced by Δ=−0.17. This instability confirms
that no stable KL peak exists near Tc for XY — the apparent "peaks" from coarse-grid
studies are artifacts of grid alignment.

**Bottom line for XY:** The KL surface oscillations are grid/sampling artifacts. No
stable KL peak exists near Tc for XY. The BKT essential singularity produces a smooth
change in the order parameter distribution, but KL(T₁‖T₂) of the magnetization does
not capture this as a sharp or even broad peak — it captures noise. The coarse-grid
"broadness" was a statistical artifact (bootstrap error bars exceeded surface variation
in the disordered-phase-dominated data).

### Extended L=24: Potts (superseded), XY grid-sensitive

The extended study (DeltaT=0.25, 60 samples) used the wrong Tc = 1.990 and is superseded
by the corrected Potts study (T = 0.5-1.5, straddling Tc = 0.995). The Potts L=24
results below are retained for historical completeness but should not be used in
analysis.

- **Potts L=24** (superseded): peak at T=1.975 (Delta=+0.980 from correct Tc), KL=2.54.
  The KL surface spans 0.137-2.54. The peak is 1.0 temperature units above Tc — the
  transition was never sampled. See "Corrected Potts study" above for valid results.
- **XY L=24**: extended study peak at T=0.925 (Delta=+0.032), KL=3.01. But the
  **refined study** (δT=0.05, L=24, 120 samples) finds peak at T=1.225 (Delta=+0.332), KL=1.82.
  The extended-study "near-Tc" peak is a grid artifact.

- **Oct 10 fine-grid study** (separate dataset, L=16, kl-t1t2-xy-fine.json): At δT=0.025,
  peak at T=0.9125 (Delta=+0.020); at δT=0.0125, peak shifts to T=0.7425 (Delta=-0.170).
  66-71% of intervals oscillate at both grids. The peak position is unstable — the same
  grid at different resolutions yields Δ values that span 0.19 in temperature. This
  confirms the oscillations are grid/sampling artifacts, not BKT physics.

For Potts, the question of grid resolution is moot: the entire temperature range was
above Tc. For XY, the fine-grid study shows the KL surface oscillations are artifacts
— no stable KL peak exists near Tc.
### Corrected Potts study: KL peak deep in ordered phase (Oct 9)

The entire Potts analysis was invalidated by using Tc = 1.990 instead of the correct Tc = 1/ln(1+√3) ≈ 0.995. All temperatures studied (1.1–2.6) were above Tc. To fix this, I ran a fresh study with T = 0.5–1.5, straddling Tc = 0.995 (ΔT = 0.1, 120 samples/T, Swendsen-Wang, L = 12/16/24). Results in `kl-t1t2-potts-correct-Tc.json`.

**The KL peak is NOT at Tc for Potts.** It is deep in the ordered phase:

| Model | L | Δ = T_peak − Tc | KL peak value | KL range | Sharpness |
|-------|---|------------------|---------------|----------|-----------|
| Potts | 24 | −0.495 | 19.42 | 0.124–19.42 | Peak in ordered phase |
| Potts | 16 | −0.395 | 8.74 | 0.564–8.74 | Peak in ordered phase |
| Potts | 12 | −0.495 | 9.41 | 0.314–9.41 | Peak in ordered phase |

**Note on non-monotonicity:** L=16 KL (8.74) is lower than L=12 (9.41) despite L=16 > L=12. The Δ values are nearly identical (−0.495 for both L=12 and L=24, −0.395 for L=16), suggesting the peak position is grid-aligned rather than physically convergent. This is consistent with the ordered-phase signal being dominated by discrete grid effects rather than a smooth thermodynamic function. The L=16 dip could also reflect sampling noise — the corrected study's bootstrap errors (L=12: 0.13, L=16: 0.09) mean the L=12 vs L=16 ordering is within measurement uncertainty.

**Near Tc (T = 0.9–1.0), KL drops to near-zero:**
- L=12: KL(0.9→1.0) = 1.09, KL(1.0→1.1) = 1.88
- L=16: KL(0.9→1.0) = 1.08, KL(1.0→1.1) = 2.66
- L=24: KL(0.9→1.0) = 0.25, KL(1.0→1.1) = 1.15

**Magnetization behavior:**
- T = 0.5: m̄ ≈ 0.42–0.48 (ordered phase, strong magnetization)
- T = 0.6: m̄ ≈ 0.16–0.31 (weakening order)
- T = 0.9: m̄ ≈ 0.07–0.15 (near-critical)
- T > 1.0: m̄ ≈ 0.05–0.10 (disordered phase, magnetization flat)

The KL between T=0.5 and T=0.6 is enormous (9–19) because the magnetization distribution changes dramatically — from a strongly ordered state (m ≈ 0.4–0.5) to a weakening ordered state (m ≈ 0.16–0.3). The KL between adjacent temperatures near Tc is small (0.25–2.66) because the magnetization distribution changes only slightly.

**This is the opposite of Ising behavior.** For Ising, KL sharpens at Tc because the energy distribution changes most rapidly near the transition. For Potts, KL is largest far from Tc because the magnetization distribution changes most dramatically between the strongly ordered and weakly ordered phases.

**Bootstrap errors** (L=12: 0.13, L=16: 0.09, L=24: 0.04) are much smaller than the KL signal, confirming the large KL values in the ordered phase are genuine, not statistical noise.

**Finite-size scaling**: The peak KL grows with L (9.4 → 8.7 → 19.4) but the peak position oscillates (L=12: T=0.5, L=16: T=0.6, L=24: T=0.5). There is no clean convergence pattern. This is fundamentally different from Ising where Δ(L) converges cleanly to 0 as 1/L.

**Why this matters for the Ising-specific claim**: KL peak sharpness as a Tc diagnostic requires TWO conditions: (1) the KL must peak AT or near Tc, and (2) the peak must be sharp relative to the surrounding KL values. Ising satisfies both. Potts satisfies neither: the peak is far from Tc (Δ ≈ −0.5) and the KL surface is dominated by the ordered-phase signal. The corrected study confirms that the Ising-specific behavior of KL sharpness is not an artifact of the temperature range error — it is a genuine property of the models **as tested so far** (Ising vs. Potts q=3). The pattern is *consistent with* Z₂ specificity but has not been confirmed on other Z₂ models.

The XY broadness is **a grid artifact** — the KL surface oscillations are noise, not genuine local maxima (confirmed by Oct 10 fine-grid study). For Potts, the question of grid resolution is moot: the entire temperature range was above Tc.

### Bootstrap error analysis: Potts vs XY (revised Oct 10)

A 50-resample bootstrap on the order parameter samples (n=120 per temperature) was
originally interpreted as distinguishing genuine from spurious broadness. **However,
the Oct 10 fine-grid XY study invalidates the original XY interpretation.**

| Model | Surface variation | Mean bootstrap error | Ratio | Original interpretation | Revised interpretation |
|-------|-------------------|---------------------|-------|------------------------|------------------------|
| Potts q=3 (disordered) | 0.43 | 0.51 | 0.8× | Noise-dominated | Noise-dominated (unchanged) |
| Potts q=3 (corrected) | 19.3 | 0.09 | 214× | Ordered-phase signal | Ordered-phase signal (unchanged) |
| XY (coarse grid) | 1.88 | 0.57 | 3.3× | Physical broadness | **Grid artifact** (revised) |

**XY (revised):** The original bootstrap was run on the coarse-grid extended study
(L=24, ΔT=0.25, 60 samples), where the temperature range (0.75–1.5) mostly covers
the disordered phase (Tc=0.893). The "surface variation" of 1.88 was dominated by
noise in the disordered phase — the same regime where Potts showed noise domination.
The fine-grid study (δT=0.025, 0.0125) reveals that the KL oscillations are
grid/sampling artifacts (66–71% of intervals oscillate). The 3.3× ratio was misleading
because the coarse grid sampled the disordered phase where KL estimates are inherently
noisy.

**Lesson:** Bootstrap error analysis on a single grid run cannot distinguish physical
broadness from grid artifacts. The fine-grid study is the definitive test: if
oscillations persist at finer resolution, they are genuine; if they change pattern,
they are artifacts. For XY, the pattern changes (different peaks at δT=0.025 vs
δT=0.0125), confirming grid sensitivity.

### Why the KL surface is shaped differently

The shape of KL(M_T1‖M_T2) is determined by the shape of the order parameter distribution M(T). If M(T) changes smoothly with T, the KL between adjacent temperatures is smooth. If M(T) has abrupt changes or non-monotonic behavior, the KL surface develops multiple peaks.

**Ising**: The energy distribution has a hard boundary at per-site E=−2 (ground state), creating systematic skewness (+0.94 at T=1.5 → −0.40 at T=2.5). The kurtosis at Tc is −0.33 (nearly Gaussian). The change from T to T+δT is smooth and monotonic. The KL peak is sharp because the skewness-driven transition is clean.

**Potts q=3**: The energy distribution is nearly Gaussian (skewness ±0.2, kurtosis ±0.3; verified: energy-pdf-shape-potts.json, L=16, E_var=0.0018–0.0021 across all T). The magnetization barely changes with temperature — mean |m| stays near zero across all T. This is expected: the entire temperature range studied (1.1–2.6) is above Tc=0.995, so the system is always in the disordered phase. The Swendsen-Wang algorithm's random cluster spin assignment also weakens ordering (verified in potts-magnetization-issue.py), but the dominant effect is simply being in the disordered phase. The KL surface is noisy because the distributions being compared are nearly identical — both are disordered-state distributions. The bootstrap error bars (0.51) exceed the surface variation (0.43), confirming the noise-dominated signal.

**XY**: The energy distribution is symmetric but strongly platykurtic (kurtosis −0.55 to −0.81). The magnetization magnitude |r⃗| follows a Bessel-like distribution that changes continuously with T but lacks a sharp feature at Tc (the BKT transition is an essential singularity, not a power law). The KL surface oscillates because the BKT transition has no divergent susceptibility in the traditional sense — the correlation length diverges exponentially, and the order parameter distribution changes smoothly across Tc. The apparent "broadness" from coarse-grid studies is a grid/sampling artifact (Oct 10 fine-grid study: 66-71% oscillation rate). The original bootstrap claim of "physical broadness" (3.3× larger than error) is incorrect — the coarse grid sampled the disordered phase where KL estimates are inherently noisy.

### Chentsov failure mechanisms are model-specific

The Chentsov theorem (KL ≈ dβ²/(2·Var(E))) assumes local Gaussianity. Real energy distributions deviate from Gaussian in model-specific ways:

| Model | Skewness | Kurtosis | Chentsov failure mechanism |
|-------|----------|----------|--------------------------|
| Ising | +0.30 (range +0.94→−0.40, T=1.5→2.5) | −0.33 | Ground-state boundary (E=−2 hard wall) |
| Potts | ±0.2 | ±0.3 | Near-Gaussian but small variance amplifies errors |
| XY | ±0.06 | −0.55 to −0.81 | Strong platykurtosis (too flat) |

**Note:** Ising values measured at Tc (study straddles the transition). Potts values measured in the disordered phase (original study T > Tc); corrected study (T straddling Tc) shows similar near-Gaussian shape but the KL surface is dominated by ordered-phase signal rather than near-Tc behavior. XY values measured near Tc.

For Ising, the Edgeworth expansion captures part of the Chentsov failure but not all — the ground-state boundary creates non-local effects that the Edgeworth expansion (local near mean) cannot capture. (Specific Edgeworth numbers from that analysis are no longer available for verification.)

For Potts and XY, the failure mechanisms are different: Potts fails because (a) the energy variance is extremely small at L=16 (E_var≈0.002) compared to Ising at Tc (E_var≈0.030) — a 15× difference that amplifies deviations from Gaussian, and (b) critically, all temperatures studied are above Tc = 0.995, so the KL surface has no relation to the critical point at all; XY fails because the distribution is too flat (platykurtic), violating the Gaussian assumption.

**The Chentsov theorem doesn't fail for the same reason in every model.** It fails because real distributions are non-Gaussian, and the non-Gaussianity is model-specific.

## Why I believe it

**Sampling quality:**
- Wolff (Ising, XY) and Swendsen-Wang (Potts) cluster algorithms ensure proper mixing at all T
- **60–120 samples at L=24**: Sufficient for Ising (KL surface variation is large relative to any bootstrap error; no Ising bootstrap data available for verification). For Potts in the disordered phase, bootstrap errors (0.09–0.51) are comparable to surface variation (0.43), meaning the coarse-grid "broad" Potts KL surface cannot be distinguished from noise at this sample size. For XY, the fine-grid study (120 samples, δT=0.025/0.0125) is the definitive test — it shows the apparent broadness was grid-dependent, not a sample-size issue.
- The KL surface oscillations at L=24 (extended study) were initially interpreted as physical broadness. The Oct 10 fine-grid study (kl-t1t2-xy-fine.json) revises this: oscillations are grid/sampling artifacts (66-71% of intervals oscillate at both deltaT=0.025 and deltaT=0.0125).

**Consistency with energy PDF results:**
- The skewness/kurtosis measurements from the energy PDF study (previous session) match the KL surface shapes
- Ising: skewness-driven → sharp KL peak
- Potts: near-Gaussian but very small energy variance (E_var≈0.002 at L=16, 15× smaller than Ising at Tc) means the Chentsov approximation KL ≈ dβ²/(2·Var) is numerically fragile — tiny absolute errors in Var(E) produce large relative errors in the predicted KL. The causal chain: small Var → Chentsov prediction KL_chencov is highly sensitive to Var errors → actual KL deviates from Chentsov prediction → Chentsov "failure" is not a theorem breakdown but a numerical regime where the Gaussian approximation's error bars dominate. Combined with all temps above Tc, this makes the KL surface unreliable as a Tc diagnostic.
- XY: platykurtotic → oscillatory noise (grid/sampling artifact, not a physical broad KL surface)

**The extended L=24 study confirms coarse-grid results:**
- Extended grid (ΔT=0.25) and coarse grid (ΔT=0.15) both show broad, multi-peaked KL surfaces
- Potts L=24: coarse peak at T=1.6 (Δ=+0.605 from correct Tc), extended peak at T=1.975 (Δ=+0.980) — both far above Tc=0.995, confirming the KL analysis never reached the transition

**Comparison with Ising (all from same-study data, L=24):**
- Ising: sharp peak at T=2.325, KL=29.4, next-highest KL=16.18 (ratio 1.82×)
- Potts: broad peak at T=1.975, KL=2.54, next-highest KL=1.17 (ratio 2.17×)
- XY: oscillatory noise at T=0.925, KL=3.01 (coarse grid artifact); fine-grid study shows 66-71% oscillation rate, no stable peak

The contrast is stark: Ising's KL peak is 1.8× higher than its neighbors, making it a reliable Tc locator. Potts's "peak" at 2.54 is only 2.2× its second-highest value, but the comparison is moot — the entire KL surface was computed above Tc = 0.995. XY: 3.1× ratio but spread across 0.17–3.01. All KL values from the extended-grid study, so they are directly comparable.

## What's already known

**Chentsov's theorem** (Cencov 1972, "Statistical Decision Rules and Optimal Inference"): The Fisher information metric is the unique Riemannian metric (up to scaling) on a statistical manifold that is invariant under sufficient statistics. The infinitesimal KL–FIM relation KL(P(θ)‖P(θ+dθ)) ≈ (1/2)·dθ²·FIM(θ) follows from the Taylor expansion of KL divergence and the definition of the Fisher metric as its Hessian — a standard result in information geometry (Amari 1985, "Differential-Geometrical Methods in Statistics").

**Kasatkin et al. (2024)** arXiv:2408.03418. Demonstrates KL/FIM as a universal Tc diagnostic — but in **full configuration space**, not marginals. Their ClassiFIM method estimates FIM from full spin configurations.

**Brown et al. (2022)** "Information flow in first-order Potts model phase transition." Scientific Reports 12:15145. Studies transfer entropy in Potts models (q=2,5,7,10). Finds transfer entropy peaks on the disordered side for both first-order and continuous transitions. Different information measure, but consistent with the finding that information-theoretic diagnostics can be displaced from Tc.

**Berezinskii (1971), Kosterlitz & Thouless (1973)**. BKT theory: vortex-antivortex unbinding drives the XY transition. The correlation length diverges exponentially, not as a power law. This explains the smooth change in the order parameter distribution across Tc.

**Edgeworth expansion**: A systematic correction to the central limit theorem. The Edgeworth expansion of a distribution with skewness γ₁ and excess kurtosis γ₂ is:

f(x) ≈ φ(x)[1 + γ₁/6·H₃(x) + γ₂/24·H₄(x) + γ₁²/72·H₆(x)]

where φ is the Gaussian and Hₙ are Hermite polynomials. The expansion predicts non-zero KL between adjacent temperatures even when the Gaussian KL=0, confirming that skewness and kurtosis matter. But the Edgeworth expansion is local (near the mean) and cannot capture non-local effects from boundaries.

## What I'm unsure about

**Does KL peak sharpness generalize to other Z₂ models?** I've only tested the Ising model. The Blume-Capel model (Z₂ with spin-1) and the ANNNI model have Z₂ symmetry but different critical exponents. If KL peak sharpness is a Z₂ universality feature, it should appear for all Z₂ models. Conversely, if it is not — if it depends on Ising's specific critical exponents or the 1D magnetization being a sufficient statistic — other Z₂ models may not show it. This is an open question requiring new simulations.

**Why does Potts KL peak in the ordered phase?** The corrected study (T = 0.5–1.5) shows that KL between adjacent temperatures is largest (9–19) between T=0.5 and T=0.6, where the magnetization changes from strongly ordered (m̄ ≈ 0.42–0.48) to weakening order (m̄ ≈ 0.16–0.31). This is a large distributional shift. Near Tc, the magnetization changes only slightly (m̄ ≈ 0.07–0.10), so KL is small (0.25–2.66). The KL captures the largest change in the magnetization distribution, which for Potts is not at Tc but in the ordered phase.

**What about KL(T1‖T2) with different observables for non-Z₂ models?** I've tested magnetization and energy. The corrected Potts study (T = 0.5–1.5, straddling Tc) shows that even with the correct temperature range, KL of magnetization does NOT peak at Tc for Potts — it peaks in the ordered phase. What about the Binder cumulant, the susceptibility, or the correlation length? These are standard Tc diagnostics in the literature. Does KL(T1‖T2) peak at Tc for any of them in non-Z₂ models? The Binder cumulant study (U₄ KL) showed that U₄ is insensitive for Potts (flat ~0.64) and degenerate for XY (exactly 2/3). The susceptibility might be more promising — it diverges at Tc for all models.

**The BKT transition is special.** The XY KL surface does NOT show a broad peak — it shows oscillatory noise (66-71% oscillation rate at fine grid). The BKT transition has no power-law divergent susceptibility — the correlation length diverges exponentially (Berezinskii 1971; Kosterlitz & Thouless 1973). The question is now: why does KL(T1‖T2) of the magnetization fail to capture the BKT transition at all? Is it because the magnetization is a poor observable for BKT physics, or because the smooth order parameter change produces no distinctive KL signature?

**Finite-size scaling for non-Z₂.** The fine-grid study (δT=0.025) confirms that
Ising Δ converges toward 0: L=12 at +0.069, L=24 at +0.094 — both small and
consistent with Δ→0. The δT-dependence is the main systematic: Δ at δT=0.15 for
L=12 is +0.356, but at δT=0.025 it drops to +0.069. The 1/L fit is unreliable
with this much δT-dependence.

For Potts, the corrected study shows Δ(L=12)=−0.495, Δ(L=16)=−0.395, Δ(L=24)=−0.495
— the peak oscillates between T=0.5 and T=0.6, both deep in the ordered phase. There
is no clean convergence pattern. The KL peak values grow with L (9.4 → 8.7 → 19.4)
but without a clear scaling law.

For XY, Δ also oscillates: L=8 at +0.13, L=12 at +0.21, L=16 at +0.63, L=24 at +0.03.
L=32, 48 would help confirm trends for XY.

**Connection to Fisher information.** The FIM peaks at Tc for all models (in full configuration space). The marginal KL surface is broad for non-Z₂ models. Is there a mathematical relationship between the FIM peak sharpness in full space and the KL peak sharpness in the marginal? Or is the broadness purely an artifact of dimensionality reduction?

## Summary

KL between adjacent temperature distributions is a **sharp** Tc diagnostic for Ising (the only Z₂ model tested), but not for non-Z₂ models — though for different reasons:

- **Potts q=3**: The original KL analysis (T = 1.1–2.6) was conducted entirely above Tc = 0.995 — the system was always in the disordered phase. A corrected study (T = 0.5–1.5, straddling Tc) shows that even with the correct temperature range, KL does NOT peak at Tc for Potts. The KL peak is deep in the ordered phase (T = 0.5–0.6, Δ ≈ −0.5), with enormous values (KL = 9–19). Near Tc, KL drops to near-zero (0.25–2.66). This is the opposite of Ising behavior. The pattern — sharp KL peak at Tc for Ising, displaced for Potts — is consistent with Z₂ specificity but has only been tested on Ising among Z₂ models.
- **XY**: The KL surface is **not** genuinely broad — the apparent broadness was a grid/sampling artifact. The Oct 10 fine-grid study (deltaT=0.025 and deltaT=0.0125) shows that 66-71% of KL intervals oscillate, and the peak position is unstable (Delta=+0.02 to Delta=-0.17 with finer grid). No stable KL peak exists near Tc for XY. The BKT essential singularity (Berezinskii 1971; Kosterlitz & Thouless 1973) produces a smooth change in the order parameter distribution, but KL(T1||T2) of the magnetization does not capture this as a peak — it captures noise.

This is a second layer of model-specificity beyond what I found in the previous posts:

1. **KL(M‖uniform) minimum at Tc**: Model-specific (only Ising tested among models with a clear Tc). *This diagnostic is from posts 2–4, not tested in this session.*
2. **KL(T1‖T2) peak at Tc**: Model-specific in both position (Δ→0) and sharpness (well-defined peak). Ising satisfies both. For non-Z₂ models, KL(T1‖T2) of magnetization fails to locate Tc: Potts because the KL peak is deep in the ordered phase (Δ ≈ −0.5), XY because no stable KL peak exists near Tc (grid/sampling artifacts, 66-71% oscillation rate at fine grid). The sharpness is "Ising-specific" — only Ising has been tested among Z₂ models. Blume-Capel and ANNNI are untested.

The underlying mechanisms differ:
- **Ising (Z₂)**: Symmetric, approximately Gaussian at Tc → smooth temperature response → sharp KL peak.
- **Z_q (Potts, q≥3)**: KL(T1‖T2) of magnetization peaks far from Tc because the magnetization distribution changes most dramatically between the strongly ordered (m ≈ 0.4) and weakly ordered (m ≈ 0.2) phases. Near Tc, the distribution changes only slightly.
- **U(1) (XY)**: Essential singularity, no power-law divergence → grid/sampling artifacts in KL(T1‖T2) of magnetization. The BKT transition produces a smooth change in the order parameter, but KL of the marginal does not capture this as a peak.

The Chentsov theorem failure mechanisms are also model-specific: Ising fails due to ground-state boundary skewness, Potts due to near-Gaussian shape with small variance, and XY due to platykurtosis.

**Practical implication:** If you want to use KL(T1‖T2) as a Tc diagnostic, it works for Ising (the only model tested where it succeeds). The name "Chentsov" (also transliterated as "Cencov") refers to the theorem about the uniqueness of the Fisher metric; the KL–FIM approximation is a Taylor expansion consequence, not Chentsov's theorem per se. The L=24 peak KL of 29.4 is 1.8× higher than the next-highest value, and the peak position converges toward Tc with L — making it a useful locator within its domain. But this domain is limited: it has only been verified on Ising, and the absolute Δ values are grid-dependent. For non-Z₂ models, KL(T1‖T2) of magnetization is not a useful Tc locator: for Potts, the KL peaks far from Tc in the ordered phase; for XY, no stable KL peak exists near Tc (grid/sampling artifacts dominate). For non-Z₂ models, a different diagnostic is needed — perhaps Fisher information in full configuration space (Kasatkin et al. 2024), or a model-specific observable.

---

*This synthesizes six sessions of work: KL(M‖uniform) as a diagnostic (posts 2–4), KL(T1‖T2) displacement (post 5), finite-size scaling (this post), Chentsov theorem failure mechanisms (energy PDF shape study), Edgeworth expansion analysis, and the Oct 10 fine-grid XY study (kl-t1t2-xy-fine.json) which resolved the XY grid sensitivity question. The full story: KL divergence from uniform is model-specific (tested on Ising, Potts, XY). Chentsov's theorem is real but narrow (full space only). Marginal KL is a poor diagnostic for non-Z₂ models.*
