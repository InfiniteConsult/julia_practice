### `0004_constants.jl`

```julia
# 0004_constants.jl

# A regular (non-constant) global variable. Its type can change.
NON_CONST_GLOBAL = 100

# A constant global variable. Its type is now fixed.
const CONST_GLOBAL = 200

function get_non_const()
    return NON_CONST_GLOBAL * 2
end

function get_const()
    return CONST_GLOBAL * 2
end

println("This script demonstrates the performance difference between constant and non-constant globals.")
println("The real difference is seen by inspecting the compiled code, not just by timing this simple script.")
println("\nIn the Julia REPL, run the following commands to see the difference:")
println("  include(\"0004_constants.jl\")")
println("  @code_warntype get_non_const()")
println("  @code_warntype get_const()")

# We can call the functions to show they work
println("\nResult from non-constant global: ", get_non_const())
println("Result from constant global: ", get_const())
```

### Explanation

This script introduces one of the most important concepts for writing high-performance Julia code: **constant global variables**.

  * **`const` Keyword**: When used on a global variable, `const` is a promise to the Julia compiler that the *type* of this variable will never change. This allows the compiler to generate highly optimized, specialized machine code for any function that uses it.

### Performance Impact ❗

Accessing **non-constant global variables** is extremely slow and is one of the most common performance pitfalls for beginners.

  * **Why it's slow**: Because the type of `NON_CONST_GLOBAL` could change at any moment, the compiler can't make any assumptions. Every time `get_non_const()` is called, it must generate slow code to dynamically look up the variable, check its current type, and then decide how to perform the `* 2` operation.

  * **How `const` fixes it**: By declaring `const CONST_GLOBAL`, the compiler knows its type will always be an integer. It can then generate fast, direct code for `get_const()` that performs an efficient integer multiplication, completely avoiding the runtime type-checking overhead.

### Diagnosing with `@code_warntype`

The `@code_warntype` macro is your primary tool for diagnosing this kind of performance issue. After running `include("0004_constants.jl")` in the REPL, compare the output of these two commands:

**1. The Slow Case (Non-Constant)**

```julia
julia> @code_warntype get_non_const()
...
Body::Any
...
```

The `Body::Any` (often highlighted in red) is a warning sign. It means Julia couldn't figure out the function's return type because it depends on a global variable of an unknown type.

**2. The Fast Case (Constant)**

```julia
julia> @code_warntype get_const()
...
Body::Int64
...
```

Here, Julia correctly infers the return type as `Int64`. This indicates type-stable, performant code.

**Rule of Thumb**: Always declare global variables as `const` unless you have a specific reason to change their type.