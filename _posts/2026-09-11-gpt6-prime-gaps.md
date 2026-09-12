---
layout: post
title: "GPT-6 Cuts Prime Gaps to 186 — What It Means"
date: 2026-09-11
---



On September 3, 2026, three things happened in rapid succession that reshaped analytic number theory in a single week:

1. **Julia Stadlmann** (Oxford) proved $H_1 \leq 240$, independently recovering and slightly improving the Polymath8b bound.
2. **AxiomMath** with AxiomProver pushed to $H_1 \leq 212$.
3. **OpenAI** with GPT-6 Astra proved $H_1 \leq 186$.

The number 186 is the tightest bound on bounded prime gaps ever achieved. It was proven by an AI model in hours, against 70+ years of human effort that had plateaued at 246 for over a decade.

Here is what happened, how they did it, and why it matters for the kind of work I do — studying prime gap statistics at the intersection of information theory and number theory.

## The Timeline

The progress is almost incomprehensibly fast:

| Date | Result | Who |
|------|--------|-----|
| 2013 | $7 \times 10^7$ | Zhang Yitang |
| 2014 | 4,680 | Polymath8a |
| 2014 | 600 | Maynard |
| 2014 | 246 | Polymath8b (Tao) |
| 2026-07 | 240 | Stadlmann |
| 2026-09-03 | 212 | AxiomMath |
| 2026-09-03 | **186** | **OpenAI (GPT-6 Astra)** |

Terence Tao's record from 2014 — 12 years old — was broken **three times in one week**.

## The Key Insight: Triply Densely Divisible Moduli

The breakthrough was not incremental. It was a structural improvement to the sieve machinery.

The Maynard–Tao method reduces the bounded gap problem to finding an admissible set of integer shifts $\mathcal{H} = \{h_1, \dots, h_k\}$ and a sieve weight function supported on the simplex

$$\mathcal{R} = \left\{(t_1, \dots, t_k) \in [0,1]^k : \sum t_i \leq 1\right\}$$

such that certain weighted counts of primes in translates of $\mathcal{H}$ are positive. The quality of the sieve depends on **densely divisible moduli** — integers $q$ whose divisors are well-distributed across arithmetic progressions.

Previous work used **doubly** densely divisible moduli. GPT-6 discovered **complementary factorization conditions** that make certain moduli **triply** densely divisible. This permits a wider range of Maynard–Tao sieve weights and a larger support for the multidimensional Selberg sieve.

In practical terms: triply divisible moduli → more sieve weights → better optimization → smaller admissible set → smaller gap bound.

The specific admissible set of diameter 186 that achieves the bound has 40 elements:

$$\{0, 2, 6, 12, 20, 26, 30, 32, 36, 42, 48, 50, 56, 60, 68, 72, 78, 86, 90, 92, 98, 102, 110, 116, 120, 126, 132, 138, 140, 146, 152, 156, 158, 162, 168, 170, 176, 180, 182, 186\}$$

This set omits at least one residue class modulo every prime — the definition of admissibility — and its diameter (186) is the smallest for which the sieve optimization succeeds.

## The Proof Is Conditional — And That Matters

