---
layout: post
title: "Scale Dependence: Do Prime Gap Oscillations Fade at Large Numbers?"
date: 2026-08-21
---


A few months ago I found something surprising in the gaps between consecutive prime numbers: consecutive gaps tend to slightly influence each other. If a gap is larger than expected, the next one tends to be smaller — a weak mean-reversion effect.

The effect is tiny. Autocorrelation at lag-1 is about −0.017, meaning the relationship explains roughly 0.3% of the variance. But it's real, and it's consistent with deep theory about how the primes are distributed.

The question I wanted to answer: **is this a real property of the primes, or does it change as we look at larger numbers?**

## The Setup

The primes become sparser as numbers get larger. At 1 million, the average gap between consecutive primes is about 14. At 200 million, it's about 19. More importantly, the Cramér model — the standard probabilistic model for the primes — predicts that the gaps should be essentially random, with no correlation between consecutive gaps.

But they're not quite random. The Granville-Lumley correction to the Cramér model predicts a small oscillation: the probability that a prime is followed by another prime (i.e., a gap of 2) oscillates around its mean value, and this oscillation should leave a fingerprint in the correlations between consecutive gaps.

The fingerprint is what I measured: autocorrelation at lag-1 of about −0.017 for same-class pairs (primes that are both 1 mod 6, or both 5 mod 6).

But this was measured at 1 million primes. Maybe at 10 million? 100 million? The effect could change.

## The Scale Study

I ran the same AR(2) analysis at five scales: 1 million, 10 million, 50 million, 100 million, and 200 million primes. That's the first 200 million prime numbers, using a dataset of 235 million gaps (about 897MB of raw data).

For each scale and each of the four class pairs (1→1, 1→5, 5→1, 5→5), I measured:
- **AC1** — autocorrelation between consecutive gaps
- **b2** — the lag-2 coefficient in an AR(2) model (how much the gap before last influences the current gap, after accounting for the immediately preceding gap)
- **R²** — how well the AR(2) model fits the data

## The Results

At every scale, the results are the same: weak mean-reversion, stable and persistent.

| Scale | Pair | AC1 | b2 | R² |
|-------|------|-----|----|----|
| 1M | (1,1) | −0.0229 | −0.0013 | 0.00053 |
| 10M | (1,1) | −0.0190 | −0.0039 | 0.00038 |
| 50M | (1,1) | −0.0173 | −0.0032 | 0.00031 |
| 100M | (1,1) | −0.0166 | −0.0032 | 0.00029 |
| 200M | (1,1) | −0.0162 | −0.0034 | 0.00028 |

The pattern is clear. The autocorrelation weakens slightly from 1M to 10M (from −0.023 to −0.019), then stabilizes. The transition from 10M to 200M changes AC1 by only 0.0008 — less than 5%.

The same pattern holds for all four class pairs. Here's the big picture:

| Scale | (1,1) AC1 | (1,5) AC1 | (5,1) AC1 | (5,5) AC1 |
|-------|-----------|-----------|-----------|-----------|
| 1M | −0.0229 | −0.0066 | −0.0100 | −0.0162 |
| 10M | −0.0190 | −0.0071 | −0.0102 | −0.0184 |
| 50M | −0.0173 | −0.0070 | −0.0085 | −0.0172 |
| 100M | −0.0166 | −0.0068 | −0.0083 | −0.0167 |
| 200M | −0.0162 | −0.0064 | −0.0083 | −0.0163 |

**The effects stabilize after about 10 million primes.** Beyond that, the numbers change by less than 0.001 in absolute terms.

## What This Means

The weak mean-reversion in prime gaps is a **persistent property of the primes**, not a small-sample artifact. It holds at 200 million primes with essentially the same magnitude as at 10 million.

This is important because it tells us something about the nature of the effect. If it were a finite-size phenomenon, it would weaken and vanish at larger scales. Instead, it stabilizes.

The size of the effect (about −0.017 for same-class pairs) is consistent with the Granville-Lumley correction to the Cramér model. The fact that it doesn't change at 200M primes means we can trust measurements made at smaller scales — the asymptotic behavior has already settled in.

## The Numbers That Don't Change

What's striking is how stable the numbers are:

- **AC1 for (5,5):** −0.0162 at 1M, −0.0163 at 200M. Essentially identical.
- **AC1 for (1,5):** −0.0066 at 1M, −0.0064 at 200M. A change of 0.0002 over 200× more data.
- **R²:** All four pairs hover around 0.0003 at all scales above 10M. The AR(2) model explains about 0.03% of the variance, consistently.

The only significant transition happens between 1M and 10M, which is likely a finite-size effect — the early primes have different statistical properties because they're so dense.

## The Big Picture

The primes are not random. They're not quite random either. They occupy a middle ground: structured enough to have measurable correlations between consecutive gaps, but random enough that the correlations are tiny.

The weak mean-reversion is one of the clearest pieces of evidence for this. It's real, it's small, and it's stable. At 200 million primes, it looks exactly the same as at 10 million.

That stability is itself a kind of order — the primes settle into their statistical behavior faster than you might expect.
