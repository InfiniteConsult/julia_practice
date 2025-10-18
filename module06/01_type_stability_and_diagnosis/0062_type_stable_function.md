### `0062_type_stable_function.jl`

```julia
# 0062_type_stable_function.jl

import InteractiveUtils: @code_warntype

# 1. A function that is type-stable.
# The compiler can infer 100% of the types.
# Input 'Int64' -> Output 'Int64'
function add_one_stable(x::Int64)
    return x + 1
end

# 2. A function that is also type-stable.
# Input 'Float64' -> Output 'Float64'
function add_one_stable_float(x::Float64)
    # The '1.0' literal ensures the result is a Float64
    return x + 1.0
end

# 3. A generic, but still type-stable, function.
# The compiler knows: Input 'T' -> Output 'T' (where T is a Number)
# It will compile a *specialized* version for each type.
function add_one_generic(x::T) where {T<:Number}
    return x + one(T) # 'one(T)' returns 1 as type T
end

# 4. Use the @code_warntype macro to inspect the compiler's
# type inference. This is our primary diagnostic tool.
# We must 'execute' the macro in a function (e.g., in main)
# or at the REPL to see the output.

function analyze_stable()
    println("--- @code_warntype for add_one_stable(1) ---")
    @code_warntype add_one_stable(1)

    println("\n--- @code_warntype for add_one_stable_float(1.0) ---")
    @code_warntype add_one_stable_float(1.0)
    
    println("\n--- @code_warntype for add_one_generic(1) ---")
    @code_warntype add_one_generic(1) # Will infer T=Int64
    
    println("\n--- @code_warntype for add_one_generic(1.0) ---")
    @code_warntype add_one_generic(1.0) # Will infer T=Float64
end

# Run the analysis
analyze_stable()
```

### Explanation

This script demonstrates what a **type-stable** function looks like and introduces our primary diagnostic tool: the **`@code_warntype`** macro.

  * **Core Concept: `add_one_stable(x::Int64)`**
    This function is the definition of type stability. The signature `(x::Int64)` and the operation `x + 1` (where `1` is an `Int64`) combine to create a contract: "This function *always* returns an `Int64`." The compiler can rely on this 100% and generate optimal, C-like machine code.

  * **Diagnostic Tool: `@code_warntype`**

      * The `@code_warntype` macro is your "X-ray vision" into the Julia compiler. It runs Julia's type-inference engine on a function call and reports what it found.
      * It prints a detailed breakdown, but we only care about one line: the `Body` line.
      * **`Body::Int64` (Good):** When we run `@code_warntype add_one_stable(1)`, the output will include `Body::Int64`. This is the compiler's "all clear" sign. It is printed in green (in a color-supporting terminal) and means: "I have successfully inferred that the body of this function will always return an `Int64`."
      * **`Body::Any` or `Body::Union{...}` (Bad):** If you see this (especially in red), it means the compiler *gave up*. It could not determine the return type. This signifies type-instability and is the source of performance problems.

  * **Generic Stability: `add_one_generic`**

      * This function is also type-stable, but in a more general way. The `where {T<:Number}` tells the compiler, "Whatever numeric type `T` you put in, I will return that same type `T`."
      * When you run `@code_warntype add_one_generic(1)`, the compiler *specializes* the function for `T=Int64` and infers a return type of `Body::Int64`.
      * When you run `@code_warntype add_one_generic(1.0)`, it *specializes again* for `T=Float64` and infers `Body::Float64`.
      * This specialization is the core of Julia's performance: it allows you to write one generic, readable function, and the compiler automatically creates multiple, hyper-specialized, fast versions for you.

  * **References:**

      * **Julia Official Documentation, Manual, "Performance Tips":** Explains the use of `@code_warntype` to "find problems in your code."
      * **Julia Official Documentation, Manual, "@code\_warntype":** "Prints the inferred return types of a function call to `stdout`... highlighting any values that are not inferred to be of a concrete type."

To run the script:

*(Note: The exact output of `@code_warntype` is verbose and can change between Julia versions. We are only interested in the `Body::` line at the top.)*

```shell
$ julia 0062_type_stable_function.jl
--- @code_warntype for add_one_stable(1) ---
Variables
  #self#::Core.Const(add_one_stable)
  x::Int64
Body::Int64
[...]

--- @code_warntype for add_one_stable_float(1.0) ---
Variables
  #self#::Core.Const(add_one_stable_float)
  x::Float64
Body::Float64
[...]

--- @code_warntype for add_one_generic(1) ---
Variables
  #self#::Core.Const(add_one_generic)
  x::Int64
Body::Int64
[...]

--- @code_warntype for add_one_generic(1.0) ---
Variables
  #self#::Core.Const(add_one_generic)
  x::Float64
Body::Float64
[...]
```