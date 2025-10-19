# 1. Import necessary components.
import BenchmarkTools: @benchmark, @benchmarkable, BenchmarkGroup, run, minimum, median

# 2. Include our math functions.
include("my_math.jl") # Contains MyMath.add_two(x)

# 3. Define another function to compare.
function add_two_alternative(x)
    # A slightly different (though likely optimized identically) way
    y = x
    y += 1
    y += 1
    return y
end

# --- @benchmark Macro ---
println("--- @benchmark for detailed analysis ---")

# 4. Use '@benchmark' for a more thorough analysis than '@btime'.
#    It runs many more samples and provides richer statistical output.
#    Remember to interpolate the argument!
input_val = 1000
bench_result = @benchmark MyMath.add_two($input_val)

# 5. Display the detailed result.
#    The raw result object contains a lot of information.
#    Printing it shows detailed quantiles, memory, etc.
println("Detailed @benchmark result for MyMath.add_two:")
display(bench_result)
# In interactive sessions (like REPL), just running '@benchmark' prints this.

# --- BenchmarkGroup ---
println("\n--- Comparing functions with BenchmarkGroup ---")

# 6. Create a BenchmarkGroup to organize related benchmarks.
#    It acts like a dictionary mapping names (Strings) to benchmarks.
suite = BenchmarkGroup()

# 7. Add benchmarks to the suite using dictionary-like syntax.
#    The value side uses '@benchmarkable' which *defines* a benchmark
#    without running it immediately. Remember interpolation!
suite["original"] = @benchmarkable MyMath.add_two($input_val)
suite["alternative"] = @benchmarkable add_two_alternative($input_val)

# 8. Run the entire suite.
#    'run(suite, verbose=true)' executes all defined benchmarks.
#    'verbose=true' prints results as they complete.
results = run(suite, verbose=true)

# 9. Access results programmatically.
#    'results' is also like a dictionary holding the Trial objects.
#    BenchmarkTools provides 'minimum()' and 'median()' functions
#    that extract the relevant TrialEstimate from a Trial. Access '.time'.
println("\nAccessing results programmatically:")
println("Minimum time for 'original': ", minimum(results["original"]).time, " ns")
println("Median time for 'alternative': ", median(results["alternative"]).time, " ns")

# Note: More advanced comparison/judging tools exist within BenchmarkTools.jl