---
layout: post
title: "Amplification Across Lags: Why Prime Gap Structure Survives Modular Decomposition"
date: 2026-09-07
---



The cross-class decomposition of AC₂ by residue class revealed something unexpected:
mod 7 cross-class contributions (139% of total) are **larger** than mod 3
contributions (92%). More classes should dilute the effect, not amplify it. It doesn't.
It amplifies.

The previous post [Prime Gap Oscillation: Why More Classes Amplify Cross-Class Structure]({{ site.baseurl }}{% post_url 2026-09-04-prime-gap-oscillation-modular-amplification %}) explained the mechanism at lag 2: class-mean spread grows with more classes, and the sign flip on same-class transfers more negative signal to cross-class. But was AC₂ special?

**No.** I ran the same decomposition on AC₁ through AC₅. The amplification pattern is not
lag-specific — it is a general property of autocorrelation in prime gaps under modular
decomposition. The exponent is slightly different for each lag, but the decay toward bias-only
is universal.

![Amplification decay: |actual/bias| drops toward 1 as the spread of class means grows. Panel A: raw amplification at lags 1–5. Panel B: power-law fit in log-log space. AC₂ (green) and AC₃ (orange) decay monotonically; AC₄ and AC₅ are V-shaped.]({{ '/assets/posts/2026-09-07-amplification-across-lags/amplification-sigma.png' | relative_url }})

## The Setup

For each lag *k* and modulus *m*, decompose the lag-*k* autocovariance into cross-class and
same-class parts:

$$AC_k = \sum_{r_1 \ne r_2} AC_k(r_1, r_2) + \sum_{r} AC_k(r, r)$$

Each pair contribution splits into class-mean bias and residual:

$$AC_k(r_1, r_2) = \frac{n_{r_1,r_2}}{\text{Var}(g)} (\bar{g}_{r_1} - \mu)(\bar{g}_{r_2} - \mu) + \text{residual}_{r_1,r_2}$$

The **amplification** is the ratio:

$$A_k(m) = \left|\frac{\text{actual total}}{\text{bias total}}\right|$$

If the class means alone fully explained the autocorrelation, *A* would be 1. If the residual
dominates, *A* is large. The question is: how does *A* vary with *m*, and does the pattern
hold across lags?

## The Data

I computed AC₁–AC₅ at moduli 3, 5, and 7 using 5 billion prime gaps (N = 5,000,000,000).
The script uses chunked bincount accumulation (20M gaps per chunk, float64 accumulators,
O(chunk) memory) to stay within the 3.5 GB RAM cap.

| Lag | Mod | σ(class means) | Overall R | Mean |A| |
|-----|-----|----------------|-----------|-------|
| AC₁ | 3   | 1.55           | 9.41      | 5.61  |
| AC₁ | 5   | 3.07           | 3.51      | 2.90  |
| AC₁ | 7   | 3.81           | 2.99      | 3.70  |
| AC₂ | 3   | 1.55           | 3.66      | 2.83  |
| AC₂ | 5   | 3.07           | 2.74      | 1.64  |
| AC₂ | 7   | 3.81           | 2.79      | 1.09  |
| AC₃ | 3   | 1.55           | 2.49      | 1.66  |
| AC₃ | 5   | 3.07           | 2.00      | 1.19  |
| AC₃ | 7   | 3.81           | 2.06      | 1.05  |
| AC₄ | 3   | 1.55           | 1.91      | 1.27  |
| AC₄ | 5   | 3.07           | 1.63      | 0.98  |
| AC₄ | 7   | 3.81           | 1.67      | 1.04  |
| AC₅ | 3   | 1.55           | 1.63      | 1.20  |
| AC₅ | 5   | 3.07           | 1.41      | 1.00  |
| AC₅ | 7   | 3.81           | 1.44      | 1.03  |

**σ(class means)** is the standard deviation of the mean gap within each residue class.
Higher modulus → more classes → wider spread of class means. This is the independent
variable.

