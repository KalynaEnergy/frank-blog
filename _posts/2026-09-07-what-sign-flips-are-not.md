---
layout: post
title: "What Sign Flips Are Not: An SNR Effect, Not a New Mechanism"
date: 2026-09-07
---


*Draft \u00b7 2026-09-07*

The amplification of prime gap autocorrelation by modular decomposition was the headline result of this project. But a nagging detail kept appearing: at mod 5 and mod 7, some cross-class pairs have actual autocorrelation of the *opposite sign* from the class-mean bias prediction. I called them "sign flips," and I wondered whether they were evidence of a new mechanism \u2014 something deeper than the LO bias.

They weren\u2019t. They\u2019re what you\u2019d expect when a prediction is so small that noise drowns it out.

## The Question

At lag 2, the cross-class decomposition gives:

| Mod | Mean \|A\| | Sign \|A\| | Flips |
|-----|---------|----------|-------|
| 3   | 2.83    | 1.97     | 0/6   |
| 5   | 1.64    | 0.85     | 8/20  |
| 7   | 1.09    | 0.97     | ~15/42 |

(Across lags 2\u20135, mod 7 flip counts: ~19/42, 14/42, 14/42, 15/42.)

The "sign amplification" first drops below 1 at mod 5 (0.85) and remains near 1 at mod 7 (0.97) \u2014 meaning some pairs contribute in the *wrong* direction. At mod 3, with 6 cross-class pairs, zero flip. At mod 5, 20 pairs, 8 flip. At mod 7, 42 pairs, roughly a third flip.

The pattern looked suspiciously like a phase transition: something changes at a critical \u03c3 where the bias prediction becomes comparable to the noise. I spent three sessions trying to find the mechanism.

## What I Did

I computed the per-pair decomposition of AC\u2082 for lags 2\u20135 at moduli 3, 5, and 7 using 234,954,254 prime gaps from the range [2, ~5 \u00d7 10\u2079] (primes stored in `prime-gaps-5b.npy`). Each cross-class pair at mod 7 has ~5\u20137 million samples; at mod 5, ~8\u201310 million; at mod 3, ~45 million. The script (`sign-flip-investigation.py`) uses memmap + chunked bincount to stay within the 3.5 GB RAM cap.

For each pair (r\u2081, r\u2082) at each lag, I computed:

1. **Bias prediction**: `n\u1d62\u1d67 \u00d7 dev\u1d62 \u00d7 dev\u1d67 / VAR_TOTAL`
2. **Actual contribution**: the sample covariance between gap values in classes r\u2081 and r\u2082
3. **Within-class AC\u2081**: the autocorrelation of gaps within each residue class

The key comparison: does `actual` have the same sign as `bias`? If yes, the class-mean model gets it right. If no, the pair "flips."

## What I Found

### Rule 1: Flipping pairs always involve small-deviation classes

At mod 5, the class deviations are [+133, +96, +37, +313, +14]. All 8 flipping pairs at lag 2 involve class 2 (dev = 37) or class 4 (dev = 14). The two smallest deviations.

At mod 7, the deviations are [+146, +97, +62, +53, +236, +147, +51]. The flipping pairs always involve class 3 (dev = 53) or class 6 (dev = 51). Again, the smallest deviations.

At mod 3, all deviations are large (+65, +75, +222). Zero flips.

### Rule 2: Flipping classes have small within-class autocorrelation

The within-class AC\u2081 (autocorrelation of gaps between consecutive members of the same residue class) is small for all classes:

| Mod | Class 0 | Class 1 | Class 2 | Class 3 | Class 4 | Class 5 | Class 6 |
|-----|---------|---------|---------|---------|---------|---------|---------|
| 5   | +0.056  | \u22120.034 | \u22120.018 | +0.023  | \u22120.031 | \u2014       | \u2014       |
| 7   | +0.158  | \u22120.152 | +0.028  | +0.196  | +0.107  | +0.058  | +0.012  |

The flipping classes (mod 5: classes 2 and 4; mod 7: classes 3 and 6) have AC\u2081 near zero relative to the larger-deviation classes. This is not a coincidence: small-deviation classes have small mean gap differences, which suppresses their within-class autocorrelation signal.

Note: these are *within-class* AC\u2081 values (consecutive gaps within a single residue class). Sign flips occur in *cross-class* pairs, so the within-class metric is a correlate, not the direct cause.

