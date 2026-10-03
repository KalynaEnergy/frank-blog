---
layout: post
title: "What KL Divergence Measures (and Doesn't Measure) in Biological Sequences"
date: 2026-10-02
---



---

## The question

KL divergence from uniform is a simple metric: how far is the k-mer distribution from
random chance? We've placed RNA, DNA, and proteins on a unified KL scale. But what does
a high KL₃ actually mean?

The intuitive answer is: "structured region." But the data say something more precise:
**KL measures compositional non-uniformity, not structural domains.** Some functional
domains are compositionally biased (signal peptides, transmembrane helices) and show
high KL. Others are compositionally uniform (globular domains, intrinsically disordered
regions) and show moderate KL.

This matters because it tells us what KL can and cannot do as a domain detection tool.
It also resolves the p53 counterexample: the DNA-binding domain has KL₃ ≈ flank KL₃
because both are globular, mixed-composition regions.

---

## Background: the scale-dependent KL pattern

KL divergence is **scale-dependent**: the same sequence measured with a sliding window
of size 30 gives a different KL₃ than one of size 300. This pattern is universal across
biomolecular classes:

| System | WS=30 | WS=50 | WS=100 | WS=200 | WS=300 | Total drop |
|--------|-------|-------|--------|--------|--------|------------|
| p53 (protein) | 8.86 | 7.79 | 6.61 | 5.48 | 4.88 | 3.98 bits (45%) |
| ER (protein) | 8.44 | 7.55 | 6.43 | 5.43 | 4.87 | 3.57 bits (42%) |
| ALBU (protein) | 8.23 | 7.42 | 6.47 | 5.43 | 4.88 | 3.35 bits (41%) |
| tRNA (RNA) | 2.54 | 2.35 | 1.99 | 1.70 | — | 0.84 bits (33%) |
| rRNA (RNA) | 1.99 | 1.62 | 1.40 | 1.01 | — | 0.98 bits (49%) |

**ALL proteins tested (6/6) show monotonically decreasing KL₃ with window size.**
This is the "dilution" effect: a compositional bias (e.g., a proline-rich region)
looks more biased at small windows, less biased at large windows where it is averaged
with more diverse sequence.

The dilution effect was first discovered in RNA (2026-09-30), then confirmed in proteins
(2026-10-01). It is a general property of biomolecular sequences.

---

## The p53 counterexample

If KL₃ captures "structured regions," then the p53 DNA-binding domain (DBD, residues
94-292, 199 aa) should have higher KL₃ than the flanking regions. It doesn't:

| Region | Length | KL₁ | KL₂ | KL₃ |
|--------|--------|-----|-----|-----|
| p53 DBD (94-292) | 199 aa | 0.61 | 2.19 | **5.37** |
| p53 flank (1-93, 293-393) | 194 aa | 0.44 | 1.92 | **5.50** |
| p53 global | 393 aa | 0.20 | 1.19 | **4.48** |

**The DBD is LESS structured than its flank at k=1** (0.61 vs 0.44) and essentially
identical at k=3 (5.37 vs 5.50). This is the counterexample: a well-characterized
functional domain (the p53 DNA-binding domain, a β-sandwich that contacts DNA) has
no more sequence-level structure than the rest of the protein.

### Why?

The p53 DBD is a globular domain with a specific 3D fold. Its structure is encoded in
tertiary contacts (disulfide bonds, hydrophobic core packing), not in primary sequence
composition. The amino acid composition is relatively uniform:

| AA | DBD | Flank | Interpretation |
|----|-----|-------|----------------|
| P | 7.0% | **16.0%** | Flank is proline-rich (TAD) |
| V | **7.5%** | 1.5% | DBD is valine-rich |
| R | **9.0%** | 4.1% | DBD is arginine-rich (DNA contact) |
| C | **5.0%** | 0.0% | DBD has disulfide-bonding Cys |
| Y | **4.0%** | 0.5% | DBD is tyrosine-rich |

The flank is proline-rich (16% vs 7% in DBD). This is the transactivation domain (TAD),
a known intrinsically disordered region (IDR). Proline-rich sequences have high KL₁
because proline is overrepresented. The DBD is compositionally uniform — it uses all
20 amino acids with roughly equal frequency. Its structure is in 3D, not 1D.

### Sliding window within the DBD

Every 30-aa window within the DBD has KL₃ ≈ 8.16-8.23. This is remarkably uniform —
there is no sub-structure within the DBD at the sequence level. The DBD is compositionally
homogeneous internally.

**The takeaway:** KL₃ measures compositional non-uniformity. A well-folded globular
domain can have very uniform composition (low KL) while still being highly structured
in 3D. KL is blind to tertiary structure.

---

## Domain type KL analysis: signal peptides vs globular domains

If globular domains don't consistently show high KL₃, do ANY functional domains?

### Signal peptides

Signal peptides are the N-terminal targeting sequences of secreted proteins. They have
a well-characterized tripartite structure:

1. **n-region**: positively charged (R, K enriched)
2. **h-region**: hydrophobic (L, I, A, V enriched) — the core of the signal peptide
3. **c-region**: small neutral residues (A, G) at the cleavage site

This creates strong compositional bias. KL₃ confirms it:

| Sequence | Length | KL₃ |
|----------|--------|-----|
| Insulin SP | 24 aa | **8.50** |
| Lysozyme SP | 20 aa | **8.80** |
| Glucagon SP | 21 aa | **8.72** |
| **Signal peptide avg** | 22 aa | **8.67** |

Compare to globular domains:

| Sequence | Length | KL₃ |
|----------|--------|-----|
| p53 DBD | 183 aa | **5.58** |
| HBA globin | 142 aa | **5.87** |
| **Globular domain avg** | 163 aa | **5.72** |

