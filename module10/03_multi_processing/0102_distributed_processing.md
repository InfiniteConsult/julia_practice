### `0102_distributed_processing.jl`

```julia
# 0102_distributed_processing.jl
# Introduces Distributed.jl for multi-processing.
# MUST BE RUN WITH: julia -p N (e.g., julia -p 4)

# 1. Import the Distributed standard library.
#    '-p N' starts Julia with N additional "worker" processes.
import Distributed

# --- Setup and Process IDs ---
println("--- Distributed Processing Setup ---")

# 2. Check the number of available processes.
num_procs = Distributed.nprocs() # Total number of processes (main + workers)
num_workers = Distributed.nworkers() # Number of worker processes only

println("Total processes (main + workers): ", num_procs)
println("Number of worker processes: ", num_workers)

if num_procs <= 1
    println("WARNING: No worker processes found.")
    println("Restart Julia with the '-p N' flag (e.g., 'julia -p 4')")
    # Exit cleanly if no workers, as subsequent code requires them.
    exit()
end

# 3. Get process IDs.
main_pid = Distributed.myid()      # ID of the *current* process (always 1 for the main script)
worker_pids = Distributed.workers() # Vector of worker process IDs (e.g., [2, 3, 4, 5])

println("Main process ID: ", main_pid)
println("Worker process IDs: ", worker_pids)

# --- Executing Code Remotely ---
println("\n--- Remote Execution ---")

# 4. Define code that needs to exist on *all* processes using '@everywhere'.
#    Worker processes start with a clean slate; they don't inherit
#    definitions from the main process unless explicitly told.
Distributed.@everywhere begin
    # This block is executed on the main process AND all workers.
    import Sockets # Make Sockets available on workers if needed inside function
    MY_CONSTANT = 10

    function get_info()
        pid = Distributed.myid()
        host = Sockets.gethostname()
        thread_id = Threads.threadid() # Each process has at least one thread
        return "Process $pid on host '$host' (thread $thread_id) knows MY_CONSTANT = $MY_CONSTANT"
    end
end

# 5. Execute a function remotely on a specific worker using '@spawnat'.
#    '@spawnat worker_pid expression' runs the expression on that worker.
#    It returns a 'Future', which is a handle to the remote result.
target_worker = worker_pids[1] # e.g., process 2
println("Spawning task on worker $target_worker...")
future = Distributed.@spawnat target_worker get_info()

# 6. Retrieve the result from the remote worker using 'fetch()'.
#    'fetch(future)' blocks until the remote task completes and sends
#    its result back to the main process (involves serialization).
println("Waiting for result from worker $target_worker...")
result = fetch(future)
println("Result from worker $target_worker: \"$result\"")

# --- Parallel Map-Reduce Across Processes ---
println("\n--- Distributed Map-Reduce (@distributed) ---")

N = 10
println("Calculating sum of squares from 1 to $N across workers...")

# 7. Use '@distributed (reducer) for ... end' for parallel loops.
#    This divides the loop iterations among the *worker* processes.
#    Each worker computes its portion, and the results are combined
#    using the specified 'reducer' function (e.g., '+').
#    Data dependencies must be explicitly handled (e.g., using @everywhere).
#    The loop variable 'i' is automatically sent to the worker.
#    NOTE: Unlike Threads.@threads, this does NOT run on the main process (ID 1).
final_sum = Distributed.@distributed (+) for i in 1:N
    # This code block runs on a worker process.
    pid = Distributed.myid()
    println("  Worker $pid processing i = $i")
    # Return the value for this iteration to be reduced
    i^2
end # Main process blocks here until all workers finish and reduction completes.

println("Distributed loop finished.")
println("Final sum of squares: ", final_sum)

```

-----

### Explanation

This script introduces **`Distributed.jl`**, Julia's standard library for **multi-processing**. This contrasts with multi-threading by using separate **OS processes**, each with its own independent memory space, enabling parallelism that can scale beyond a single machine and provides memory isolation.

## Core Concepts: Threads vs. Processes

  * **Multi-Threading (`Threads`, Module 10):**
      * **Pros:** Runs within a **single process**, allowing **direct sharing of memory**. Communication is extremely fast (just read/write variables). Low overhead to start tasks (`@spawn`).
      * **Cons:** Requires careful **thread safety** (locks, atomics) to prevent data races. A crash in one thread can bring down the entire process. Limited to the cores on a single machine.
  * **Multi-Processing (`Distributed`, This Lesson):**
      * **Pros:** Runs in **multiple, separate processes**. Provides complete **memory isolation** (no data races possible on standard variables). A crash in one worker process does not affect others. Can scale across **multiple machines** over a network (though this example uses local processes).
      * **Cons:** **Communication is expensive**. Passing data between processes requires **serialization** (converting objects to a byte stream), network/inter-process communication (IPC), and **deserialization**. High overhead to start worker processes (`julia -p N`).

