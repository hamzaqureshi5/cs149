# Learning Notes — CS149 Fall 2023

Tags: **[Slide]** = stated on the slide · **[Background]** = extra context added by the tutor · **[Verify]** = interpretation that should be checked

---

## Lecture 1: Why Parallelism? Why Efficiency?

### 1.1 What is a parallel computer? (slide 3)
- **[Slide]** "A parallel computer is a collection of processing elements that cooperate to solve problems quickly."
- **[Slide]** Two reasons: we care about *performance* and *efficiency*, and we use multiple processors to get them.
- **[Background]** "Processing element" is deliberately vague: it can be a CPU core, a SIMD lane, a GPU core, or a whole machine in a cluster. The key word is *cooperate*: the pieces must share or exchange data, and that cooperation has a cost.

### 1.2 Speedup (slide 5)
- **[Slide]** speedup(P processors) = execution time (1 processor) / execution time (P processors)
- **[Background]** Ideal ("linear") speedup is P. Efficiency = speedup / P.
- Worked example: 1 processor takes 100 s; 4 processors take 40 s → speedup = 2.5, efficiency = 2.5 / 4 = 62.5%.

### 1.3 What limits speedup: lessons from the demos (slides 6, 8, 10)
- **[Slide]** Demo 1: communication (telling each other partial sums) limited speedup; reducing its cost (moving closer) helped.
- **[Slide]** Demo 2: work imbalance; some processors went idle while others worked. Better distribution helped.
- **[Slide]** Demo 3: when communication is large compared to computation, it can dominate and severely limit speedup.
- **[Background]** These are the three main enemies of the course: **communication**, **load imbalance**, and (later) **serial work** (Amdahl, L4).

---

## Lecture 4: Parallel Programming Basics

### 4.0 Two programming models (slide 2, detailed on slides 32–50)
- **[Background]** A *programming model* is the abstraction a language gives you: what the parallel workers are, how they communicate, and how they synchronize. It is separate from the hardware that implements it.
- **Data-parallel [Slides 34, 50]:** a single logical thread of control; `for_all` exposes independent iterations; the system does assignment; communication uses built-ins (`reduceAdd`) and is otherwise implicit in loads and stores; implicit barrier at the end of `for_all`.
- **Shared address space [Slides 36–44, 50]:** SPMD threads read and write shared variables (the "bulletin board"); communication is implicit in loads and stores; the programmer does assignment (threadId → rows) and synchronization (locks for mutual exclusion, barriers for phase dependencies).
- **Verified example (tutor):** array sum ×2 in ISPC (`foreach` + `reduce_add`) and in C++ `std::thread` + `std::mutex`; both print 2000000 for N = 1e6.
- Coming in L6: a third model, **message passing** (no shared variables; explicit send/recv).

### 4.1 Creating a parallel program: four steps (slides 3–4)
- **[Slide]** Decomposition → subproblems ("tasks") · Assignment → parallel threads ("workers") · Orchestration → parallel program (communicating threads) · Mapping → execution on the parallel machine.
- **[Slide]** "These responsibilities may be assumed by the programmer, by the system (compiler, runtime, hardware), or by both!"
- **[Slide]** Goal: usually speedup for a fixed computation; other goals include efficiency (cost, area, power) or solving bigger problems than fit on one machine.

### 4.2 Decomposition (slides 5, 12)
- **[Slide]** Create at least enough tasks to keep all execution units busy. The key challenge is identifying dependencies (or a lack of them).
- **[Slide]** Usually the programmer's job; automatic parallelization of general code is still unsolved (data-dependent dependencies cannot be known at compile time).

### 4.3 Amdahl's law (slides 6–11)
- **[Slide]** S = fraction of sequential execution that is inherently sequential → max speedup ≤ 1/S.
- **[Slide]** On P processors: speedup ≤ 1 / (S + (1−S)/P).
- **[Background]** Derivation: normalize the 1-processor time to 1. The serial part still takes S; the parallel part takes (1−S)/P at best. It is an upper bound, because it assumes perfect scaling and zero communication.
- **[Slide] Image example (N×N):** step 1 (double brightness) is fully parallel; step 2 (average) is serial → speedup ≤ 2n²/(n²/p + n²) ≤ 2.
- **[Slide]** Parallel partial sums plus a serial combine of P values → speedup ≤ 2n²/(2n²/p + p) → P when N ≫ P. The `+p` term is the "overhead of parallel algorithm".
- Worked numbers (tutor): N = 1000, P = 100 → first version ≈ 1.98×, second version ≈ 99.5×.
- **Lesson:** the "serial fraction" is not fixed; changing the algorithm can shrink it (step 2 went from serial to mostly parallel).
