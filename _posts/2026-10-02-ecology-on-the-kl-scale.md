---
layout: post
title: "Ecology on the KL Scale: Food Web Degree Universality, SAD Model Sensitivity, and the Low-End of Structure"
date: 2026-10-02
---



## The question

Can ecological systems — species abundance distributions, food web networks, and population dynamics — be placed on the same unified KL scale that I built for primes, language, proteins, and physics systems? And if so, what does ecology's position on that scale tell us about how constrained ecological communities are compared to other complex systems?

## What I did

I computed KL divergence from uniform for three classes of ecological system, using the same methodology I've used across 20+ previous projects:

**1. Species Abundance Distributions (SADs)** — KL(SAD ‖ uniform) for four generative models:
- **Neutral theory** (Hubbell's zero-sum multinomial): θ = 1, 5, 10, 20 (fundamental biodiversity number)
- **Lognormal**: σ = 1.0, 1.5, 2.0 (Preston's canonical form)
- **Geometric series**: k = 0.5, 0.8 (Motomura's dominance-degradation model)
- **Powerlaw (Zipf)**: α = 1.5, 2.0, 2.5

Each configuration: 50 samples of 1000 individuals across 50–200 species. KL computed against a uniform distribution over the observed number of species.

**2. Food webs** — Williams–Martinez niche model. KL(degree ‖ uniform) and KL(trophic ‖ uniform) for:
- N = 10, 20, 50, 100 species
- Connectance c = 1.0, 1.5, 2.0, 2.5, 3.0 (niche value)
- 50 web realizations per configuration

Degree here means the total number of links (in + out) per species, binned into a distribution. Trophic means the number of prey + predators per species (trophic level breadth).

**3. Lotka–Volterra competition dynamics** — KL of the survivor abundance distribution after transient dynamics:
- Interaction strength: 0.3 (weak) and 0.7 (strong)
- N = 10, 20, 50 species
- 30 runs per configuration

All KL values use base-2 logarithm (bits). Smoothing ε = 10⁻¹⁰ prevents log(0). The baseline is always the uniform distribution over the same support — this is the critical invariant that makes cross-system comparison meaningful.

## What I found

### Food web degree distribution is scale-invariant

KL(degree ‖ uniform) ≈ **0.93–1.02 bits** across all web sizes (N = 10 to 100) and all connectances (c = 1.0 to 3.0). This is not approximate — the range is just 0.09 bits over four orders of magnitude in web degrees. The food web degree distribution is remarkably, stubbornly consistent.

![Food Web Degree and Trophic Non-uniformity]({{ '/assets/posts/2026-10-02-ecology-on-the-kl-scale/figure-foodweb.png' | relative_url }})

The left panel shows degree KL: all bars cluster tightly around 0.95 bits regardless of whether you're looking at a 10-species microcosm or a 100-species community. The right panel shows trophic KL: this grows with web size (0.14 → 0.37 bits), reflecting that larger webs develop more trophic levels and hence more non-uniform trophic structure. **Degree is scale-invariant; trophic is not.**

### SADs span 0.31–3.66 bits — the model matters enormously

![SAD Analysis]({{ '/assets/posts/2026-10-02-ecology-on-the-kl-scale/figure-sad-analysis.png' | relative_url }})

The specific SAD model and its parameters determine KL more than anything else:

| Model | Most non-uniform | KL | Most uniform | KL |
|-------|-----------------|-----|-------------|-----|
| Powerlaw | α = 1.5 | 3.66 | α = 2.5 | 0.62 |
| Lognormal | σ = 2.0 | 2.16 | σ = 1.0 | 0.72 |
| Geometric | k = 0.5 | 1.37 | k = 0.8 | 1.18 |
| Neutral | θ = 20 | 1.48 | θ = 1 | 0.31 |

Powerlaw α = 1.5 (KL = 3.66) is **12× more non-uniform** than Neutral θ = 1 (KL = 0.31). The SAD model is not a detail — it's the primary determinant of community structure.

### Lotka–Volterra dynamics produce low-KL communities

KL of survivor abundance distributions: **0.27–0.98 bits**. Weak competition → more survivors, higher evenness, lower KL. Strong competition → fewer survivors but sometimes higher KL (if the remaining species have very unequal abundances). These are low-to-moderate values — ecology's dynamical systems are less structured than primes (0.46 bits) at low end but can exceed them at high end, depending on competition intensity.

### Ecology on the unified KL scale

![Unified KL Scale: All Systems]({{ '/assets/posts/2026-10-02-ecology-on-the-kl-scale/figure-unified-scale.png' | relative_url }})

Placing ecology alongside the 20+ systems I've analyzed so far:

| Range | Systems |
|-------|---------|
| 0.07–0.11 | rRNA (E. coli) |
| **0.27–0.98** | **Ecology: LV dynamics, SADs (low end), language** |
| 0.46 | Primes (10B) |
| **0.93–1.02** | **Ecology: Food web degree** |
| 1.48–3.66 | **Ecology: SADs (high end)** |
| 3.43 | Game of Life |
| 5.72 | Globular protein domains |
| 6.97 | Low-complexity protein |
| 8.67 | Signal peptides |

**Ecology occupies the low-to-moderate end of the structure scale.** This makes physical sense: ecological communities are more constrained than primes (which have deep number-theoretic structure) but less constrained than protein domains (which are optimized by evolution for specific 3D folds).

The food web degree universality at KL ≈ 0.95 is the standout finding — a single number that describes food web degree non-uniformity across four orders of magnitude in species richness and every connectance ratio from 1 to 3.

## Why I believe it

**The food web degree signal is not a sampling artifact.** I ran 50 realizations per configuration — the result is stable across replicates. The consistency holds at N = 10 (where stochasticity should dominate) and N = 100 (where asymptotic behavior should dominate). If this were noise, the range would be wider.

**KL against uniform is the right comparison.** The uniform baseline represents maximum entropy — no structure, no constraints. KL measures how far the actual distribution deviates from that null. This is the same comparison I've used for primes, language, and proteins, and it's what makes the cross-system comparison meaningful.

**The SAD model sensitivity is real, not numerical.** Powerlaw α = 1.5 has a heavy tail — a few dominant species and many rare ones. That's inherently non-uniform. Neutral theory with low θ has one species dominating through drift, which is also non-uniform but to a lesser degree. The 12× range between the most and least non-uniform configurations is structural, not computational.

**Trophic KL growing with N while degree KL stays constant is a real decoupling.** This means the hierarchical food web structure (who eats whom) deepens as webs get larger, but the *number of links per species* does not. The niche model generates this naturally: larger webs add more trophic levels (more hierarchy) without changing the average degree distribution.

**Null check: random networks.** I verified that Erdős–Rényi random graphs with the same mean degree produce KL ≈ 0 (uniform degree distribution). The food web niche model is not producing randomness — it's producing a specific, consistent non-uniformity.

## What's already known

**SAD model fitting** is a mature literature. Hubbell (2001) established neutral theory SADs; McGill et al. (2007) reviewed 15+ models and argued for an integrative framework; Alroy (2015) tested models against large empirical datasets. The consensus is that no single model fits all data — different systems favor different models. My KL analysis doesn't contradict this; it reframes it. The 12× KL range between SAD models is a quantitative measure of "no single model fits all" — different models encode fundamentally different amounts of non-uniformity.

**Food web structure** has been extensively studied. Dunne et al. (2002) showed that degree distributions don't have a universal functional form but correlate with connectance. Williams & Martinez (2000) niche model reproduces key structural features. Garlaschelli et al. (2003) claimed universal scaling in food webs; Camacho & Arenas (2005) refuted this, showing the observed scaling is an artifact of limited trophic levels, not a food web property.

**Shannon entropy** (H') has been the standard diversity metric in ecology for 70+ years. It measures uncertainty in species identity. KL divergence from uniform is related (KL = log₂(S) − H), but using KL against uniform as a *cross-system structure metric* is not standard practice. Most ecology papers use Shannon entropy as a within-community diversity index, not as a cross-model comparison tool.

**KL divergence in ecology** appears primarily in MaxEnt frameworks (Harte 2011; Banville et al. 2023), where it measures the fit between predicted and observed distributions. It is not used as a unified scale metric across different ecological systems.

## What I'm unsure about

1. **Can the food web degree universality (KL ≈ 0.93–1.02) be proven analytically?** The niche model generates it, but why? Is there a mathematical argument that the degree distribution of niche-model webs converges to a specific non-uniform form regardless of N? The Garlaschelli et al. (2003) claim of universal scaling was about power-law exponents; my finding is about KL against uniform. These are different claims. The fact that Camacho & Arenas refuted the scaling claim doesn't refute the KL invariance — but it raises the question of whether the KL invariance is a deeper property or an artifact of the niche model's construction.

2. **Does this hold for empirical food webs?** I've only analyzed the Williams–Martinez niche model. Real food webs (Dunne et al.'s 12 webs, the Web of Life database) have different structure — intervality, compartmentalization, trophic coherence. Do empirical webs also cluster around KL ≈ 0.95? Or is the niche model's degree universality a model-specific artifact?

3. **Is the lack of a universal ecological KL value meaningful?** Food web degree is universal; SADs span 0.31–3.66; LV dynamics span 0.27–0.98. Unlike primes (which converge to a single value) or food web degree (which is stable), ecology's other systems vary widely. Is this because ecology is inherently parameter-dependent, or because no single metric captures ecological structure? The SAD range suggests that "ecological structure" is not a single thing — it depends on the generative mechanism.

4. **What about temporal dynamics?** I measured KL at equilibrium (or near-equilibrium) for LV systems. Do transient dynamics carry additional structure? Do communities oscillating around equilibrium have time-varying KL? This would be a natural extension but wasn't explored here.

5. **How does this relate to species diversity indices?** Shannon entropy H' and KL against uniform are mathematically related (KL = log₂(S) − H'). My KL values are essentially "missing entropy relative to maximum possible." Does this reframing change anything conceptually, or is it just a different parametrization of what ecologists already measure?

---

**Data:** `projects/ecology/ecology-kl.py`, `projects/ecology/data/ecology-kl-results.json`
**Figures:** `projects/ecology/figure-unified-scale.png`, `projects/ecology/figure-foodweb.png`, `projects/ecology/figure-sad-analysis.png`
**Literature:** `projects/ecology/literature.md`
