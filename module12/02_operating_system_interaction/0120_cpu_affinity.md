### `0120_cpu_affinity.jl`

```julia
# 0120_cpu_affinity.jl
# Demonstrates pinning Julia threads to specific CPU cores using ThreadPinning.jl.
# Requires the ThreadPinning.jl package and running Julia with multiple threads.

# 1. Import the package. See Explanation for installation.
try
    import ThreadPinning
catch e
    println("ERROR: ThreadPinning.jl not found.")
    println("Please install it: Open Julia REPL, type ']', then 'add ThreadPinning'")
    exit(1)
end
import Base.Threads: @spawn, threadid, nthreads

# 2. Check if multi-threading is enabled.
if nthreads() < 2
    println("WARNING: Multi-threading is DISABLED (Threads.nthreads() == $(nthreads())).")
    println("Restart Julia with '-t N' (N >= 2) to run this demo.")
    exit()
end

println("--- CPU Affinity Demo using ThreadPinning.jl ---")
println("Total Julia threads available: ", nthreads())

# 3. Display initial system topology and thread placement (optional but informative).
println("\n--- Initial State ---")
# threadinfo() provides a visual overview of cores, sockets, NUMA nodes,
# and where Julia threads are currently allowed to run (or currently are).
# By default, threads usually aren't pinned and can run anywhere.
ThreadPinning.threadinfo()

# 4. Pin threads using a predefined strategy.
#    ':cores' attempts to pin each Julia thread to a distinct physical core,
#    avoiding hyperthreads if possible. Other options include :sockets, :numa,
#    or explicit core IDs (e.g., 0:3).
pinning_strategy = :cores
println("\n--- Pinning threads with strategy: $pinning_strategy ---")
try
    ThreadPinning.pinthreads(pinning_strategy)
    println("Pinning successful (using pinthreads).")
catch e
    println("ERROR during pinning: $e")
    println("Ensure you have appropriate permissions (may require admin/root on some systems).")
    # Continue without pinning if it fails
end

# 5. Display the state *after* pinning.
#    threadinfo() should now show each Julia thread restricted to specific cores.
println("\n--- State After Pinning ---")
ThreadPinning.threadinfo()

# (Optional: Add work here using @spawn or @threads to see tasks running on pinned threads)

# 6. Unpin threads to restore default OS scheduling.
println("\n--- Unpinning threads ---")
try
    ThreadPinning.unpinthreads()
    println("Unpinning successful.")
catch e
    println("ERROR during unpinning: $e")
end

# 7. Display the state after unpinning.
#    Should revert towards the initial state where threads can run on any core,
#    though the OS might keep them somewhat localized initially.
println("\n--- State After Unpinning ---")
ThreadPinning.threadinfo()

println("\nAffinity demo finished.")
```

-----

### Explanation

This script demonstrates **CPU core pinning** (also known as setting thread affinity), a crucial technique in low-latency systems to ensure predictable performance by controlling which CPU core(s) a specific thread can run on. It uses the **`ThreadPinning.jl`** package.

-----

**Installation Note:**

`ThreadPinning.jl` is an external package. You need to add it to your project environment once.

1.  Start the Julia REPL: `julia`
2.  Enter Pkg mode: `]`
3.  Add the package: `add ThreadPinning`
4.  Exit Pkg mode: Press Backspace or `Ctrl+C`.
5.  You can now run this script (remembering to start Julia with multiple threads). Note that pinning functionality is primarily supported on **Linux**.

-----

## Core Concept: Thread Affinity and Performance Jitter

  * **Default OS Scheduling:** By default, the operating system's scheduler is free to **migrate** a running thread between different CPU cores.
  * **The Problem: Cache Invalidation & Jitter:** When a thread moves from Core A to Core B, data in Core A's L1/L2 caches becomes useless for that thread. The thread must repopulate Core B's caches, causing a significant, unpredictable **performance stall** or **latency spike (jitter)**.
  * **Low-Latency Impact:** In HFT and other real-time systems, unpredictable jitter is unacceptable. Consistent, low latency is paramount.

