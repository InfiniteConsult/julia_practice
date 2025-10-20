### `0088_isbits_examples.jl`

```julia
# 0088_isbits_examples.jl
# Demonstrates the 'isbitstype' check.

# 1. Primitives are isbits types.
# They are immutable and contain only data bits.
println("--- Primitives ---")
println("isbitstype(Int64):   ", isbitstype(Int64))   # true
println("isbitstype(Float64): ", isbitstype(Float64)) # true
println("isbitstype(Bool):    ", isbitstype(Bool))    # true
println("isbitstype(Char):    ", isbitstype(Char))    # true

# --- Immutable Composites ---
println("\n--- Immutable Composites ---")

# 2. Immutable struct with ONLY isbits fields IS an isbits type.
struct Point
    x::Float64
    y::Float64
end
println("isbitstype(Point):   ", isbitstype(Point))   # true

# 3. NTuple (fixed-size tuple) of isbits types IS an isbits type.
println("isbitstype(NTuple{3, Int}): ", isbitstype(NTuple{3, Int})) # true

# 4. Immutable struct containing a non-isbits field is NOT isbits.
#    'String' holds a pointer to heap data, making it non-isbits.
struct LabeledPoint
    p::Point      # Point is isbits
    label::String # String is NOT isbits
end
println("isbitstype(LabeledPoint): ", isbitstype(LabeledPoint)) # false

# --- Mutables and References ---
println("\n--- Mutables and References ---")

# 5. Mutable struct is NEVER an isbits type, even with isbits fields.
#    It must be heap-allocated to have a stable identity.
mutable struct MutablePoint
    x::Float64
    y::Float64
end
println("isbitstype(MutablePoint): ", isbitstype(MutablePoint)) # false

# 6. Types that inherently involve pointers/references are NOT isbits types.
println("isbitstype(String):       ", isbitstype(String))       # false
println("isbitstype(Vector{Int}):  ", isbitstype(Vector{Int}))  # false
println("isbitstype(Dict{Int, Int}): ", isbitstype(Dict{Int, Int})) # false
println("isbitstype(Channel{Int}): ", isbitstype(Channel{Int})) # false

# 7. Abstract types are NOT isbits types.
println("isbitstype(Number):       ", isbitstype(Number))       # false
println("isbitstype(AbstractArray):", isbitstype(AbstractArray)) # false
```

### Explanation

This script uses the built-in `isbitstype(T)` function to concretely demonstrate the rules outlined in the previous lesson for determining if a type is an **`isbits` type** (a plain-data type). Understanding this classification is crucial for predicting memory layout and performance.

  * **Core Concept: `isbitstype(T::Type)`**
    This function takes a **Type** object (like `Int64`, `Point`, `String`) as input and returns `true` if that type meets the criteria for being an `isbits` type, and `false` otherwise. Recall, the criteria are:

    1.  The type must be **immutable**.
    2.  The type must **contain no references** (pointers) to other memory locations; all its data must be stored directly within its own memory footprint.

  * **Verification of Rules:**

      * **Primitives (`Int64`, `Float64`, etc.):** As expected, these fundamental types are `isbits` (`true`).
      * **Immutable `struct` (`Point`):** Because `Point` is immutable and contains only `Float64` fields (which are `isbits`), `isbitstype(Point)` is `true`. This confirms it has a C-like, contiguous memory layout.
      * **`NTuple`:** Similarly, `NTuple{3, Int}` is a fixed-size, immutable collection of `isbits` types, making it `isbits` (`true`).
      * **Immutable `struct` with Non-`isbits` Field (`LabeledPoint`):** `LabeledPoint` contains a `String`. Since `String` itself is not `isbits` (it holds a pointer to heap data), the entire `LabeledPoint` struct becomes non-`isbits` (`false`).
      * **`mutable struct` (`MutablePoint`):** `isbitstype(MutablePoint)` is `false`. This confirms the rule: **all `mutable struct`s are non-`isbits`**, regardless of their fields, because they require heap allocation for a stable identity.
      * **Reference Types (`String`, `Vector`, `Dict`):** These types inherently involve pointers to heap-allocated data, so they are non-`isbits` (`false`).
      * **Abstract Types (`Number`, `AbstractArray`):** Abstract types do not have a single, fixed memory layout; they represent a *set* of possible concrete types. Therefore, they cannot be `isbits` (`false`).

  * **Performance Implication Summary:**

      * Types for which `isbitstype` returns `true` (like `Point`) are candidates for **stack allocation**, **register passing**, and **inlined storage** in arrays (`Vector{Point}` is contiguous).
      * Types for which `isbitstype` returns `false` (like `MutablePoint` or `LabeledPoint`) are generally **heap-allocated**, passed **by reference (pointer)**, and stored as **pointers** in arrays (`Vector{MutablePoint}` is an array of pointers).

Knowing how to check `isbitstype` allows you to verify your assumptions about how your custom types will be handled by the compiler and predict their performance characteristics.

  * **References:**
      * **Julia Official Documentation, Base Documentation, `isbitstype`:** "Return `true` if type `T` is a 'plain data' type..."

To run the script:

```shell
$ julia 0088_isbits_examples.jl
--- Primitives ---
isbitstype(Int64):   true
isbitstype(Float64): true
isbitstype(Bool):    true
isbitstype(Char):    true

--- Immutable Composites ---
isbitstype(Point):   true
isbitstype(NTuple{3, Int}): true
isbitstype(LabeledPoint): false

--- Mutables and References ---
isbitstype(MutablePoint): false
isbitstype(String):       false
isbitstype(Vector{Int}):  false
isbitstype(Dict{Int, Int}): false
isbitstype(Channel{Int}): false
isbitstype(Number):       false
isbitstype(AbstractArray):false
```