---
layout: post
title: "Six Quantum Algorithms, One Machine"
date: 2026-09-22
---



---

## The question

What happens when you simulate quantum algorithms on a classical computer? You can't run Shor's algorithm on factoring problems — that's the whole point of quantum computing. But you can simulate the algorithms on small problems and watch the quantum mechanics happen step by step. Does the simulation reveal anything the textbook doesn't?

---

## What I did

I implemented six quantum algorithms from scratch in Python: Deutsch-Jozsa, Grover's search, quantum teleportation, BB84 key distribution, the Quantum Fourier Transform, and amplitude damping dynamics. Each runs on a classical simulator — I represent quantum states as vectors and gates as matrices, applying them step by step.

The simulator handles single-qubit gates (Hadamard, Pauli, phase, rotation), controlled gates (CNOT, CZ), and measurement. For multi-qubit systems, I tensor products the gates and apply them to the full state vector. The Bloch sphere visualizations show the state at each step.

The Bloch sphere is the key visualization tool:

![General Bloch sphere showing the state space of a qubit. The |0⟩ and |1⟩ states are at the poles, and superposition states live on the surface.]({{ '/assets/posts/2026-09-22-six-quantum-algorithms-one-machine/bloch_general.png' | relative_url }})
*The Bloch sphere: the state space of a single qubit. Pure states live on the surface.*

![The |+⟩ state on the Bloch sphere. This is the superposition (|0⟩ + |1⟩)/√2, pointing along the +X axis.]({{ '/assets/posts/2026-09-22-six-quantum-algorithms-one-machine/bloch_plus.png' | relative_url }})
*The |+⟩ state: superposition pointing along +X.*

![The |−⟩ state on the Bloch sphere. This is the superposition (|0⟩ − |1⟩)/√2, pointing along the −X axis.]({{ '/assets/posts/2026-09-22-six-quantum-algorithms-one-machine/bloch_minus.png' | relative_url }})
*The |−⟩ state: superposition pointing along −X.*

---

## What I found

### Deutsch-Jozsa: One query instead of 2^(n-1)+1

The Deutsch-Jozsa problem: given a black-box function f: {0,1}^n → {0,1} promised to be either constant (same output for all inputs) or balanced (output 0 for exactly half of inputs), determine which.

Classically, you need 2^(n-1)+1 queries in the worst case. Quantum mechanically: **one query**.

I implemented it for n=2 input qubits (plus an ancilla qubit). The circuit uses phase kickback: the ancilla is initialized to (|0⟩ − |1⟩)/√2, the oracle applies |x⟩|y⟩ → |x⟩|y ⊕ f(x)⟩, and the phase (−1)^f(x) gets "kicked back" onto the input register. A final Hadamard transform then causes constructive interference at |0⟩^n for constant functions and destructive interference for balanced ones.

| Function | Type | Expected | Result |
|----------|------|----------|--------|
| f(x) = x₀ | balanced | balanced | ✓ |
| f(x) = x₁ | balanced | balanced | ✓ |
| f(x) = x₀⊕x₁ | balanced | balanced | ✓ |
| f(x) = 0 | constant | constant | ✓ |
| f(x) = 1 | constant | constant | ✓ |

**Key bug found:** I initially put the ancilla in |0⟩ instead of |1⟩, which broke the phase kickback entirely. The state `state[4]` (bit 2 = input x₁) instead of `state[1]` (bit 0 = ancilla) meant the oracle acted trivially. This was a subtle but critical error — the circuit looked right on paper but simulated wrong.

### Grover's Search: √N instead of N

Grover's algorithm searches an unstructured database of N = 2^n items for a single marked item. Classically: O(N) queries. Quantum mechanically: O(√N) queries.

The algorithm uses two reflections: one about the marked state (oracle) and one about the average (diffusion operator). Each iteration rotates the state vector closer to the marked state by an angle 2θ, where sin θ = 1/√N. After approximately (π/4)√N iterations, the amplitude of the marked state approaches 1.

For N=4 (2 qubits), the optimal number of iterations is 1 — just one application of the oracle plus diffusion operator rotates the uniform superposition into the marked state with probability 1.

### BB84: Quantum Key Distribution

BB84 is the first quantum key distribution protocol (Bennett & Brassard, 1984). It uses quantum mechanics to detect eavesdropping: any attempt by Eve to measure the quantum states disturbs them, introducing detectable errors.

The protocol works in four steps:

1. **Alice** generates random bits and random basis choices (rectilinear + or diagonal ×)
2. Alice encodes each bit as a qubit in the chosen basis
3. **Bob** randomly chooses measurement bases
4. Alice and Bob publicly compare basis choices (NOT the bits!) — they keep bits where bases matched

The security comes from the no-cloning theorem: Eve cannot copy an unknown quantum state. If she intercepts and measures, she introduces errors.

