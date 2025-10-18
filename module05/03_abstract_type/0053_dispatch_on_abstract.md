### `0053_dispatch_on_abstract.jl`

```julia
# 0053_dispatch_on_abstract.jl

# 1. Define the type hierarchy from the previous lesson
abstract type AbstractShape end

struct Circle <: AbstractShape
    radius::Float64
end

struct Rectangle <: AbstractShape
    width::Float64
    height::Float64
end

mutable struct MutableSquare <: AbstractShape
    side::Float64
end

# 2. Define a "generic" function that operates on the abstract type.
# This function defines the "interface" or "contract".
# We can provide a fallback method that throws an error.
function calculate_area(s::AbstractShape)
    # This error will be hit by any subtype that doesn't
    # provide its own specific method.
    error("calculate_area not implemented for type ", typeof(s))
end

# 3. Define a specific METHOD for Circle.
# Julia will dispatch to this function when it sees a Circle.
function calculate_area(c::Circle)
    return π * c.radius^2
end

# 4. Define a specific METHOD for Rectangle.
# This is the same function name, 'calculate_area', but with
# a different type signature (a different method).
function calculate_area(r::Rectangle)
    return r.width * r.height
end

# 5. Create a heterogeneous list of shapes.
# This will be a Vector{AbstractShape}, which is an
# array of pointers (boxed objects).
shapes = [Circle(1.0), Rectangle(2.0, 3.0), Circle(4.0)]

println("--- Processing heterogeneous array of shapes ---")
for shape in shapes
    # 6. Call the generic function.
    # At runtime, Julia inspects the *actual* type of 'shape'
    # and calls the *most specific* method available.
    area = calculate_area(shape)
    println("Shape: ", shape, " | Area: ", area)
end

println("\n--- Testing unimplemented type ---")
# 7. Test the fallback error
s = MutableSquare(5.0)
try
    calculate_area(s)
catch e
    println("Caught expected error:")
    println(e)
end
```

### Explanation

This script demonstrates **multiple dispatch**, which is the "payoff" for using the `abstract type` hierarchy. This is arguably the most important and powerful design pattern in Julia.

  * **Core Concept:** We have defined one generic function name, `calculate_area`, but multiple **methods** for it.

      * `calculate_area(s::AbstractShape)` is a generic fallback.
      * `calculate_area(c::Circle)` is a specific method for `Circle`.
      * `calculate_area(r::Rectangle)` is a specific method for `Rectangle`.

  * **Multiple Dispatch:** When you call `calculate_area(shape)`, Julia performs a runtime lookup on the *concrete type* of the `shape` variable. This is called **dynamic dispatch**.

    1.  In the first loop iteration, `shape` is a `Circle`. Julia sees this and **dispatches** the call to the `calculate_area(c::Circle)` method.
    2.  In the second iteration, `shape` is a `Rectangle`. Julia dispatches to the `calculate_area(r::Rectangle)` method.
        This mechanism allows you to write generic code (the `for` loop) that operates on the abstract concept (`AbstractShape`), while Julia handles executing the correct, specialized code automatically.

  * **Defining an Interface:** The abstract type `AbstractShape` and the generic function `calculate_area(s::AbstractShape)` together define a "contract" or "interface." They state: "To be a usable shape in this system, you must provide a concrete method for `calculate_area`."

      * The `MutableSquare` example proves this. We created `MutableSquare <: AbstractShape`, but we *forgot* to provide a `calculate_area(s::MutableSquare)` method.
      * When `calculate_area(s)` is called, Julia finds no specific method for `MutableSquare`. It falls back to the next most general method, `calculate_area(s::AbstractShape)`, which correctly throws our "not implemented" error. This is a feature, not a bug; it tells us our `MutableSquare` is incomplete.

  * **Performance:** This is not the same as in many object-oriented languages. This dispatch is extremely fast. Even in this "worst-case" scenario of a heterogeneous, type-unstable array (`Vector{AbstractShape}`), Julia's dynamic dispatch is highly optimized. In cases where the compiler *can* infer the concrete type (e.g., in a loop over a `Vector{Circle}`), this dispatch is resolved at **compile time** and has **zero runtime cost**.

  * **References:**

      * **Julia Official Documentation, Manual, "Methods":** "In Julia, all named functions are *generic functions*. A generic function is conceptually a single function, but consists of many *methods*. A method is a definition of a function's behavior for a specific combination of argument types."
      * **Julia Official Documentation, Manual, "Dynamic Dispatch":** "When a function is called, the most specific method applicable to the given arguments is executed."