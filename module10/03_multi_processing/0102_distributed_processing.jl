import Distributed

import Sockets

import Base: fetch

println("--- DIstributed Processing Setup ---")
num_procs = Distributed.nprocs()
num_workers = Distributed.nworkers()

println("Total processes (main + workers): ", num_procs)
println("Number of worker processes: ", num_workers)

if num_procs <= 1
    println("WARNING: No worker process found.")
    println("Restart Julia with the '-p N' flag (e.g., 'julia -p 4')")
    exit()
end

main_pid = Distributed.myid()
worker_pids = Distributed.workers()

println("Main process ID: ", main_pid)
println("Worker process IDs: ", worker_pids)

println("\n--- Remote Execution ---")

Distributed.@everywhere begin
    import Sockets
    MY_CONSTANT = 10

    function get_info()
        pid = Distributed.myid()
        host = Sockets.gethostname()
        thread_id = Threads.threadid()
        return "Process $pid on host '$host' (thread $thread_id) knows MY_CONSTANT = $MY_CONSTANT"
    end
end

target_worker = worker_pids[1]
println("Sparning task on worker $target_worker...")
future = Distributed.@spawnat target_worker get_info()

println("Waiting for result from worker $target_worker...")
result = fetch(future)
println("Result from worker $target_worker: \"$result\"")

println("\n--- Distributed Map-Reduce (@distributed) ---")

N = 10
println("Calculating sum of squares from 1 to $N across workers...")

final_sum = Distributed.@distributed (+) for i in 1:N
    pid = Distributed.myid()
    println("   Worker $pid processing i = $i")
    i^2
end

println("Distributed loop finished.")
println("Final sum of squares: ", final_sum)
