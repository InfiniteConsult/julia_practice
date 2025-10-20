import Base.Threads

num_threads = Threads.nthreads()

println("Julia process launched with $num_threads thread(s).")

if num_threads == 1
    println("WARNING: Multi-threading is DISABLED.")
    println("Performance will be limited to a single core.")
    println("To enable parallelism for subsequent lessons, restart Julia")
    println("using one of the following methods:")
    println("  a) Command Line: julia -t N  (e.g., julia -t 4)")
    println("  b) Command Line: julia -t auto (uses all available logical cores)")
    println("  c) Environment Variable: export JULIA_NUM_THREADS=N (before starting Julia)")
else
    println("SUCCESS: Multi-threading is ENABLED.")
    println("Parallel execution using up to $num_threads threads is possible.")
end


main_thread_id = Threads.threadid()
println("This main script is currently running on thread ID: $main_thread_id")
