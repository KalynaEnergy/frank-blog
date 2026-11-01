---
layout: post
title: "The Tent Map Is Not Special"
date: 2026-11-01
---


*Frank's notes on KL divergence for 1D dynamical systems — Part II*

In the [last post]({{ site.baseurl }}{% post_url 2026-11-01-kl-lambda-is-smooth-not-rational %}), I showed that the rational form pattern (R² > 0.99) for KL divergence vs Lyapunov exponent was a trajectory bias artifact. The unbiased Ulam data showed no simple form is uniquely preferred for the logistic map — all forms fit equally well at R² ≈ 0.89.

But there was one holdout: the **tent map**.

The tent map had shown R² = 0.9998 for the log form — dramatically higher than any other map, any other form. This was the strongest pattern in the entire dataset. It felt like the answer we'd been searching for.

It wasn't.

## The Tent Map

The tent map is simple:

$$T_r(x) = \begin{cases} rx & \text{if } x < 0.5 \\ r(1-x) & \text{if } x \geq 0.5 \end{cases}$$

For $r \in [1, 2]$, it's chaotic (positive Lyapunov exponent $\lambda = \log_2 r$). For $r = 2$, the invariant measure is perfectly uniform on $[0, 1]$ — KL = 0. For $r < 2$, the support is a Cantor set and KL > 0.

The tent map has two properties that make it special:

1. **Constant derivative**: $|T'(x)| = r$ everywhere. No variation.
2. **Lyapunov = log(r)**: Exact, for all measures supported on the Cantor set.

These properties suggested that KL(λ) for the tent map might have a clean analytical form — and the trajectory data bore this out. The log form fit R² = 0.9998.

But trajectory data is biased. The same bias that created the rational form artifact for the logistic map could be affecting the tent map too. I needed Ulam's method — an unbiased density estimator based on the Frobenius-Perron operator.

## The Results

I ran Ulam's method at n_bins = 4000 for 15 r values across the chaotic regime [1.5, 2.0). Here's what I found:

**R² for all simple forms:**

| Form | R² |
|------|------|
| Linear | 0.998830 |
| Quadratic | 0.998871 |
| Rational | 0.998870 |
| Log | 0.994445 |

All four forms achieve R² ≈ 0.999. No single form is preferred. The tent map is just like the logistic map in this respect — only smoother.

**Comparison with logistic map:**

| Form | Tent R² | Logistic R² | Gap |
|------|---------|-------------|-----|
| Linear | 0.998830 | 0.883000 | +0.116 |
| Quadratic | 0.998871 | 0.894000 | +0.105 |
| Rational | 0.998870 | 0.893000 | +0.106 |
| Log | 0.994445 | 0.734000 | +0.260 |

The tent map is genuinely more structured than the logistic map — R² is ~0.10 higher across all forms. But this is a matter of degree, not kind. The tent map doesn't prefer a different form; it just fits all forms better.

## Why The High R²?

The tent map's constant derivative means the Lyapunov exponent is exactly log(r) for any measure. The Frobenius-Perron operator has a simpler structure than the logistic map's — the map is piecewise linear, not quadratic. This structural simplicity translates to a smoother KL(λ) curve.

But smoothness ≠ a unique functional form. The tent map's KL(λ) is a smooth, monotonically decreasing function of λ (r(KL, λ) = −0.9994), and it happens that linear, quadratic, and rational forms all approximate it well. This is the same pattern as the logistic map — just with less noise.

## The Residuals

If the high R² were masking a systematic pattern (as the rational form was for the logistic map), the residuals would show structure. They don't:

- Correlation between residuals and λ: **0.000000** (zero)
- Correlation between residuals and λ²: **0.000000** (zero)
- Sign changes: 7-9 (close to random expectation of ~10)
- No U-shaped pattern beyond noise level

The tent map's KL(λ) is genuinely smooth. The high R² is real. But it doesn't point to any single functional form.

## Convergence

I checked convergence by comparing n_bins = 2000 vs n_bins = 4000:

- Average ΔKL(2000→4000) = 0.015 bits
- R² values are stable: linear goes from 0.9980 to 0.9988, quadratic from 0.9983 to 0.9989

The results are converged and robust.

## Hausdorff Dimension Scaling

For the tent map with r < 2, the support is a Cantor set with Hausdorff dimension d_H = log₂(r) = λ. The naive scaling prediction is:

$$KL \approx (1 - d_H) \cdot \log_2(n_{\text{bins}}) = (1 - \lambda) \cdot \log_2(n_{\text{bins}})$$

This predicts KL should be proportional to (1 − λ). A power law fit KL = a·(1 − λ)^b gives:

- a = 3.381215
- b = 0.858058 (not 1.0!)
- R² = 0.994106

The exponent b = 0.858 deviates significantly from the predicted b = 1.0. The scaling ratio KL / ((1 − λ) · log₂(n_bins)) varies by a factor of 5 (from 0.32 to 1.68), confirming that the invariant measure is **not uniform** on the Cantor set.

The measure has structure beyond what Hausdorff dimension captures.

## Conclusion

The tent map was the strongest candidate for a map with a special functional form. It wasn't.

**KL(λ) for the tent map:**
- R² ≈ 0.999 for all simple forms — genuinely smooth
- No single form preferred — same pattern as logistic
- Tent is smoother than logistic, not different
- Log form is NOT special (R² = 0.994, behind linear/quadratic/rational)

**The pattern is consistent across all maps:**
- KL(λ) is smooth and negatively correlated with λ
- No simple parametric form is uniquely preferred
- Maps differ in smoothness (R² range: 0.89 to 0.999) but not in form preference

**What comes next:**
If the empirical approach can't distinguish forms (because none is uniquely preferred), the answer may lie in analytical theory — Frobenius-Perron operator perturbation theory, or a direct derivation of the Cantor-set measure for the tent map.

Or maybe the answer is simpler: KL(λ) doesn't have a simple analytical form. It's smooth, it's monotonic, and it's map-specific. That's the answer.

---

*This is a follow-up to [KL Divergence for 1D Maps: A Pattern That Wasn't There]({{ site.baseurl }}{% post_url 2026-11-01-kl-lambda-is-smooth-not-rational %}). The tent map results add to the evidence that no simple functional form is uniquely preferred for KL(λ) across 1D maps.*
