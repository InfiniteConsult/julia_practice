### `0074_tasks_fetch.jl`

```julia
# 0074_tasks_fetch.jl

# 1. Define a function that returns a value after some work.
function compute_value(id::Int, duration::Float64)
    println("Task $id: Starting computation...")
    sleep(duration) # Simulate work
    result = id * 100
    println("Task $id: Finished computation, returning $result.")
    return result # Return the computed value
end

println("--- Launching tasks with @async ---")

# 2. Launch tasks asynchronously. '@async' returns Task objects.
task_a = @async compute_value(1, 1.0)
task_b = @async compute_value(2, 0.5)

println("Tasks launched. Main code continues...")
println("Type of task_a: ", typeof(task_a))

# 3. Use 'fetch()' to wait for a task and get its result.
#    'fetch(t)' blocks the *current* task until task 't' completes.
println("\nWaiting for Task B...")
result_b = fetch(task_b) # Waits for task_b (0.5s)
println("Result from Task B: ", result_b)
println("Type of result_b: ", typeof(result_b)) # Int64

println("\nWaiting for Task A...")
result_a = fetch(task_a) # Waits for task_a (remaining 0.5s)
println("Result from Task A: ", result_a)
println("Type of result_a: ", typeof(result_a)) # Int64

# 4. Fetching multiple tasks (often done after a @sync block conceptually)
println("\n--- Fetching after @sync ---")
local result_c, result_d # Define variables outside the sync block scope
@sync begin
    local task_c = @async compute_value(3, 0.8)
    local task_d = @async compute_value(4, 0.3)
    # The @sync block waits here until both task_c and task_d finish.

    # We can fetch inside the @sync block *after* they finish if needed,
    # but often you fetch afterwards. Fetching here is redundant due to @sync.
    # result_c = fetch(task_c)
    # result_d = fetch(task_d)
end # Both tasks are guaranteed complete now

# Fetching after the @sync block is guaranteed not to block
# (unless accessing task handles defined outside the block scope requires care).
# For tasks defined *inside* @sync, accessing them outside requires care with scope.
# A better pattern involves storing tasks in a collection defined outside @sync.

# Better pattern for collecting results after @sync
tasks = []
@sync begin
    push!(tasks, @async compute_value(5, 0.6))
    push!(tasks, @async compute_value(6, 0.2))
end # Both tasks 5 & 6 are done

println("Fetching results after @sync using a collection:")
results = fetch.(tasks) # Use broadcasting '.' for fetch on a collection
println("Results [5, 6]: ", results)


println("\nMain code finished.")

```

### Explanation

This script demonstrates how to retrieve the **return value** from a concurrently running `Task` using the `fetch()` function.

  * **Core Concept: Tasks Return Values**
    Just like regular functions, computations wrapped in `@async` can `return` a value. The `@async` macro captures this eventual return value.

  * **`fetch(t::Task)` Function**

      * `fetch(t)` is the primary mechanism to **wait for a specific task `t` to complete** and then retrieve its return value.
      * **Blocking Behavior:** If task `t` has not yet finished when `fetch(t)` is called, the *current* task (the one calling `fetch`) will **block** (pause execution and yield control) until task `t` completes.
      * **Return Value:** Once task `t` completes, `fetch(t)` returns the value that the task's expression evaluated to (i.e., the value returned by the function wrapped in `@async`). The type of the value returned by `fetch` is the type returned by the task's function.
      * **Fetching Again:** If you call `fetch(t)` on a task that has already completed, it immediately returns the stored result without blocking.

  * **Example Walkthrough:**

    1.  `task_a` and `task_b` are launched concurrently. The main code continues.
    2.  `fetch(task_b)` is called. Since `task_b` only needs 0.5s and likely hasn't finished immediately, the main task blocks here.
    3.  After \~0.5s, `task_b` finishes, returns `200`. `fetch(task_b)` unblocks and returns `200`.
    4.  `fetch(task_a)` is called. `task_a` needs 1.0s total. Since \~0.5s has already passed, the main task blocks for the remaining \~0.5s.
    5.  After \~1.0s total, `task_a` finishes, returns `100`. `fetch(task_a)` unblocks and returns `100`.

  * **`fetch` and `@sync`:**

      * The `@sync` block guarantees that all `@async` tasks launched *directly within it* are complete before the block finishes.
      * Therefore, calling `fetch` on a task *after* the `@sync` block it was defined in will **not block**, because the task is already guaranteed to be finished.
      * A common pattern is to collect `Task` objects created within `@sync` into an array defined *outside* the block, and then use broadcasted `fetch.` after the block to gather all results efficiently.

  * **Error Handling:** If a task terminates due to an exception, `fetch(t)` will **re-throw that same exception** in the calling task. This allows you to handle errors from asynchronous tasks using standard `try...catch` blocks around the `fetch` call.

  * **References:**

      * **Julia Official Documentation, Base Documentation, `fetch`:** "Wait for a `Task` to complete and return its value."
      * **Julia Official Documentation, Manual, "Asynchronous Programming":** Shows examples of using `fetch` to get results from tasks.

To run the script:

*(Output timing and interleaving may vary slightly.)*

```shell
$ julia 0074_tasks_fetch.jl
--- Launching tasks with @async ---
Tasks launched. Main code continues...
Type of task_a: Task (runnable) @0x...
Task 1: Starting computation...
Task 2: Starting computation...

Waiting for Task B...
Task 2: Finished computation, returning 200.
Result from Task B: 200
Type of result_b: Int64

Waiting for Task A...
Task 1: Finished computation, returning 100.
Result from Task A: 100
Type of result_a: Int64

--- Fetching after @sync ---
Task 5: Starting computation...
Task 6: Starting computation...
Task 6: Finished computation, returning 600.
Task 5: Finished computation, returning 500.
Fetching results after @sync using a collection:
Results [5, 6]: [500, 600]

Main code finished.
```