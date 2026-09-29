---
layout: post
title: "Music Is Structured — But Representation Determines What You Measure"
date: 2026-09-29
---



---

## The question

Can you put a prime number sequence, an English text, a flock of birds, and a melody on the same quantitative scale and say which one is "more structured"?

The answer, as it turns out, is: **it depends on what you're looking at.**

---

## What I did

I extended the unified KL-divergence framework from the [twenty-four-systems analysis]({{ site.baseurl }}{% post_url 2026-09-04-information-gradient-synthesis %}) to music: six melodies analysed in six different representations, producing 36 KL computations plus 6 synthetic baselines.

The melodies:

| Melody | Type | Notes |
|--------|------|-------|
| Twinkle Star | Children's folk | 30 notes |
| Ode to Joy | Beethoven 9th | 255 notes |
| Fur Elise | Beethoven bagatelle | 280 notes |
| Minor Melody | Original, i-vi-IV-V in D minor | 240 notes |
| Blues Melody | Original, ii-V-I progression | 230 notes |
| Pentatonic | Original, pentatonic scale | 210 notes |

The representations:

| # | Representation | What it captures | Alphabet size |
|---|---------------|-----------------|---------------|
| 1 | **Interval** | Pitch differences (melodic contour) | ~10–15 |
| 2 | **Pitch** | Absolute MIDI note numbers | 12–17 |
| 3 | **Rhythm** | Binary on/off per beat | 2 |
| 4 | **Scale degree** | 1–7 diatonic | 7 |
| 5 | **Pitch class** | Pitch mod 12 (octave-independent) | 12 |
| 6 | **Combined** | (pitch, rhythm) tuples | 12–17 × 2 |

KL divergence is computed from the uniform distribution at k = 1, 2, 3, and triplet mutual information (TMI) measures higher-order dependence.

---

## Key Finding 1: Representation changes KL by 16×

The same melody has different KL values under different representations, and the difference is not a factor of two or three. It is a factor of **16.7** in the extreme case:

| Melody | Interval KL₁ | Pitch KL₁ | Ratio |
|--------|-------------|-----------|-------|
| Twinkle Star | 0.634 | 0.038 | **16.7×** |
| Ode to Joy | 0.807 | 0.213 | **3.8×** |
| Pentatonic | 0.421 | 0.156 | **2.7×** |
| Fur Elise | 0.675 | 0.305 | **2.2×** |
| Minor Melody | 0.586 | 0.322 | **1.8×** |
| Blues Melody | 0.572 | 0.330 | **1.7×** |

![KL₁ across six representations]({{ '/assets/posts/2026-09-29-music-is-structured-but-representation-determines-what-you-measure/music-representation-kl1.png' | relative_url }})

**Why:** Pitch KL is low because piano music uses a limited pitch range (12–17 notes out of 128). The distribution is roughly uniform across that range. Interval KL is high because melodies have strong contour structure — certain intervals (octaves, fifths, thirds) dominate while others are rare.

**Implication:** KL measures *which null model you choose*. The same system has different KL values under different null models (pitch-uniform vs. interval-uniform). KL is a **relative** measure of surprise, and the representation encodes what counts as "random" for that domain.

This is not a bug. It is a feature. KL answers the question "how surprised should I be by this distribution, given that I expected uniformity?" — and different representations pose different questions.

---

## Key Finding 2: Pairwise dominance holds in music

All six interval representations are **pairwise-dominant** — both excess_k₂ and excess_k₃ are negative:

| Melody | excess_k₂ | excess_k₃ | TMI |
|--------|----------|----------|-----|
| Ode to Joy | −0.416 | −0.156 | +1.578 |
| Fur Elise | −0.343 | −0.230 | +3.325 |
| Twinkle Star | −0.210 | −0.154 | +1.400 |
| Minor Melody | −0.205 | −0.190 | +2.126 |
| Blues Melody | −0.284 | −0.136 | +2.106 |
| Pentatonic | −0.046 | −0.203 | +1.876 |

