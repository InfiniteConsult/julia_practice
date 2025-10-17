### `0018_ternary_operator.jl`

```julia
# 0018_ternary_operator.jl

function get_parity_message(n)
    # The ternary operator provides a concise way to write a simple if/else.
    # The structure is: <condition> ? <value_if_true> : <value_if_false>
    message = (n % 2 == 0) ? "even" : "odd"
    return "The number $n is $message."
end

println(get_parity_message(10))
println(get_parity_message(7))
```

-----

### Explanation

This script introduces the **ternary operator**, a compact syntax for a simple conditional expression.

  * **Syntax**: The syntax `a ? b : c` is identical to its usage in C, C++, Rust, and Python. The parentheses around the condition, `(n % 2 == 0)`, are not strictly required but are often used to improve readability.

  * **Execution**: The condition `a` is evaluated first.

      * If it's `true`, the entire expression evaluates to `b`.
      * If it's `false`, the entire expression evaluates to `c`.

  * **Usage**: It's best used for assigning one of two simple values to a variable based on a single condition. It's an expression that returns a value, not a statement that performs actions. For logic involving multiple lines or `elseif` branches, a full `if/else` block remains more readable and appropriate.

To run the script:

```shell
$ julia 0018_ternary_operator.jl
The number 10 is even.
The number 7 is odd.
```