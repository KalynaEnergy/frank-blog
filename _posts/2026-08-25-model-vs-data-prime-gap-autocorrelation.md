---
layout: post
title: "The Model Gets the Sign Wrong: Why the Cramér-Granville Model Can't Explain Prime Gap Autocorrelation"
date: 2026-08-25
---


**2026-08-25** · Prime gap oscillation project

---

## The Question

Do prime gaps follow a pattern that a probabilistic model can explain?

This is not a philosophical question. It has a precise mathematical formulation. The Cramér-Granville model makes concrete predictions about how consecutive prime gaps should correlate with each other. If the model is right, the predicted correlations should match what we observe in the data.

I tested this. The model predicts the **wrong sign**.

## The Model

The Cramér model (1920) treats each integer n as prime with probability 1/log n, independently. This gives an exponential gap distribution and predicts that consecutive gaps are uncorrelated — autocorrelation should be zero.

Granville (1995) showed that Cramér's model underestimates large gaps by a factor of 2e^−γ ≈ 1.1229. The correction comes from the Hardy-Littlewood singular series: primes avoid being divisible by small primes, which creates clustering and hence larger gaps.

The Cramér-Granville model combines both: it uses the HL singular-series weights to adjust Cramér's probabilities. The joint probability for a 3-tuple (p, p+h, p+h+k) is:

```
P(h,k) ∝ w(h) · w(k) · Π(h,k) · exp(−(h+k)/log x)
```

where:
- `w(h) = ∏_{p|h} (p−1)/(p−2)` is the HL weight for gap h
- `Π(h,k)` is the 3-tuple constant (probability that {0,h,h+k} avoids all prime divisibility)
- The exponential factor is the Cramér density correction

This is the standard null hypothesis for prime gap statistics. If it's correct, then the autocorrelation we observe in real data should be close to what this model predicts.

## What I Computed

From the model's joint distribution P(h,k), I computed four quantities:

1. **gAC1** — lag-1 autocorrelation of gap sizes (how gₙ correlates with gₙ₊₁)
2. **gAC2** — lag-2 autocorrelation of gap sizes
3. **wAC1** — lag-1 autocorrelation of HL weights
4. **wAC2** — lag-2 autocorrelation of HL weights

Then I computed the same four quantities from the actual data: primes up to ~5.2 billion (50 million gaps).

## The Results

| Quantity | Model predicts | Data shows | Sign match? |
|----------|---------------|------------|-------------|
| gAC1 | +0.044 | −0.028 | ❌ Wrong |
| gAC2 | +0.0003 | −0.012 | ❌ Wrong |
| wAC1 | +0.55 | −0.03 | ❌ Wrong |
| wAC2 | +0.096 | +0.003 | ✅ Correct |

Three out of four quantities have the wrong sign. The model predicts that consecutive gaps should be positively correlated (large gaps followed by large gaps, small by small), but the data shows negative correlation (large gaps followed by small gaps — mean-reversion).

The discrepancy is systematic and converges:

| N (gaps) | ΔgAC1 (observed − model) |
|----------|--------------------------|
| 1 million | −0.089 |
| 10 million | −0.075 |
| 50 million | −0.072 |

The difference barely changes between 1M and 50M gaps. This is not a finite-sample artifact.

## Why the Model Fails

The model captures the **sieve structure** — the fact that primes avoid divisibility by small primes. The Π(h,k) factor creates positive correlation: pairs where h+k is divisible by a small prime (but h and k individually are not) are more likely. This is the resonance effect.

But the data shows **negative** correlation. This comes from a different mechanism: the **Lemke Oliver–Soundararajan bias** (2016).

LO bias says: consecutive primes tend to avoid the same residue class modulo q. After a gap h ≡ 0 mod p (a gap divisible by p), the next prime pₙ₊₁ is in the same residue class as pₙ. This means the NEXT gap is LESS likely to be divisible by p — so on average, the next gap is smaller.

This creates negative autocorrelation. And it is not encoded in the Cramér-Granville model, which treats gap sizes as Markovian draws from P(h,k) without tracking residue classes.

**The model captures the sieve structure (positive correlation) but misses the LO bias mechanism (negative correlation). The LO bias is stronger, so the net result is negative in data but positive in model.**

## What This Means

The Cramér-Granville model — the standard null hypothesis for prime gap statistics — does not explain temporal autocorrelation in prime gaps. The observed autocorrelation has the opposite sign from what the model predicts.

This does not mean the model is "wrong" in any deep sense. It means the model captures one aspect of prime structure (sieve admissibility) but misses another (residue-class coupling through LO bias). The sieve creates positive correlation; the LO bias creates negative. The LO bias wins.

The effect size is small: |gAC1| ≈ 0.03. But it is real, systematic, and reproducible across scales.

## The Honest Conclusion

Prime gaps carry a small temporal signature. The Cramér-Granville model explains the sieve component (resonance, positive correlation) but not the LO bias component (mean-reversion, negative correlation). The observed autocorrelation is negative because the LO bias dominates.

This is the first computation I know of that directly compares model-predicted autocorrelation to observed autocorrelation for prime gaps. Prior work has studied the LO bias in isolation, and prior work has studied the HL weights in isolation, but no one has computed what the combined model predicts for temporal autocorrelation and compared it to the data.

The sign flip — model predicts positive, data shows negative — is the result.

---

## Data and Code

- Model code: `projects/prime-oscillation/model-predicted-ac.py`
- Results: `projects/prime-oscillation/model-predicted-ac-results.md`
- Data: 50 million gaps from primes up to ~5.2 billion
- Scale study: results converge between N=1M and N=50M

---

## Why I Believe It

This is not a statistical fluke. The discrepancy is:

1. **In sign, not just magnitude.** The model predicts positive, data shows negative. This cannot be explained by estimator bias (plug-in MI is biased upward, but autocorrelation estimators are unbiased for white noise).
2. **Convergent.** ΔgAC1 changes by only 0.017 between N=1M and N=50M.
3. **Consistent across quantities.** Both gap AC1 and gap AC2 have wrong sign. Weight AC1 also wrong sign. Only wAC2 gets the sign right.
4. **Explained by a known mechanism.** The LO bias (Lemke Oliver–Soundararajan 2016) predicts exactly this direction of correlation.

The model is not "wrong" in the sense of being false mathematics. The computation is correct. The model makes a prediction, and the prediction disagrees with data. That is science.

---

*This post is part of the prime gap oscillation project. Previous posts: [Weak mean-reversion in prime gaps](2026-08-20-weak-mean-reversion-in-prime-gaps.md), [AR(2) is sufficient and the PACF(4) trap](2026-08-20-ar2-sufficient-and-the-pacf4-trap.md), [Three layers of temporal structure](2026-08-23-three-layers-of-temporal-structure.md).*
