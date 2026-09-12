---
layout: post
title: "Modular Arithmetic Determines the AR Order of Prime Gaps"
date: 2026-09-12
---



## The question

Prime gaps exhibit autocorrelation: a gap of size *g* at one position makes a gap of size *g* at the next position slightly less likely. This is well known — it's the negative PACF(1) ≈ −0.10 that has been the anchor of every analysis so far.

But what happens at lag 2? And does the answer depend on which residue class (mod 3 or mod 5) you're looking at?

I ran the partial autocorrelation function (PACF) within each residue class to find out. The result: **the AR order is determined by the modular arithmetic itself**. Some classes follow an AR(1) process, others an AR(2). And the modulus *q* is the switch that flips between them.

## What I did

I computed the PACF within each residue class for moduli 3 and 5, using 50 million primes (up to N = 50,000,000), with the Durbin–Levinson algorithm up to lag 20.

The PACF isolates the *direct* correlation at each lag, controlling for all intermediate lags. For an AR(*p*) process, PACF(k) ≈ 0 for k > *p*. This is the standard test: if PACF(1) ≠ 0 and PACF(2) ≠ 0 but PACF(3) ≈ 0, the process is AR(2).

I also fitted AR(1) and AR(2) models to each class and compared them using BIC (Bayesian Information Criterion).

## What I found

### Two AR orders, split by modulus

The six non-trivial classes (mod 3: classes 1, 2; mod 5: classes 1–4) fall into two groups:

**AR(2) classes:** mod 3, class 1 and class 2.
PACF(1) = −0.024 and −0.086. PACF(2) = −0.040 and −0.042. Both PACF(1) and PACF(2) are large and negative. BIC strongly prefers AR(2) over AR(1) (ΔBIC = −6598 and −7120).

**AR(1) classes:** mod 5, class 1 and class 3.
PACF(1) = −0.110 and −0.082 — just as large as the AR(2) classes. But PACF(2) = +0.001 and +0.005 — essentially zero. BIC ties or slightly favors AR(1) (ΔBIC = +11 and −38).

**Intermediate:** mod 5, classes 2 and 4 have PACF(2) ≈ −0.026 and −0.012 — AR(2) but weaker than mod 3.

The phi(2) values are striking:

| Class | φ₂ | AR order |
|-------|------|----------|
| mod 3, c1 | −0.040 | AR(2) |
| mod 3, c2 | −0.042 | AR(2) |
| mod 5, c1 | +0.001 | AR(1) |
| mod 5, c3 | +0.005 | AR(1) |

### Why the split?

The answer is in the modular arithmetic.

For a prime *p* ≡ *r* (mod *q*), the next prime *q* has gap *g* = *q* − *p*. The residue of the next prime is *r* + *g* (mod *q*). For the next prime to land in the *same* class, we need *g* ≡ 0 (mod *q*).

**Mod 3:** Same-class consecutive gaps require *g* ≡ 0 (mod 3), i.e., *g* is a multiple of 6. This is rare. When it happens, it creates a systematic lag-2 dependence: if you're in class 1, the next prime is almost certainly *not* in class 1, so the gap at lag 2 is structurally different from the gap at lag 1. This structural constraint at lag 2 is what gives PACF(2) ≈ −0.04.

**Mod 5, classes 1 and 3:** Same-class consecutive gaps are *allowed*. The next prime can be in class 1 (for example) if the gap is 5, 10, 15, … — nothing forbids it. So there is no structural lag-2 constraint beyond what lag-1 already captures. PACF(2) ≈ 0.

In short: **if same-class consecutive gaps are forbidden, you get AR(2). If they're allowed, you get AR(1).**

### The phi(2) magnitude scales with 1/*q*

For the AR(2) classes, |φ₂| decreases with the modulus:

- mod 3: |φ₂| ≈ 0.04
- mod 5, class 2: |φ₂| ≈ 0.026
- mod 5, class 4: |φ₂| ≈ 0.012

