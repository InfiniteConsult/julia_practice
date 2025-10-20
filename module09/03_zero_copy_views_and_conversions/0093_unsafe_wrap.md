### `0093_unsafe_wrap.jl`

```julia
# 0093_unsafe_wrap.jl
# Creates a Julia Array view over a raw pointer (zero-copy).
import Libc # For malloc/free examples

# --- Case 1: Wrapping Memory Managed by Julia ---

println("--- Wrapping a Julia Array's Pointer (Borrowing) ---")

# 1. Get a pointer to existing, GC-managed memory.
julia_data = Float64[1.1, 2.2, 3.3, 4.4, 5.5]
ptr_julia = pointer(julia_data)
num_elements = length(julia_data)

# 2. Use 'unsafe_wrap' to create an Array VIEW.
#    Syntax: unsafe_wrap(Array, pointer::Ptr{T}, dims; own = false)
#    'dims' can be an integer (for Vector) or a tuple (for multi-dim).
#    'own = false' (default) means Julia does NOT own/manage this memory.
wrapped_array = unsafe_wrap(Array, ptr_julia, num_elements; own = false)

println("Original Julia data: ", julia_data)
println("Wrapped array view:  ", wrapped_array)
println("Type of wrapped array: ", typeof(wrapped_array)) # Vector{Float64}

# 3. Modifications through the view AFFECT the original data.
#    They share the same underlying memory. No copy was made.
println("\nModifying wrapped_array[1] = 99.9")
wrapped_array[1] = 99.9

println("Wrapped array view is now: ", wrapped_array)
println("Original Julia data is now: ", julia_data) # Also changed!

# --- Case 2: Wrapping Memory Allocated Outside Julia (e.g., C) ---

println("\n--- Wrapping Externally Allocated Memory (Taking Ownership) ---")

# 4. Allocate memory using C's malloc (via Libc).
#    This memory is NOT tracked by Julia's GC initially.
bytes_to_alloc = 3 * sizeof(Int64)
ptr_malloc_void = Libc.malloc(bytes_to_alloc)
if ptr_malloc_void == C_NULL
    error("malloc failed")
end
# Cast the void* to a typed pointer
ptr_malloc_int = convert(Ptr{Int64}, ptr_malloc_void)
println("Allocated external memory at: ", ptr_malloc_int)

# 5. Wrap the C memory, passing 'own = true'.
#    'own = true' tells Julia's GC to take ownership of this pointer
#    and call 'Libc.free()' on it when the wrapped array is finalized.
owned_array = unsafe_wrap(Array, ptr_malloc_int, 3; own = true)

# 6. Initialize and use the array.
owned_array[1] = 1000
owned_array[2] = 2000
owned_array[3] = 3000
println("Owned wrapped array: ", owned_array)

# 7. IMPORTANT: We do NOT manually call Libc.free(ptr_malloc_void).
#    The GC will handle it because we passed 'own = true'.
#    Manually freeing would cause a double-free crash later.

# --- DANGER: Using 'own=true' on Julia Memory ---

# 8. NEVER use 'own=true' when wrapping memory from another Julia object.
# ptr_julia_bad = pointer(julia_data)
# WRONG: owned_bad = unsafe_wrap(Array, ptr_julia_bad, num_elements; own = true)
# This would tell the GC to 'free()' the memory managed by 'julia_data',
# leading to heap corruption and likely crashes.

println("\nFinished unsafe_wrap examples.")

```

-----

### Explanation

This script introduces `unsafe_wrap(Array, ...)`, a powerful function for creating a Julia `Array` object that acts as a **zero-copy view** onto a raw block of memory specified by a pointer. This is fundamental for high-performance interoperability with C libraries or for working directly with memory buffers.

## Core Concept: Zero-Copy View

  * `unsafe_wrap(Array, pointer::Ptr{T}, dims; own=false)` constructs a standard Julia `Array` (e.g., `Vector{T}` or `Matrix{T}`) whose underlying data *is* the memory block starting at `pointer`.
  * **No Data Copy:** Absolutely no data is copied during this operation. The created array directly uses the memory pointed to by `pointer`. This makes it extremely fast.
  * **Shared Memory:** As demonstrated in Case 1, modifications made through the `wrapped_array` are instantly reflected in the original `julia_data` because they operate on the exact same memory locations.

## The `own` Parameter: Managing Memory Ownership

This boolean keyword argument is **critically important** for memory safety:

  * **`own = false` (Default - "Borrowing"):**
      * Use this when the memory pointed to by `pointer` is **managed elsewhere**.
      * Examples:
          * Wrapping a pointer obtained from another Julia object (like `pointer(julia_data)`). The Julia GC owns `julia_data`.
          * Wrapping a pointer returned by a C library where the C library *retains ownership* and will free the memory later.
      * You are telling Julia's GC: "Do **not** try to `free` this memory when the wrapped array goes out of scope."
  * **`own = true` (Taking Ownership):**
      * Use this **only** when the memory pointed to by `pointer` was allocated using a mechanism like C's `malloc` (or `Libc.malloc`), and you want to **transfer ownership** of that memory block to the Julia GC.
      * You are telling Julia's GC: "When this wrapped array object is finalized (no longer reachable), you **must call `Libc.free()`** on the original `pointer` to release the memory."
      * **CRITICAL DANGER:** Never use `own = true` on a pointer obtained from another Julia object (like `pointer(A)`). This will cause the GC to incorrectly `free` memory it doesn't own, leading to **heap corruption** and crashes (double-free).

## Use Cases

  * **C Interoperability (HFT):** When a C library (e.g., a market data feed handler) gives you a `Ptr{OrderUpdate}` pointing to a large buffer of updates, you use `unsafe_wrap(Array, ptr, num_updates; own=false)` to instantly get a `Vector{OrderUpdate}` (assuming `OrderUpdate` is an `isbits struct` with matching layout) without any copying. You can then process this vector using fast, idiomatic Julia code.
  * **Memory-Mapped Files:** Wrapping pointers obtained from memory-mapping large files allows processing huge datasets that don't fit in RAM as if they were regular Julia arrays.
  * **Shared Memory:** Working with pointers to shared memory segments used for inter-process communication.

`unsafe_wrap` provides the crucial link between Julia's high-level array interface and low-level memory buffers, enabling maximum performance in data-intensive scenarios. However, misuse of the `own` parameter is a common source of serious memory errors.

-----

  * **References:**
      * **Julia Official Documentation, Base Documentation, `unsafe_wrap`:** "Wrap a pointer `p` to an array of element type `T`..." Explains arguments including `own`.
      * **Julia Official Documentation, Base Documentation, `Libc.malloc`, `Libc.free`:** Functions for interacting with the C standard library's memory allocation.

-----

To run the script:

```shell
$ julia 0093_unsafe_wrap.jl
--- Wrapping a Julia Array's Pointer (Borrowing) ---
Original Julia data: [1.1, 2.2, 3.3, 4.4, 5.5]
Wrapped array view:  [1.1, 2.2, 3.3, 4.4, 5.5]
Type of wrapped array: Vector{Float64} (alias for Array{Float64, 1})

Modifying wrapped_array[1] = 99.9
Wrapped array view is now: [99.9, 2.2, 3.3, 4.4, 5.5]
Original Julia data is now: [99.9, 2.2, 3.3, 4.4, 5.5]

--- Wrapping Externally Allocated Memory (Taking Ownership) ---
Allocated external memory at: Ptr{Int64}(0x...)
Owned wrapped array: [1000, 2000, 3000]

Finished unsafe_wrap examples.
```

*(Memory addresses will vary.)*