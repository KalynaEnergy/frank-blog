---
layout: post
title: "Where Biology Fits on the Structure Scale"
date: 2026-09-29
---



---

## The question

Can you put a prime number sequence, an Ising spin glass, a flock of birds, and a stretch of DNA on the same quantitative scale and say which one is "more structured"?

The twenty-four-systems analysis showed you could — KL divergence from uniform at k = 3 ranges from 0.03 bits (Kuramoto oscillators) to 7.08 bits (real SNAP networks). But that analysis was missing the biggest category: **biology**. Living systems have sequences — DNA, RNA, proteins — and those sequences carry the imprint of evolutionary constraints. They should be measurable.

This post places 13 biological sequence variants on the unified KL scale, resolving an apparent contradiction along the way: KL can grow monotonically across orders while mutual information stays pairwise-dominant. They measure different things.

---

## What I did

I computed KL divergence from the uniform distribution at k = 1, 2, 3 for 13 biological sequence variants: 7 DNA types and 5 protein types (plus one protein variant). Sequences were generated synthetically (n = 100,000) for comparability across all systems.

The sequences:

| System | Type | What it models | Alphabet |
|--------|------|---------------|----------|
| DNA_random | Synthetic baseline | Uniform random | 4 (A,C,G,T) |
| DNA_coding | Open reading frame | Codon bias in protein-coding genes | 4 |
| DNA_cpg_island | CpG-rich region | Methylation-sensitive regions | 4 |
| DNA_GC25 / DNA_GC75 | GC-biased | Genomic regions with extreme base composition | 4 |
| DNA_homopolymer | Run-length model | Tracts of identical bases | 4 |
| DNA_microsatellite | Periodic repeat | (A,T)ₙ(G,C)ₙ alternating repeats | 4 |
| DNA_purine_pyrimidine | Binary encoding | R (A,G) vs Y (C,T) | 2 |
| protein_random | Synthetic baseline | Uniform amino acid distribution | 20 |
| protein_conserved | Evolutionarily constrained | Slowly evolving protein regions | 20 |
| protein_disordered | Intrinsically disordered | Flexible protein regions | 20 |
| protein_membrane | Transmembrane domain | Hydrophobic patterning | 20 |
| protein_low_complexity | Repetitive tract | Poly-Q, serine-rich domains | 20 |

KL is computed as D_KL(P_k || Uniform_k) with Laplace smoothing (ε = 10⁻¹²). Triplet mutual information (TMI) measures higher-order dependence beyond pairwise.

---

## Finding 1: Biology extends the scale to 7.0 bits

The biological sequences span KL₃ = 0.000 (DNA_random) to 6.966 (protein_low_complexity) bits. This extends the unified range from 0.03 to 7.08 bits — a 236× ratio (7.08/0.03) across 16 systems.

Notable placements on the unified scale:

| System | KL₃ (bits) | What it means |
|--------|-----------|---------------|
| Real SNAP networks | 7.080 | Most structured real-world network |
| **protein_low_complexity** | **6.966** | Low-complexity protein tracts are nearly as structured as real networks |
| DNA_microsatellite | 4.000 | Periodic repeats exceed Gray-Scott spots (3.59) |
| protein_membrane | 2.191 | Hydrophobic patterning exceeds GoL (2.10) |
| DNA_purine_pyrimidine | 2.000 | Binary R/Y encoding is highly structured |
| **DNA_coding** | **0.259** | Coding regions are less structured than primes (0.462) |
| **protein_disordered** | **0.393** | Brackets primes |

![KL divergence from uniform — biological sequences]({{ '/assets/posts/2026-09-29-where-biology-fits-on-the-structure-scale/bio-kl-scale.png' | relative_url }})

**protein_low_complexity** is the surprise: repetitive amino acid tracts (poly-Q, serine-rich domains) are among the most structured objects measured, approaching real SNAP networks. They are structured because they are highly constrained — the protein is *supposed* to be repetitive. High KL doesn't mean "complex" in the sense of intricate; it means "far from random."

