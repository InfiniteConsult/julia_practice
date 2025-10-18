### `0051_mutable_vs_immutable_performance.md`

This is one of the most important performance trade-offs in the Julia language. The choice between an immutable `struct` and a `mutable struct` is not cosmetic; it fundamentally changes how the compiler handles your data, with massive performance implications.

---

### Comparison: `struct` (Immutable) vs. `mutable struct` (Mutable)

| Feature | `struct Point` (Immutable) | `mutable struct MutablePoint` (Mutable) |
| :--- | :--- | :--- |
| **`isbits` Status** | **`true`** (if fields are `isbits`) | **`false`** (always) |
| **Allocation** | **Stack** (if possible) | **Heap** (always) |
| **Passing to Functions** | By value (in **CPU registers**) | By reference (as a **pointer**) |
| **Array Layout (`Vector{T}`)** | **Inlined / Contiguous** (Array of Structs) | **Array of Pointers** (Array of Pointers) |
| **Cache Performance** | **Excellent** (cache-friendly) | **Poor** (pointer-chasing, cache misses) |

---

### 1. Allocation: Stack vs. Heap

* **`struct Point` (Immutable):** Because an immutable `struct` is a self-contained, unchangeable block of bits (it's `isbits`), the compiler can treat it as a simple value, just like an `Int` or `Float64`. When created inside a function, it will typically be **stack-allocated**. Stack allocation is extremely fast—it's just a single instruction to move the stack pointer. It also means there is **zero work for the garbage collector (GC)**.
* **`mutable struct MutablePoint` (Mutable):** Because a mutable object's fields can change at any time, it must have a single, stable address in memory so that all variables referencing it see the same changes. This requires it to be **heap-allocated**. Heap allocation is much slower: it requires a call to the memory manager (`malloc`) to find a free block of memory, and the GC must track this object for its entire lifetime.

**Conclusion:** Immutable `struct`s are significantly "cheaper" to create and destroy than mutable `struct`s.

---

### 2. Array Layout: Inlined vs. Pointers

This is the most critical difference for high-performance computing.

* **`Vector{Point}` (Immutable `isbits`):** Julia stores the `Point` objects **inlined** in the array's memory. The `Vector` is one single, contiguous block of `Float64` values.
    * **Memory Layout:** `[p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, ...]`
* **`Vector{MutablePoint}` (Mutable):** Julia stores an array of **pointers**. Each pointer references a *separate* `MutablePoint` object allocated somewhere else on the heap.
    * **Memory Layout:** `[ptr1, ptr2, ptr3, ...]`
    * ...where `ptr1` points to `MutablePoint(x1, y1)`, `ptr2` points to `MutablePoint(x2, y2)`, etc.

---

### 3. CPU Cache and Iteration Performance

The array layout has a direct and massive impact on iteration speed.

* **Iterating `Vector{Point}`:** When you loop over this array, you are reading memory sequentially. The CPU's prefetcher can load this data directly into the L1/L2 cache *before* it's even needed. This results in an **extremely fast, cache-friendly** loop with no wasted cycles. The compiler can also **vectorize** the loop using **SIMD** instructions, processing multiple `Point`s per cycle.
* **Iterating `Vector{MutablePoint}`:** When you loop over this array, you get **pointer-chasing**.
    1.  Read `ptr1` from the array (potential cache miss).
    2.  "Jump" (dereference) to the memory address of `ptr1` to fetch the `MutablePoint` object (another potential cache miss).
    3.  Read `ptr2` from the array...
    4.  Jump to the memory address of `ptr2`...
    This "jumpy" memory access pattern defeats the CPU's prefetcher, causes constant cache misses, and makes SIMD vectorization impossible.

**Conclusion:** Iterating a `Vector` of immutable `isbits` `struct`s is often **orders of magnitude faster** than iterating a `Vector` of `mutable struct`s.

---

### Guideline

* **Always default to immutable `struct`**. You should only use `mutable struct` when you have a specific, compelling reason to—such as a long-lived object that *must* have its state changed, like a buffer, a simulation environment, or a network connection manager.
* For any small, data-carrying object (coordinates, complex numbers, configuration parameters), immutability (`struct`) is the correct, safe, and high-performance choice.