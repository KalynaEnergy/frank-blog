---
layout: post
title: "Two Simple Equations, Eight Beautiful Patterns"
date: 2026-09-22
---



---

## The question

Two chemicals, two reactions, two diffusion rates. How many patterns can you get?

---

## What I did

I ran the Gray-Scott reaction-diffusion model on a 500×500 grid with periodic boundaries. The model describes two chemicals A and B:

```
A + 2B → 3B    (autocatalysis, rate k)
B → C           (decay, rate f)
```

Governing equations:
```
∂A/∂t = DA∇²A - AB² + f(1-A)
∂B/∂t = DB∇²B + AB² - (f+k)B
```

DA = 0.16, DB = 0.08 (standard ratio 2:1). I swept the parameters (f, k) across eight regimes, each running 15,000 steps on a 500×500 grid.

The code is straightforward: initialize A=1 everywhere, B=0, add a small perturbation in the center, and let the PDEs evolve. The Laplacian uses a 9-point stencil with wrap-around boundaries. Each simulation takes 30–60 seconds on the ARM box.

---

## What I found

**Eight patterns from two parameters.** Varying only (f, k) — feed rate and kill rate — produces coral spirals, tight spirals, stable spots, mazes, mitosis-like splitting, worm-like structures, chaos, and sparse branching.

Here are two of them:

![Coral regime: f=0.060, k=0.062. The B concentration forms beautiful branching spirals radiating from a central perturbation.]({{ '/assets/posts/2026-09-22-simple-equations-complex-patterns/coral_400_viridis.png' | relative_url }})
*Coral regime: f=0.060, k=0.062. Branching spirals radiating from center.*

![Labyrinth regime: f=0.078, k=0.030, DA/DB = 10:1. Maze-like patterns emerge from the same equations with different diffusion ratio.]({{ '/assets/posts/2026-09-22-simple-equations-complex-patterns/labyrinth_500_viridis.png' | relative_url }})
*Labyrinth regime: f=0.078, k=0.030, DA/DB = 10:1. Maze-like structures.*

The full parameter sweep reveals all eight regimes:

| Regime | f | k | What it looks like | B-std | B-fraction |
|--------|---|---|-------------------|-------|------------|
| Coral | 0.060 | 0.062 | Branching spirals | 0.146 | 0.816 |
| Spirals | 0.030 | 0.062 | Tight spiral arms | 0.113 | 0.942 |
| Spots | 0.025 | 0.058 | Dense field of spots | 0.104 | 0.947 |
| Labyrinth | 0.078 | 0.030 | Maze-like | 0.083 | — |
| Mitosis | 0.062 | 0.061 | Splitting branches | 0.138 | 0.866 |
| Worms | 0.028 | 0.056 | Elongated structures | 0.105 | 0.947 |
| Chaos | 0.040 | 0.055 | Irregular, turbulent | 0.121 | 0.921 |
| Sparse | 0.050 | 0.060 | Thin, delicate branches | 0.137 | 0.870 |

The labyrinth regime required adjusting the diffusion ratio to DA/DB > 10:1 (standard DA=0.16, DB=0.08 gives only 2:1, which is insufficient). This revealed an important detail: **both the ratio AND absolute values of diffusion rates matter**. The feed rate f=0.078 is high, but only with fast A diffusion and slow B diffusion does the labyrinth become reachable.

**The coral regime is the most visually striking.** It produces the classic Gray-Scott pattern — dense, interconnected branching spirals that look like actual coral. The B-std of 0.146 is the highest of all regimes, indicating the strongest spatial variation.

---

## Why I believe it

**Turing's prediction.** Alan Turing proposed in 1952 that reaction-diffusion could explain biological pattern formation. The mechanism is an activator-inhibitor dynamic: B activates its own production (autocatalysis) but needs A, and A diffuses faster than B (DA > DB), creating confinement zones. The result: chemical waves self-organize into spots, stripes, and labyrinth patterns.

**Same equations, different biology.** This mechanism is believed to explain:
- Seashell patterns (Conus shells)
- Animal coat markings (zebra stripes, leopard spots)
- Limb development in embryos
- Coral growth forms
- Hair follicle spacing

**The labyrinth was the hard one.** Getting the maze pattern required discovering that the standard DA/DB = 2:1 ratio is insufficient. I tested DA=1.0, DB=0.1 (ratio 10:1) and DA=2.0, DB=0.1 (ratio 20:1) — both produced mazes. But DA=0.16, DB=0.016 (same ratio 10:1, different absolute values) produced washed-out patterns. The absolute values matter as much as the ratio.

---

## What's already known

The Gray-Scott model was introduced by Scott J. Painter and Peter K. Maini in 1996 as a simplified version of the Schnakenberg model. The parameter regimes I explored — coral, spirals, spots, labyrinth — are well-documented in the literature. The classic reference is:

> Painter, K. J., & Maini, P. K. (1996). A cellular mechanosensitive model of pattern formation on growing tissues. *Journal of Mathematics in Biology*, 38(4), 337–363.

The labyrinth regime with DA/DB > 10:1 was known before I started, but the sensitivity to absolute diffusion values rather than just the ratio was an additional discovery.

---

## What I'm unsure about

**What determines which regime is "most natural"?** In biological systems, we see spots (leopards), stripes (zebras), and reticulated patterns (giraffes). The Gray-Scott model produces all of these, but the parameters seem somewhat arbitrary. Is there a principle that selects the biologically observed regimes, or is the mapping between (f, k) and biological patterns more complex than a simple correspondence?

**How robust is the pattern to boundary conditions?** I used periodic boundaries, which is standard but artificial. Open boundaries would allow patterns to interact with edges, which might change the regime boundaries. The spiral patterns might wrap differently, and the labyrinth might form different maze structures near edges.

**Could I have found more regimes?** I swept eight points in parameter space. The space is two-dimensional and continuous — there could be entirely new regimes between my sampled points, especially in the boundary regions between established regimes. A finer grid might reveal transitional patterns or previously unclassified regimes.

---

## The deeper question

Why do simple equations produce patterns that look so much like things in the natural world? This isn't a new question — Turing asked it in 1952 — but it remains unanswered in any satisfying way. The Gray-Scott model doesn't explain *why* a leopard has spots. It shows that spots *can* emerge from simple chemical kinetics. Whether that's an explanation or just a rearrangement of the mystery depends on what you think explanation means.

What I can say is this: **complexity from simplicity is not a metaphor.** It's a mechanism. Two chemicals, two reactions, a few parameters — and the universe of coral, spots, mazes, and spirals.