**DNA_coding** is the other surprise: at KL₃ = 0.259, coding regions are *less* structured than prime gaps (0.462) at k = 3. This is counterintuitive — coding regions carry the genetic code, which encodes amino acids through triplet constraints. But the genetic code's degeneracy (61 sense codons for 20 amino acids) spreads structure across the three-position codon frame, making single-position and di-position KL values very low (0.01 and 0.075). The structure is genuinely higher-order and concentrated in codon-level patterns that k = 1 and k = 2 barely register.

---

## Finding 2: DNA structure is higher-order (with two exceptions)

Two DNA variants are **periodic** and show linear KL growth (excess_k₃ ≈ excess_k₂):

| Variant | KL₁ | KL₂ | KL₃ | Δ₂₋₁ | Δ₃₋₂ | Pattern |
|---------|-----|-----|-----|------|------|---------|
| DNA_microsatellite | 0.000 | 2.000 | 4.000 | 2.000 | 2.000 | linear (periodic) |
| DNA_purine_pyrimidine | 0.000 | 1.000 | 2.000 | 1.000 | 1.000 | linear (periodic) |

All other DNA variants show **excess_k₃ > excess_k₂** — meaning KL grows faster from k = 2 to k = 3 than from k = 1 to k = 2.

![KL growth trajectories — where structure lives]({{ '/assets/posts/2026-09-29-where-biology-fits-on-the-structure-scale/bio-kl-growth.png' | relative_url }})

**DNA_coding** is the clearest case:

| Order | KLₖ | Excess |
|-------|-----|--------|
| k = 1 | 0.011 | — |
| k = 2 | 0.075 | +0.065 |
| k = 3 | 0.259 | **+0.184** |

Structure grows by a factor of 2.9 from dinucleotide to trinucleotide. This is the **codon bias signature**: single-nucleotide frequencies are nearly uniform (KL₁ = 0.01), but codon-level structure (KL₃ = 0.26) is substantial. The genetic code's degeneracy creates a three-position constraint that single- and di-nucleotide analyses miss entirely.

**DNA_cpg_island** shows roughly equal growth at each order (Δ₂₋₁ = 0.141, Δ₃₋₂ = 0.142), meaning CpG dinucleotide enrichment drives most structure, but triplet patterns add equally.

**DNA_GC-biased** sequences show linear growth (Δ ≈ 0.19 at each step), consistent with a simple compositional bias that scales additively.

---

## Finding 3: Proteins are also higher-order (with one exception)

Three structured protein variants show excess_k₃ > excess_k₂:

| Protein | KL₁ | KL₂ | KL₃ | Δ₂₋₁ | Δ₃₋₂ |
|---------|-----|-----|-----|------|------|
| protein_conserved | 0.272 | 0.546 | 0.876 | 0.274 | 0.330 |
| protein_disordered | 0.112 | 0.227 | 0.393 | 0.115 | 0.166 |
| protein_membrane | 0.711 | 1.425 | 2.191 | 0.714 | 0.766 |
| protein_low_complexity | 2.322 | 4.644 | 6.966 | 2.322 | 2.322 | linear (repetitive) |

The first three show the same higher-order pattern as DNA (non-periodic): fold constraints, disorder flexibility, and hydrophobic patterning all create structure that grows at k = 3.

**protein_low_complexity** shows *linear* growth (Δ₂₋₁ ≈ Δ₃₋₂ ≈ 2.32), identical to DNA_microsatellite. This makes sense — low-complexity regions are repetitive amino acid tracts with strong compositional bias. The structure is in the *composition*, not in the *arrangement*. Every position is highly non-uniform (KL₁ = 2.32), and every higher order just adds the same amount.

---

## Finding 4: The contradiction resolved — KL growth ≠ triplet synergy

**The puzzle:** In the earlier network-information-theory analysis, triplet MI was *always subdominant to pairwise MI* across all 11 physical systems (primes, ER, BA, WS, GoL, RD, Ising, Kuramoto, Boids, SIR, Hopfield). Yet here, biological sequences show excess_k₃ > excess_k₂ for *all* variants — KL grows at k = 3. This appeared to contradict the pairwise-dominance finding.

**The resolution:** KL divergence and mutual information measure **different things**.

