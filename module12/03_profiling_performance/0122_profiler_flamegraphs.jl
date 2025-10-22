import Profile
try
    import PProf
catch e
    println("ERROR: PProf.jl not found.")
    println("Please install it: Open Julia REPL, type ']', then 'add PProf'")
    println("Viewing the output file requires 'pprof' (Go tool) and 'graphviz'.")
    exit(1)
end

function work_level_1(n)
    s = 0.0
    for i in 1:n; s += sin(sqrt(float(i))); end
    return s
end

function work_level_2(n)
    s = 0.0
    for _ in 1:5
        s += work_level_1(n ÷ 5)
    end
    for i in 1:(n ÷ 10); s += cos(float(i)); end
    return s
end

function main_computation(n)
    println("Starting main computation...")
    result = work_level_2(n)
    println("Main computation finished.")
    return result
end

println("--- Warming up (compiling) functions ---")
warmup_n = 1_000_000
_ = main_computation(warmup_n)
println("Warmup finished.")

Profile.clear()

println("\n--- Running computation under Profile.@profile ---")
profile_n = 5_000_000
Profile.@profile main_computation(profile_n)
println("Profiling finished.")

output_filename = "profile.pb.gz"
println("\n--- Saving profile data to '$output_filename' using PProf.jl ---")
try
    PProf.pprof(out = output_filename)
    println("Profile data saved successfully.")
    println("\nTo view the flame graph, install 'pprof' (see explanation)")
    println("and run:")
    println("  pprof -http=:8080 $output_filename")
    println("(Then open http://localhost:8080 in your browser and select 'Flame Graph')")
catch e
     println("\nError saving profile data using PProf: $e")
end

println("\n--- End of Script ---")