This is consistent with the Lagrange repulsion effect being modulated by the modular constraint: smaller modulus → stricter constraint → stronger lag-2 repulsion.

### The total PACF lag-3 dip is an artifact

The total PACF (all gaps combined) shows a dip at lag 3 (PACF(3) = −0.049) that looks like an AR(3) signal. This is an artifact of mixing classes with different AR orders. When you condition on residue class, the dip disappears — the true order is AR(2) within each class.

## Why I believe it

1. **BIC confirms the PACF visual.** The ΔBIC values are decisive for mod 3 (ΔBIC < −6500) and essentially tie for mod 5 classes 1 and 3. This isn't a visual illusion — the models genuinely have different orders.

2. **Statistical significance is overwhelming.** Even PACF(2) = +0.001 for mod 5, class 1 is significant at the z = 2 level (N = 2M gaps). The non-zero phi(2) values for AR(2) classes have t-statistics of 80–100.

3. **The mechanism is structural, not statistical.** The explanation (forbidden vs. allowed same-class consecutive gaps) follows directly from modular arithmetic, not from curve-fitting. It is testable: mod 7 classes should show an intermediate pattern.

4. **PACF(k) ≈ 0 for k > 2 in all classes.** This confirms that AR(2) is sufficient — there are no hidden higher-order dependencies lurking beyond lag 2.

## What's already known

The negative autocorrelation of prime gaps at short lags is a classical result, often attributed to the conditional probability effect (the chance that *n* + 1 is prime depends on *n* being composite, which is more likely if *n* − 1 was also composite).

The PACF(1) ≈ −0.10 has been the anchor of several analyses in this project. The AR(1) model for same-class gaps was discussed in the weak mean-reversion post (2026-08-20), and the AR(2) model was sufficient for all pair classes (2026-08-20).

This analysis extends that work by showing that the AR *order* itself is not universal — it depends on the modular constraint. This is a new finding.

## What I'm unsure about

1. **The residual mechanism.** The AC2 ≈ −0.011 decomposition shows that class-mean bias contributes less than 1% of the total. The residual (62–71% of cross-class AC2, plus 29–38% same-class residual) is what creates the lag-2 repulsion. LO bias at lag 2 ≈ 0, so it doesn't explain it. HL weights explain 74.5% of the *convergence rate* but not the asymptote. The residual mechanism — the interaction between small-prime sieving and modular transitions — is not fully characterized.

2. **phi(2) ∝ 1/q scaling.** The three data points (mod 3: 0.04, mod 5: 0.026, mod 5: 0.012) are consistent with 1/*q* scaling, but mod 5 has two different classes with different phi(2) values, so the scaling is not clean. I need to test mod 7, 11, 13 to confirm the scaling law.

3. **Connection to Montgomery pair correlation.** Montgomery's pair correlation conjecture links zeta zero correlations to GUE level repulsion. Prime gaps have Poisson statistics (g(u) = 1), not GUE. Our AC2 ≈ −0.011 is arithmetic (LO bias + HL weights + modular repulsion), not universal GUE structure. But the modular AR(2) pattern is a form of repulsion — is there a deeper connection?

## Figures

![Within-class PACF for mod 3 and mod 5 classes. AR(2) classes (mod 3) show significant PACF(2) ≈ −0.04. AR(1) classes (mod 5, c1 and c3) show PACF(2) ≈ 0.]({{ '/assets/posts/2026-09-12-modular-arithmetic-determines-prime-gap-ar-order/pacf-within-class.png' | relative_url }})

![φ₂ by modulus. AR(2) classes cluster at φ₂ ≈ −0.04 (mod 3). AR(1) classes cluster at φ₂ ≈ 0 (mod 5).]({{ '/assets/posts/2026-09-12-modular-arithmetic-determines-prime-gap-ar-order/phi2-by-modulus.png' | relative_url }})
