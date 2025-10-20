### `0096_module_intro.md`

This module tackles **parallelism**, the technique of executing computations simultaneously to leverage modern multi-core processors. We will distinguish this sharply from the **concurrency** explored in Module 7 and introduce Julia's powerful tools for both shared-memory (multi-threading) and distributed-memory (multi-processing) parallelism.

---
## Concurrency vs. Parallelism Revisited

* **Concurrency (Module 7):** Primarily managed with `Task`s (`@async`). Focuses on **managing many tasks over time**, often interleaving their execution on a **single OS thread**. Tasks yield control during blocking operations (like I/O or `sleep`), preventing one slow operation from halting progress on others. Excellent for I/O-bound workloads (like handling many network clients).
* **Parallelism (This Module):** Focuses on **executing multiple tasks truly simultaneously** to speed up CPU-bound work. This requires utilizing multiple CPU cores via:
    * **Multi-Threading:** Multiple OS threads operating within a **single process**, sharing the same memory space.
    * **Multi-Processing:** Multiple independent OS **processes**, each with its own separate memory space.

---
## Julia's Parallelism Advantage: No GIL

A defining feature, especially compared to languages like CPython, is Julia's **lack of a Global Interpreter Lock (GIL)**. This means:

* **True Shared-Memory Parallelism:** Julia code running on Thread 1 can execute *at the exact same physical time* as Julia code running on Thread 2, provided they are scheduled on different CPU cores. 
* **C++/Rust Level Capability:** This enables genuine in-process, shared-memory parallelism, matching the capabilities of compiled languages like C++ and Rust, which is crucial for maximizing performance on modern hardware.

---
## The Responsibility: Thread Safety

With the power of shared-memory parallelism comes the absolute requirement of **thread safety**.

* **Data Races:** When multiple threads access shared, mutable data without proper synchronization, and at least one access is a write, you have a **data race**. This leads to unpredictable results, memory corruption, and non-deterministic crashes that are notoriously difficult to debug.
* **Synchronization:** Protecting shared data requires **synchronization mechanisms** like locks or atomic operations to ensure that critical sections of code are executed by only one thread at a time or that updates happen indivisibly.
* **Non-Negotiable:** Failure to ensure thread safety *will* break your program in subtle and catastrophic ways. Understanding and correctly applying synchronization primitives is not optional; it's a fundamental requirement of multi-threaded programming.

---
## Relevance to High-Performance Computing (HFT)

Parallelism is essential for low-latency systems:

* Processing data from multiple market feeds simultaneously.
* Running computationally intensive calculations (e.g., signal processing, model execution) for different instruments or strategies in parallel.
* Reacting to incoming events with minimal delay by dedicating threads or processes to specific tasks.

The tools covered in this module—`Threads`, `Distributed`, atomics, and SIMD—are the building blocks for constructing such high-performance, parallel systems in Julia.

---
* **References:**
    * **Julia Official Documentation, Manual, "Parallel Computing":** Provides a high-level overview of Julia's multi-threading and distributed computing capabilities.
    * **Julia Official Documentation, Manual, "Multi-Threading":** Details the specifics of Julia's threading model and associated tools.