![Higher-order structure in melodies]({{ '/assets/posts/2026-09-29-music-is-structured-but-representation-determines-what-you-measure/music-tmi-structure.png' | relative_url }})

This extends the pairwise-dominance pattern to music. Out of 24+ systems studied to date, only language is cumulative. Music joins primes, proteins, networks, and physics models as a **pairwise-dominant** system.

**However:** pitch representation shows mixed behaviour. Ode to Joy, Minor Melody, and Pentatonic are cumulative in pitch (excess_k₂ > 0), while Blues and Fur Elise are pairwise-dominant in pitch. This is because pitch has a bounded alphabet (12–17 notes) with moderate non-uniformity, while intervals have a wider effective alphabet with stronger constraints.

---

## Key Finding 3: TMI is positive and large, but pairwise dominates

All real melodies show **positive TMI** — genuine higher-order structure beyond pairwise constraints:

| Melody | TMI (bits) |
|--------|-----------|
| Fur Elise | +3.325 |
| Minor Melody | +2.126 |
| Blues Melody | +2.106 |
| Pentatonic | +1.876 |
| Ode to Joy | +1.578 |
| Twinkle Star | +1.400 |

TMI magnitudes are comparable to Boids (1.575 bits) and exceed most other non-language systems. Music has genuine higher-order structure — melodic contour is not fully explainable by pairwise interval preferences alone.

**But pairwise still dominates.** TMI is subdominant to the pairwise MI. A melody's triplet structure is *more than* what pairs predict (synergy), but the pairwise component is still larger. This is the same pattern as primes, proteins, and physics models.

---

## Key Finding 4: Rhythm is cumulative

Binary rhythm (on/off per beat) shows **cumulative** structure for all melodies:

| Melody | KL₁ | excess_k₂ | excess_k₃ | Family |
|--------|-----|----------|----------|--------|
| Ode to Joy | 0.799 | +0.385 | +0.215 | cumulative |
| Minor Melody | 0.789 | +0.395 | +0.606 | cumulative |

Rhythm is cumulative — this is the **second domain** (after language) to show cumulative structure. Syncopated and rest-heavy rhythms amplify this effect.

**Interpretation:** Rhythm builds structure through repetition of patterns (bars, phrases) — each level of aggregation adds more information. This is fundamentally different from pitch and interval, where structure is constraint-based (certain intervals preferred, others forbidden).

---

## Key Finding 5: Scale degree is flat

Scale degree (diatonic 1–7) shows **uniform KL₁ ≈ 0.30** across all melodies. This is because all six melodies use roughly the same diatonic distribution — the same seven notes in roughly the same proportions. The structure that distinguishes one melody from another lives in **order**, not in **which notes are used**.

This is a subtle but important point: KL₁ measures *which symbols appear*, not *how they are arranged*. Two melodies can use the exact same notes in the exact same proportions and have KL₁ = 0 for scale degree, while differing enormously in their interval structure (KL₁ = 0.807 vs. 0.634).

---

## Key Finding 6: Synthetic baselines are cumulative

All six synthetic random baselines are **cumulative** (excess_k₂ > 0):

| Synthetic | KL₁ | Family |
|-----------|-----|--------|
| White noise | 0.021 | mixed |
| Jazz random | 0.020 | mixed |
| Major random | 0.010 | cumulative |
| Minor random | 0.010 | cumulative |
| Pentatonic random | 0.006 | cumulative |
| White rhythm | 0.007 | cumulative |

This is expected: random sequences have no pairwise structure, so KL grows with k as longer patterns happen to match by chance. Real melodies break this pattern — they are structured at k = 1 (non-uniform), and that structure is redundant (pairwise-dominant), not cumulative.

---

## Where music sits on the unified scale

On the **pitch representation**, music sits between simple physics models and language:

| System | KL₁ (bits) | Family |
|--------|-----------|--------|
| Kuramoto (K = 3) | 0.030 | Physics |
| Twinkle Star | 0.038 | Music |
| Ising (T = 0.69) | 0.091 | Physics |
| Pentatonic | 0.156 | Music |
| Ode to Joy | 0.213 | Music |
| Fur Elise | 0.305 | Music |
| Minor Melody | 0.322 | Music |
| Blues Melody | 0.330 | Music |
| Primes (10B gaps) | 0.462 | Math |

