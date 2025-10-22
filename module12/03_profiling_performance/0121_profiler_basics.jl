import Profile

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

println("\n--- Running computation under @profile ---")
profile_n = 5_000_000
Profile.@profile main_computation(profile_n)
println("Profiling finished.")

println("\n--- Displaying Profile Results (Text Format) ---")
Profile.print(format=:tree, sortedby=:count)

println("\n--- End of Script ---")