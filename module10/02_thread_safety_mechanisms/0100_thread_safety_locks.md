### `0100_thread_safety_locks.jl`

```julia
# 0100_thread_safety_locks.jl
# Demonstrates using locks to prevent data races.
# Requires running Julia with multiple threads (e.g., 'julia -t 4')

import Base.Threads: @spawn, ReentrantLock, lock, unlock, nthreads
import Base: fetch

# 1. Initialize a lock.
#    A lock is a synchronization primitive ensuring mutual exclusion.
#    'ReentrantLock' allows the *same* thread to acquire the lock multiple times
#    without deadlocking (it must unlock it the same number of times).
#    'SpinLock' is lower-level, busy-waiting lock (CPU intensive) for very short critical sections.
const counter_lock = ReentrantLock()

# Shared mutable state that needs protection
total_sum_correct = 0.0
num_increments = 1_000_000 # Use a larger number to make races likely

println("--- Correctly calculating sum using lock ---")
println("Using $(nthreads()) threads for $num_increments increments...")

# Array to hold Task objects
tasks = Vector{Task}(undef, num_increments)

# --- Method 1: Manual lock/unlock with try...finally (Less Preferred) ---
# Launch tasks that increment the shared counter safely
# for i in 1:num_increments
#     tasks[i] = @spawn begin
#         # 2. Acquire the lock *before* accessing shared data.
#         # If another thread holds the lock, this call blocks.
#         lock(counter_lock)
#         try
#             # --- CRITICAL SECTION START ---
#             # Only one thread can execute this code block at a time.
#             global total_sum_correct += 1.0
#             # --- CRITICAL SECTION END ---
#         finally
#             # 3. CRITICAL: Release the lock *always*.
#             # 'finally' ensures unlock happens even if an error
#             # occurs inside the 'try' block, preventing deadlock.
#             unlock(counter_lock)
#         end
#     end
# end

# --- Method 2: Idiomatic lock(...) do ... end (Recommended) ---
# This is syntactic sugar for the try...finally block above.
for i in 1:num_increments
    tasks[i] = @spawn begin
        # 4. Acquire lock, execute block, guarantee unlock.
        lock(counter_lock) do
            # --- CRITICAL SECTION START ---
            # Code here is automatically protected by the lock.
            global total_sum_correct += 1.0
            # --- CRITICAL SECTION END ---
        end # Lock is automatically released here
    end
end


# 5. Wait for all tasks to complete.
#    fetch() will block until each task is done.
fetch.(tasks) # Using broadcasted fetch

println("Loop finished.")
# The result should now be exactly equal to num_increments.
println("Correct Total Sum (with lock): ", total_sum_correct)

```

-----

### Explanation

This script demonstrates how to use **locks** (specifically `ReentrantLock`) to prevent the **data race** identified in the previous lesson when multiple threads modify shared mutable state concurrently.

## Core Concept: Mutual Exclusion

  * **Data Race Cause:** The operation `total_sum_correct += 1.0` is not atomic; it involves reading the current value, modifying it, and writing it back. Multiple threads executing these steps concurrently can interfere, leading to lost updates.
  * **Solution: Mutual Exclusion:** We need to ensure that only **one thread at a time** can execute the code that modifies the shared variable (`total_sum_correct`). This protected section of code is called a **critical section**.
  * **Locks (Mutexes):** A lock (also known as a mutex, for MUTual EXclusion) is a synchronization primitive used to enforce mutual exclusion. It acts like a token; only the thread currently holding the token (the lock) is allowed to enter the critical section.

## Using Locks in Julia (`Threads.ReentrantLock`)

1.  **Initialization:** Create a lock object **once** for the shared resource you need to protect: `const counter_lock = ReentrantLock()`. Make it `const` so the reference to the lock itself doesn't change.
2.  **Acquiring the Lock:** Before entering the critical section, a thread must **acquire** the lock using `lock(counter_lock)`.
      * If the lock is available, the thread acquires it and proceeds into the critical section.
      * If another thread already holds the lock, the `lock()` call **blocks** the current thread (pauses its execution efficiently) until the lock is released.
3.  **Critical Section:** The code that accesses or modifies the shared mutable state (e.g., `global total_sum_correct += 1.0`) is placed *after* `lock()` and *before* `unlock()`.
4.  **Releasing the Lock:** After leaving the critical section, the thread **must release** the lock using `unlock(counter_lock)`. This allows one of the waiting (blocked) threads, if any, to acquire the lock and proceed.

## Ensuring Unlock: `try...finally` and `lock...do`

  * **The Danger of Deadlock:** If a thread acquires a lock and then encounters an error *before* it releases the lock, the lock will remain held forever. Any other thread waiting for that lock will block indefinitely, causing a **deadlock**.
  * **`try...finally...unlock` (Manual but Safe):** The standard way to prevent deadlock is to put the critical section code inside a `try` block and the `unlock()` call inside a `finally` block. The `finally` block is **guaranteed** to execute whether the `try` block completes normally or throws an error.
  * **`lock(l) do ... end` (Idiomatic and Safest):** Julia provides syntactic sugar for the `try...finally` pattern. The code inside the `do ... end` block becomes the critical section. Julia automatically acquires the lock (`l`) before executing the block and **guarantees** that the lock is released when the block finishes, regardless of how it finishes (normal completion or error). **This is the strongly recommended pattern** as it makes forgetting to unlock impossible.

## Performance Impact

  * **Serialization:** Locks fundamentally **serialize** execution through the critical section. Only one thread can be executing that code at any given time. If the critical section is large or frequently contended (many threads trying to acquire the lock often), the lock itself becomes a **performance bottleneck**, limiting overall parallelism.
  * **Overhead:** Acquiring and releasing locks involves atomic operations and potentially interaction with the OS scheduler (if blocking occurs), which has non-zero overhead.
  * **Guideline (HFT):** Use locks only when necessary to protect shared state. Keep critical sections **as small and fast as possible**. Prefer lock-free alternatives (like atomics, covered next) for simple operations like counters if performance is paramount.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Multi-Threading", "Data race freedom":** Discusses locks (`Mutex`, `ReentrantLock`, `SpinLock`) as the primary mechanism for protecting shared mutable state.
      * **Julia Official Documentation, Base Documentation, `ReentrantLock`, `lock`, `unlock`, `lock(f::Function, lock)`:** Details the lock types and functions, including the `do` block syntax.

-----

To run the script:

*(You MUST start Julia with multiple threads, e.g., `julia -t 4 0100_thread_safety_locks.jl`)*

```shell
$ julia -t 4 0100_thread_safety_locks.jl
--- Correctly calculating sum using lock ---
Using 4 threads for 1000000 increments...
Loop finished.
Correct Total Sum (with lock): 1000000.0
```

*(The result should now consistently be exactly 1,000,000.0, demonstrating that the lock correctly prevented the data race.)*