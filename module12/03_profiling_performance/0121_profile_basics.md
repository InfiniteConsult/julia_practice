### `0121_profiler_basics.jl`

```julia
# 0121_profiler_basics.jl
# Introduces the built-in Profile standard library.

# 1. Import the Profile module (part of Julia's standard library).
import Profile

# 2. Define some functions with varying amounts of "work".
#    (Using simple loops; real work would be more complex).
function work_level_1(n)
    s = 0.0
    for i in 1:n; s += sin(sqrt(float(i))); end
    return s
end

function work_level_2(n)
    # Calls level 1 multiple times
    s = 0.0
    for _ in 1:5
        s += work_level_1(n ÷ 5)
    end
    # Add some work at this level too
    for i in 1:(n ÷ 10); s += cos(float(i)); end
    return s
end

function main_computation(n)
    println("Starting main computation...")
    # Call the intermediate function
    result = work_level_2(n)
    println("Main computation finished.")
    return result
end

# --- Profiling ---

# 3. Warmup Run (CRITICAL!)
#    We MUST run the code once *before* profiling to ensure
#    all functions are compiled by the JIT. Profiling the first
#    run would incorrectly measure compilation time.
println("--- Warming up (compiling) functions ---")
warmup_n = 1_000_000
_ = main_computation(warmup_n) # Discard result using '_'
println("Warmup finished.")

# 4. Clear any previous profiling data.
Profile.clear()

# 5. Run the code under the profiler using 'Profile.@profile'.
#    Need to qualify '@profile' since we used 'import Profile'.
println("\n--- Running computation under @profile ---")
profile_n = 5_000_000 # Use a larger N for profiling
Profile.@profile main_computation(profile_n)
println("Profiling finished.")

# 6. Print the profiling results to the console.
println("\n--- Displaying Profile Results (Text Format) ---")
# 'Profile.print()' displays the collected stack traces.
# Options like 'format=:flat' or 'sortedby=:count' exist.
Profile.print(format=:tree, sortedby=:count)

# Optional: Clear data after printing if you intend to profile something else later.
# Profile.clear()

println("\n--- End of Script ---")
```

### Explanation

This script introduces Julia's built-in **statistical profiler**, available through the `Profile` standard library. Profiling is essential for identifying **performance bottlenecks** – the specific parts of your code where the most execution time is spent.

## Core Concept: Statistical (Sampling) Profiling

  * **How it Works:** Julia's profiler is a **sampling** profiler. It periodically interrupts the program's execution and records the **stack trace** – the sequence of functions currently being executed.
  * **Statistical Inference:** By collecting many such samples, it builds a statistical picture of where the program spends its time. Functions that appear frequently at the *top* of the recorded stack traces are likely the "hot spots" consuming the most CPU time.
  * **Low Overhead:** Sampling profilers generally have low overhead, making them suitable for analyzing performance-critical code.

## Using the Profiler

1.  **`import Profile`:** Load the standard library module.
2.  **Warmup (Critical):** Run your code at least once *before* profiling to ensure JIT compilation is complete. Profiling the first run measures compilation time, not execution performance.
3.  **`Profile.clear()`:** Clear any pre-existing profiling data before starting a new measurement.
4.  **`Profile.@profile expression`:** (Note the qualification `Profile.@profile` because we used `import Profile`). This macro enables sampling, executes the `expression`, and stops sampling. Data is stored internally.
5.  **`Profile.print(...)`:** Analyzes collected samples and prints a formatted report. Key options include:
      * `format=:tree` (default): Hierarchical call stack view.
      * `format=:flat`: Flat list sorted by time spent *in* the function itself.
      * `sortedby=:count` (default): Sorts by sample frequency.
      * `C=true`: Include calls into C libraries.
      * `noisefloor=...`: Hide entries below a percentage threshold.

## Interpreting the Tree Output

The default tree format shows stack traces. Read from **bottom to top**:

```
Count File:Line Function                    # Example Line
--------------------------------------------------------------
[100] ... main_computation                 # 100 samples total in this call stack
 [98] ... work_level_2                     # 98 samples were within work_level_2 or its children
  [90] ... work_level_1                    # 90 samples were further down inside work_level_1 (the hot spot)
  [8]  ... work_level_2                    # 8 samples were directly in work_level_2's own code
```

  * **Counts/Percentages:** High counts/percentages, especially deep in the indentation (leaves of the tree), indicate functions consuming significant time.
  * **Identifying Bottlenecks:** Look for the widest bars (highest counts) deepest in the call tree. In the example output provided previously, `work_level_1` and the math functions it calls (`sin`, `sqrt`, `float`) were clearly identified as the primary consumers of time.

Profiling is iterative: profile, identify, optimize, profile again.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Profiling":** Main guide to using the `Profile` module.
      * **Julia Official Documentation, Standard Library, `Profile`:** Documents `@profile`, `Profile.print`, `Profile.clear`.

-----

To run the script:

*(Ensure you're running with Julia 1.0 or later)*

```shell
$ julia 0121_profiler_basics.jl
--- Warming up (compiling) functions ---
Starting main computation...
Main computation finished.
Warmup finished.

--- Running computation under @profile ---
Starting main computation...
Main computation finished.
Profiling finished.

--- Displaying Profile Results (Text Format) ---
Overhead ╎ [+additional indent] Count File:Line  Function
=========================================================
  ╎60  @Base/client.jl:550  _start()
  ╎ 60  @Base/client.jl:317  exec_options(opts::Base.JLOptions)
  # ... (Rest of the detailed profile tree as shown in your output) ...
  # ... showing significant time spent within work_level_1 and its calls ...

--- End of Script ---
```
