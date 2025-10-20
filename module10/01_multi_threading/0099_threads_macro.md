### `0099_threads_macro.jl`

```julia
# 0099_threads_macro.jl
# Introduces Threads.@threads for static parallelization of for loops.
# Requires running Julia with multiple threads (e.g., 'julia -t 4')

import Base.Threads: @threads, threadid, nthreads

# --- Example 1: Safe Parallel Loop (Writing to unique indices) ---
println("--- Example 1: Safe Parallel Loop ---")

N = 10 # Number of iterations
results = zeros(Float64, N) # Array to store results

println("Main script on thread: ", threadid())
println("Looping $N times using $(nthreads()) threads...")

# 1. Use 'Threads.@threads' before a 'for' loop.
#    Julia divides the loop iterations (1:N) into chunks,
#    one chunk per available thread. Each thread executes its chunk.
Threads.@threads for i in 1:N
    # Simulate work for each iteration
    work_val = 0.0
    for _ in 1:20_000_000 # Shorter loop for quicker demo
        work_val += rand()
    end

    # Report which thread handled which iteration
    println("  Iteration $i running on thread ", threadid())

    # CRITICAL: This is safe *only* because each thread writes
    # to a unique, non-overlapping index results[i].
    # There is no shared mutable state being modified concurrently.
    results[i] = work_val
end # The main thread waits here until *all* threads finish their chunks.

println("Loop finished.")
println("Results: ", results)


# --- Example 2: Data Race (Incorrectly modifying shared state) ---
println("\n--- Example 2: Data Race ---")

total_sum_incorrect = 0.0 # Shared mutable variable
iterations_race = 1_000_000

println("Calculating sum incorrectly (data race)...")

# 2. INCORRECT use of @threads with shared mutable state.
Threads.@threads for i in 1:iterations_race
    # !! DATA RACE !!
    # Multiple threads read 'total_sum_incorrect', add 1.0,
    # and try to write back simultaneously. Updates will be lost.
    global total_sum_incorrect += 1.0
end

println("Loop finished.")
# The result will be significantly LESS than iterations_race.
println("Incorrect Total Sum (will be < $iterations_race): ", total_sum_incorrect)
println("This demonstrates a read-modify-write data race.")

```

-----

### Explanation

This script introduces **`Threads.@threads`**, a macro designed for simple **parallelization of `for` loops**. It offers a straightforward way to distribute loop iterations across multiple threads but requires careful consideration of **data safety**.

  * **Core Concept: Static Loop Scheduling**
    `Threads.@threads for i in iterable ... end` tells Julia to divide the work of the loop iterations among the available threads.

      * **Static Schedule:** Unlike `@spawn`'s dynamic work-stealing, `@threads` typically performs a **static schedule**. It divides the iteration space (e.g., `1:N`) into roughly equal chunks (approximately `N / nthreads()` iterations per chunk) and assigns one chunk to each thread (`1` to `nthreads()`).
      * **Implicit Wait:** The code *after* the `@threads for` loop only executes **after all threads** have completed their assigned chunks. The main thread implicitly waits.

  * **When to Use `@threads`:**
    It's best suited for **"embarrassingly parallel"** loops where:

    1.  Each iteration is **independent** of the others (the calculation for `i` doesn't depend on the result for `i-1`).
    2.  The amount of work per iteration is **roughly equal**.
    3.  You are primarily performing **CPU-bound work**.

  * **The Critical Danger: Data Races**

      * **Example 1 (Safe):** This loop is safe because each thread writes to a **separate, unique location** in the `results` array (`results[i]`). There's no possibility of two threads trying to modify the *same* memory location simultaneously.
      * **Example 2 (Unsafe - Data Race):** This loop demonstrates a **classic data race**. `total_sum_incorrect` is a single variable shared by all threads. The operation `total_sum_incorrect += 1.0` is **not atomic** (indivisible). It involves three steps:
        1.  **Read** the current value of `total_sum_incorrect`.
        2.  **Modify** the value (add 1.0).
        3.  **Write** the new value back.
      * If Thread 2 reads the value (`100`), then Thread 3 reads the value (`100`) *before* Thread 2 writes its result (`101`), both threads will eventually write `101`. One increment is lost. This happens thousands of times, leading to a final sum far less than the number of iterations.
      * **`global` Keyword:** Note the use of `global total_sum_incorrect += 1.0`. Just like in single-threaded loops (Module 2), modifying a global variable from within the loop's scope requires the `global` keyword.

  * **`@threads` vs. `@spawn`:**

      * **`@threads`:** Simpler syntax for basic `for` loops. Static scheduling (can be inefficient if work per iteration varies greatly). **Requires manual care** regarding data races if shared mutable state is involved.
      * **`@spawn`:** More flexible (can parallelize any code block, not just loops). Dynamic work-stealing scheduler (better load balancing for uneven tasks). Still requires manual synchronization (`fetch`) and care with shared mutable state.

**Guideline:** Prefer `@threads` for simple, independent, balanced `for` loops where writes go to unique locations. For more complex scenarios or when modifying shared state safely, use `@spawn` combined with locks or atomics (covered next). Always be extremely vigilant about data races when using `@threads` with shared mutable variables.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Multi-Threading", `Threads.@threads`:** Explains the macro and its use cases. Explicitly warns about data races.

-----

To run the script:

*(You MUST start Julia with multiple threads, e.g., `julia -t 4 0099_threads_macro.jl`)*

```shell
$ julia -t 4 0099_threads_macro.jl
--- Example 1: Safe Parallel Loop ---
Main script on thread: 1
Looping 10 times using 4 threads...
  Iteration 1 running on thread 1
  Iteration 4 running on thread 2
  Iteration 7 running on thread 3
  Iteration 10 running on thread 4
  Iteration 2 running on thread 1
  Iteration 5 running on thread 2
  Iteration 8 running on thread 3
  Iteration 3 running on thread 1
  Iteration 6 running on thread 2
  Iteration 9 running on thread 3
Loop finished.
Results: [###, ###, ###, ###, ###, ###, ###, ###, ###, ###]

--- Example 2: Data Race ---
Calculating sum incorrectly (data race)...
Loop finished.
Incorrect Total Sum (will be < 1000000): ###.0 # A value significantly less than 1,000,000
This demonstrates a read-modify-write data race.
```

*(The exact order of iterations per thread may vary. Results `###` will be floats. The incorrect total sum will vary between runs but will be less than 1,000,000.)*