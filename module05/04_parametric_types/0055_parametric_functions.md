### `0055_parametric_functions.jl`

```julia
# 0055_parametric_functions.jl

# 1. Define our parametric struct from the previous lesson
struct Container{T}
    value::T
end

# 2. A generic function using the 'where {T}' syntax.
# This is the standard way to write functions for parametric types.
#
# Read as: "A function 'get_value' that takes 'c' of type 'Container{T}',
#          'where T' is some type. This function returns a value of type T."
function get_value(c::Container{T})::T where {T}
    # 'T' is available as a type *variable* inside the function.
    println("Generic 'get_value(c::Container{T})' called, where T = ", T)
    return c.value
end

# 3. A function that returns both the value and the *type*.
# This shows that 'T' is a real value (a 'DataType') inside the function.
function get_value_and_type(c::Container{T}) where {T}
    println("Function 'get_value_and_type' called, where T = ", T)
    return (c.value, T) # Return a tuple
end

# 4. A *specific method* for Container{String}.
# This method is *more specific* than the generic 'where {T}' version.
function get_value(c::Container{String})::String
    println("Specific 'get_value(c::Container{String})' called!")
    return uppercase(c.value)
end

# --- Script Execution ---

# 5. Create instances
c_int = Container(100)       # Container{Int64}
c_str = Container("hello")   # Container{String}
c_flt = Container(3.14)      # Container{Float64}

println("--- Calling generic methods ---")
val_int = get_value(c_int)
println("  Got value: ", val_int)

val_flt, type_flt = get_value_and_type(c_flt)
println("  Got value: ", val_flt, " | Got type: ", type_flt)

println("\n--- Calling specific method (dispatch) ---")
# 6. Julia's dispatch system will see that c_str is a Container{String}
# and select the *most specific* method available.
val_str = get_value(c_str)
println("  Got value: ", val_str)
```

### Explanation

This script demonstrates how to write **functions** that operate on the **parametric types** we just defined. This is where parametric types and multiple dispatch combine to create Julia's high-performance, generic code.

  * **Core Concept: `where {T}`:**

      * The `where {T}` syntax is the key. It's how you "get" the type parameter from an argument.
      * In the signature `function get_value(c::Container{T})::T where {T}`, we are telling Julia:
        1.  `c::Container{T}`: "This function accepts a `Container`, and I don't care what type it holds. Let's call that type `T`."
        2.  `where {T}`: "Bind that unknown type `T` to a variable named `T` that I can use inside my function."
        3.  `::T`: "I promise that this function will return a value of that same type `T`."
      * As shown in `get_value_and_type`, the variable `T` is a real value (a `DataType` object) that you can inspect, return, or use.

  * **Performance: Compile-Time Specialization:**

      * This is **not** like a generic `function(c::Container{Object})` in Java. There is no runtime "unboxing."
      * When you first call `get_value(c_int)`, the compiler *sees* that `T` is `Int64`. It then **generates and compiles a new, specialized method** just for `Int64`:

    <!-- end list -->

    ```julia
    # This is what Julia effectively compiles:
    function get_value(c::Container{Int64})::Int64
        return c.value
    end
    ```

      * This specialized method is just as fast as if you had written it by hand. It knows `c.value` is an `Int64` and the return type is `Int64`. There is **zero abstraction cost**. A separate, fast version is also compiled for `Float64`.

  * **Dispatch: Generic vs. Specific:**

      * This script shows how parametric methods interact with multiple dispatch. We have two methods for the `get_value` function:
        1.  `get_value(c::Container{T}) where {T}` (The generic "catch-all")
        2.  `get_value(c::Container{String})` (The specific "special case")
      * When we call `get_value(c_int)`, the `Container{Int64}` type does not match `Container{String}`. It falls back to the generic `where {T}` method, with `T` becoming `Int64`.
      * When we call `get_value(c_str)`, the `Container{String}` type matches **both** methods. Julia's dispatch system follows the rule: **"always pick the most specific method."**
      * Since `Container{String}` is *more specific* than `Container{T}`, the specialized string version is called, and we get the `uppercase` behavior.

  * **References:**

      * **Julia Official Documentation, Manual, "Methods", "Parametric Methods":** "Method definitions can be parameterized... When a function is called, the method with the most specific matching signature is invoked."

To run the script:

```shell
$ julia 0055_parametric_functions.jl
--- Calling generic methods ---
Generic 'get_value(c::Container{T})' called, where T = Int64
  Got value: 100
Function 'get_value_and_type' called, where T = Float64
  Got value: 3.14 | Got type: Float64

--- Calling specific method (dispatch) ---
Specific 'get_value(c::Container{String})' called!
  Got value: HELLO
```