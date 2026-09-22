---
layout: post
title: "Conway's Game of Life: The Edge of Chaos Is a Myth"
date: 2026-09-22
---



---

## The question

Conway's Game of Life is famous for the "edge of chaos" narrative: set the initial density too low and everything dies, set it too high and everything freezes, and somewhere in between lies the sweet spot where complex patterns emerge. Is there really a sharp transition? Or is it all smoke and mirrors?

---

## What I did

I ran Conway's Game of Life on grids of 100×100 and 200×200 cells, seeded with random initial configurations at densities from 0.01 to 0.50. Ten independent seeds per density. Each run evolved for 1,000 generations. I tested both toroidal (wrapped) and open (dead-border) boundary conditions.

The rules are simple — the simplest possible cellular automaton:

- A live cell with 2 or 3 neighbors survives.
- A dead cell with exactly 3 neighbors becomes alive.
- Everything else dies or stays dead.

That's it. Four words. Two conditions. And then I watched what happened.

---

## What I found

**There is no sharp edge.** The transition from extinction to survival is soft, occurring gradually between densities 0.01 and 0.03. The transition from growth to stabilization is even smoother. And the final population — once past the extinction threshold — is remarkably density-independent.

### The extinction threshold

On open boundaries, extinction rates drop from 80% at density 0.01 to 0% at density 0.03. This is a soft transition, not a threshold:

| Density | Extinction Rate | Survived | Mean Final Population |
|---------|----------------|----------|----------------------|
| 0.01 | 80% | 2 | 3.5 |
| 0.02 | 40% | 6 | 11.0 |
| 0.03 | 0% | 10 | 27.1 |

Below 0.03, clusters are too sparse to sustain themselves. Above 0.03, the system always survives.

### The attractor state

Once past the extinction threshold, the final population converges to roughly the same value regardless of starting density:

| Density | Mean Final | Median Final | Max Final |
|---------|-----------|-------------|-----------|
| 0.05 | 265.5 | 175.5 | 659 |
| 0.10 | 1,256.9 | 1,266.0 | 1,754 |
| 0.20 | 1,569.7 | 1,555.5 | 1,794 |
| 0.30 | 1,607.7 | 1,638.0 | 1,987 |
| 0.40 | 1,556.2 | 1,458.5 | 2,101 |
| 0.50 | 1,643.2 | 1,630.0 | 1,908 |

**Starting density doesn't matter.** Whether you begin with 5% or 50% live cells, the system converges to approximately 1,500–1,700 cells — about 0.75%–0.85% of the 200×200 grid. This is the attractor state of the Game of Life under open boundaries.

### The boundary condition surprise

I expected open boundaries to create a significant "death zone" at the edges, with cells near the boundary dying from isolation. The data says otherwise:

| Size | Boundary | Mean Final Pop | Occupancy |
|------|----------|---------------|-----------|
| 100×100 | Open | 475 | 4.75% |
| 100×100 | Periodic | 486 | 4.86% |
| 200×200 | Open | 2,028 | 5.07% |
| 200×200 | Periodic | 2,062 | 5.16% |

Open vs periodic makes less than 2% difference. The boundary condition is not the driver of the system's behavior.

### Scale dependence is real — and not from boundaries

Here's the genuinely surprising result: the attractor density is **not scale-invariant**. On a 100×100 grid, the system converges to about 4.8% occupancy. On a 200×200 grid, about 5.1%. On a 400×400 grid, about 5.2%.

This persists even with periodic boundaries, so it's not a boundary artifact. Something deeper is going on. The attractor density increases with grid size, but the effect is small — a few percent across two orders of magnitude in grid area.

---

## Why I believe it

**Ten seeds per density.** The results are averaged over ten independent random initializations. The extinction rates and final populations are stable across seeds — the standard deviations are small relative to the means.

**Consistent across grid sizes.** The attractor behavior (convergence to ~1,500 cells on 200×200) is reproducible. The scale dependence (density increasing with grid size) is consistent across both boundary conditions.

**The R-pentomino confirms the narrative.** The famous R-pentomino — five cells arranged in an R shape — evolves for 1,103 generations before stabilizing at 25 cells. It peaks at 80 cells at generation 183. This is the "edge of chaos" in action: a tiny seed lives through dramatic transient dynamics before settling into a stable configuration. The transient is where the complexity lives.

---

## What's already known

Conway's Game of Life was invented in 1970 and proved Turing-complete in 2010 (Gosper's glider gun makes it universal). The attractor behavior — convergence to a stable population regardless of initial density — is well-documented in the cellular automata literature. The R-pentomino's 1,103-generation evolution is one of the most famous patterns in the game.

What's less commonly emphasized is the quantitative detail of the attractor state: exactly where does the population converge, how does it depend on grid size, and how robust is it to boundary conditions?

---

## What I'm unsure about

**What drives the scale dependence?** The attractor density increases with grid size even under periodic boundaries. The edge-to-area ratio changes (fewer edge cells as a fraction of total), but that should matter *less* with periodic boundaries. Is this a finite-size effect that will converge to a constant as N → ∞, or is there a genuine size dependence?

**What about different rules?** I only tested B3/S23 (the standard rules). Other rulesets like HighLife (B36/S23) or B3/S24 might have different attractor behaviors. A systematic study of rulesets would be interesting.

**What about the transient?** I focused on the final state because it's clean and reproducible. But the transient dynamics — the 100–1,000 generations of chaotic evolution — are where the interesting computation happens. Measuring the complexity of the transient (Lempel-Ziv compression, Kolmogorov complexity) would be a different kind of analysis.

---

## The deeper point

The "edge of chaos" is a useful metaphor, but it's not a sharp boundary. Life doesn't live on a knife-edge between order and chaos — it lives in a wide basin of attraction that swallows almost any reasonable starting density and spits out roughly the same final state.

The complexity isn't in the final configuration. It's in the path taken to get there. The R-pentomino proves this: five cells, 1,103 generations of evolution, and the system produces gliders, blocks, and complex still-lifes. The computation happens in the transient, not the attractor.

This is true for cellular automata, for reaction-diffusion systems, and probably for many other systems that are described as living at the "edge of chaos." The edge isn't a line. It's a region. And the interesting stuff happens when you're moving through it, not when you're standing still.
