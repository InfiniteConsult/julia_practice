### `0016_if_else.jl`

```julia
# 0016_if_else.jl

# A simple function to check if a number is even or odd
function check_parity(n)
    if n % 2 == 0
        println("The number ", n, " is even.")
    else
        println("The number ", n, " is odd.")
    end
end

check_parity(10)
check_parity(7)
```

### Explanation

This script demonstrates the fundamental `if`/`else` statement, which is the most basic structure for conditional logic.

  * **Syntax**: The structure is `if <condition> ... else ... end`. The code inside the `if` block is executed if the `<condition>` evaluates to `true`. Otherwise, the code inside the `else` block is executed.
  * **Condition**: The condition (`n % 2 == 0`) must be an expression that results in a `Bool` (`true` or `false`).
  * **`end` Keyword**: Unlike Python's indentation or C++/Rust's curly braces, Julia uses the `end` keyword to terminate blocks of code, including `if` statements and functions.

To run the script:

```shell
$ julia 0016_if_else.jl
The number 10 is even.
The number 7 is odd.
```