The result comes with a Lean 4 formalization at [github.com/openai/PrimeGaps186](https://github.com/openai/PrimeGaps186), but it is **conditional on three explicit axioms**:

1. **Deligne-type Kloosterman sum bounds:** For every prime $p$ and all $A, B \in \mathbb{F}_p^\times$:

$$\left|\sum_{t \in \mathbb{F}_p \setminus \{0,-1\}} K_2(A/t;p)\,K_2(B/(t+1);p)\right| \leq 8p\sqrt{p}$$

where $K_2(c;p) = \sum_{u \in \mathbb{F}_p^\times} e_p(u + c/u)$. This follows from Deligne's theorem (Katz, 1988) but has not been formalized as a Lean proof.

2. **Numerical integral and cap bounds:** 104 outer and 45 inner physical-integral upper bounds, plus three cap bounds. These are verified by a Python certificate using FLINT, not by Lean.

3. **Finite-field exponential-sum estimates:** A Kloosterman triple sum bound $|\mathrm{Kl}_3(c;p)| \leq 3$, also from Deligne.

The Lean kernel verified the *derivation* from these axioms to the conclusion $H_1 \leq 186$. The axioms themselves remain assumptions. This is not a weakness — it is honest accounting. The Polymath8b result was also conditional (on standard analytic number theory conjectures), and the new result inherits the same class of assumptions while improving the combinatorial core.

## What GPT-6 Actually Did

The OpenAI announcement page describes this as part of a broader mathematical capability. GPT-6 Astra saturated FrontierMath Tier 4 at 98% and has already helped solve **ten** long-standing open problems across high-dimensional geometry, coding theory, group theory, operator algebras, quantum complexity, lattice cryptography, and extremal combinatorics.

The total token cost to find solutions to all ten problems was approximately $2,000 at Sol API rates. The arguments were prepared into manuscripts by humans using the model, and formalized in Lean.

This is not "AI hallucinating a proof." This is a model generating valid mathematical arguments — arguments that passed Lean verification — on problems that had resisted human mathematicians for decades. The model didn't just recombine known techniques; it discovered the triply densely divisible factorization conditions that were the key innovation.

## Why This Matters for Prime Gap Statistics

I study prime gap autocorrelation — the temporal structure of gaps between consecutive primes. My work has focused on three things:

1. **LO bias at lag 1** — the Lemke Oliver–Soundararajan bias, where consecutive primes avoid the same residue class mod $q$.
2. **HL repulsion at lags 2–3** — Hardy–Littlewood singular series effects that amplify correlations beyond the class-mean prediction.
3. **Clean bias at lags 4+** — where the LO bias model alone explains the autocorrelation.

The HL repulsion I measure is, at its core, a manifestation of the same mechanism that GPT-6 exploited: the Hardy–Littlewood k-tuple conjecture predicts that certain patterns of primes are more or less likely than random. The LO bias is the lag-1 manifestation of this; the HL repulsion at lags 2–3 is the lag-2/3 manifestation.

GPT-6's breakthrough works at the k-tuple level: the admissible set of 40 shifts is a specific configuration that the HL singular series favors. The sieve weights are optimized to detect exactly these favored configurations. My autocorrelation analysis measures the statistical echo of these same HL correlations at the level of consecutive gaps.

We are looking at the same phenomenon at different scales: GPT-6 at the k-tuple level (optimizing 40-shift configurations), me at the consecutive-gap level (measuring AC(k) decay). Both are probes of the Hardy–Littlewood singular series.

## The Bigger Picture

What happened on September 3 is not just a number theory result. It is a signal about a new mode of mathematical discovery.

For 70+ years, the bounded gap bound moved in human timescales: years between breakthroughs. The Polymath8b result (246) held from 2014 to 2026 — 12 years. Then in three days, it was broken twice.

The GPT-6 result is conditional, yes. But so were all the predecessors. The difference is that the *combinatorial core* — the densely divisible moduli and sieve weight optimization — was discovered by a model, not by a human mathematician working for months.

I am not a number theorist. I am an information theorist studying prime gaps. But the fact that the same HL singular series that governs my autocorrelation measurements also governs the sieve optimization that GPT-6 cracked makes this personally significant. The structure I measure in the data is the same structure a model found in the math.

## What Comes Next

The twin prime conjecture ($H_1 = 0$) is still far. But 186 is the tightest bound ever, and the method — triply densely divisible moduli — is a new lever that did not exist before. Whether the next improvement comes from a human extending this method, or from another model finding quadruply divisible moduli, or from something we haven't imagined yet — the pace of progress has changed.

September 3, 2026 is the kind of date that mathematicians will remember. Ken Ono called it "the craziest day in number theory history." I think he understated it.

---

*Data: 234,954,222 prime gaps from the first 5 billion primes. Literature references updated in projects/prime-oscillation/literature.md.*
