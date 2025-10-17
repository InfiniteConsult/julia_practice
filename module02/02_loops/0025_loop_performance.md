### `0025_loop_performance.md`

### Explanation

As a systems programmer, you know that the performance of a loop is critical. In interpreted languages like Python, loops are famously slow because the interpreter has to re-evaluate every operation in every iteration. Julia solves this problem, achieving C/Rust-level speed for loops.

-----

## The Julia Performance Model: Functions are Compilation Boundaries

The single most important rule is: **For performance, put your code in functions.**

  - **Global Scope is Slow**: When you run a `for` loop in the global scope (like in many of our basic examples), Julia's compiler can't make many assumptions. The types of the variables involved could change at any time, forcing the interpreter to fall back to slow, dynamic lookups in every iteration.

  - **Functions are Fast**: When you put a loop inside a function, the Julia JIT compiler can perform powerful optimizations. The first time you call a function with arguments of specific types (e.g., `my_function(10, 3.0)`), the compiler:

    1.  **Analyzes Types**: It traces the types of all variables throughout the function.
    2.  **Checks for Type Stability**: It checks if the types of variables change within the function.
    3.  **Generates Specialized Machine Code**: If the function is type-stable, the compiler generates a highly optimized version of that function specifically for those input types.

The result is machine code that is just as fast as what a C++ or Rust compiler would produce. The overhead of the JIT compilation happens only once (the first time), and every subsequent call to the function with the same argument types is extremely fast.

### Example: The "Why"

Consider this simple loop:

```julia
# Slow if run in global scope
for i in 1:1_000_000_000
    # operation
end

# Fast if run like this
function loop_in_a_function()
    for i in 1:1_000_000_000
        # operation
    end
end

loop_in_a_function() # First call compiles, subsequent calls are fast
```

Inside `loop_in_a_function`, the compiler knows the type of `i` will always be an `Int`. It can then unroll the loop, use CPU registers, and apply other low-level optimizations, just as `gcc` or `clang` would. In the global scope, it cannot make these guarantees.

This "compilation boundary" at the function level is the core of Julia's performance model and the reason it successfully solves the "two-language problem" (where you prototype in a slow language and rewrite in a fast one). In Julia, the prototype *is* the fast code, as long as it's written in functions.