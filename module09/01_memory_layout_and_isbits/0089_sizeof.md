### `0089_sizeof.jl`

```julia
# 0089_sizeof.jl
# Demonstrates 'sizeof()' and introduces data alignment/padding.

# 1. 'sizeof()' on primitive (isbits) types.
#    Returns the number of bytes occupied by the type in memory.
println("--- Primitive Types ---")
println("sizeof(Int8):   ", sizeof(Int8))   # 1 byte
println("sizeof(Int16):  ", sizeof(Int16))  # 2 bytes
println("sizeof(Int32):  ", sizeof(Int32))  # 4 bytes
println("sizeof(Int64):  ", sizeof(Int64))  # 8 bytes
println("sizeof(Float64):", sizeof(Float64)) # 8 bytes
println("sizeof(Bool):   ", sizeof(Bool))   # 1 byte

# Size of a pointer (depends on architecture, typically 8 on 64-bit)
println("sizeof(Ptr{Nothing}): ", sizeof(Ptr{Nothing}))

# --- isbits Structs ---
println("\n--- isbits Structs ---")

# 2. 'sizeof()' on a simple isbits struct.
#    Size is the sum of the sizes of its fields (plus padding).
struct Point # isbits
    x::Float64 # 8 bytes
    y::Float64 # 8 bytes
end
println("sizeof(Point):  ", sizeof(Point))  # 8 + 8 = 16 bytes

# 3. 'sizeof()' on an isbits struct requiring padding.
struct PaddedData # isbits
    a::Int8    # 1 byte
    b::Int64   # 8 bytes
end
# Expected size might seem like 1 + 8 = 9 bytes. Due to alignment
# padding is added, resulting in 16 bytes.
println("sizeof(PaddedData): ", sizeof(PaddedData)) # Usually 16 bytes!

# --- Non-isbits Types (Instances) ---
println("\n--- Non-isbits Types (Instances) ---")

# 4. 'sizeof(T)' errors for non-isbits *types* like String or Vector{Int}.
#    However, 'sizeof(instance)' has specific definitions for some types:
s = "hello" # 5 characters (5 bytes in UTF-8)
v = [1, 2, 3] # 3 Int64 elements (3 * 8 = 24 bytes of data)

# sizeof(s::String) returns the number of code units (bytes for UTF-8).
println("sizeof(instance s): ", sizeof(s)) # 5 bytes

# sizeof(v::Array) returns the size of the data buffer in bytes.
println("sizeof(instance v): ", sizeof(v)) # 24 bytes (length * element size)

# NOTE: Neither of these returns the size of the object *header* itself.

# --- Total Memory Usage ---
println("\n--- Total Memory (Base.summarysize) ---")

# 5. 'Base.summarysize()' calculates the total memory used by an object,
#    including the object header/metadata AND any heap-allocated data it points to.
println("Base.summarysize(s): ", Base.summarysize(s)) # Size of String object + size of "hello" bytes + overhead
println("Base.summarysize(v): ", Base.summarysize(v)) # Size of Vector object + size of [1, 2, 3] data + overhead

p = Point(1.0, 2.0) # isbits struct
println("Base.summarysize(p): ", Base.summarysize(p)) # Same as sizeof(Point)
```

### Explanation

This script introduces the `sizeof()` function, which reports the memory size occupied by a type or value, and reveals the important concept of **data alignment** and **padding** in `struct` layouts.

  * **Core Concept: `sizeof(T)` and `sizeof(x)`**
    The `sizeof()` function returns the number of bytes required to store a value of type `T` or the specific value `x`. Its behavior depends on the type:

      * For **`isbits` types** (primitives, immutable structs with `isbits` fields), `sizeof(T)` gives the total size of the actual data representation, including any padding needed for alignment. For `Point`, it's `16`.
      * For **non-`isbits` *types*** (like `String` or `Vector{Int}`), `sizeof(T)` **throws an error** because these types don't have a single, fixed-size binary representation.
      * For **instances** of *some* non-`isbits` types, `sizeof(x)` has specific definitions:
          * `sizeof(s::String)` returns the number of bytes in the string's data (`ncodeunits(s)`).
          * `sizeof(v::Array)` returns the size in bytes of the array's **data buffer** (`length(v) * sizeof(eltype(v))`).
      * **Important:** For non-`isbits` instances like `s` and `v`, `sizeof(instance)` **does not** report the size of the object's header or reference part; it reports the size of the referenced *data*.

  * **Data Alignment and Padding**
    The output for `sizeof(PaddedData)` (16 bytes, not 9) is crucial. It demonstrates **data alignment**. CPUs access memory most efficiently when data is aligned (e.g., an 8-byte `Int64` starts at an address multiple of 8). To ensure `b::Int64` is aligned, the compiler inserts **7 bytes of unused padding** after `a::Int8`.

      * **Memory Layout:** `[ a (1 byte) | padding (7 bytes) | b (8 bytes) ]`
      * This padding is added automatically for performance. The next lesson (`fieldoffset`) will show this explicitly.

  * **`Base.summarysize(obj)` vs. `sizeof(obj)`**

      * `sizeof(obj)` gives the size of the inline data (`isbits`) or the referenced data (`String`, `Array`).
      * `Base.summarysize(obj)` is the function for the **total memory footprint**, including the object's header/reference itself **and** any out-of-line (heap-allocated) data it references, plus potential GC overhead.
      * For `isbits` types like `p`, `summarysize(p) == sizeof(p)`.
      * For non-`isbits` types like `s` and `v`, `summarysize(obj)` is generally larger than `sizeof(obj)` because it includes the header size and overhead. The results (`summarysize(s)=13`, `summarysize(v)=64`) reflect this accurately (e.g., `13 = 5 bytes data + 8 bytes header? + overhead?`).

Understanding `sizeof` (especially its specific behavior for `String` and `Array` instances) and `Base.summarysize` is vital for analyzing memory usage. Understanding alignment is key for optimizing data structures and C interop.

  * **References:**
      * **Julia Official Documentation, Base Documentation, `sizeof`:** "Return the size, in bytes, of the canonical binary representation..." Also notes the specific method `sizeof(s::String) = ncodeunits(s)`. Behavior for `Array` instances seems less explicitly documented but empirically matches data buffer size.
      * **Julia Official Documentation, Base Documentation, `Base.summarysize`:** "Compute the total size, in bytes, of an object and all its fields and elements."
      * (Data alignment is a general computer architecture concept).

-----

To run the script:

```shell
$ julia 0089_sizeof.jl
--- Primitive Types ---
sizeof(Int8):   1
sizeof(Int16):  2
sizeof(Int32):  4
sizeof(Int64):  8
sizeof(Float64):8
sizeof(Bool):   1
sizeof(Ptr{Nothing}): 8

--- isbits Structs ---
sizeof(Point):  16
sizeof(PaddedData): 16

--- Non-isbits Types (Instances) ---
sizeof(instance s): 5
sizeof(instance v): 24

--- Total Memory (Base.summarysize) ---
Base.summarysize(s): 13
Base.summarysize(v): 64
Base.summarysize(p): 16
```