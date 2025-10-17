### `0040_type_annotations.jl`

```julia
# 0040_type_annotations.jl

# 1. Function without type annotations.
#    Julia will compile specialized versions based on the types it sees at runtime.
function process_unannotated(data)
    # This might be fast if `data` is always the same type,
    # but the compiler has less information upfront.
    println("Processing data of type: ", typeof(data))
    return data # Return the data unmodified
end

# 2. Function WITH type annotations for arguments.
#    This tells the compiler (and the programmer) that `x` MUST be an Int.
#    It enables method dispatch and performance optimizations.
function calculate_area(width::Int, height::Int)
    return width * height
end

# 3. Function WITH annotations for arguments AND return type.
#    The `::Int` after the argument list guarantees the function will return an Int.
#    If it tries to return something else, an error occurs.
function get_int_length(s::String)::Int
    len = length(s)
    # If we tried to return a float here, like `len + 0.5`, it would error.
    return len
end


# Call the functions
println("--- Unannotated ---")
process_unannotated(10)
process_unannotated("hello")

println("\n--- Annotated Arguments ---")
area = calculate_area(5, 4)
println("Calculated area: ", area)
# Calling with wrong types will cause a MethodError immediately
try
    calculate_area(5.0, 4)
catch e
    println("Error calling with wrong type: ", e)
end

println("\n--- Annotated Return Type ---")
str_len = get_int_length("Julia")
println("Length of 'Julia': ", str_len)
println("Return type is indeed Int: ", typeof(str_len))
```

-----

### Explanation

This script demonstrates **type annotations** in Julia functions, which are crucial for both correctness and performance. 📝

  * **Syntax**: Annotations are added using the double colon `::` operator.

      * `function func(arg::Type)`: Annotates the type of an argument.
      * `function func(arg)::Type`: Annotates the expected return type of the function.

  * **Purpose**:

    1.  **Method Dispatch**: Annotations allow you to define different **methods** of the same function for different argument types (this is the core of multiple dispatch, coming next). When you call `calculate_area(5, 4)`, Julia knows *exactly* which version of the function to run because the types match the annotation `(width::Int, height::Int)`.
    2.  **Performance**: When the compiler knows the types of the arguments and the expected return type, it can generate highly specialized and optimized machine code. It eliminates the need for runtime type checks within the function body. Functions with fully annotated arguments and return types are much more likely to be **type-stable** and fast.
    3.  **Correctness & Readability**: Annotations act as documentation and assertions. They make the function's contract clear. If you call a function with the wrong type, you get an immediate `MethodError` instead of a potentially obscure error later on. If a function annotated to return `::Int` accidentally returns a `Float64`, Julia will throw a `TypeError`.

  * **Omitting Annotations**: You *can* omit annotations (like in `process_unannotated`). Julia will still compile specialized versions based on the types it observes when the function is first called. However, adding annotations provides stronger guarantees to the compiler and makes the code easier to understand and debug.

To run the script:

```shell
$ julia 0040_type_annotations.jl
--- Unannotated ---
Processing data of type: Int64
Processing data of type: String

--- Annotated Arguments ---
Calculated area: 20
Error calling with wrong type: MethodError(f=calculate_area, args=(5.0, 4))

--- Annotated Return Type ---
Length of 'Julia': 5
Return type is indeed Int: Int64
```