### `0011_boolean_operators.jl`

```julia
# 0011_boolean_operators.jl

# Define functions that print when they are called
function is_true(label)
    println("Function '", label, "' was called and returns true.")
    return true
end

function is_false(label)
    println("Function '", label, "' was called and returns false.")
    return false
end

println("--- Demonstrating && (AND) ---")
# The right side is NOT evaluated because the left side is false.
println("Result: ", is_false("LHS") && is_true("RHS"))

println("\n--- Demonstrating || (OR) ---")
# The right side is NOT evaluated because the left side is true.
println("Result: ", is_true("LHS") || is_false("RHS"))

println("\n--- Demonstrating ! (NOT) ---")
println("Result: ", !is_false("NOT test"))
```

### Explanation

This script demonstrates Julia's logical operators and their short-circuiting behavior, which is a critical feature for writing efficient and safe code.

  * **Operators**:
      * **`&&`**: Logical AND. Returns `true` only if both the left and right sides are `true`.
      * **`||`**: Logical OR. Returns `true` if either the left or the right side is `true`.
      * **`!`**: Logical NOT. Inverts a boolean value.

### Short-Circuit Evaluation

As in C, C++, Rust, and Python, Julia's `&&` and `||` operators perform **short-circuit evaluation**. This is a key performance and control-flow feature.

  * **For `a && b`**: The expression `b` is **only** evaluated if `a` is `true`. If `a` is `false`, the overall result must be `false`, so there is no need to evaluate `b`. In the first example, only the `is_false("LHS")` function is called.

  * **For `a || b`**: The expression `b` is **only** evaluated if `a` is `false`. If `a` is `true`, the overall result must be `true`, so there is no need to evaluate `b`. In the second example, only the `is_true("LHS")` function is called.

This behavior is commonly used to "guard" subsequent operations, for example, checking that an object is not `nothing` before trying to access one of its fields.

To run the script:

```shell
$ julia 0011_boolean_operators.jl
--- Demonstrating && (AND) ---
Function 'LHS' was called and returns false.
Result: false

--- Demonstrating || (OR) ---
Function 'LHS' was called and returns true.
Result: true

--- Demonstrating ! (NOT) ---
Function 'NOT test' was called and returns false.
Result: true
```