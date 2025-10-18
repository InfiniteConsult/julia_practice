### `0052_abstract_types.jl`

```julia
# 0052_abstract_types.jl

# 1. Define an 'abstract type'.
# An abstract type defines a general concept, not a concrete object.
# You cannot create an instance of it.
abstract type AbstractShape end

# 2. Define a 'concrete type' that *subtypes* AbstractShape.
# The '<:' operator means "is a subtype of".
# This struct is immutable and will be 'isbits'.
struct Circle <: AbstractShape
    radius::Float64
end

# 3. Define another concrete 'isbits' subtype.
struct Rectangle <: AbstractShape
    width::Float64
    height::Float64
end

# 4. Define a concrete *mutable* subtype.
# Because it is 'mutable', it will *not* be 'isbits'.
mutable struct MutableSquare <: AbstractShape
    side::Float64
end

# 5. Attempting to instantiate the abstract type will fail.
# Abstract types are just concepts; they have no constructor.
try
    shape_fail = AbstractShape()
catch e
    println("Caught expected error (cannot instantiate abstract type):")
    println(e)
end

# 6. Instantiating the *concrete* types succeeds.
c = Circle(10.0)
r = Rectangle(5.0, 10.0)
s = MutableSquare(7.0)

println("\nConcrete instances:")
println("c = ", c)
println("r = ", r)
println("s = ", s)

# 7. Check the type hierarchy using the subtype operator '<:'.
println("\nType hierarchy checks:")
println("Circle <: AbstractShape? ", Circle <: AbstractShape)
println("Rectangle <: AbstractShape? ", Rectangle <: AbstractShape)
println("MutableSquare <: AbstractShape? ", MutableSquare <: AbstractShape)
# Check if the *instance's type* is a subtype.
println("typeof(c) <: AbstractShape? ", typeof(c) <: AbstractShape)

println("\n--- The Nuance of isbits ---")
# 8. 'isbits(x)' checks the property of an *instance*.
# It's a convenient shorthand for isbitstype(typeof(x)).
println("isbits(c): ", isbits(c)) # true
println("isbits(r): ", isbits(r)) # true
println("isbits(s): ", isbits(s)) # false (it's mutable)

# 9. 'isbitstype(T)' checks the property of the *Type* itself.
# This is the canonical way to check if a type has a C-like,
# plain-data memory layout.
println("\nisbitstype(Circle): ", isbitstype(Circle)) # true
println("isbitstype(Rectangle): ", isbitstype(Rectangle)) # true
println("isbitstype(MutableSquare): ", isbitstype(MutableSquare)) # false
```

### Explanation

This script introduces **`abstract type`s**, which form the foundation of Julia's powerful type hierarchy and are the key to **multiple dispatch**.

  * **Core Concept:** An `abstract type` defines a **concept** or an **interface**, not a specific "thing." You **cannot** create an instance of an abstract type.

      * In our example, `AbstractShape` represents the general idea of "a shape." It makes no sense to create a generic "shape" without knowing if it's a circle, a square, etc.
      * The `try...catch` block proves this: `AbstractShape()` fails with a `MethodError` because no constructor exists for this abstract concept.

  * **Subtyping (`<:`):** The "is a subtype of" operator, `<:`, is used to build the hierarchy.

      * `struct Circle <: AbstractShape` declares that a `Circle` **is a kind of** `AbstractShape`.
      * `Circle` and `Rectangle` are called **concrete types**. They are "real" types that you *can* create instances of.

  * **The Purpose:** Why define this? Abstract types allow you to write **generic functions**. You can write a function that accepts any `AbstractShape`, and Julia's dispatch system will automatically call the correct, specific implementation for a `Circle` or a `Rectangle`. This is the subject of the very next lesson.

  * **`isbits` vs. `isbitstype`:** This is a crucial, subtle distinction.

      * **`isbitstype(T::Type)`:** This is the authoritative function to ask: "Does the type `T` describe a plain-data, C-like memory layout?" As shown, `isbitstype(Circle)` is `true` because it's immutable and has `isbits` fields. `isbitstype(MutableSquare)` is `false` because it's mutable.
      * **`isbits(x)`:** This is a function that operates on a **value**. It's a convenient shorthand for `isbitstype(typeof(x))`. This is why `isbits(c)` is `true`. The *instance* `c` is of type `Circle`, and `isbitstype(Circle)` is `true`.

  * **Container Performance:** This hierarchy has direct performance implications for arrays.

      * A `Vector{Circle}` is a **homogeneous** array. Because `isbitstype(Circle)` is `true`, the `Circle` objects will be stored **inlined and contiguously** in memory (an "Array of Structs"). This is fast.
      * A `Vector{AbstractShape}` is a **heterogeneous** array. Since it must be able to hold *any* `AbstractShape`, including `Circle` (16 bytes) and `MutableSquare` (8-byte pointer), it **must** be an "array of pointers" (a "boxed" array). This is much slower to iterate.

  * **References:**

      * **Julia Official Documentation, Manual, Types, "Abstract Types":** "Abstract types cannot be instantiated... Abstract types are a way to organize types into a hierarchy."
      * **Julia Official Documentation, Manual, Types, "Subtyping":** "The `<:` operator is declared as `(::Type, ::Type) -> Bool`, and returns `true` if its left operand is a subtype of its right operand."
      * **Julia Official Documentation, `isbits(x)`:** "Return `true` if the value `x` is of an `isbits` type." `isbitstype(T)` is noted as the canonical check for the type itself.

To run the script:

```shell
$ julia 0052_abstract_types.jl
Caught expected error (cannot instantiate abstract type):
MethodError: no method matching AbstractShape()

Concrete instances:
c = Circle(10.0)
r = Rectangle(5.0, 10.0)
s = MutableSquare(7.0)

Type hierarchy checks:
Circle <: AbstractShape? true
Rectangle <: AbstractShape? true
MutableSquare <: AbstractShape? true
typeof(c) <: AbstractShape? true

--- The Nuance of isbits ---
isbits(c): true
isbits(r): true
isbits(s): false

isbitstype(Circle): true
isbitstype(Rectangle): true
isbitstype(MutableSquare): false
```