### `0054_parametric_struct.jl`

```julia
# 0054_parametric_struct.jl

# 1. Define a 'parametric struct'.
# The '{T}' is a type parameter. This makes 'Container' a
# generic blueprint, not a single concrete type.
# 'T' can be any type.
struct Container{T}
    value::T
end

# 2. Instantiate with an explicit type parameter.
# We create a 'Container{Float64}', where T=Float64.
c_float = Container{Float64}(10.0)
println("Container with explicit Float64:")
println("  Value: ", c_float.value)
println("  Type:  ", typeof(c_float))

# 3. Instantiate with an implicit type parameter.
# We let Julia's constructor *infer* the type 'T'.
# By passing an Int, Julia creates a 'Container{Int64}'.
c_int = Container(20) # Equivalent to Container{Int64}(20)
println("\nContainer with inferred Int64:")
println("  Value: ", c_int.value)
println("  Type:  ", typeof(c_int))

# 4. 'T' can be *any* type, including non-isbits types.
c_string = Container("Hello")
println("\nContainer with inferred String:")
println("  Value: ", c_string.value)
println("  Type:  ", typeof(c_string))

println("\n--- Performance: isbits checks ---")

# 5. The 'isbits' status of the struct depends on its *parameters*.
# Container{Float64} is immutable and holds an isbits type (Float64).
println("isbitstype(Container{Float64}): ", isbitstype(Container{Float64})) # true

# Container{String} is immutable but holds a non-isbits type (String).
println("isbitstype(Container{String}):  ", isbitstype(Container{String})) # false

# 'Container' itself is not a concrete type, so it's not isbits.
# It's a "family" of types.
println("isbitstype(Container):          ", isbitstype(Container)) # false
```

### Explanation

This script introduces **parametric types**, Julia's version of generics (like C++ templates or C\# generics). This is a core feature for writing code that is both **reusable** and **high-performance**.

  * **Core Concept:** A parametric `struct` is a "blueprint for a type." The `struct Container{T}` definition does not create a single type. Instead, it creates a *factory* that can produce an infinite family of types, like `Container{Float64}`, `Container{Int64}`, and `Container{String}`.

  * **Type Parameter `{T}`:** The `{T}` introduces a "type variable" named `T`. This `T` can then be used as a type annotation for the fields inside the `struct`, as we did with `value::T`.

  * **Instantiation (Explicit vs. Implicit):**

    1.  **Explicit:** `Container{Float64}(10.0)`: We explicitly tell Julia to "use the `Container` blueprint, setting `T = Float64`."
    2.  **Implicit:** `Container(20)`: We call the default constructor, passing an `Int64`. Julia's compiler infers that `T` must be `Int64` and automatically creates a `Container{Int64}`.

  * **Zero-Cost Abstraction (Performance):** This is the crucial takeaway. When you create `c_int = Container(20)`, Julia's compiler generates a **new, specialized, concrete type** `Container{Int64}`. This specialized type is *just as fast* as if you had manually defined `struct IntContainer { value::Int64 }`.

      * This is **not** like `Object` in Java. There is no boxing or dynamic dispatch to access `c_int.value`. The compiled code knows *exactly* where the `Int64` is stored.
      * **`isbits` Status:** The performance of the `Container` depends on what `T` is.
          * `isbitstype(Container{Float64})` is **`true`**. This type is immutable and its field is `isbits`, so it gets all the performance benefits: stack allocation, register passing, and inlined, contiguous array layouts.
          * `isbitstype(Container{String})` is **`false`**. Because `String` is not `isbits` (it's a pointer to heap data), the resulting `Container{String}` struct is *also* not `isbits`. A `Vector{Container{String}}` would be an "array of pointers."

  * This pattern lets you write one, generic, reusable `struct` and trust Julia's compiler to stamp out a specialized, high-performance version for every concrete type you use it with.

  * **References:**

      * **Julia Official Documentation, Manual, Types, "Parametric Composite Types":** "It is a common pattern that a type definition declares a composite type `Foo` that can hold values of type `T`. This is written in Julia as `struct Foo{T} ... end`."

To run the script:

```shell
$ julia 0054_parametric_struct.jl
Container with explicit Float64:
  Value: 10.0
  Type:  Container{Float64}

Container with inferred Int64:
  Value: 20
  Type:  Container{Int64}

Container with inferred String:
  Value: Hello
  Type:  Container{String}

--- Performance: isbits checks ---
isbitstype(Container{Float64}): true
isbitstype(Container{String}):  false
isbitstype(Container):          false
```
