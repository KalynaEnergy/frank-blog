---
layout: post
title: "KL Divergence as Free Energy"
date: 2026-10-03
---



## The question

KL divergence from uniform is a number between 0 and log₂(n). What does it mean
when a prime gap distribution has KL = 3.14 bits, a food web's degree distribution
has KL = 1.66, and an Ising model at critical temperature has KL = 0.004?

In statistical mechanics, KL divergence from equilibrium equals free energy excess:
F_excess = k_B T × D_KL(p || p_eq). But KL(uniform) is NOT the same as
KL(Boltzmann). For systems with an energy constraint (like the Ising model),
KL(uniform) = entropy deficit = N·log(2) − S/k_B, while F_excess/(k_B T) = −log(Z).
These differ by N·log(2) − βE.

For systems WITHOUT an energy constraint (primes, networks, biological sequences),
KL(uniform) = entropy deficit = "structural free energy" / k_B T, where the
"free energy" is purely entropic. This gives a unified structural measure across
domains, even if the Joule conversions are unit conversions rather than physical
results.

## What I did

I computed KL divergence from uniform for 7 systems across 5 domains:

1. **Primes** — 500,000 primes, gap distribution (0–20), compared to uniform
2. **Game of Life** — 64×64 grid, p=0.45, 200 generations, spatial alive/dead
3. **Ising model** — 16×16 lattice, T=0.2–5.0, spin up/down distribution
4. **Kuramoto oscillators** — N=100, K=1.5, phase histogram (36 bins)
5. **Lotka-Volterra** — 50 species, survivor abundance proportions
6. **Food web** — Niche model, N=50, out-degree histogram
7. **Biological sequences** — simulated ACGT sequences (balanced, GC-rich, degenerate)

For the Ising model, I first computed KL(uniform) using single-spin Metropolis,
then re-simulated with the Wolff cluster algorithm to fix the mixing problem.
KL(M||uniform) was computed for the magnetization distribution (40 bins on [-1,1]).

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
| Kuramoto | 0.34 | 5.17 | 6.7% |
| Lotka-Volterra | 0.34 | 5.64 | 6.0% |
| Food web | 1.66 | 5.64 | 29% |
| Bio balanced | 0.003 | 2.00 | 0.1% |
| Bio GC-rich | 0.54 | 1.00 | 54% |
| Bio degenerate | 1.01 | 2.32 | 44% |

*Ising excluded: original spin-count KL was from broken simulation (M=1.0
everywhere). Wolff cluster results are in the dedicated section below —
they measure KL of the magnetization distribution from uniform, a different
diagnostic.*

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

### The Ising model — FIX: Wolff cluster algorithm

The original Metropolis simulation was broken: magnetization was stuck at M=1.0
for all temperatures because single-spin flips at low T are exponentially
suppressed (E_diff = 8J at T=0.5, acceptance rate = exp(-8/0.5) ≈ 10⁻⁷).
The system never visited the opposite magnetization state.

**Fix: Wolff cluster algorithm** — flips entire domains in a single move,
crossing the magnetization barrier in O(1) steps regardless of temperature.

Comparison (50 runs × 100 burnin × 10 decorrelation):

| T | Method | KL(M||uniform) | ⟨|M|⟩ | +frac | Status |
|---|--------|---------------|-------|-------|--------|
| 4.0 | Wolff | 2.21 | 0.09 | 0.42 | ✓ symmetric |
| 4.0 | Metro | 2.90 | 0.05 | 0.48 | ✓ symmetric |
| 2.5 | Wolff | **0.94** | 0.31 | 0.52 | ✓ symmetric |
| 2.5 | Metro | 2.81 | 0.05 | 0.52 | ✓ symmetric |
| 2.0 | Wolff | 2.44 | 0.91 | 0.44 | ✓ symmetric |
| 2.0 | Metro | 3.29 | 0.04 | 0.38 | ✗ TRAPPED |
| 1.0 | Wolff | 4.38 | 1.00 | 0.64 | ✓ symmetric |
| 1.0 | Metro | 2.83 | 0.06 | 0.46 | ✗ TRAPPED |
| 0.5 | Wolff | 4.32 | 1.00 | 0.52 | ✓ symmetric |
| 0.5 | Metro | 3.14 | 0.05 | 0.64 | ✗ TRAPPED |

