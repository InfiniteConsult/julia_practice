### `0083_benchmark_tools.jl`

```julia
# 0083_benchmark_tools.jl
# Introduces BenchmarkTools.jl for accurate performance measurement.

# 1. Import the '@btime' macro.
#    Requires BenchmarkTools.jl to be installed. See Explanation.
import BenchmarkTools: @btime

# 2. Include the code we want to benchmark.
include("my_math.jl")

# 3. Define a slightly more complex function to benchmark.
function sum_of_add_two(n::Int)
    total = 0
    for i in 1:n
        # Call the function inside the loop
        total += MyMath.add_two(i)
    end
    return total
end

# --- Benchmarking ---

println("--- Benchmarking sum_of_add_two(1000) ---")

# 4. Use the '@btime' macro.
#    '@btime Expression' runs the expression many times to get a
#    statistically accurate measurement of its *minimum* execution time.
#    It automatically handles things like warmup runs.
@btime sum_of_add_two(1000)

# 5. Benchmark with input variables (Incorrectly - see next lesson)
#    If the input is a variable, simply putting it in the expression
#    can lead to inaccurate results because it might measure
#    global variable lookup time.
input_size = 10000
println("\n--- Benchmarking sum_of_add_two(input_size) ---")
@btime sum_of_add_two(input_size)
println("(Note: This result might be inaccurate, see next lesson on interpolation)")

```

-----

### Explanation

This script introduces the **`BenchmarkTools.jl`** package, the standard and most reliable tool in Julia for measuring the performance of code accurately.

-----

**Installation Note:**

`BenchmarkTools.jl` is not part of Julia's standard library. You need to add it to your project environment once.

1.  Start the Julia REPL: `julia`
2.  Enter Pkg mode: `]`
3.  Add the package: `add BenchmarkTools`
4.  Exit Pkg mode: Press Backspace or `Ctrl+C`.
5.  You can now run this script.

-----

  * **Core Concept: Accurate Measurement**
    Simply running code once with `@time` (Julia's basic timing macro) is often unreliable for measuring performance. Results can be noisy due to JIT compilation overhead on the first run, system background tasks, CPU frequency scaling, etc. `BenchmarkTools.jl` is designed to overcome these issues.

  * **The `@btime` Macro:**

      * **Purpose:** `@btime Expression` provides a quick and easy way to get a reliable estimate of the **minimum execution time** of an `Expression`.
      * **How it Works (Simplified):**
        1.  **Warmup:** It runs the `Expression` once or twice initially to ensure everything (including the function itself and any functions it calls) is compiled by the JIT.
        2.  **Sampling:** It then runs the `Expression` in a loop many times, collecting execution times for each run.
        3.  **Statistics:** It calculates statistics on these times, paying special attention to the **minimum** time, which is usually the best estimate of the code's performance when system conditions are optimal (e.g., caches are hot).
        4.  **Output:** It prints a concise summary including the minimum time, the number of memory allocations, and the total memory allocated.

  * **Why Minimum Time?** In performance tuning, we are often most interested in the best possible execution time the code can achieve under ideal conditions. Average time can be skewed upwards by random system events, but the minimum time reflects the code's inherent speed limit more closely.

  * **Memory Allocations:** `@btime` also reports memory allocations (`allocs:` and memory size). This is **critical**. Unexpected memory allocations are a major sign of type instability or inefficient code (like creating temporary arrays). Aiming for `0 allocations` is often a key goal in high-performance code.

  * **Benchmarking with Variables (Caveat):**
    As noted in the script, simply using a global variable like `input_size` inside `@btime` can skew the results. `@btime` might include the time it takes to look up that global variable in its measurement. The next lesson (`0084_benchmark_interpolation.jl`) will show the correct way to handle this using `$` interpolation.

  * **Rule of Thumb:** Use `@btime` whenever you need a quick but reliable measurement of a function call or code snippet's speed and memory usage. It's the go-to tool for performance iteration.

-----

  * **References:**
      * **`BenchmarkTools.jl` Documentation:** [https://github.com/JuliaCI/BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl)
      * **Julia Official Documentation, Manual, "Performance Tips":** Recommends using `BenchmarkTools.jl` for accurate measurements.

-----

To run the script:

1.  Make sure `my_math.jl` (from lesson 0080) is in the same directory.
2.  Ensure `BenchmarkTools.jl` is installed (see installation note).
3.  Run `julia 0083_benchmark_tools.jl` from your terminal.

<!-- end list -->

```shell
$ julia 0083_benchmark_tools.jl
--- Benchmarking sum_of_add_two(1000) ---
  1.485 ns (0 allocations: 0 bytes)

--- Benchmarking sum_of_add_two(input_size) ---
  5.192 ns (0 allocations: 0 bytes)
(Note: This result might be inaccurate, see next lesson on interpolation)
```

*(Replace `### ns minimum time: ... ###` with the actual timings and allocations you observe. The exact numbers will vary based on your CPU.)*