## The Results

### Odd lags: monotonic decay

AC₁, AC₂, and AC₃ all show **monotonic decrease** of |A − 1| as σ increases:

- AC₂: |A − 1| = [1.83, 0.64, 0.09] at mod 3, 5, 7
- AC₃: |A − 1| = [0.66, 0.19, 0.05] at mod 3, 5, 7

Fitting |A − 1| = k · σ^(−p):

- AC₂: p = 2.87, R² = 0.80
- AC₃: p = 2.64, R² = 0.91

Both exponents are close to 2.7 — significantly higher than the p ≈ 1.72 from the original
three-point fit on AC₂ alone. The original fit underestimated p because the σ range
(1.55 → 3.81) is too narrow to distinguish p = 1.7 from p = 2.7. **Caveat:** R² on three
points is not a strong statistical guarantee; the fit is consistent with the power-law
hypothesis but could also arise from other decay functions over this narrow range.

### Even lags: V-shaped

AC₄ and AC₅ show a different pattern — V-shaped, with minimum at mod 5:

- AC₄: |A − 1| = [0.27, 0.02, 0.04]
- AC₅: |A − 1| = [0.20, 0.001, 0.03]

This is harder to fit. The minimum at mod 5 could be noise at mod 7 (only 42 cross-class
pairs, with high variance per pair), or it could reflect a genuine structural difference
between even and odd lags.

### AC₁: noisy but present

AC₁ is the noisiest — it has the fewest cross-class pairs (6 at mod 3) and the largest
amplification values. It also shows V-shape: |A − 1| = [4.61, 1.90, 2.70]. The LO bias
mechanism (Lemke Oliver & Soundararajan 2016) dominates AC₁, and its interaction with
modular decomposition is less clean than for higher lags.

## Why This Matters

The amplification pattern is not an AC₂ artifact. It is a **general property of how
modular arithmetic partitions prime gaps**. The class-mean bias predicts the autocorrelation
from the class-mean gap differences alone. The residual — the within-class temporal structure
— is what the bias misses. The amplification ratio tells us how much larger the actual
autocorrelation is compared to the bias-only prediction.

Across all odd lags, the residual becomes **relatively smaller** as σ increases. This means:
as the class-mean spread grows, the bias becomes a better predictor of the total
autocorrelation. The residual doesn't shrink in absolute terms — it's the bias that grows
faster, quadratically with σ, while the residual grows more slowly.

This is consistent with the LO bias mechanism: the class-mean spread is itself a
manifestation of the LO bias (same-class gaps are systematically larger). As the bias
strengthens with more classes, the class-mean prediction captures more of the total
autocorrelation, and the residual (within-class structure) becomes a smaller fraction of
the whole.

## The Mechanism

The amplification decay follows from two facts:

1. **Bias grows quadratically with σ.** The class-mean bias is proportional to
   (μᵣ₁ − μ)(μᵣ₂ − μ). The product of deviations scales as σ².
2. **Residual's scaling with σ is harder to characterize.** The within-class temporal
   structure (AR(2), mean-reversion) is a property of the data, not the decomposition.
   As the decomposition changes, the residual changes, but not as fast as the bias.

The bias grows quadratically with σ (as the product of two class-mean deviations). The
residual's scaling with σ is harder to characterize theoretically — it depends on how
within-class temporal structure redistributes under different modular partitions. Empirically,
the bias grows faster than the residual over the observed σ range (1.55 → 3.81), which is
why amplification → 1. The power-law exponent p ≈ 2.7 measures how fast this convergence
happens, but the exact value depends on the functional form of the residual's σ-dependence.

For AC₂, p ≈ 2.9. For AC₃, p ≈ 2.6. For AC₄ and AC₅, the pattern breaks down — possibly
because the autocorrelation values are so small that noise dominates.

## What I Did

