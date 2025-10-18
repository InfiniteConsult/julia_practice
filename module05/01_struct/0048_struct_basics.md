### `0048_struct_basics.jl`

```julia
# 0048_struct_basics.jl

# 1. Define a new composite data type using the 'struct' keyword.
# By default (without 'mutable'), a 'struct' is immutable.
# This creates a new type named 'Point'.
struct Point
    # Fields are defined with their names and type annotations
    x::Float64
    y::Float64
end

# 2. Instantiate (create an instance of) the struct.
# Julia provides a default constructor that takes all fields as arguments.
p1 = Point(10.0, 20.0)

# 3. Access fields using dot notation.
# Note: println separates arguments with a space by default.
# The call: println("Label: ", variable) is the standard, readable form.
println("Accessing field p1.x: ", p1.x)
println("Accessing field p1.y: ", p1.y)

# 4. Inspect the instance and its type.
println("\nInstance p1: ", p1)
println("Type of p1:  ", typeof(p1))

println("-"^20)

# 5. Constructor Type Conversion
# Julia's default outer constructor calls convert() on its arguments.
# Point(x, y) is automatically defined as:
# Point(x, y) = new(convert(Float64, x), convert(Float64, y))

# Therefore, passing integers is valid, as they are convertible to Float64.
p2 = Point(10, 20)
println("Constructed from Ints: ", p2)
println("Type of p2: ", typeof(p2))

p3 = Point(10, 20.0)
println("Constructed from Int/Float: ", p3)

# 6. When does construction fail?
# It fails when convert() fails.
try
    p_fail = Point("hello", 20.0)
catch e
    println("\nError (as expected) on non-convertible type: ")
    println(e)
end
```

### Explanation

This script introduces the `struct`, the fundamental tool in Julia for creating your own **composite data types**. It is the direct equivalent of a C `struct`, a `std::tuple` in C++, or a "frozen" dataclass in Python.

  * **Core Concept:** A `struct` is a way to bundle multiple, related values (called **fields**) into a single, named object. You define the "blueprint" for the `struct` (its name and its fields' types), and then you can create **instances** of that blueprint.

  * **Default Immutability:** By default, a `struct` in Julia is **immutable**. This is a deliberate design choice. Once an instance like `p1` is created, its fields (`p1.x` and `p1.y`) **cannot be changed**.

  * **Constructor and Conversion:**

      * The `::Float64` annotations are a **strict contract** defining the *physical memory layout* of the `struct`. `Point` is a contiguous 16-byte block of memory: 8 bytes for `x` followed by 8 bytes for `y`.
      * When you define a `struct`, Julia *also* provides a default **outer constructor** that makes it easy to use. This constructor's behavior is `Point(x, y) = new(convert(Float64, x), convert(Float64, y))`.
      * This is why `Point(10, 20)` and `Point(10, 20.0)` **both succeed**. Julia automatically calls `convert(Float64, 10)` and `convert(Float64, 20)`, creating the `Point(10.0, 20.0)` instance.
      * A `MethodError` only occurs if you provide a type that `convert` cannot handle, such as `Point("hello", 20.0)`. This robust, "it-just-works" conversion is a core feature of Julia's constructor system.

  * **Performance Deep-Dive: The `isbits` Optimization**
    This is the most critical concept for understanding `struct` performance.

    1.  **`isbits` Type:** Our `Point` struct is an **`isbits`** type. The Julia documentation defines this as a type that is **immutable** and **contains no references** to other values. `Point` is immutable and contains only `Float64`s (which are `isbits`), so it qualifies.
    2.  **Stack Allocation:** Because `Point` is a small, immutable, self-contained block of data, the compiler can treat it as a single, simple value (like a single `Int128`). When created inside a function, it can be allocated on the **stack**, which is dramatically faster than heap allocation and avoids any work for the garbage collector (GC).
    3.  **Register Passing:** When you pass a `Point` object to another function, the compiler can pass it *directly* in **CPU registers** (e.g., two 64-bit registers) instead of allocating it and passing a pointer. This is the fastest possible way to pass an argument.
    4.  **Array Layout:** This is the key. A `Vector{Point}` is **not** an array of pointers. Because `Point` is `isbits`, Julia stores the values **inlined** in a single, flat, contiguous block of memory. The memory layout is literally `[p1.x, p1.y, p2.x, p2.y, ...]`. This "Array of Structs" (AoS) layout is C-like, cache-friendly, and enables the compiler to use powerful SIMD vector instructions when iterating.

  * **References:**

      * **`isbits` Definition:** Julia Official Documentation, `isbits` function. States `isbits(T)` is `true` if `T` is "immutable and contains no references to other values."
      * **Stack/Register Allocation:** Julia Official Documentation, Manual, Types. States: "...small enough immutable values like integers and floats are typically passed to functions in registers (or stack allocated). Mutable values, on the other hand are heap-allocated..."
      * **Array Layout:** Confirmed by Julia contributor `mbauman` in an authoritative Stack Overflow answer: "Julia's arrays will only store elements of type `T` unboxed if `isbits(T)` is true. That is, the elements must be both immutable and pointer-free."

To run the script:

```shell
$ julia 0048_struct_basics.jl
Accessing field p1.x: 10.0
Accessing field p1.y: 20.0

Instance p1: Point(10.0, 20.0)
Type of p1:  Point
--------------------
Constructed from Ints: Point(10.0, 20.0)
Type of p2: Point
Constructed from Int/Float: Point(10.0, 20.0)

Error (as expected) on non-convertible type: 
MethodError(f=convert, args=(Float64, "hello"), world=...)
```