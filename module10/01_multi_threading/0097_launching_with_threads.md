### `0097_launching_with_threads.jl`

```julia
# 0097_launching_with_threads.jl
# How to enable and check Julia's multi-threading capabilities.

# 1. Access the 'Threads' module (part of Base Julia).
#    No 'import' is needed for names directly in 'Base.Threads'.
import Base.Threads # Import the module itself to be explicit

# 2. Get the number of threads Julia was started with.
#    'Threads.nthreads()' returns the size of the thread pool.
num_threads = Threads.nthreads()

println("Julia process launched with $num_threads thread(s).")

# 3. Check if multi-threading is actually enabled.
#    If nthreads() == 1, parallel execution is not possible.
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

# 4. Get the ID of the *current* OS thread executing this code.
#    Thread IDs range from 1 to nthreads().
#    The main thread (that runs the script initially) is always ID 1.
main_thread_id = Threads.threadid()
println("This main script is currently running on thread ID: $main_thread_id")

```

-----

### Explanation

This script explains how Julia's multi-threading capabilities are **enabled at startup** and how to verify the configuration. Unlike some languages where threading is always available, Julia requires an explicit opt-in to create its pool of worker threads.

  * **Core Concept: Startup Configuration**
    Julia's parallel scheduler uses a pool of **Operating System (OS) threads**. This pool is created **only once** when the Julia process starts. You **cannot** change the number of threads after Julia has started.
  * **Enabling Threads:**
    To utilize multiple CPU cores for parallel execution, you *must* tell Julia how many threads to create when you launch it. There are three primary methods:
    1.  **`-t N` / `--threads N` Command-Line Flag:** `julia -t 4 my_script.jl` starts Julia with a main thread and 3 additional worker threads, for a total of 4 threads available via `Threads.nthreads()`.
    2.  **`-t auto` / `--threads auto` Flag:** `julia -t auto my_script.jl` automatically detects the number of logical CPU cores on your machine and sets `N` to that value. This is often the most convenient option.
    3.  **`JULIA_NUM_THREADS` Environment Variable:** Setting this variable *before* launching Julia (e.g., `export JULIA_NUM_THREADS=4` in bash, then `julia my_script.jl`) achieves the same result as the command-line flag.
  * **Checking the Configuration:**
      * **`Threads.nthreads()`:** This function returns the **total number of threads** in Julia's pool (main thread + worker threads). If this returns `1`, multi-threading was not enabled at startup, and parallel execution macros like `Threads.@spawn` or `Threads.@threads` will effectively run sequentially on the single main thread.
      * **`Threads.threadid()`:** This function returns the **integer ID** (from `1` to `nthreads()`) of the specific OS thread that is currently executing the code. The thread that initially runs your script is always `1`. When you launch parallel tasks (next lessons), you'll see them report different `threadid()`s as they run on other threads in the pool.
  * **Verification:**
    Running this script normally (`julia 0097_launching_with_threads.jl`) will likely show `1` thread and print the warning. Running it with threading enabled (e.g., `julia -t 4 0097_launching_with_threads.jl`) will show the number of threads requested and confirm that multi-threading is active. This check is essential before running any multi-threaded code to ensure parallelism is actually possible.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Multi-Threading", "Starting Julia with multiple threads":** Details the command-line flags and environment variable.
      * **Julia Official Documentation, Base Documentation, `Threads.nthreads`:** "Get the number of threads available to the Julia process."
      * **Julia Official Documentation, Base Documentation, `Threads.threadid`:** "Get the ID of the current thread."

-----

To run the script:

1.  **Without Threads:**
    ```shell
    $ julia 0097_launching_with_threads.jl
    Julia process launched with 1 thread(s).
    WARNING: Multi-threading is DISABLED.
    Performance will be limited to a single core.
    To enable parallelism for subsequent lessons, restart Julia
    using one of the following methods:
      a) Command Line: julia -t N  (e.g., julia -t 4)
      b) Command Line: julia -t auto (uses all available logical cores)
      c) Environment Variable: export JULIA_NUM_THREADS=N (before starting Julia)
    This main script is currently running on thread ID: 1
    ```
2.  **With Threads (e.g., 4):**
    ```shell
    $ julia -t 4 0097_launching_with_threads.jl
    Julia process launched with 4 thread(s).
    SUCCESS: Multi-threading is ENABLED.
    Parallel execution using up to 4 threads is possible.
    This main script is currently running on thread ID: 1
    ```
    *(Replace `4` with the number of threads you requested or `auto` detected.)*