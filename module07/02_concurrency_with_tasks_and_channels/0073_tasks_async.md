### `0073_tasks_async.jl`

```julia
# 0073_tasks_async.jl

# 1. Define a function that simulates a slow operation (like I/O).
#    'sleep()' yields control to Julia's scheduler, allowing other Tasks to run.
function slow_operation(id::Int, duration::Float64)
    println("Task $id: Starting on thread ", Threads.threadid())
    sleep(duration)
    println("Task $id: Finished after $duration seconds.")
end

# --- Part 1: @async without @sync ---

println("--- Part 1: @async without @sync ---")
println("Main code running on thread ", Threads.threadid())

# 2. Launch tasks asynchronously using '@async'.
#    '@async' starts the task and immediately returns control.
#    The main code continues *without* waiting.
t1 = @async slow_operation(1, 1.0)
t2 = @async slow_operation(2, 0.5)

println("Tasks 1 and 2 launched. Main code continues...")
# The script might end here *before* the tasks finish, depending on timing.
# We add a sleep to give them a chance to complete for demonstration.
sleep(1.5)
println("Main code finished Part 1.")


# --- Part 2: @async within @sync ---

println("\n--- Part 2: @async within @sync ---")
println("Main code starting @sync block...")

# 3. Use '@sync' to wait for all enclosed '@async' tasks.
@sync begin
    println("Inside @sync block, launching tasks...")
    # These tasks are launched concurrently.
    @async slow_operation(3, 1.0)
    @async slow_operation(4, 0.5)
    println("Tasks 3 and 4 launched within @sync.")
    # Control flow waits *here* (at the 'end' of the @sync block)
    # until both task 3 and task 4 have completed.
end # <--- Synchronization point

# 4. This line only executes *after* both task 3 and task 4 are finished.
println("Main code finished @sync block. All tasks completed.")

```

### Explanation

This script introduces **`Task`s** and the **`@async`** macro, which are Julia's fundamental tools for **concurrency**. Concurrency allows managing multiple operations seemingly simultaneously, crucial for responsive applications dealing with I/O or background processing.

  * **Concurrency vs. Parallelism:**

      * **Concurrency:** Managing multiple tasks over time, often interleaving their execution on a **single OS thread**. Tasks yield control during blocking operations (like I/O or `sleep`). This prevents one slow task from blocking others. This is what `@async` provides by default.
      * **Parallelism:** Executing multiple tasks simultaneously on **multiple CPU cores** using multiple OS threads. (This is covered later with `Threads.@spawn`).
      * **Key Point:** Notice that `Threads.threadid()` typically prints `1` for all tasks here. `@async` achieves concurrency, not necessarily parallelism by default.

  * **`Task`:**
    A `Task` is Julia's basic unit of concurrent execution. It's a lightweight construct (lighter than an OS thread) that represents a computation that can be paused and resumed. They are managed by Julia's cooperative scheduler.

  * **`@async expression`:**

      * This macro takes an expression (like a function call), wraps it in a `Task`, and submits it to Julia's scheduler to run **asynchronously**.
      * **Non-blocking:** The key feature is that `@async` returns **immediately**, allowing the code following it to execute without waiting for the task to finish. It returns a `Task` object, which is a handle to the running task.
      * In Part 1, the main script launches tasks 1 and 2 and continues. Without the `sleep(1.5)`, the script might exit before the tasks even get a chance to print their "Finished" messages.

  * **`@sync begin ... end`:**

      * This macro creates a **synchronization point**. It executes the code within its `begin...end` block.
      * **Waiting:** The crucial behavior is that the code *after* the `@sync` block's `end` will **only execute once all `@async` tasks launched *directly within* that block have completed**.
      * In Part 2, tasks 3 and 4 are launched. The `@sync` block waits at its `end` until both `slow_operation(3, ...)` and `slow_operation(4, ...)` have finished. Only then does the final `println` execute. This guarantees completion.

  * **Cooperative Scheduling:**
    Julia's `Task`s are scheduled **cooperatively**. A `Task` runs until it hits an operation that yields control, such as `sleep()`, network I/O, `yield()`, or waiting on a `Channel` (next lesson). This yielding allows the scheduler to run another waiting `Task`. This is efficient for I/O-bound workloads but means a CPU-bound task (`for i in 1:1e12 end`) will hog the thread unless it explicitly `yield`s.

  * **References:**

      * **Julia Official Documentation, Manual, "Asynchronous Programming":** Explains `Task`s, `@async`, `@sync`, and cooperative scheduling.
      * **Julia Official Documentation, Base Documentation, `@async` and `@sync`:** Detailed descriptions of the macros.

To run the script:

*(The exact interleaving of "Starting" and "Finished" messages may vary slightly due to scheduling.)*

```shell
$ julia 0073_tasks_async.jl
--- Part 1: @async without @sync ---
Main code running on thread 1
Tasks 1 and 2 launched. Main code continues...
Task 1: Starting on thread 1
Task 2: Starting on thread 1
Task 2: Finished after 0.5 seconds.
Task 1: Finished after 1.0 seconds.
Main code finished Part 1.

--- Part 2: @async within @sync ---
Main code starting @sync block...
Inside @sync block, launching tasks...
Tasks 3 and 4 launched within @sync.
Task 3: Starting on thread 1
Task 4: Starting on thread 1
Task 4: Finished after 0.5 seconds.
Task 3: Finished after 1.0 seconds.
Main code finished @sync block. All tasks completed.
```