# CS149 Fall 2023 — Course Roadmap

Built from the local slides in `lectures/` (every title slide says "Stanford CS149, Fall 2023").
Instructors: Prof. Kayvon Fatahalian and Prof. Kunle Olukotun.
Slide numbers are PDF page numbers.

Status key: ⬜ not started · 🟡 in progress · ✅ understood (checked by quiz, not just explained)

## Course themes (L1, slides 11–13)
1. **Designing parallel programs that scale:** decomposition → assignment → communication/synchronization.
2. **Parallel hardware implementation:** how abstractions are implemented, and the trade-offs (performance, convenience, cost).
3. **Efficiency:** fast ≠ efficient (e.g. "Is 2x speedup on 10 processors good?").

## Dependency map

```
L1 why parallelism / caches
 └─ L2 multi-core, SIMD, multithreading
     └─ L3 bandwidth + ISPC (abstraction vs implementation)
         └─ L4 programming basics (decomp/assign/orchestrate/map, Amdahl)
             ├─ L5 work distribution & scheduling (work stealing)
             └─ L6 locality, communication, contention (arith. intensity, roofline)
                 ├─ L7 GPU + CUDA ── L8 data-parallel thinking (scan) ── L10 DNNs
                 ├─ L9 Spark (+ L11 first part)
                 └─ L11 coherence ── L12 consistency ── L13 locks/lock-free ── L15/L16a transactional memory
L14 DSLs (Halide, Liszt) ← uses L6 locality + L10 scheduling ideas
L16b/L17 heterogeneity & specialization, Spatial ← uses L1 power, L6, L10
L18 DRAM + wrap-up (DRAM material is also repeated at the end of L16 and L17)
```

## Lectures

### Part A — Parallel hardware basics (`lectures/1_parallel_hardware_basics/`)

| # | Lecture (official title) | Slides | Main topics | Status |
|---|---|---|---|---|
| 1 | Why Parallelism? Why Efficiency? | 82 | definition of a parallel computer; speedup; 3 class demos (communication, imbalance); course themes; [logistics 14–22]; history of single-core scaling; what a program/processor is; ILP and superscalar execution; diminishing ILP returns; power wall (P ∝ C·V²·f); multi-core, GPU, mobile, specialized HW; memory address space; latency and stalls; caches (lines, LRU, spatial/temporal locality, cold/capacity misses); cache hierarchy and access times | 🟡 |
| 2 | A Modern Multi-Core Processor | 103 | review; multi-core; data-parallel `forall`; SIMD (AVX intrinsics), conditional execution and masking/divergence; jargon (coherent execution, explicit SIMD vs SIMT); Part 2: prefetching, hardware multithreading to hide latency; throughput computing; utilization exercise (how many threads for 100%); V100 GPU; bonus summary of core designs | ⬜ |
| 3 | Multi-Core Architecture Part II (latency/bandwidth) + Parallel Programming Abstractions | 56 | latency vs bandwidth vs throughput (highway, laundry); pipelining; bandwidth-bound execution; HBM; Part 2: abstraction vs implementation; ISPC (gangs, program instances, interleaved vs blocked assignment, `foreach`, reductions, cross-instance ops, tasks); SPMD | ⬜ |

**Prerequisites:** basic C, binary/hex, the idea of a CPU executing instructions (L1 fills this in).
**Practice:** Programming Assignment 1 (`asst1/`, quad-core CPU: threads, SIMD, ISPC) · Written Assignment 1 (multi-core architecture).

### Part B — Parallel programming and performance (`lectures/2_programming_and_performance/`)

| # | Lecture | Slides | Main topics | Status |
|---|---|---|---|---|
| 4 | Parallel Programming Basics | 51 | decomposition, assignment, orchestration, mapping; Amdahl's law; static vs dynamic assignment in ISPC; 2D grid solver case study; dependencies (red-black); data-parallel vs shared-address-space versions; synchronization (locks, atomicity, barriers) | 🟡 |
| 5 | Performance Optimization Part 1: Work Distribution and Scheduling | 62 | load balance; static / semi-static / dynamic assignment; work queues; task granularity; distributed queues; fork-join (Cilk Plus spawn/sync); work stealing (child-first vs continuation-first); implementing sync; greedy join | ⬜ |
| 6 | Performance Optimization Part II: Locality, Communication, and Contention | 69 | shared-memory HW (ring interconnect, NUMA); message passing model and grid solver; blocking vs non-blocking send/recv and deadlock; system as extended memory hierarchy; arithmetic intensity; inherent vs artifactual communication; blocking and loop fusion; contention; roofline model; profiling; bonus: scaling (problem-constrained, memory-constrained) | ⬜ |

**Prerequisites:** L1–L3 (especially caches, SIMD, ISPC tasks).
**Practice:** Programming Assignment 2 (`asst2/`, task execution library) · Written Assignment 2.

### Part C — Data-parallel: GPUs, scan, Spark, DNNs (`lectures/3_data_parallel_gpu_spark/`)

