### `0056_parametric_abstract.jl`

```julia
# 0056_parametric_abstract.jl

# 1. Define a 'parametric abstract type'.
# This defines an interface for a *family* of generic types.
# It's a contract: "Any subtype must also be parameterized by a type T."
abstract type AbstractContainer{T} end

# 2. Define a concrete parametric struct that subtypes it.
# We 'pass through' the type parameter T to the abstract type.
struct ConcreteContainer{T} <: AbstractContainer{T}
    value::T
end

# 3. Define another concrete struct that *fixes* the type parameter.
# This struct is *not* parametric itself, but it fulfills the
# contract by subtyping a *specific* variant of the abstract type.
struct StringContainer <: AbstractContainer{String}
    name::String
    value::String
end

# 4. Define a generic function that operates on the abstract interface.
# This function will work on *any* type 'S' that is a subtype
# of AbstractContainer{T}, 'where T' is some type.
function get_abstract_value(c::S) where {T, S <: AbstractContainer{T}}
    println("Dispatching to generic AbstractContainer{T} method where T=", T)
    # We can't access c.value because we don't know
    # if the struct has a 'value' field (e.g., StringContainer)
    # We just return the type parameter we found.
    return T
end

# 5. Define a more specific (but still abstract) method.
# This will dispatch for *any* AbstractContainer that holds a 'String'.
function process_text_container(c::AbstractContainer{String})
    println("Dispatching to specific AbstractContainer{String} method.")
    # Here we still can't access c.value, but we know T is String.
end

# --- Script Execution ---
c_int = ConcreteContainer(10)      # ConcreteContainer{Int64}
c_str = ConcreteContainer("Hello") # ConcreteContainer{String}
s_str = StringContainer("ID", "Data") # StringContainer

# 6. Call the generic function
println("--- Calling generic get_abstract_value ---")
get_abstract_value(c_int)
get_abstract_value(c_str)
get_abstract_value(s_str)

# 7. Call the more specific function
println("\n--- Calling specific process_text_container ---")
# process_text_container(c_int) # This would fail (MethodError)
process_text_container(c_str)
process_text_container(s_str)

# 8. Check the type hierarchy
println("\n--- Type hierarchy checks ---")
println("ConcreteContainer{Int64} <: AbstractContainer{Int64}?  ", ConcreteContainer{Int64} <: AbstractContainer{Int64})
println("StringContainer <: AbstractContainer{String}?      ", StringContainer <: AbstractContainer{String})
println("StringContainer <: AbstractContainer{Int64}?      ", StringContainer <: AbstractContainer{Int64})
```

### Explanation

This script combines the two previous concepts—`abstract type`s and `struct{T}`s—to create **parametric abstract types**. This is a powerful pattern for defining a generic "interface" for a whole family of types.

  * **Core Concept:** An `abstract type AbstractContainer{T} end` defines a contract for *generic* containers. It says, "Any type that claims to be a subtype of me must also specify what `T` it is."

  * **Fulfilling the Contract:**

    1.  **`ConcreteContainer{T} <: AbstractContainer{T}`:** This is the most direct way. We create a new parametric `struct` and "pass through" the type parameter `T`. This says, "A `ConcreteContainer{Int}` **is a kind of** `AbstractContainer{Int}`."
    2.  **`StringContainer <: AbstractContainer{String}`:** This is a more specialized way. The `StringContainer` *is not* generic (it only holds `String`s), but it fulfills the contract by declaring that it **is a kind of** `AbstractContainer{String}`.

  * **Dispatching on Parametric Abstract Types:**

      * The function `get_abstract_value` shows the most generic form. Its signature `where {T, S <: AbstractContainer{T}}` is the full, explicit way of saying: "I accept any type `S`, as long as that type `S` is a subtype of `AbstractContainer{T}` for *some* `T`."
      * The function `process_text_container(c::AbstractContainer{String})` is much simpler. It accepts *any* object whose type is a subtype of `AbstractContainer{String}`.

  * **How Dispatch Works:**

      * When we call `process_text_container(c_str)`, Julia checks: Is `typeof(c_str)` (which is `ConcreteContainer{String}`) a subtype of `AbstractContainer{String}`? The check is `true`, so the call succeeds.
      * When we call `process_text_container(s_str)`, Julia checks: Is `typeof(s_str)` (which is `StringContainer`) a subtype of `AbstractContainer{String}`? The check is `true`, so the call succeeds.
      * A call with `c_int` (`ConcreteContainer{Int64}`) would fail, because `ConcreteContainer{Int64}` is **not** a subtype of `AbstractContainer{String}`.

  * **Parametric Invariance:** This last point is critical. `ConcreteContainer{Int64}` is **not** related to `ConcreteContainer{String}`. A generic type `Foo{T}` is **invariant** in its type parameter. This strictness is what allows the compiler to generate highly specialized, fast code, as it never has to guess what `T` might be.

  * **References:**

      * **Julia Official Documentation, Manual, Types, "Parametric Abstract Types":** "Parametric abstract types are a useful way to define a hierarchy of types on a common parametric structure."
      * **Julia Official Documentation, Manual, "Types", "Parametric Types" (on Invariance):** "A `Container{Int}` is not a subtype of `Container{Number}`, even though `Int <: Number`."

To run the script:

```shell
$ julia 0056_parametric_abstract.jl
--- Calling generic get_abstract_value ---
Dispatching to generic AbstractContainer{T} method where T=Int64
Dispatching to generic AbstractContainer{T} method where T=String
Dispatching to generic AbstractContainer{T} method where T=String

--- Calling specific process_text_container ---
Dispatching to specific AbstractContainer{String} method.
Dispatching to specific AbstractContainer{String} method.

--- Type hierarchy checks ---
ConcreteContainer{Int64} <: AbstractContainer{Int64}?  true
StringContainer <: AbstractContainer{String}?      true
StringContainer <: AbstractContainer{Int64}?      false
```