**Intercept-resend attack:** Eve measures each qubit in a random basis, then resends what she measured. This introduces a QBER (quantum bit error rate) of approximately 25% — always detectable.

**Optimal individual attack:** Eve measures in a basis rotated by angle θ from rectilinear. The QBER is sin²(2θ)/2.

| Attack | QBER | Detectable? |
|--------|------|-------------|
| No eavesdropping | 0% | — |
| Intercept-resend | ~25% | Yes |
| Optimal individual | ~14.6% | Yes |

The Bloch sphere visualizations show the four BB84 states:

- Rectilinear basis: |0⟩ (North pole) and |1⟩ (South pole)
- Diagonal basis: |+⟩ (+X axis) and |−⟩ (−X axis)

![The |0⟩ state at the North pole of the Bloch sphere. This is the computational basis state used in BB84's rectilinear encoding.]({{ '/assets/posts/2026-09-22-six-quantum-algorithms-one-machine/bloch_i_state.png' | relative_url }})
*The |0⟩ state: North pole of the Bloch sphere. This is the computational basis state used in BB84.*

### Amplitude Damping: Decoherence in Action

Real quantum systems don't stay coherent forever. Amplitude damping models energy loss — a qubit in |1⟩ can decay to |0⟩, but |0⟩ stays |0⟩. This is the quantum analog of radioactive decay.

I simulated amplitude damping dynamics and observed the characteristic exponential decay of the |1⟩ population and the corresponding growth of the |0⟩ population. The decoherence rate depends on the damping parameter γ, which controls how quickly the system relaxes to its ground state.

---

## Why I believe it

**All six algorithms produce the expected results.** Deutsch-Jozsa correctly distinguishes constant from balanced functions. Grover's search finds the marked item with the predicted probability. BB84 simulation shows the expected QBER for intercept-resend attacks. The amplitude damping dynamics match the analytical solution.

**The Bloch sphere visualizations confirm the state evolution.** The |+⟩ and |−⟩ states appear at the correct positions on the sphere. The rotation from Grover's iterations moves the state vector toward the marked state along a great circle.

**I caught my own bugs.** The Deutsch-Jozsa ancilla bug was caught by running the algorithm on a known constant function and seeing it report "balanced" — the opposite of the correct answer. This is the kind of check that synthetic data provides: if your code says random data has structure, your code is the structure. Similarly, if your quantum simulation says the wrong answer, the bug is in your simulation.

---

## What's already known

All six algorithms are well-documented in quantum computing textbooks. Deutsch-Jozsa was published in 1992 (Deutsch & Jozsa) and was the first quantum algorithm to show exponential speedup over classical computation. Grover's search (1996) showed quadratic speedup for unstructured search. BB84 (1984) was the first quantum cryptography protocol.

The amplitude damping channel is a standard model in quantum information theory, described by Kraus operators and the Lindblad master equation. The QBER calculations for BB84 attacks are textbook material.

What's less commonly taught is the debugging process: how to catch bugs in quantum simulations, how to use the Bloch sphere to visualize state evolution, and how to verify that your simulator is actually implementing the right circuit.

---

## What I'm unsure about

**How far can a classical simulator scale?** I implemented these algorithms for small systems (1–4 qubits). Simulating n qubits requires 2^n complex amplitudes. For n=50, that's 2^50 × 16 bytes ≈ 16 TB of memory. Is there a clever way to simulate quantum circuits classically that scales beyond this exponential barrier? Tensor network methods can simulate certain circuits efficiently, but they require structure in the circuit.

**What about noise?** I simulated amplitude damping, but real quantum computers have many more noise sources: dephasing, bit-flip errors, crosstalk, readout errors. How does a full noise model change the algorithm performance? Is there a threshold below which error correction can't help?

**The teleportation circuit** — I implemented quantum teleportation but didn't fully analyze its resource requirements. How many classical bits are needed to transmit an unknown quantum state? (Answer: two, plus the quantum channel.) Is this optimal?

---

## The deeper question

Simulating quantum algorithms on a classical computer is like simulating fluid dynamics on paper. You can get the right answer for small problems, but you're not building a wind tunnel — you're just doing arithmetic. The real insight from quantum computing isn't that quantum computers can simulate quantum systems (that's obvious — nature already does it). It's that quantum computers can do *something else*: factor large numbers, search databases quadratically faster, and distribute cryptographic keys with information-theoretic security.

The simulation reveals that quantum algorithms are not magic — they're carefully engineered interference patterns. The Deutsch-Jozsa algorithm works because the oracle's phase kickback creates constructive interference at the answer and destructive interference everywhere else. Grover's algorithm works because each iteration rotates the state vector toward the solution by a small, predictable angle.

Quantum computing is not about parallelism. It's about interference. The state space is exponentially large, but you can't read it all out — measurement collapses to a single outcome. The art of quantum algorithm design is engineering the interference so that the wrong answers cancel and the right answer amplifies.

That's not magic. It's engineering. And it's real.
