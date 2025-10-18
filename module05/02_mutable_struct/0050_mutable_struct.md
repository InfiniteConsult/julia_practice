### `0050_mutable_struct.jl`

```julia
# 0050_mutable_struct.jl

# 1. Define a MUTABLE composite type using the 'mutable struct' keywords.
mutable struct MutablePoint
    x::Float64
    y::Float64
end

# 2. Instantiate the mutable struct.
# The default constructor works identically.
p1 = MutablePoint(10.0, 20.0)
println("Original mutable point p1: ", p1)

# 3. Modify a field in-place.
# This operation is now legal and succeeds.
println("\nMutating p1.x = 30.0...")
p1.x = 30.0

println("Mutated point p1: ", p1)

# 4. Another in-place modification
p1.y += 5.0
println("Mutated point p1 again: ", p1)
```

### Explanation

This script introduces the **`mutable struct`**, which creates objects whose fields **can be changed** after creation.

  * **Core Concept:** The `mutable` keyword changes the fundamental contract of the type. `mutable struct` creates a "container" whose contents can be modified in-place, while the default `struct` creates a single, unchangeable "value".

  * **Syntax:** The only difference in the definition is the addition of the `mutable` keyword before `struct`. Instantiation and field access (`.x`) are syntactically identical.

  * **In-Place Modification:** The line `p1.x = 30.0` now succeeds. This operation directly modifies the memory of the `p1` object itself. Any other variable in the program that holds a reference to `p1` will instantly see this change.

  * **The Performance Trade-Off: Heap vs. Stack**
    This is one of the most important performance distinctions in Julia.

    1.  **Allocation:** Because a `mutable struct` must have a single, stable identity in memory (so all references to it can be updated), it is **heap-allocated**. This is a slower operation than the stack-allocation that is possible for immutable `struct`s.
    2.  **`isbits`:** A `mutable struct` is **never** an `isbits` type.
    3.  **Array Layout:** A `Vector{MutablePoint}` is an **array of pointers** (or "references") to heap-allocated `MutablePoint` objects. It is *not* a flat, contiguous block of data. This memory layout (an "Array of Pointers") is less cache-friendly and prevents the compiler from using SIMD instructions.

  * **Guideline:** You pay a significant performance cost for mutability. Therefore, **always default to an immutable `struct`**. Only use `mutable struct` when you have a specific, long-lived object that *must* have its state changed over time (e.g., a simulation environment, a network connection manager, a buffer). For small, data-carrying objects like coordinates or complex numbers, `struct` is almost always the correct, high-performance choice.

  * **References:**

      * **Julia Official Documentation, Manual, Types:** "Composite Types declared with `mutable struct` are mutable..."
      * **Julia Official Documentation, Manual, Types (on Mutability):** "Mutable values, on the other hand are heap-allocated and passed to functions as pointers to heap-allocated values..."
      * **Julia Official Documentation, `isbits`:** `isbits(MutablePoint)` would return `false`.

To run the script:

```shell
$ julia 0050_mutable_struct.jl
Original mutable point p1: MutablePoint(10.0, 20.0)

Mutating p1.x = 30.0...
Mutated point p1: MutablePoint(30.0, 20.0)
Mutated point p1 again: MutablePoint(30.0, 25.0)
```