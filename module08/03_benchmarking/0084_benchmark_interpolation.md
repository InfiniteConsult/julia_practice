### `0084_benchmark_interpolation.jl`

```julia
# 0084_benchmark_interpolation.jl
# Demonstrates the CRUCIAL use of '$' interpolation in BenchmarkTools.

# 1. Import the '@btime' macro.
#    (Assumes BenchmarkTools.jl is installed)
import BenchmarkTools: @btime

# 2. Define a simple function to benchmark (we'll use a built-in one).
#    Using 'sin()' which is fast, making overhead more visible.

# 3. Define a NON-CONST global variable.
#    This is key to reliably showing the lookup overhead.
global_x = 100.0 # Use a Float64 for sin

# --- Benchmarking ---

println("--- Benchmark 1: Non-Const Global Directly (INCORRECT) ---")
# 4. Incorrect way: Use the non-const global variable directly.
#    '@btime' creates a timing function internally. Accessing
#    'global_x' involves a slow, runtime global lookup.
#    We measure lookup cost + sin() cost.
@btime sin(global_x)


println("\n--- Benchmark 2: Non-Const Global Interpolated (CORRECT) ---")
# 5. Correct way: Use '$' to interpolate the *value* of 'global_x'.
#    Before timing, '@btime' evaluates '$global_x' (getting 100.0)
#    and substitutes this *value* into the expression.
#    The benchmark effectively becomes '@btime sin(100.0)'.
#    This eliminates the global lookup overhead.
@btime sin($global_x)


println("\n--- Benchmark 3: Using a Literal (Reference) ---")
# 6. For comparison, benchmark with the literal value.
#    Allows maximum compiler optimization (constant propagation).
@btime sin(100.0)

```

-----

### Explanation

This script demonstrates one of the most critical details for using `BenchmarkTools.jl` correctly: **variable interpolation** using the dollar sign (`$`). Failing to use `$` when benchmarking expressions involving variables (especially non-`const` globals) is the **\#1 mistake** leading to inaccurate results.

  * **The Problem: Benchmarking Global Variable Access**

      * The `@btime` macro wraps the expression in a function for timing.
      * When you write `@btime sin(global_x)` using a **non-`const` global**, the timing function must perform a **runtime lookup** for `global_x` *every time* it runs. Accessing non-`const` globals is **slow** because the compiler cannot know its type or value beforehand.
      * Therefore, the first benchmark **incorrectly measures** the combined time of:
        1.  Looking up the global variable `global_x`.
        2.  Calling `sin` with the retrieved value.
      * This **pollutes** the measurement; you're not just timing `sin`, but also the slow global access, often leading to extra memory allocations as well.

  * **The Solution: `$` Interpolation**

      * The `$` symbol within `@btime` (and other `BenchmarkTools` macros) triggers **interpolation**.
      * When `@btime` sees `$global_x`, it **first evaluates** `global_x` in the current scope to get its *value* (which is `100.0`).
      * It then **substitutes this value** into the expression *before* creating the timing function.
      * So, `@btime sin($global_x)` becomes equivalent to `@btime sin(100.0)`.
      * The internal timing function now operates on a **constant value**, eliminating the slow global lookup and allowing the compiler to generate type-stable code.
      * This **correctly measures** only the execution time of `sin` operating on that value.

  * **Interpreting Results:**

      * **Benchmark 1 (No `$`)**: Shows a **slower** time and likely **memory allocations** (e.g., `1 allocation: 16 bytes`) due to the runtime global lookup and potential type instability.
      * **Benchmark 2 (`$`)**: Shows a **significantly faster** time and **zero allocations**. This accurately reflects the cost of the `sin` call itself.
      * **Benchmark 3 (Literal)**: May show an even **faster** time than Benchmark 2, also with **zero allocations**. This is because the compiler can perform the most aggressive constant propagation optimizations when it sees the literal value directly in the code at compile time. It represents the absolute lower bound.

  * **Rule of Thumb:** **ALWAYS** use `$` to interpolate variables (global or local) into expressions benchmarked with `@btime` or `@benchmark`. Treat the expression inside `@btime` as if it were running in its own little function world where it can't see outside variables unless you explicitly pass their values in via `$`.

-----

  * **References:**
      * **`BenchmarkTools.jl` Documentation, Manual, "Interpolating values into benchmark expressions":** This section explicitly explains the purpose and necessity of `$`.

-----

To run the script:

*(Requires `BenchmarkTools.jl` installed)*

```shell
$ julia 0084_benchmark_interpolation.jl
--- Benchmark 1: Non-Const Global Directly (INCORRECT) ---
  14.647 ns (1 allocation: 16 bytes)  # Slow, Allocates

--- Benchmark 2: Non-Const Global Interpolated (CORRECT) ---
  3.706 ns (0 allocations: 0 bytes)   # Faster, No Allocations

--- Benchmark 3: Using a Literal (Reference) ---
  0.743 ns (0 allocations: 0 bytes)   # Fastest (Constant Propagation), No Allocations
```

*(Your exact times will vary based on CPU, but the relative differences and allocation patterns should be similar.)*