### `0039_function_basics.jl`

```julia
# 0039_function_basics.jl

# 1. Standard function definition using the 'function' keyword.
#    The return type can be annotated, but often Julia's inference is sufficient.
function add_numbers(x::Int, y::Int)
    result = x + y
    # The last evaluated expression in a function is implicitly returned.
    # No explicit 'return' keyword is needed here.
    result
end

# 2. Compact, single-line function definition.
#    This is suitable for simple functions. It's just syntactic sugar.
multiply_numbers(x, y) = x * y

# Call the functions
sum_result = add_numbers(5, 3)
product_result = multiply_numbers(5, 3)

println("Result of add_numbers(5, 3): ", sum_result)
println("Result of multiply_numbers(5, 3): ", product_result)

# Demonstrate implicit return with a slightly more complex example
function check_positive(n)
    if n > 0
        "Positive" # Implicit return if n > 0
    else
        "Non-positive" # Implicit return otherwise
    end
end

println("Check positive for 10: ", check_positive(10))
println("Check positive for -2: ", check_positive(-2))
```

-----

### Explanation

This script introduces the two main ways to define functions in Julia and highlights the concept of implicit return.

  * **Standard Syntax (`function ... end`)**: This is the block syntax used for longer or more complex functions.

      * `function add_numbers(x::Int, y::Int)`: Defines a function named `add_numbers` that takes two arguments, `x` and `y`. The `::Int` are **type annotations**, which we'll cover next. They tell the compiler what type these arguments are expected to be.
      * The code within the `function` and `end` keywords is the function body.

  * **Compact Syntax (`f(x) = ...`)**: For simple, single-expression functions, Julia offers a concise assignment form: `multiply_numbers(x, y) = x * y`. This defines a function named `multiply_numbers` that takes two arguments and immediately returns the result of `x * y`. This is purely syntactic sugar for the standard form.

  * **Implicit Return**: A defining feature of Julia is that the value of the **last evaluated expression** in a function's body is automatically returned. You do not need to use the `return` keyword unless you want to return early from the middle of a function.

      * In `add_numbers`, the last expression is `result`, so its value is returned.
      * In `check_positive`, the last expression evaluated is either `"Positive"` or `"Non-positive"`, depending on the `if` condition, and that string is returned.

To run the script:

```shell
$ julia 0039_function_basics.jl
Result of add_numbers(5, 3): 8
Result of multiply_numbers(5, 3): 15
Check positive for 10: Positive
Check positive for -2: Non-positive
```