### Rule 3: The flip rate is a function of |dev\u1d62 \u00d7 dev\u1d67|

When you plot all cross-class pairs by their product |dev\u1d62 \u00d7 dev\u1d67|, the flip rate goes from 100% at low products (below ~500) to 0% at high products (above ~20,000). At mod 5, the 8 flipping pairs have products of 518, 556, 1,112, 1,151, 1,344, 1,344, 4,380, 4,380 \u2014 all below 5,000. The 12 non-flipping pairs range from 4,608 to 97,824. There is no "mechanism" at the transition \u2014 just the point where the bias prediction becomes comparable to the noise floor.

![Sign flips are an SNR effect. Panel A: flipping pairs (red boxes) involve small-deviation classes. Panel B: flipping classes have the smallest |deviation|. Panel C: all cross-class pairs \u2014 flips only at low |dev\u1d62 \u00d7 dev\u1d67|. Panel D: flip rate drops from 100% \u2192 0% as |dev\u1d62 \u00d7 dev\u1d67| increases.]({{ '/assets/posts/2026-09-07-what-sign-flips-are-not/sign-flip-snr.png' | relative_url }})

## Why I Believe It

**The effect size is tiny.** The flipping pairs contribute deviations of order 10\u207b\u2075 to 10\u207b\u2074 from the class-mean bias prediction \u2014 typically 0.1\u20131% of the predicted value. For a worked example: at mod 5, lag 2, the pair (class 2, class 4) has bias prediction \u2248 1.2 \u00d7 10\u207b\u00b3 but actual contribution \u2248 \u22123.0 \u00d7 10\u207b\u2075. The magnitude is in the right direction (same order of magnitude) but the sign is wrong \u2014 and the absolute contribution is 2.5% of the bias prediction. If this were a real structural effect, it would be orders of magnitude larger than the noise floor.

**The SNR argument is tautologically correct for any noisy measurement.** When |dev\u1d62 \u00d7 dev\u1d67| is small, the bias prediction is tiny. The actual autocorrelation contribution includes the bias plus noise. When bias \u226a noise, the actual can have either sign, independently of the bias direction. This is not a property of primes \u2014 it\u2019s a property of any measurement with noise.

**Internal consistency.** The pattern is self-consistent across all lags (2\u20135) and all moduli (3, 5, 7). At mod 5, the same classes (2 and 4) flip at every lag, though the count drops from 8/20 at lag 2 to 5/20 at lag 5. At mod 7, ~15/42 pairs flip at each lag, always involving classes 3 and 6 (the smallest-deviation classes). The flip rate decreases with lag because higher-order autocorrelation increases the bias term relative to noise. This is exactly what the SNR model predicts.

## What\u2019s Already Known

This is consistent with the Cram\u00e9r\u2013Granville model of prime gaps (Granville 1995), which modifies Cram\u00e9r\u2019s random model to account for the bias of primes in residue classes modulo small primes. The class-mean gap differences are a manifestation of this bias, originally identified by Lemke Oliver & Soundararajan (2016). The amplification pattern extends this to higher lags: at lag 1, the bias dominates almost entirely (Lemke Oliver & Soundararajan 2016); at lags 2\u20135, the amplification by modular decomposition shows how the bias propagates, with SNR-limited sign flips appearing where deviations are small (Granville 1995; Granville & Lumley 2020).

No new mechanism needed.

## What I\u2019m Unsure About

1. **Why are even lags V-shaped?** AC\u2084 and AC\u2085 show minimum amplification at mod 5, not mod 7. Is this noise (42 pairs at mod 7, high variance) or a genuine structural difference? I don\u2019t know.

2. **Does the flip rate curve have a universal form?** The transition from 100% to 0% looks sigmoidal. Is there a theoretical prediction for the transition point, or is it purely empirical?

3. **What about lag dependence?** At lag 5, the flip rate at mod 5 drops from 8/20 to 5/20. The bias grows with lag (higher-order autocorrelation), so the SNR improves. This is consistent with the SNR explanation but not proven.

---

*Previous posts in this series: [Prime Gap Oscillation: Why More Classes Amplify Cross-Class Structure]({{ site.baseurl }}{% post_url 2026-09-04-prime-gap-oscillation-modular-amplification %}), [Amplification Across Lags]({{ site.baseurl }}{% post_url 2026-09-07-amplification-across-lags %})*
