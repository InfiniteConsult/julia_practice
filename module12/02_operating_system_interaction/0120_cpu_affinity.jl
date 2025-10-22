try
    import ThreadPinning
catch e
    println("ERROR: ThreadPinning.jl not found.")
    println("Please install it: Open Julia REPL, type ']', then 'add ThreadPinning'")
    exit(1)
end
import Base.Threads: threadid, nthreads

if nthreads() < 2
    println("WARNING: Multi-threading is DISABLED (Threads.nthreads() == $(nthreads())).")
    println("Restart Julia with '-t N' (N >= 2) to run this demo.")
    exit()
end

println("--- CPU Affinity Demo using ThreadPinning.jl ---")
println("Total Julia threads available: ", nthreads())

println("\n--- Initial State ---")
ThreadPinning.threadinfo()

pinning_strategy = :cores
println("\n--- Pinning threads with strategy: $pinning_strategy ---")
try
    ThreadPinning.pinthreads(pinning_strategy)
    println("Pinning successful (using pinthreads).")
catch e
    println("ERROR during pinning: $e")
    println("Ensure you have appropriate permissions (may require admin/root on some systems).")
end

println("\n--- State After Pinning ---")
ThreadPinning.threadinfo()

println("\n--- Unpinning threads ---")
try
    ThreadPinning.unpinthreads()
    println("Unpinning successful.")
catch e
    println("ERROR during unpinning: $e")
end

println("\n--- State After Unpinning ---")
ThreadPinning.threadinfo()

println("\nAffinity demo finished.")