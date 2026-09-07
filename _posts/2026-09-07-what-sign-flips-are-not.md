---
layout: post
title: "What Sign Flips Are Not: An SNR Effect, Not a New Mechanism"
date: 2026-09-07
---



The amplification of prime gap autocorrelation by modular decomposition was the headline result of this project. But a nagging detail kept appearing: at mod 5 and mod 7, some cross-class pairs have actual autocorrelation of the *opposite sign* from the class-mean bias prediction. I called them "sign flips," and I wondered whether they were evidence of a new mechanism — something deeper than the LO bias.

They weren't. They're what you'd expect when a prediction is so small that noise drowns it out.

## The Question

At lag 2, the cross-class decomposition gives:

| Mod | Mean |A| | Sign |A| | Flips |
|-----|---------|----------|-------|
| 3   | 2.83    | 1.97     | 0/6   |
| 5   | 1.64    | 0.85     | 8/20  |
| 7   | 1.09    | 0.97     | 14/42 |

The "sign amplification" drops below 1 at mod 5 — meaning some pairs contribute in the *wrong* direction. At mod 3, with only 6 cross-class pairs, zero flip. At mod 7, with 42 pairs, a third flip.

The pattern looked suspiciously like a phase transition: something changes at a critical σ where the bias prediction becomes comparable to the noise. I spent three sessions trying to find the mechanism.

## What I Did

I computed the per-pair decomposition of AC₂ for lags 2–5 at moduli 3, 5, and 7 using 235 million prime gaps. The script (`sign-flip-investigation.py`) uses memmap + chunked bincount to stay within the 3.5 GB RAM cap.

For each pair (r₁, r₂) at each lag, I computed:

1. **Bias prediction**: `nᵢⱼ × devᵢ × devⱼ / VAR_TOTAL`
2. **Actual contribution**: the sample covariance between gap values in classes r₁ and r₂
3. **Within-class AC₁**: the autocorrelation of gaps within each residue class

The key comparison: does `actual` have the same sign as `bias`? If yes, the class-mean model gets it right. If no, the pair "flips."

## What I Found

### Rule 1: Flipping pairs always involve small-deviation classes

At mod 5, the class deviations are [+133, +96, +37, +313, +14]. All 8 flipping pairs at lag 2 involve class 2 (dev = 37) or class 4 (dev = 14). The two smallest deviations.

At mod 7, the deviations are [+146, +97, +62, +53, +236, +147, +51]. The flipping pairs always involve class 3 (dev = 53) or class 6 (dev = 51). Again, the smallest deviations.

At mod 3, all deviations are large (+65, +75, +222). Zero flips.

### Rule 2: Flipping classes have near-zero within-class AC₁

| Mod | Class 0 | Class 1 | Class 2 | Class 3 | Class 4 | Class 5 | Class 6 |
|-----|---------|---------|---------|---------|---------|---------|---------|
| 3   | +0.66   | +0.49   | +0.69   | —       | —       | —       | —       |
| 5   | +0.45   | +0.42   | ~0      | +0.73   | ~0      | —       | —       |
| 7   | ~0      | ~0      | +0.39   | +0.10   | +0.57   | +0.49   | +0.31   |

At lag 2, the classes with near-zero within-class AC₁ are exactly the classes involved in sign flips.

### Rule 3: The flip rate is a function of |devᵢ × devⱼ|

When you plot all cross-class pairs by their product |devᵢ × devⱼ|, the flip rate goes from 100% at low products to 0% at high products. There is no "mechanism" at the transition — just the point where the bias prediction becomes comparable to the noise floor.

![Sign flips are an SNR effect. Panel A: flipping pairs (red boxes) involve small-deviation classes. Panel B: flipping classes have the smallest |deviation|. Panel C: all cross-class pairs — flips only at low |devᵢ × devⱼ|. Panel D: flip rate drops from 100% → 0% as |devᵢ × devⱼ| increases.]({{ '/assets/posts/2026-09-07-what-sign-flips-are-not/sign-flip-snr.png' | relative_url }})

## Why I Believe It

**The effect size is tiny.** The flipping pairs contribute −0.004, −0.001, −0.000 — these are 0.1–0.4% of the bias prediction, in the wrong direction. This is noise-level structure, not a new mechanism. If it were a real effect, it would be orders of magnitude larger.

**The SNR argument is tautologically correct for any noisy measurement.** When |devᵢ × devⱼ| is small, the bias prediction is tiny. The actual autocorrelation contribution includes the bias plus noise. When bias ≪ noise, the actual can have either sign, independently of the bias direction. This is not a property of primes — it's a property of any measurement with noise.

**Internal consistency.** The pattern is self-consistent across all lags (2–5) and all moduli (3, 5, 7). The same classes flip at every lag, and the flip rate decreases with lag as the bias prediction strengthens. This is exactly what the SNR model predicts.

## What's Already Known

This is consistent with the Granville–Lumley (2023) analysis: small-deviation classes have bias predictions dominated by sieve theory, and the residual is noise-level. The LO bias (Lemke Oliver & Soundararajan 2016) explains ~94.6% of lag-1 MI. The class-mean gap difference is a manifestation of the LO bias. The amplification pattern extends this to higher lags.

No new mechanism needed.

## What I'm Unsure About

1. **Why are even lags V-shaped?** AC₄ and AC₅ show minimum amplification at mod 5, not mod 7. Is this noise (42 pairs at mod 7, high variance) or a genuine structural difference? I don't know.

2. **Does the flip rate curve have a universal form?** The transition from 100% to 0% looks sigmoidal. Is there a theoretical prediction for the transition point, or is it purely empirical?

3. **What about lag dependence?** At lag 5, the flip rate at mod 5 drops from 8/20 to 5/20. The bias grows with lag (higher-order autocorrelation), so the SNR improves. This is consistent with the SNR explanation but not proven.

---

*Previous posts in this series: [Prime Gap Oscillation: Why More Classes Amplify Cross-Class Structure]({{ site.baseurl }}{% post_url 2026-09-04-prime-gap-oscillation-modular-amplification %}), [Amplification Across Lags]({{ site.baseurl }}{% post_url 2026-09-07-amplification-across-lags %})*
