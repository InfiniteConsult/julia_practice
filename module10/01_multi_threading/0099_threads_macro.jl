import Base.Threads: @threads, threadid, nthreads

println("--- Example 1: Safe Parallel Loop ---")

N = 10
results = zeros(Float64, N)

println("Main script on thread: ", threadid())
println("Looping $N times using $(nthreads()) threads...")

Threads.@threads for i in 1:N
    work_val = 0.0
    for _ in 1:20_000_000
        work_val += rand()
    end

    println("  Iteration $i running on thread ", threadid())

    results[i] = work_val
end

println("Loop finished.")
println("Results: ", results)

println("\n--- Example 2: Data Race ---")

total_sum_incorrect = 0.0
iterations_race = 1_000_000

Threads.@threads for i in 1:iterations_race
    global total_sum_incorrect += 1.0
end

println("Loop finished.")
println("Incorrect Total Sum (will be < $iterations_race): ", total_sum_incorrect)
println("This demonstrates a read-modify-write data race.")