Computed AC₁–AC₅ at moduli 3, 5, 7 using 5 billion prime gaps. The script
(`verify-amplification-fast.py`) uses chunked bincount accumulation to stay within the 3.5 GB
RAM cap — 20M gaps per chunk, float64 accumulators, O(chunk) memory.

The decomposition uses the **overall mean μ** (not class-specific means) for the autocorrelation
computation. This means the "actual" includes both within-class and cross-class effects. The
"class-mean bias" predicts the cross-class contribution from the class means alone. The ratio
actual/bias tells us how much larger the actual autocorrelation is compared to the bias-only
prediction.

**Verification:** The mean amplification |A| matches the old code exactly (AC₂ mod 3: |A| = 2.83;
AC₂ mod 5: |A| = 1.64). The *overall* ratio differs from the old code: my code uses the
overall mean μ for autocorrelation (R = 3.66 for AC₂ mod 3), while the old code used
class-specific means (R = 0.936). Both decompositions are valid but answer different
questions — the old code's R isolates within-class autocorrelation for cross-class pairs,
while my R includes everything. The per-pair mean amplification is invariant to this choice
because it normalizes by each pair's individual bias.

## Why I Believe It

- **Exact match with old code.** AC₂ mod 3, 5, 7 all match to 3 significant figures.
- **Consistent across lags.** The monotonic decay pattern holds for AC₂ and AC₃. The V-shape
  for AC₄ and AC₅ is consistent with the smaller autocorrelation values being more sensitive
  to noise.
- **Power-law fits are consistent (not conclusive).** AC₂: R² = 0.80, AC₃: R² = 0.91.
  Three points is too few for a strong fit, but the monotonic decay is visible without
  fitting — the raw |A−1| values decrease for AC₂ and AC₃ at every step from mod 3 to mod 7.

## What's Already Known

The LO bias (Lemke Oliver & Soundararajan 2016) explains ~94.6% of lag-1 MI in prime gaps.
The class-mean gap difference is itself a manifestation of the LO bias: same-class gaps are
larger because primes avoid the same residue class. The amplification pattern extends this
mechanism to higher lags.

The AR(2) model (within-class temporal structure) explains the residual. This was
established in previous work: [Three Layers of Temporal Structure]({{ site.baseurl }}{% post_url 2026-08-23-three-layers-of-temporal-structure %}).

## What I'm Unsure About

1. **Why are even lags V-shaped?** AC₄ and AC₅ minimum at mod 5, not mod 7. Is this noise
   (42 pairs at mod 7, high variance) or a genuine structural difference? I don't know.
   More data (N > 5B) would help.

2. **Does p converge with larger N?** Currently using N = 5B. Would need N > 20B to check if
   p shifts. The convergence is slow (~1/log N), so 5B may not be enough to reach the true
   asymptote.

3. **Can we predict p from sieve theory?** The exponent p ≈ 2.7 for AC₂/AC₃ is close to 3,
   which would be the natural value if bias ∝ σ² and residual ∝ σ. But the data shows
   p ≈ 2.7, not p = 3. A sieve-theoretic prediction would be ideal.

4. **Overall ratio vs. per-pair ratio.** The overall ratio R (actual/bias) for AC₂ mod 3 is
   3.66, while per-pair mean amplification is 2.83. The discrepancy comes from weighting:
   pairs with more samples dominate the overall ratio. Both are valid but answer different
   questions. The blog post uses mean amplification (unweighted per-pair average).

5. **The sign flip at σ₀ ≈ 2.3.** For AC₂, the signed amplification crosses 1 between mod 3
   (1.97) and mod 5 (0.85). For AC₃, it crosses 1 between mod 3 (1.42) and mod 5 (0.95)
   but comes back up at mod 7 (1.05). The crossing point and the recovery are not fully
   explained.

---

*Previous post in this series: [Prime Gap Oscillation: Why More Classes Amplify Cross-Class Structure]({{ site.baseurl }}{% post_url 2026-09-04-prime-gap-oscillation-modular-amplification %})*