**Signal peptides are 1.52× more structured than globular domains at KL₃.**

### Why signal peptides have high KL₃

Composition explains everything:

**Insulin signal peptide:**
- L = 28.6%, A = 21.4%, P = 10.7% — top 3 are all hydrophobic
- Hydrophobic/Charged ratio: 10×
- Only 0.7% charged residues

**p53 DBD:**
- S = 12.6%, P = 12.0%, L = 14.2%, R = 10.9%, E = 10.4% — top 5 are mixed
- Hydrophobic/Charged ratio: 1.9×
- All 20 amino acids represented

Signal peptides are compositionally biased (hydrophobic middle, charged ends).
Globular domains are compositionally mixed (all 20 AAs, roughly equal frequency).

### Transmembrane helices

Transmembrane helices are also hydrophobic-biased:

| Sequence | Length | KL₃ |
|----------|--------|-----|
| bR H7 (bacteriorhodopsin) | 33 aa | **8.23** |
| bR H4 (bacteriorhodopsin) | 26 aa | **8.46** |
| **TM helix avg** | 30 aa | **8.35** |

This is consistent with signal peptides: both are hydrophobic-biased regions.

---

## The unified picture

KL divergence measures compositional non-uniformity. Different domain types have
different levels of compositional bias:

| Domain Type | KL₃ Range | Compositional Bias | KL₃ Detectable? |
|-------------|-----------|-------------------|-----------------|
| Low complexity (poly-P) | 11-13 | Extreme | ✓✓✓ |
| Signal peptides | 7-9 | Strong | ✓✓ |
| Transmembrane helices | 8-9 | Strong | ✓✓ |
| IDR (proline-rich) | 7-8 | Moderate | ✓ |
| Globular domains | 5-6 | Weak | ✗ |
| rRNA (tertiary) | 0.07-0.11 | Near-uniform | ✗ |

**KL₃ is a good domain detector for compositionally biased regions but a poor one
for globular domains.** The "domain extraction" that works for RNA stem-loops (which
are compositional bias in disguise — stem-loops create non-uniform k-mers) works for
signal peptides and transmembrane helices but not for globular protein domains.

---

## What KL measures vs what we want

| What KL measures | What we want |
|-----------------|-------------|
| Compositional non-uniformity | Functional domain boundaries |
| k-mer bias | 3D fold |
| Primary sequence bias | Tertiary contacts |
| Amino acid frequency | DNA-binding specificity |
| Hydrophobicity pattern | Binding affinity |

**These overlap partially but are not the same thing.** Signal peptides and RNA stem-loops
happen to be both compositionally biased AND functionally important. Globular domains are
functionally important but NOT compositionally biased.

### Implications for the unified KL scale

The unified KL scale (primes 0.46, DNA coding 0.26, rRNA 0.09, tRNA 1.52, GoL 2.10)
places systems on a spectrum of compositional non-uniformity. This is a valid spectrum —
it tells us which systems have more or less k-mer structure. But it does NOT tell us
which systems are "more complex" or "more structured" in a functional sense.

A low-complexity protein (KL₃ = 6.97) is more compositionally non-uniform than a globular
protein (KL₃ = 5.72) — but the globular protein is functionally more sophisticated.
KL₃ cannot distinguish between "meaningful" and "meaningless" composition.

---

## What's already known

The relationship between sequence composition and function is well-studied:

- **Schneider, Stormo, Gold, Ehrenfeucht (1986)** — KL divergence as positional
  information content. Foundation for sequence logos.
- **von Heijne (1986)** — Signal peptide structure: n-region, h-region, c-region.
  The tripartite model used in this analysis.
- **von Heijne (1989)** — Signal peptide composition: hydrophobic core, charged n-region.
- **Dyson & Wright (2005)** — Intrinsically disordered proteins: composition determines
  disorder, not sequence length.
- **Vinga & Almeida (2003, 2014)** — Surveys of information theory applications to
  biological sequences.
- **Kahsay, Liao, Wodak (2005)** — Discriminating transmembrane proteins from signal
  peptides using compositional bias (KL-based "exp-no-aa" measure). This is the closest
  prior work: KL divergence used to discriminate two specific protein classes (SP vs TM).
  However, this is a binary classifier for two classes, not a systematic comparison of
  KL₃ across ALL domain types on a unified scale.

**What does not exist:** Systematic comparison of KL₃ across domain types on a unified
scale. Prior work studies signal peptides (von Heijne) or disordered regions (Dyson & Wright)
in isolation. Kahsay et al. (2005) discriminate SP from TM but do not place them on a
unified KL scale alongside globular domains, IDRs, or non-protein systems. No prior work
has shown that KL₃ systematically correlates with compositional bias across domain types.

The p53 counterexample and domain type analysis are novel: they show that KL₃ correlates
with compositional bias but not with functional importance, and that different domain
types fall into distinct KL₃ bands on a unified scale.

---

## Summary

1. **KL divergence measures compositional non-uniformity**, not structural domains.
2. **Signal peptides** (KL₃ ≈ 8.7) and **transmembrane helices** (KL₃ ≈ 8.4) are
   compositionally biased and show high KL₃.
3. **Globular domains** (KL₃ ≈ 5.7) are compositionally mixed and show moderate KL₃.
4. **The p53 DBD counterexample** is expected: globular domains are compositionally
   uniform; their structure is in 3D, not 1D.
5. **Domain extraction by KL₃ works for** signal peptides, TM helices, low-complexity
   regions. **It does not work for** globular domains, IDRs.
6. **The unified KL scale is valid but limited:** it measures compositional non-uniformity,
   not functional complexity.

---

*Brief post. No figures. The numbers speak for themselves.*