**Guideline (HFT):** Use `Threads` for low-latency, tightly coupled computations on a single machine where shared memory performance is critical (e.g., parallel signal processing within one market data handler). Use `Distributed` for higher-level task parallelism where memory isolation is desired, fault tolerance is needed, or scaling across machines is required (e.g., running independent strategy simulations, connecting to different exchange gateways in separate processes).

## Using `Distributed.jl`

1.  **Launch Workers (`julia -p N`):** You **must** start Julia with the `-p N` flag (e.g., `julia -p 4`) to create `N` additional worker processes alongside the main interactive process (Process 1). Alternatively, use `Distributed.addprocs(N)` programmatically (less common for script-based work).
2.  **Process IDs:** `Distributed.nprocs()` gives the total count (main + workers). `Distributed.nworkers()` gives just the worker count. `Distributed.myid()` returns the ID of the current process. `Distributed.workers()` returns a list of worker IDs (usually `[2, 3, ..., N+1]`).
3.  **Code on Workers (`@everywhere`):** Worker processes start "empty." They don't inherit code definitions or variable values from Process 1. The `Distributed.@everywhere begin ... end` block ensures the enclosed code (module imports, function definitions, constant assignments) is executed on **all** processes (main + workers), making it available everywhere.
4.  **Remote Execution (`@spawnat`):** `Distributed.@spawnat worker_id expression` executes the `expression` specifically on the worker process with ID `worker_id`. It returns a `Future`, which is a remote reference to the task.
5.  **Fetching Remote Results (`fetch`):** `fetch(future)` waits for the remote task referenced by `future` to complete and then transfers its result back to the calling process (involving serialization/deserialization).
6.  **Parallel Loop (`@distributed`):** `Distributed.@distributed (reducer) for ... end` provides a parallel map-reduce pattern across **worker processes**.
      * It divides the loop iterations among the workers.
      * Each worker executes the loop body for its assigned iterations.
      * The values returned by each iteration on each worker are collected.
      * The specified `reducer` function (e.g., `+`, `vcat`, `append!`) is used to combine the results from all workers into a final result returned on the main process.

## Communication Overhead

Remember that any data sent to (`@spawnat`, loop variables in `@distributed`) or received from (`fetch`) worker processes must be serialized and deserialized. This adds significant overhead compared to threads accessing shared memory directly. `Distributed` is best for coarse-grained parallelism where the computation time is large relative to the communication time.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Parallel Computing", "Distributed Computing":** Provides a detailed guide to `Distributed.jl`.
      * **Julia Official Documentation, Standard Library, `Distributed`:** Documents `addprocs`, `nprocs`, `nworkers`, `myid`, `workers`, `@everywhere`, `@spawnat`, `fetch`, `@distributed`.

-----

To run the script:

*(You MUST start Julia with multiple worker processes, e.g., `julia -p 4 0102_distributed_processing.jl`)*

```shell
$ julia -p 4 0102_distributed_processing.jl
--- Distributed Processing Setup ---
Total processes (main + workers): 5
Number of worker processes: 4
Main process ID: 1
Worker process IDs: [2, 3, 4, 5]

--- Remote Execution ---
Spawning task on worker 2...
Waiting for result from worker 2...
Result from worker 2: "Process 2 on host '...' (thread 1) knows MY_CONSTANT = 10"

--- Distributed Map-Reduce (@distributed) ---
Calculating sum of squares from 1 to 10 across workers...
      From worker 2:   Worker 2 processing i = 1
      From worker 3:   Worker 3 processing i = 4
      From worker 4:   Worker 4 processing i = 7
      From worker 5:   Worker 5 processing i = 10
      From worker 2:   Worker 2 processing i = 2
      From worker 3:   Worker 3 processing i = 5
      From worker 4:   Worker 4 processing i = 8
      From worker 2:   Worker 2 processing i = 3
      From worker 3:   Worker 3 processing i = 6
      From worker 4:   Worker 4 processing i = 9
Distributed loop finished.
Final sum of squares: 385
```

*(The exact hostname `'...'` and the interleaving of worker output will vary.)*