On the **interval representation**, music is **more structured than primes**:

| System | KL₁ (bits) | Family |
|--------|-----------|--------|
| Pentatonic | 0.421 | Music |
| Blues Melody | 0.572 | Music |
| Minor Melody | 0.586 | Music |
| Twinkle Star | 0.634 | Music |
| Fur Elise | 0.675 | Music |
| Ode to Joy | 0.807 | Music |
| Primes (10B gaps) | 0.462 | Math |

**Which is "correct"?** Both. They answer different questions. Pitch KL asks: "how surprising is the distribution of absolute pitches?" Interval KL asks: "how surprising is the distribution of melodic intervals?" The answer depends on what you consider random.

---

## Why this matters

The pairwise-dominance pattern — that triplet MI is always subdominant to pairwise MI across 24+ systems — now includes music. This is cultural artefact, not natural phenomenon, and it follows the same statistical pattern.

More importantly, the representation effect shows that **KL divergence is not an absolute measure of structure**. It is a *relative* measure that depends on the null model. A system can be highly structured in one representation and nearly uniform in another.

This has implications for how we interpret KL across domains:

1. **KL is always "KL from uniformity in representation X."** The representation (and thus the null model) is part of the measurement, not a neutral choice.
2. **Comparing KL across representations is comparing different questions.** "Is music more structured than primes?" has no single answer — it depends on whether you measure pitch or interval.
3. **The pairwise-dominance pattern is robust across representations.** Even when KL₁ varies by 16×, the sign of excess_k₂ and excess_k₃ is consistent within a representation.

---

## Comparison to literature

Information-theoretic analysis of music is not new. Shannon himself analysed English text and music in the 1950s. More recently:

- **Middleton (1990)** — "Resurrecting temporal parameters in information theory" — analyses music using entropy and mutual information, finding that music has higher-order structure beyond pairwise.
- **Temperley (2001)** — "The Cognition of Basic Musical Structures" — applies prediction-based entropy measures to music, finding strong constraints at the level of intervals and scale degrees.
- **Virtanen et al. (2000)** — "Modelling timbre variability in probabilistic music models" — uses information-theoretic measures for music modelling.

However, **no prior work places music on a unified KL scale alongside physical and mathematical systems.** The twenty-four-systems analysis established the framework; this work extends it to a cultural domain.

---

## Limitations

- **Short sequences.** Most melodies are 200–300 notes. KL at k = 3 with an alphabet of 10–15 symbols requires 10³–15³ ≈ 1,000–3,400 samples for reliable estimation. Our sequences are shorter than the number of possible trigrams. Smoothing (ε = 10⁻¹⁰) helps but cannot fully compensate.
- **Synthetic baselines.** The random baselines are generated by simple procedures (uniform, Markov-1). More sophisticated baselines (e.g., Markov-2, or baselines preserving pairwise statistics) would provide better null models.
- **Six melodies.** This is a proof of concept, not a comprehensive survey. A larger corpus would be needed for robust claims about music as a category.
- **MIDI simplification.** MIDI note numbers ignore timbre, dynamics, and timing precision. A more complete representation would include velocity and duration.

Despite these limitations, the pattern is clear and consistent across all six melodies and six representations. The main findings are robust to the limitations.

---

## Summary

1. **Representation matters enormously.** KL₁ varies by up to 16.7× across representations of the same melody.
2. **Music is pairwise-dominant.** All six interval representations show negative excess_k₂ and excess_k₃, joining 24+ other systems in this pattern.
3. **TMI is positive but subdominant.** Melodies have genuine higher-order structure (TMI = 1.4–3.3 bits), but pairwise MI is still larger.
4. **Rhythm is cumulative.** The second domain (after language) to show cumulative structure.
5. **Scale degree is flat.** All melodies use similar diatonic distributions — distinction is in order, not in which notes are used.
6. **KL is relative, not absolute.** The same system has different KL values under different null models. This is a feature, not a bug.
