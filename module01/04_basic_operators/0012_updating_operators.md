### `0012_updating_operators.jl`

```julia
# 0012_updating_operators.jl

# Initialize a counter
counter = 10
println("Initial counter value: ", counter)

# Increment the counter by 5
counter += 5
println("After 'counter += 5': ", counter)

# Decrement the counter by 3
counter -= 3
println("After 'counter -= 3': ", counter)

# Multiply the counter by 2
counter *= 2
println("After 'counter *= 2': ", counter)

# Floating-point divide the counter by 4
# Note: The type of 'counter' will change from Int to Float64
counter /= 4
println("After 'counter /= 4': ", counter)
println("New type of counter: ", typeof(counter))

```

### Explanation

This script demonstrates Julia's updating operators, which provide a concise syntax for modifying a variable in place. These operators are syntactically and functionally identical to their counterparts in C, C++, Rust, and Python.

  * **Syntax**: An updating operator is a combination of a binary operator (like `+`, `-`, `*`) and the assignment operator (`=`). The expression `x += y` is a shorthand for `x = x + y`.

  * **Common Operators**: Julia supports a wide range of these operators, including:

      * `+=` (add and assign)
      * `-=` (subtract and assign)
      * `*=` (multiply and assign)
      * `/=` (divide and assign)
      * `÷=` (integer divide and assign)
      * `%=` (remainder and assign)
      * `^=` (exponentiate and assign)

  * **Type Promotion**: Be aware that the operation can change the type of the variable. As shown in the example, when `counter /= 4` is executed, the `/` operator performs floating-point division. The result is a `Float64`, so the `counter` variable is rebound to this new floating-point value.

To run the script:

```shell
$ julia 0012_updating_operators.jl
Initial counter value: 10
After 'counter += 5': 15
After 'counter -= 3': 12
After 'counter *= 2': 24
After 'counter /= 4': 6.0
New type of counter: Float64
```