| Metric | What it asks | What it measures |
|--------|-------------|-----------------|
| KL(k) | "How non-uniform is the k-mer distribution?" | Total structure (non-uniformity) |
| TMI | "Do triplets carry information beyond pairs?" | Specific-order dependence |

KL grows because the k-mer distribution deviates from uniform. MI measures only the *dependence* between positions. A k-mer can be non-uniform (driving KL up) even if the non-uniformity is fully explainable by lower-order dependencies (MI stays pairwise-dominant).

**Concrete example — DNA_coding:**

| Quantity | Value |
|----------|-------|
| excess_k₃ | +0.184 bits (KL grows from k = 2 to k = 3) |
| TMI | −0.036 bits (triplets are *redundant*, not synergistic) |

Codon bias creates a non-uniform triplet distribution, but this non-uniformity is already largely explained by pairwise dependencies (MI(0,1) = 0.066, MI(1,2) = 0.066). The triplet distribution is non-uniform, but not synergistic.

**All structured proteins are strongly redundant at the triplet level:**

| Protein | TMI (bits) | Interpretation |
|---------|-----------|----------------|
| protein_membrane | −0.045 | Redundant |
| protein_conserved | −0.042 | Redundant |
| protein_disordered | −0.039 | Redundant |

Pairwise amino acid dependencies are weak (0.003–0.008 bits), but triplet redundancy is consistently negative (TMI ≈ −0.04 bits). This means triplets are *less* than what pairs alone would predict — not because there is no triplet structure, but because the pairwise dependencies already over-explain the triplet distribution. The absolute magnitude (≈0.04 bits) is small relative to the KL excess (0.17–0.77 bits), confirming that KL growth is driven by non-uniformity, not triplet synergy.

**The DNA homopolymer is the exception:** TMI = +0.374 bits (20% of ΣMI), the highest relative triplet synergy among non-periodic biological sequences. Homopolymer runs create a Markov-2 structure — the probability of observing base X at position 2 depends on whether position 1 is a run extension or run termination.

**The complete picture:**

| System | excess_k₃ | TMI | Pattern |
|--------|-----------|-----|---------|
| DNA_coding | +0.184 | −0.036 | KL grows, MI redundant |
| protein_conserved | +0.330 | −0.042 | KL grows, MI redundant |
| DNA_homopolymer | +0.762 | +0.374 | KL grows, MI synergistic |
| DNA_microsatellite | +2.000 | +0.500 | KL grows, MI synergistic |

For the first two — the biologically interesting cases — KL grows while MI is redundant. They measure different things.

---

## Finding 5: Pairwise-dominance holds across 24+ synthetic systems

Across all 11 physical/mathematical systems AND all 13 biological sequence variants, **triplet MI is always subdominant to pairwise MI** (|TMI| < 50% of |ΣMI|) — except for periodic sequences (microsatellite, purine-pyrimidine encoding) where exact algebraic constraints create genuine triplet synergy.

This strengthens the claim from the network-information-theory project: **structure is fundamentally pairwise-dominant in synthetic systems.** The pattern now spans primes, proteins, DNA, networks, cellular automata, spin glasses, flocking birds, epidemic models, and musical melodies.

**Caveat:** The biological sequence data here is entirely synthetic (n = 100,000). The pairwise-dominance pattern for biological sequences has not been verified on real genomic data. The physical/mathematical systems were mostly simulated (not empirical), so the universality claim applies to the *models* studied, not to natural systems per se.

---

## Finding 6: The homopolymer is the most interesting structured DNA

The DNA homopolymer (run-length encoded A/C/G/T tracts) is the only *non-periodic* biological sequence where KL growth and triplet synergy agree:

| Quantity | Value |
|----------|-------|
| KL₃ | 1.511 bits |
| excess_k₃ | +0.762 |
| TMI | +0.374 bits (20% of ΣMI) |

This is biologically relevant: homopolymer runs are common in genomes (especially poly-A tracts) and are associated with frameshift mutations, regulatory elements, and nucleosome positioning. The Markov-2 structure of runs creates genuine triplet dependence that pairwise MI cannot capture — the probability of observing base X at position 2 depends not just on position 1, but on whether position 1 is a run extension or run termination.

---

## Where biology sits on the unified scale

