### `0010_comparison_operators.jl`

```julia
# 0010_comparison_operators.jl

# Standard comparison operators
println("5 > 3 is ", 5 > 3)
println("5 == 5 is ", 5 == 5)
println("5 != 3 is ", 5 != 3)

# 'a' is less than 'b' based on its Unicode value
println("'a' < 'b' is ", 'a' < 'b')

println("-"^20)

# The `==` operator compares values after type promotion
println("Does 1 (Integer) == 1.0 (Float)? ", 1 == 1.0)

# The `===` operator checks for strict equality (same type and value)
println("Does 1 (Integer) === 1.0 (Float)? ", 1 === 1.0)

# `NaN` is a special case for equality
println("Does NaN == NaN? ", NaN == NaN)

# `isequal()` is a function that considers NaN equal to itself
println("Does isequal(NaN, NaN)? ", isequal(NaN, NaN))
```

### Explanation

This script demonstrates Julia's comparison operators, highlighting the important differences between the three types of equality checks.

  * **Standard Operators**: The usual operators `==` (equal), `!=` (not equal), `<`, `>`, `<=`, and `>=` work as expected. They compare values, promoting numeric types if necessary. This is why `1 == 1.0` evaluates to `true`.

### The Three Equalities

For a systems programmer, understanding the distinction between different equality checks is critical.

  * **`==` (Value Equality)**: This is the most common equality check. It compares values. If the types are different but can be promoted to a common type (like `Int` and `Float64`), it does so before comparing. The one special case is that `NaN == NaN` is always `false`, following the IEEE 754 standard.

  * **`isequal()` (Consistent Value Equality)**: This function is similar to `==` but provides more consistent behavior for use in hash tables (like `Dict`). The key difference is that `isequal(NaN, NaN)` returns `true`.

  * **`===` (Strict Equality / Identity)**: This operator, pronounced "triple equals," checks if two operands are identical.

      * For immutable values like numbers or characters, it returns `true` only if they are of the **exact same type** and have the same value. This is why `1 === 1.0` is `false`.
      * For mutable objects (which we will cover later), it checks if they are the exact same object in memory, similar to comparing pointers in C/C++.

To run the script:

```shell
$ julia 0010_comparison_operators.jl
5 > 3 is true
5 == 5 is true
5 != 3 is true
'a' < 'b' is true
--------------------
Does 1 (Integer) == 1.0 (Float)? true
Does 1 (Integer) === 1.0 (Float)? false
Does NaN == NaN? false
Does isequal(NaN, NaN)? true
```