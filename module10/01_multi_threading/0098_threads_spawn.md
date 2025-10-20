### `0098_threads_spawn.jl`

```julia
# 0098_threads_spawn.jl
# Introduces Threads.@spawn for dynamic parallel task execution.
# Requires running Julia with multiple threads (e.g., 'julia -t 4')

import Base.Threads: @spawn, threadid
import Base: fetch # fetch is needed to get results

# 1. Define a function simulating CPU-intensive work.
function cpu_intensive_work(id::Int, iterations::Int)
    # Report which thread is starting the work for this ID
    println("Task $id: Starting on thread ", threadid())
    sum_val = 0.0
    # Perform a non-trivial computation
    for i in 1:iterations
        sum_val += sin(sqrt(float(i)))
    end
    # Report which thread finished the work
    println("Task $id: Finished on thread ", threadid(), " | Result: ", sum_val)
    return (id, sum_val) # Return a tuple with the ID and result
end

# --- Execution ---
println("Main script running on thread: ", threadid())
num_tasks = 4
iterations_per_task = 50_000_000

println("Spawning $num_tasks parallel tasks using Threads.@spawn...")

# 2. Create storage for the Task objects returned by @spawn.
tasks = Vector{Task}(undef, num_tasks)

# 3. Launch tasks using Threads.@spawn.
#    '@spawn' creates a Task and schedules it to run on any available thread
#    from Julia's thread pool. It returns the Task object immediately.
for i in 1:num_tasks
    # Schedule the function call to run in parallel
    tasks[i] = @spawn cpu_intensive_work(i, iterations_per_task)
end

println("All tasks spawned. Main thread continues while tasks run in parallel.")
println("Waiting for tasks to complete by calling fetch()...")

# 4. Wait for each task and retrieve its result using 'fetch()'.
#    'fetch(t)' blocks the *current* thread (Thread 1 here) until 't' finishes.
#    We collect results in an array.
results = Vector{Any}(undef, num_tasks) # Use Any for tuples, or be more specific
for i in 1:num_tasks
    println("Main: Waiting for Task ", i, "...")
    # fetch() blocks here if tasks[i] is not yet complete.
    task_result = fetch(tasks[i])
    results[i] = task_result
    println("Main: Fetched result from Task ", i)
end

println("\nAll tasks complete.")
println("Collected results:")
for res in results
    println("  ", res)
end

```

-----

### Explanation

This script introduces **`Threads.@spawn`**, the primary macro for launching **parallel tasks** in Julia's modern multi-threading system. It enables dynamic task creation and leverages an efficient work-stealing scheduler.

  * **Core Concept: Parallel Task Execution**
    `Threads.@spawn expression` takes a Julia expression (typically a function call), wraps it in a `Task`, and submits it to Julia's **multi-threaded scheduler**. This scheduler then assigns the task to run on one of the available **worker threads** (threads with ID \> 1) in Julia's thread pool, allowing it to execute in parallel with the main thread and other spawned tasks.
  * **`@spawn` vs. `@async`:**
      * `@async` (Module 7): Designed for **concurrency** on a *single* thread. Tasks yield cooperatively during I/O or explicit yields.
      * `@spawn`: Designed for **parallelism** across *multiple* threads/cores. Ideal for CPU-bound computations.
  * **Return Value: `Task` Object**
    Like `@async`, `@spawn` returns **immediately**, without waiting for the task to start or finish. It returns a `Task` object, which serves as a handle to the asynchronously executing computation.
  * **Work-Stealing Scheduler:**
    `@spawn` uses a sophisticated **work-stealing scheduler**. Each worker thread maintains a queue of tasks. If a thread finishes its own tasks and another thread still has tasks waiting in its queue, the idle thread can "steal" work from the busy thread. This provides excellent load balancing and CPU utilization, especially when tasks have varying durations.
  * **Synchronization and Results: `fetch(t::Task)`**
    To get the result of a task launched with `@spawn` and ensure it has completed, you use `fetch(t)`.
      * **Blocking:** `fetch(t)` **blocks** the calling thread until task `t` finishes execution.
      * **Return Value:** It returns the value returned by the expression executed within the task (e.g., the tuple `(id, sum_val)` from `cpu_intensive_work`).
      * **Error Propagation:** If the spawned task throws an exception, `fetch(t)` will re-throw that same exception on the calling thread.
  * **Workflow:**
    1.  Launch multiple parallel computations using `@spawn`, storing the returned `Task` objects.
    2.  Perform any other work that can be done concurrently on the main thread (optional).
    3.  Call `fetch()` on each `Task` object to wait for its completion and collect its result. This loop effectively acts as a "join" point, ensuring all parallel work is done before proceeding.

`Threads.@spawn` is the recommended, flexible way to achieve parallelism for complex or dynamic workloads in Julia.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Multi-Threading":** Explains `@spawn` and the task-based parallelism model.
      * **Julia Official Documentation, Base Documentation, `Threads.@spawn`:** Details the macro's behavior.
      * **Julia Official Documentation, Base Documentation, `fetch`:** Explains how to wait for and retrieve task results.

-----

To run the script:

*(You MUST start Julia with multiple threads, e.g., `julia -t 4 0098_threads_spawn.jl`)*

```shell
$ julia -t 4 0098_threads_spawn.jl
Main script running on thread: 1
Spawning 4 parallel tasks using Threads.@spawn...
All tasks spawned. Main thread continues while tasks run in parallel.
Waiting for tasks to complete by calling fetch()...
Main: Waiting for Task 1...
Task 1: Starting on thread 1  # May start on any thread
Task 2: Starting on thread 2
Task 3: Starting on thread 3
Task 4: Starting on thread 4
Task 2: Finished on thread 2 | Result: ###
Task 4: Finished on thread 4 | Result: ###
Task 3: Finished on thread 3 | Result: ###
Task 1: Finished on thread 1 | Result: ###
Main: Fetched result from Task 1
Main: Waiting for Task 2...
Main: Fetched result from Task 2
Main: Waiting for Task 3...
Main: Fetched result from Task 3
Main: Waiting for Task 4...
Main: Fetched result from Task 4

All tasks complete.
Collected results:
  (1, ###)
  (2, ###)
  (3, ###)
  (4, ###)
```

*(The exact order of "Starting" and "Finished" messages will vary due to parallel execution and scheduling. Results `###` will be floating-point numbers.)*