## The Solution: Core Pinning (`ThreadPinning.jl`)

  * **CPU Affinity:** This refers to the set of CPU cores on which a thread is *allowed* to run. Core pinning involves explicitly setting a thread's affinity, often to a single, specific core or a limited set.
  * **`ThreadPinning.jl`:** Provides functions to control thread affinity:
      * **`ThreadPinning.threadinfo(; kwargs...)`:** Displays a detailed visualization of the system topology (sockets, cores, hyperthreads, NUMA domains) and shows where Julia threads are currently placed or allowed to run. Indispensable for verifying pinning.
      * **`ThreadPinning.pinthreads(strategy; kwargs...)`:** Pins Julia threads according to a specified `strategy`. Common strategies include:
          * `:cores`: Pin threads sequentially to physical cores, avoiding hyperthreads if possible.
          * `:sockets`: Distribute threads round-robin across CPU sockets.
          * `:numa`: Distribute threads round-robin across NUMA memory domains.
          * Explicit Core IDs: Pass a vector or range of OS core IDs (e.g., `0:3` or `[0, 2, 4]`).
      * **`ThreadPinning.unpinthreads()`:** Removes pinning restrictions for all Julia threads, restoring the default OS scheduling behavior.
  * **Benefits of Pinning:**
    1.  **Eliminates Migration:** Prevents OS scheduler-induced moves.
    2.  **Maximizes Cache Locality:** Keeps thread data hot in specific L1/L2 caches.
    3.  **Reduces Jitter:** Leads to more predictable, lower-latency execution.
    4.  **Reduces Interference:** Isolates critical threads from other processes competing for the same core.

## Typical HFT Architecture

A common pattern is dedicating specific threads (pinned to specific cores) to distinct tasks (Network I/O, Strategy A, Strategy B, Order Management) to maximize cache efficiency and minimize interference.

## Important Notes

  * **Permissions:** Setting thread affinity might require specific OS permissions.
  * **Platform:** `ThreadPinning.jl`'s pinning functions work primarily on **Linux**. Querying functions like `threadinfo` may work elsewhere.
  * **Core Indexing:** OS core/CPU IDs are typically **0-indexed**. Be mindful when providing explicit lists. `ThreadPinning.jl`'s documentation clarifies its indexing conventions. The `threadinfo` output mapping clarifies which Julia thread ID maps to which OS core ID.

Core pinning is an advanced but essential technique for optimizing latency-sensitive applications by taking control of thread placement from the OS scheduler.

-----

  * **References:**
      * **`ThreadPinning.jl` Documentation:** ([https://github.com/carstenbauer/ThreadPinning.jl](https://github.com/carstenbauer/ThreadPinning.jl)). The primary source for usage and available strategies.
      * **Operating System Documentation (Linux `sched_setaffinity`):** Describes the underlying OS system calls.

-----

To run the script:

*(Requires `ThreadPinning.jl` installed and Julia started with multiple threads, e.g., `julia -t 4 0120_cpu_affinity.jl`. Output indicates an Intel i9-13900HX with 24 CPU-threads.)*

```shell
$ julia -t 4 0120_cpu_affinity.jl
--- CPU Affinity Demo using ThreadPinning.jl ---
Total Julia threads available: 4

--- Initial State ---
Hostname:       a8b1b1c0bbc3
CPU(s):         1 x 13th Gen Intel(R) Core(TM) i9-13900HX
CPU target:     alderlake
Cores:          24 (24 CPU-threads)
Core kinds:     16 "efficiency cores", 8 "performance cores".
NUMA domains:   1 (24 cores each)

Julia threads:  4

CPU socket 1
  0,1,2,3,4,5,6,7,8,9 (J1),10,11,12,13,14,15,
  16,17 (J2),18,19,20,21 (J3),22 (J4),23
# ... Legend ...
(Mapping: 1 => 9, 2 => 17, 3 => 21, 4 => 22,) # Initial OS placement

--- Pinning threads with strategy: cores ---
Pinning successful (using pinthreads).

--- State After Pinning ---
Hostname:       a8b1b1c0bbc3
CPU(s):         1 x 13th Gen Intel(R) Core(TM) i9-13900HX
CPU target:     alderlake
Cores:          24 (24 CPU-threads)
Core kinds:     16 "efficiency cores", 8 "performance cores".
NUMA domains:   1 (24 cores each)

Julia threads:  4

CPU socket 1
  0 (J1),1 (J2),2 (J3),3 (J4),4,5,6,7,8,9,10,11,12,13,14,15,
  16,17,18,19,20,21,22,23
# ... Legend ...
(Mapping: 1 => 0, 2 => 1, 3 => 2, 4 => 3,) # Pinned to first cores

--- Unpinning threads ---
Unpinning successful.

--- State After Unpinning ---
Hostname:       a8b1b1c0bbc3
CPU(s):         1 x 13th Gen Intel(R) Core(TM) i9-13900HX
CPU target:     alderlake
Cores:          24 (24 CPU-threads)
Core kinds:     16 "efficiency cores", 8 "performance cores".
NUMA domains:   1 (24 cores each)

Julia threads:  4

CPU socket 1
  0 (J2),1 (J1),2,3 (J3),4 (J4),5,6,7,8,9,10,11,12,13,14,15, # Example OS placement
  16,17,18,19,20,21,22,23
# ... Legend ...
(Mapping: 1 => 1, 2 => 0, 3 => 3, 4 => 4,) # Example after unpinning

Affinity demo finished.
```