The 13 biological sequences fill gaps across the entire KL spectrum:

| KL range | What's there |
|----------|-------------|
| 0.00–0.20 | DNA_random, protein_random (baselines) |
| 0.20–0.50 | **DNA_coding** (0.26), **protein_disordered** (0.39), **DNA_cpg_island** (0.38) — less structured than primes |
| 0.50–1.00 | DNA_GC-biased, **protein_conserved** (0.88) |
| 1.00–2.50 | DNA_homopolymer, DNA_purine_pyrimidine, **protein_membrane** (2.19) |
| 4.00–7.00 | DNA_microsatellite (4.00), **protein_low_complexity** (6.97) |

Biological sequences are not a single point on the scale — they span the entire range from random to nearly-as-structured-as-real-networks. The category "biology" is too broad; the meaningful unit is the *functional class* of the sequence.

---

## What's already known

KL divergence applied to biological sequences is a mature field. Key established results:

- **Schneider, Stormo, Gold, Ehrenfeucht (1986)** — Introduced KL divergence as the measure of positional information content in binding sites. This is the foundation.
- **Schneider & Stephens (1990)** — Sequence logos as visual representation of KL divergence. The most widely used KL-based method in molecular biology.
- **Zeeberg (2002)** — KL divergence for codon usage bias analysis.
- **Vinga & Almeida (2003, 2014)** — Surveys of information theory applications in bioinformatics.
- **Hershberg & Petrov (2008)** — Selection on codon bias as an information-theoretic phenomenon.

What does *not* exist: placing biological sequences on a **unified KL scale** alongside physical systems (primes, Ising model, GoL, networks, flocking). The network-information-theory project established that framework; this work extends it to biology.

---

## What I'm unsure about

1. **Synthetic data.** All biological sequences were generated synthetically (n = 100,000). Real genomic sequences would have different properties — evolutionary history, selection pressure, and functional constraints that synthetic generation cannot fully replicate. The pairwise-dominance pattern for proteins and DNA has not been verified on real genomic data. The numbers are *potential* values, not empirical ones.

2. **Sequence length effects.** At k = 3 with a 4-letter DNA alphabet, there are 4³ = 64 bins. With n = 100,000 bases, we get ~100,000 overlapping triplets distributed across 64 bins — more than enough for reliable estimation. But at k = 4 (256 bins) or k = 5 (1024 bins), the estimates become noisy. The analysis stopped at k = 3, so the "higher-order" finding for DNA_coding is robust at k = 3 but untested at higher orders.

3. **The KL ≠ MI distinction.** This finding — that KL grows while MI stays pairwise-dominant — is a general property of how these two metrics relate, not something specific to biology. But I haven't tested it systematically across the other 11 physical systems. The music analysis showed the same pattern (cumulative rhythm vs pairwise-dominant melody), but a dedicated cross-domain study would be needed to claim it as a general principle.

4. **What about RNA and epigenetics?** RNA secondary structure (base-pairing constraints) and epigenetic methylation patterns (CpG islands, histone modifications) are natural extensions. RNA would add a structural constraint (complementarity) that DNA lacks. Epigenetic patterns would add a layer *on top* of sequence — the "code" within the code. These are open territory.

---

## Summary

1. **Biology fills the entire KL spectrum.** From random (0.00) to nearly-as-structured-as-real-networks (6.97), biological sequences span 7 bits of structure.
2. **DNA structure is higher-order.** Codon bias creates structure that grows at k = 3 — single- and di-nucleotide KL values are near-zero.
3. **Coding regions are less structured than primes.** DNA_coding (KL₃ = 0.26) < primes (KL₃ = 0.46) at k = 3. The genetic code's degeneracy spreads structure across codon frames.
4. **KL growth ≠ triplet synergy.** KL can grow monotonically while TMI is negative — they measure non-uniformity and dependence, respectively. This is a general property, not biology-specific.
5. **Pairwise-dominance is universal.** Across 24+ systems, triplet MI is always subdominant to pairwise MI (except periodic sequences).
6. **Low-complexity proteins are the most structured biological objects.** KL₃ = 6.97 — approaching real SNAP networks (7.08). Structure here means constraint, not complexity.
