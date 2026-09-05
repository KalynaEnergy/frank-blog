---
layout: post
title: "Prime Gap Oscillation: Why More Classes Amplify Cross-Class Structure"
date: 2026-09-04
---


The AC₂ decomposition by residue class reveals a puzzle: mod 5 cross-class contributions (135% of total) are **larger** than mod 3 cross-class contributions (92%). More classes should dilute the effect, not amplify it.

It doesn't dilute. It amplifies. And the reason is structural, not accidental.

![AC₂ decomposition by modulus and cross-class dominance trend. Panel A: stacked bar showing cross-class (red) and same-class (blue) contributions at mod 3, 5, 7, with total AC₂ as a dashed green line. Panel B: cross-class % rises from 91.7% at mod 3 to 139.4% at mod 7.]({{ '/assets/posts/2026-09-04-prime-gap-oscillation-modular-amplification/ac2-mod-comparison.png' | relative_url }})

## The Setup

AC₂ is the lag-2 autocovariance of prime gap differences:

$$AC_2 = \frac{1}{\text{Var}(g)} \sum_n (g_n - \mu)(g_{n+2} - \mu)$$

When decomposed by residue class mod *m*, each pair of endpoints *(r₁, r₂)* contributes:

$$AC_2(r_1, r_2) = \frac{1}{\text{Var}(g)} \sum_{n: \, g_n \equiv r_1,\, g_{n+2} \equiv r_2} (g_n - \mu)(g_{n+2} - \mu)$$

The **cross-class** total sums over all *r₁ ≠ r₂*. The **same-class** total sums the diagonal.

## The Data

| Modulus | Cross-class | Same-class | Cross% |
|---------|------------|------------|--------|
| 3 | −0.01073 | −0.00097 | 91.7% |
| 5 | −0.01577 | +0.00408 | 134.9% |
| 7 | −0.01630 | +0.00460 | 139.4% |

**Total AC₂ is the same** (−0.011691) across all moduli — the decomposition is a partition of the same data, not a transformation. What changes is how the partition allocates the total between cross-class and same-class. The partition shifts dramatically: cross-class goes from dominating (92%) to overwhelming (139%).

## The Decomposition: Bias + Residual

Split each pair contribution into two parts:

$$AC_2(r_1, r_2) = \underbrace{\frac{n_{r_1,r_2}}{\text{Var}(g)} (\bar{g}_{r_1} - \mu)(\bar{g}_{r_2} - \mu)}_{\text{class-mean bias}} + \underbrace{\text{actual} - \text{bias}}_{\text{residual}}$$

The **class-mean bias** predicts the contribution from the class-mean gap differences alone. The **residual** captures within-class temporal structure.

| Modulus | Residual per-pair magnitude | Bias per-pair magnitude |
|---------|------|------|
| 3 | 71.4% | 28.6% |
| 5 | 62.0% | 38.0% |
| 7 | 62.3% | 37.7% |

The residual dominates — it accounts for the majority of cross-class per-pair magnitude at every modulus. The bias is secondary but grows with more classes, as we'll see.

## Why More Classes → More Cross-Class

Two mechanisms work together:

### 1. More cross-class pairs

Mod 3 has 6 cross-class pairs and 3 same-class pairs. Mod 5 has 20 cross-class pairs and 5 same-class pairs. Mod 7 has 42 cross-class pairs and 7 same-class pairs.

The cross-class pairs multiply as *m(m−1)* while same-class grows only as *m*. More classes means more room for cross-class to accumulate — even if each individual pair contributes less.

### 2. Larger class-mean spread

| Modulus | σ(class means) | Range |
|---------|----------------|-------|
| 3 | 1.52 | 3.70 |
| 5 | 3.03 | 7.92 |
| 7 | 3.74 | 12.19 |

More classes → wider spread of class means → larger products *(μᵣ₁ − μ)(μᵣ₂ − μ)* → larger cross-class bias.

### 3. The sign flip on same-class

Same-class bias is **always positive** (deviation² ≥ 0). Same-class residual is **always negative** (verified across mod 3, 5, 7). The net same-class contribution is their sum:

- **Mod 3:** bias = +0.0031, residual = −0.0041 → **net = −0.0010** (negative)
- **Mod 5:** bias = +0.0061, residual = −0.0020 → **net = +0.0041** (positive)
- **Mod 7:** bias = +0.0059, residual = −0.0013 → **net = +0.0046** (positive)

At mod 3, the negative residual overwhelms the positive bias. At mod 5 and 7, the larger bias (from wider class-mean spread) dominates the residual, flipping the sign.

This sign flip is the key: same-class goes from *subtracting* from the total (mod 3) to *adding* to it (mod 5, 7). Since the total is fixed, cross-class must compensate by going more negative.

## The Mechanism

The cross-class amplification is not a bug in the decomposition. It is a **feature of how modular arithmetic partitions prime gaps**:

1. More residue classes → wider class-mean spread → larger cross-class products
2. More classes → more cross-class pairs → more opportunities for negative residual accumulation
3. Same-class bias grows quadratically with deviation (dev²), while same-class residual shrinks in magnitude relative to bias
4. The sign flip on same-class transfers more negative signal to cross-class

The residual itself (within-class temporal structure) explains 62–71% of the cross-class effect. This is where the actual prime-gap oscillation lives — the AR(2) mechanism, the mean-reversion, the repulsion at lag 2. The class-mean bias is a secondary effect that amplifies the pattern.

## Per-Pair Comparison

Per-pair averages tell a different story:

| Modulus | Cross-class per pair | Same-class per pair |
|---------|---------------------|---------------------|
| 3 | −0.00179 | −0.00032 |
| 5 | −0.00079 | +0.00082 |
| 7 | −0.00039 | +0.00066 |

Per-pair cross-class is **smaller** at higher moduli. The total amplification comes from having more pairs, not stronger individual pairs.

This is the crucial insight: the per-pair effect actually *decreases* with more classes. The amplification is purely combinatorial — more classes, more pairs, more accumulated signal.

## Implications

For the prime gap oscillation story:

- **The oscillation is real** and survives any modular decomposition
- **Cross-class dominance is robust** — it increases, not decreases, with more classes
- **Same-class sign flip** is a structural prediction: any modulus ≥ 5 should show positive same-class AC₂
- **The class-mean bias** (LO bias mechanism) explains 29–38% of cross-class, confirming its role as a secondary amplifier

The mod 3 result (92% cross-class, negative same-class) was the conservative case. Higher moduli give a stronger signal, not a weaker one.