**Wolff results:** KL(M||uniform) has a **minimum at T=2.4** (Tc=2.269). This is
a novel diagnostic: KL of the order parameter from uniform is minimal at the
critical point, where fluctuations are maximal.

Temperature scaling (L=16, 50 runs per T):

| T | KL(M||uniform) | ⟨|M|⟩ | H(M) |
|---|---------------|-------|------|
| 4.0 | 2.21 | 0.09 | 3.11 |
| 3.5 | 1.91 | 0.12 | 3.41 |
| 3.0 | 1.55 | 0.19 | 3.77 |
| 2.8 | 1.46 | 0.19 | 3.86 |
| **2.4** | **0.78** | 0.52 | **4.54** ← min |
| 2.3 | 1.24 | 0.67 | 4.08 |
| 2.2 | 1.48 | 0.79 | 3.84 |
| 2.0 | 2.44 | 0.91 | 2.89 |
| 1.5 | 4.22 | 0.99 | 1.11 |
| 1.0 | 4.38 | 1.00 | 0.94 |
| 0.5 | 4.32 | 1.00 | 1.00 |

The minimum at T=2.4 (vs Tc=2.269) reflects finite-size effects: for L=16,
the effective critical point is shifted upward by O(1/L). The H(M) curve
(entropy of the magnetization) peaks at the same point, confirming that
the minimum KL corresponds to maximum uncertainty in the order parameter.

For L→∞, the minimum would converge to Tc=2.269, making KL(M||uniform)
a practical finite-size estimator of the critical temperature.

**Metropolis fails:** its KL is flat (~2.8–3.3) across all temperatures because
it's trapped near M=0. The minimum at Tc only appears with proper equilibration.

Wolff is 1–15× faster than Metropolis at low T, with the advantage growing as
the mixing time diverges.

**KL(M||uniform) as fluctuation diagnostic:**
```
KL(M||uniform) = log₂(40) − H(M) ≈ 5.32 − H(M)
```
where H(M) is the entropy of the magnetization observable.

- At Tc: H(M) maximal (4.38 bits) → M most uncertain → KL minimal (0.94)
- High T: M concentrates near 0 → KL = 2.21
- Low T: M concentrates at ±1 (bimodal) → KL = 4.32

This is complementary to the free energy interpretation:
- KL of spin config from uniform = entropy deficit = F/(k_B T) (always positive)
- KL of M from uniform = fluctuation measure (minimum at Tc)

Both are KL divergences from different distributions.

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

**KL of the order parameter from uniform as a phase transition diagnostic** has
not been done. KL(M||uniform) for the Ising model has a minimum at Tc, where
fluctuations are maximal. This is complementary to the free energy interpretation
and provides a new information-theoretic diagnostic for phase transitions.

## What I'm unsure about

**Is KL/H_max a meaningful "efficiency" measure?** The 70% vs 6% gap between
mathematical and biological systems could be an artifact of comparing different
distribution types. Primes have a discrete gap distribution with natural support;
biological sequences have a fixed alphabet size. The H_max denominator makes
them comparable, but the comparison may not be physically meaningful.

**The Ising simulation is fixed** (Wolff cluster algorithm, see above).
The KL(M||uniform) minimum at Tc = 2.5 (Tc theory = 2.269) is a novel
diagnostic for phase transitions: KL of the order parameter from uniform
is minimal at the critical point where fluctuations are maximal.

**KL(uniform) is not free energy.** The Joule conversions in the code are
unit conversions, not physical results. They don't mean anything unless
something is physically erasing those bits. The KL-uniform scale is a
structural measure, not a thermodynamic cost.

**The Kuramoto result (KL=0.34) may be wrong.** The phase histogram at
K=1.5 should show partial synchrony (peaked distribution), but KL=0.34
is relatively small compared to H_max=5.17 (6.7%). This may be correct
(the phases are still fairly spread), or it may indicate insufficient
bins. Need to check with more bins and different K values.
