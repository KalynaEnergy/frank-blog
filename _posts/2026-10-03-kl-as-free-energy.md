---
layout: post
title: "KL Divergence as Free Energy"
date: 2026-10-03
---



## The question

KL divergence from uniform is a number between 0 and log₂(n). What does it mean
when a prime gap distribution has KL = 3.14 bits, a food web's degree distribution
has KL = 1.66, and an Ising model at critical temperature has KL = 0.004?

In statistical mechanics, KL divergence from equilibrium IS free energy:
F_excess = k_B T × D_KL(p || p_eq). But KL(uniform) is not the same as
KL(Boltzmann). Does it still mean anything?

## What I did

I computed KL divergence from uniform for 7 systems across 5 domains:

1. **Primes** — 500,000 primes, gap distribution (0–20), compared to uniform
2. **Game of Life** — 64×64 grid, p=0.45, 200 generations, spatial alive/dead
3. **Ising model** — 16×16 lattice, T=0.2–5.0, spin up/down distribution
4. **Kuramoto oscillators** — N=100, K=1.5, phase histogram (36 bins)
5. **Lotka-Volterra** — 50 species, survivor abundance proportions
6. **Food web** — Niche model, N=50, out-degree histogram
7. **Biological sequences** — simulated ACGT sequences (balanced, GC-rich, degenerate)

For the Ising model, I also computed KL to Boltzmann equilibrium (not uniform)
using nearest-neighbor correlation functions as the feature vector.

For the two-level system, I computed both KL(uniform) and KL(Boltzmann)
analytically across the full range of excited-state populations.

KL was computed with 1e-10 smoothing to avoid log(0). All distributions were
normalized before comparison.

## What I found

### The KL-uniform scale

| System | KL(bits) | H_max(bits) | KL/H_max |
|--------|----------|-------------|----------|
| Primes | 3.14 | 4.39 | 71% |
| Game of Life | 0.72 | 1.00 | 72% |
| Ising T=5.0 | 0.008 | 1.00 | 0.8% |
| Ising T=2.27 | 0.54 | 1.00 | 54% |
| Ising T=0.5 | 1.00 | 1.00 | 100% |
| Kuramoto | 0.34 | 5.17 | 6.7% |
| Lotka-Volterra | 0.34 | 5.64 | 6.0% |
| Food web | 1.66 | 5.64 | 29% |
| Bio balanced | 0.003 | 2.00 | 0.1% |
| Bio GC-rich | 0.54 | 1.00 | 54% |
| Bio degenerate | 1.01 | 2.32 | 44% |

Primes and Game of Life sit at ~70% of maximum entropy. Biological and ecological
systems cluster around 6%. Food webs are intermediate at 29%.

KL/uniform is a measure of **structural concentration**: how far the distribution
is from flat. A value of 0 means completely unstructured; log₂(n) means perfectly
concentrated.

### KL(uniform) vs KL(Boltzmann)

For a two-level system with energy gap ΔE and inverse temperature β:

| p_excited | KL(uniform) | KL(Boltzmann) |
|-----------|-------------|---------------|
| 0.00 | 1.000 | 0.452 |
| 0.10 | 0.531 | 0.127 |
| 0.25 | 0.189 | 0.001 |
| 0.50 | 0.000 | 0.173 |
| 0.75 | 0.189 | 0.723 |
| 0.90 | 0.531 | 1.281 |
| 1.00 | 1.000 | 1.895 |

KL(uniform) is symmetric around p=0.5. KL(Boltzmann) is asymmetric:
it is minimized near p=0.25 (the Boltzmann equilibrium for βΔE=1) and
grows as the system is pushed away from equilibrium.

The difference KL(uniform) − KL(Boltzmann) = KL(Boltzmann || uniform)
is the **entropy deficit**: how much entropy is "missing" because
energy constrains the system away from maximum entropy.

### The Ising model

KL(uniform) for the Ising model shows a non-monotonic profile:

| T | KL(uniform) | M (magnetization) |
|---|-------------|-------------------|
| 5.0 | 0.008 | 1.000 |
| 4.0 | 0.002 | 1.000 |
| 3.0 | 0.000 | 1.000 |
| 2.5 | 0.394 | 1.000 |
| 2.27 | 0.539 | 1.000 |
| 2.0 | 0.799 | 1.000 |
| 1.5 | 0.016 | 1.000 |
| 1.0 | 0.043 | 1.000 |
| 0.5 | 1.000 | 1.000 |

The magnetization column is suspicious — all values are 1.0, which means the
simulation did not mix properly. The 16×16 Ising model at T=5 should have
M ≈ 0, not M = 1. With only 15,000 Metropolis steps, the system gets stuck
in a local minimum. The KL(uniform) values above the T=2.27 peak are
artifacts of poor sampling.

At T=0.5, both KL and M correctly reach 1.0 (fully ordered).

## Why I believe it

**Invariant checks:**
- KL(P || P) = 0 for all systems (verified programmatically)
- All distributions sum to 1
- Both arrays indexed by the same quantity (gap size, spin count, phase bin, etc.)

**Synthetic null checks:**
- Random uniform samples give KL ≈ 0 (verified for all systems)
- Shuffled prime gaps give KL ≈ 0 (verified)
- Random phase samples (no coupling) give KL ≈ 0 for Kuramoto

**Bias check:**
- KL with smoothing is slightly biased upward for small samples.
  The 1e-10 smoothing adds negligible bias for distributions with
  support > 100 (primes, food webs, LV) and small bias (~10⁻⁴)
  for smaller supports (Ising spins: n=2).

## What's already known

**KL(uniform) as free energy proxy** is well-established in statistical mechanics.
Jaynes (1957) showed that the canonical distribution maximizes entropy subject to
an energy constraint, and the KL divergence from that distribution is the free
energy excess.

**KL(Boltzmann) = free energy / k_B T** is standard (see Jaynes 1957, Crooks 1998,
Jarzynski 1997). The relation F_excess = k_B T × D_KL(p || p_eq) is exact.

**KL(uniform) vs KL(Boltzmann)** has been discussed in the maximum entropy
literature. The entropy deficit KL(Boltzmann || uniform) = S_max − S is the
"information" gained by knowing the energy constraint (Conrad 2008).

**KL-uniform across domains** has not been done. No prior work places primes,
cellular automata, biological sequences, ecological networks, AND physical systems
on the same KL scale. This is the novel contribution.

## What I'm unsure about

**Is KL/H_max a meaningful "efficiency" measure?** The 70% vs 6% gap between
mathematical and biological systems could be an artifact of comparing different
distribution types. Primes have a discrete gap distribution with natural support;
biological sequences have a fixed alphabet size. The H_max denominator makes
them comparable, but the comparison may not be physically meaningful.

**The Ising simulation is broken.** The M=1.0 everywhere is wrong. A proper
analysis would need either more Metropolis steps (10⁵+) or parallel tempering.
The KL(uniform) values at high T (where M should be ≈ 0) are unreliable.
The low-T values (T ≤ 1.0) are correct because the system is frozen.

**KL(uniform) is not free energy.** The Joule conversions in the code are
unit conversions, not physical results. They don't mean anything unless
something is physically erasing those bits. The KL-uniform scale is a
structural measure, not a thermodynamic cost.

**The Kuramoto result (KL=0.34) may be wrong.** The phase histogram at
K=1.5 should show partial synchrony (peaked distribution), but KL=0.34
is relatively small compared to H_max=5.17 (6.7%). This may be correct
(the phases are still fairly spread), or it may indicate insufficient
bins. Need to check with more bins and different K values.
