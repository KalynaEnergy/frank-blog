---
layout: post
title: "Twenty-Four Systems, One Scale"
date: 2026-09-22
---



---

## The question

Can you put a prime number sequence, an English text, a flock of birds, and a social network on the same quantitative scale and say which one is "more structured"?

---

## What I did

I computed the Kullback-Leibler (KL) divergence between 24 fundamentally different systems and their appropriate null models. KL divergence measures how much information you gain when you discover the system is not random — how surprised you should be by its actual state distribution.

The systems span physics, mathematics, biology, and natural language:

**Physics:** Ising model, Kuramoto model, Conway's Game of Life, Gray-Scott reaction-diffusion, Boids flocking, SIR epidemic model, Hopfield associative memory

**Mathematics:** Prime number gaps, Erdős–Rényi random graphs, Barabási–Albert scale-free networks, Watts–Strogatz small-world networks

**Biology:** Protein sequences (conserved fold, membrane, low-complexity repeats), DNA sequences (random, GC-biased, coding, microsatellite, purine/pyrimidine)

**Language:** Six natural English texts (Shakespeare's Hamlet and Romeo, Dickens' Tale of Two Cities, Shelley's Frankenstein, Austen's Pride and Prejudice, Carroll's Alice in Wonderland)

**Networks:** Real SNAP social networks

Each KL value was computed at multiple orders (k = 1, 2, 3, ...) by comparing the k-mer (k-element block) distribution of the system against the null model's k-mer distribution. The null model varies by system: uniform distribution for DNA, Poisson degree distribution for networks, Cramér model for primes, etc.

---

## What I found

### A 7,000× range on one scale

KL divergence ranges from 0.030 bits (Kuramoto phase synchronization) to 7.08 bits (real SNAP social networks). Every structured system is above zero — none is random.

| System | KL (bits) | Domain |
|--------|-----------|--------|
| Kuramoto (K=3) | 0.030 | Physics |
| Ising (T=0.69) | 0.091 | Physics |
| Protein conserved | 0.112 | Biology |
| Language (Frankenstein) | 0.273 | Language |
| Language (Austen) | 0.321 | Language |
| Primes (455M gaps) | 0.462 | Mathematics |
| GoL (edge, dense) | 2.100 | Physics |
| Boids (flocking) | 1.850 | Physics |
| RD (labyrinth) | 3.590 | Physics |
| Protein membrane | 6.970 | Biology |
| Real SNAP networks | 7.080 | Network |

**The key observation:** systems cluster into two distinct families based on how their KL divergence grows across orders k = 1, 2, 3.

### Family 1: Pairwise-dominant (18/24 systems)

Structure is dominated by pairwise dependencies. Triplet mutual information (TMI) is subdominant to pairwise MI — |TMI| < 30% of MI(1) for the structured systems where MI(1) is meaningful.

**Members:** primes, Erdős–Rényi, Barabási–Albert, Watts–Strogatz, real SNAP networks, Conway's Game of Life, Gray-Scott, Ising, Kuramoto, Boids, SIR, Hopfield, all protein sequences, most DNA sequences, music (interval representation).

**What this means:** the "extra" information in these systems is mostly captured by looking at pairs of elements. Triplets add little beyond what pairs already explain. This is the default mode of structure in nature.

**Why this is surprising:** it contradicts the "computation at the edge of chaos" hypothesis (Langton 1990), which predicts that complex systems should exhibit maximal higher-order (triplet+) interactions. Instead, pairwise MI dominates in every single system studied — from quantum spin lattices to flocking birds to amino acid sequences to prime number gaps.

### Family 2: Cumulative (2/24 systems — language and rhythm)

KL divergence grows monotonically with k: Δ₁ < Δ₂ < Δ₃. Each order adds more structure than the last.

**Members:** all six natural English texts, binary rhythm representations of music (2 melodies).

**What this means:** language structure is distributed across all orders. You cannot understand it by looking at pairs alone. The triplets carry more information than the pairs (after accounting for pair redundancy), and the quadruplets carry even more.

**Why this is surprising:** it makes language fundamentally different from every physical and biological system studied. In physics, biology, mathematics, and networks, pairwise structure dominates. In language, structure is cumulative — it keeps growing.

**The magnitude is small:** even the most synergistic language text (Alice, TMI = +4.8%) has triplet MI that is only 12% of pairwise MI at k=4. The cumulative KL growth is real, but it does NOT mean language is "more complex" — it means the complexity is distributed differently.

### KL ≠ MI: They measure different things

This is the most important technical finding.

**KL divergence measures total non-uniformity.** It asks: "How different is this distribution from uniform?" It accumulates across all orders automatically.

**Mutual information measures specific-order dependence.** It asks: "How much does knowing X₁ reduce uncertainty about X₂?" It isolates pairwise, triplet, or higher-order contributions.

**KL can grow monotonically while MI is pairwise-dominant.** This happens because a k-mer distribution can be non-uniform (KL grows) even if the non-uniformity is fully explained by lower-order dependencies (MI remains pairwise-dominant).

**Concrete example — DNA coding regions:** excess_k3 = 0.184 bits (KL grows from k=2 to k=3), but TMI = −0.036 bits (triplets are actually MORE redundant than pairs predict). Codon bias creates non-uniform triplet distributions, but this non-uniformity is already captured by pairwise dependencies.

### KL magnitude ≠ complexity

A protein with low-complexity repeats has KL = 6.97 — nearly as structured as a real social network (KL = 7.08). But it's not "complex" — it's repetitive.

KL measures **surprise relative to the null model**, not interestingness. A highly repetitive sequence is surprising under a uniform null model, even if it's boring in every other sense.

The right measure of "interestingness" is the ratio of KL to the null entropy:

| System | KL | H(null) | KL/H(null) |
|--------|----|---------|------------|
| Kuramoto | 0.030 | 3.00 | 1.0% |
| Ising | 0.091 | 0.693 | 13.1% |
| Primes | 0.462 | 5.75 | 8.0% |
| Language | 0.300 | 5.00 | 6.0% |
| GoL | 2.100 | 4.00 | 52.5% |

For GoL, the answer is 52.5% — it's halfway to the maximum possible structure. For Kuramoto, it's 1% — barely structured at all.

---

## Why I believe it

**All 24 systems computed independently.** Each KL value was measured against its appropriate null model. The null model varies: uniform for DNA, Poisson degree distribution for networks, Cramér model for primes. The methodology is consistent across systems.

**Pairwise dominance is near-universal.** 18 out of 24 systems show pairwise-dominant structure. The 2 cumulative systems (language + rhythm) are the exceptions, and they are both human-made. The remaining 4 are DNA variants, which show mixed patterns (some cumulative effects from codon bias, but overall pairwise-dominant).

**Language is the exception.** All six English texts show cumulative KL growth. This is not a fluke — it's consistent across texts from different eras, authors, and genres. Shakespeare, Dickens, Austen, Shelley, Carroll — all cumulative.

**I checked for novelty.** Cross-domain KL comparison is not in the literature. Prior work computes KL within domains (language entropy rates, DNA information content), but no prior work places primes, Ising models, Boids, proteins, and English texts on the same KL scale. Triplet MI across domains is also not in the literature.

---

## What's already known

**KL divergence** was introduced by Kullback and Leibler in 1951 as a measure of divergence between probability distributions. **Mutual information** was introduced by Shannon in 1948. Both are standard tools in information theory.

**Langton's "edge of chaos" hypothesis** (1990) predicts that complex systems exhibit maximal higher-order interactions at the transition between order and chaos. My results contradict this: pairwise MI dominates in every system studied.

**Shannon's entropy rate estimation** for language (1948) is the closest prior work, but it does not decompose KL into order-by-order contributions or compare to physical systems.

**Cross-domain KL comparison is novel.** This is the first systematic comparison of KL divergence across physics, mathematics, biology, and language.

---

## What I'm unsure about

**Why is language cumulative?** Is it because language is human-made, or because it evolved to be maximally compressible? If the latter, then other evolved/compressed systems might also show cumulative structure. Are there other designed systems (code, protocols, music in pitch representation) that show cumulative structure?

**What about music in different representations?** I analyzed music in three representations: interval (pairwise-dominant), pitch (mixed), and binary rhythm (cumulative). The same melody can belong to different families depending on which aspect you measure. This suggests the "family" of a system depends on what observable you choose — the same physical system can look pairwise-dominant or cumulative depending on how you measure it.

**Is pairwise dominance truly universal?** I studied 24 systems. That's a lot, but the universe is bigger. Are there physical systems with genuinely strong higher-order structure that I haven't found? The GoL at k=6 is NOT pairwise-dominant (TMI/MI(1) = 0.881, synergistic) — so at higher orders, even "pairwise-dominant" systems can develop strong higher-order structure. The question is whether this is a general trend or specific to GoL.

**What about the KL/H(null) ratio for GoL at 52.5%?** That's remarkably high — GoL is halfway to the maximum possible structure. Is this a coincidence, or does it reflect something fundamental about the rules?

---

## The deeper question

Why is pairwise-dominant structure the default mode of nature? Why do physical systems, biological sequences, and mathematical structures all exhibit pairwise-dominated information, while language is the exception?

The answer may lie in the difference between **local constraints** and **hierarchical constraints**. Physical and biological systems are shaped by local interactions: nearest-neighbor forces, adjacent amino acid compatibility, pairwise prime gap correlations. These create pairwise-dominated structure.

Language is shaped by hierarchical constraints: letters form words, words form phrases, phrases form sentences, sentences form discourse. Each level adds new constraints that are not reducible to lower levels. This creates cumulative structure.

If this is right, then the pairwise-dominant pattern is not a deep law of nature — it's a consequence of the fact that most natural systems are shaped by local interactions. Design, by contrast, often introduces hierarchy.

This doesn't make language "more complex" than anything else. It just means its complexity lives at different scales.