| # | Lecture | Slides | Main topics | Status |
|---|---|---|---|---|
| 7 | GPU Architecture & CUDA Programming | 73 | graphics history, GPGPU; CUDA thread hierarchy (grid/block/thread); host vs device memory; shared memory; 1D convolution example; `__syncthreads`, atomics; block scheduling; warps on a V100 SM; why a block's contexts must all be allocated; histogram example | ⬜ |
| 8 | Data-Parallel Thinking | 51 | map, fold, scan; work-efficient scan; scan on 2 cores and in CUDA; segmented scan; sparse matrix-vector multiply; gather/scatter; turning scatter into sort+gather; worked examples (5 solutions); histogram | ⬜ |
| 9 | Spark (Distributed Computing on a Cluster) | 57 | warehouse-scale computers; GFS/HDFS; MapReduce (word count, scheduler, limits); Spark RDDs; transformations vs actions; narrow vs wide dependencies; fusion; partitioning; lineage-based fault tolerance | ⬜ |
| 10 | Efficiently Evaluating DNNs | 68 | DNN layers (fully connected, convolution); conv → GEMM; blocked matrix multiply; CUTLASS; algorithmic tricks; operator fusion; attention and fused/flash-style attention; GPU tensor cores; energy efficiency | ⬜ |

**Prerequisites:** L2–L3 (SIMD, multithreading), L6 (arithmetic intensity, locality).
**Practice:** Programming Assignment 3 (`asst3/`, CUDA renderer) · Programming Assignment 4 (`asst4/`, NanoGPT149 attention) · Written Assignment 3 (cache, CUDA, Spark, locks).

### Part D — Memory and synchronization (`lectures/4_memory_and_synchronization/`)

| # | Lecture | Slides | Main topics | Status |
|---|---|---|---|---|
| 11 | Cache Coherence | 67 | slides 2–21 finish Spark (repeated from L9); cache design review (write-back, write-allocate); coherence problem and definition; snooping; MSI, MESI; directories; false sharing | ⬜ |
| 12 | Memory Coherency and Consistency | 64 | slides 2–24 review coherence; coherence vs consistency; sequential consistency; relaxed models (write buffers, W→R, W→W reordering); fences/synchronization; data races; language memory models | ⬜ |
| 13 | Implementing Locks, Fine-grained Synchronization, & Lock-free Programming | 66 | deadlock, livelock, starvation; test-and-set, test-and-test-and-set, ticket-style locks; atomics, CAS, LL/SC; C++11 `atomic<T>`; hand-over-hand locking on lists; lock-free queues/stacks; ABA problem; hazard pointers | ⬜ |
| 15 | Transactional Memory | 60 | atomic {} vs locks (declarative vs imperative); composability, failure atomicity; eager vs lazy versioning; pessimistic vs optimistic conflict detection; STM data structures and an example algorithm | ⬜ |
| 16a | Transactional Memory II (in `5_.../16_heterogeneity.pdf`, slides 1–50) | 50 | TM review; STM overheads and compiler optimizations; hardware TM (HTM) design and examples | ⬜ |

**Prerequisites:** L1 caches, L4 synchronization, L6 communication.
**Practice:** Written Assignment 4 ("Feeling Relaxed": consistency) · Written Assignment 5 ("Transactions on Trees", locks, DRAM).

### Part E — Specialization and heterogeneity (`lectures/5_specialization_and_heterogeneity/`)

| # | Lecture | Slides | Main topics | Status |
|---|---|---|---|---|
| 14 | Domain-Specific Programming Systems | 66 | why DSLs; Halide (algorithm vs schedule, 3x3 blur, tiling/fusion, autoscheduling); Liszt (mesh DSL, ghost cells, cluster and GPU compilation); principles of good DSL design | ⬜ |
| 16b | Heterogeneous Parallelism and Hardware Specialization (16_heterogeneity.pdf, slides 51–116) | 66 | heterogeneous chips; energy-constrained computing; why general-purpose CPUs are inefficient; ASICs, DSPs, FPGAs, NPUs; data movement energy; DRAM internals, HBM | ⬜ |
| 17 | Hardware Specialization and Algorithm Specific Programming | 100 | specialization recap; Spatial language (inner product); kernel-based vs streaming execution; attention on accelerators, FlashAttention; slides 73–100 repeat the DRAM material | ⬜ |

**Prerequisites:** L1 power wall, L6 locality, L10 DNNs and fusion.

### Part F — Wrap-up (`lectures/6_wrapup/`)

| # | Lecture | Slides | Main topics | Status |
|---|---|---|---|---|
| 18 | Accessing Memory + Course Wrap Up | 49 | DRAM operation (rows, banks, bursts, DIMMs, memory controller scheduling), HBM; course key issues; next steps/research | ⬜ |

## Notes on the materials
- Slides with mostly logistics (L1 14–22) are summarized, not taught.
- Repeated material (L11 2–21, L12 2–24, L16 1–20, L17 2–17 and 73–100, L18 3–25) will be taught once and reviewed briefly where it repeats.
- L1 slides 76–77 (cache examples) carry a "Fall 2022" footer: reused from the previous year.
- L1 slide 51 has no extractable text (image only) and needs to be viewed as an image.
