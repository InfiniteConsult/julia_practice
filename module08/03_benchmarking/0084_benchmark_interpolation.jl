# 0084_benchmark_interpolation_revised_sin.jl
import BenchmarkTools: @btime

# --- Setup ---
# *** CRITICAL: Use a NON-CONST global ***
# The value itself doesn't really matter, just that it's global and non-const
global_x = 100.0 # Use a Float64 for sin

# --- Benchmarking ---

println("--- Benchmark 1: Non-Const Global Directly (INCORRECT) ---")
# Accessing the non-const global 'global_x' inside the benchmark loop.
# Measures lookup cost + sin() cost.
@btime sin(global_x)

println("\n--- Benchmark 2: Non-Const Global Interpolated (CORRECT) ---")
# Interpolating the *value* of the non-const global.
# Measures sin() cost ONLY.
@btime sin($global_x)

println("\n--- Benchmark 3: Literal (Reference) ---")
# Using the literal value directly. Should be similar to Benchmark 2.
@btime sin(100.0)