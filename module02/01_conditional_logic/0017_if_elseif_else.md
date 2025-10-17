### `0017_if_elseif_else.jl`

```julia
# 0017_if_elseif_else.jl

# A function to check the sign of a number
function check_sign(n)
    if n > 0
        println("The number ", n, " is positive.")
    elseif n < 0
        println("The number ", n, " is negative.")
    else
        println("The number ", n, " is zero.")
    end
end

check_sign(10)
check_sign(-5)
check_sign(0)
```

### Explanation

This script introduces the `if`/`elseif`/`else` structure, which allows you to chain multiple conditions together.

  * **Syntax**: The structure is `if <condition1> ... elseif <condition2> ... else ... end`.
  * **Execution Flow**: Julia evaluates the conditions sequentially from top to bottom.
    1.  First, it checks `if n > 0`. If this is `true`, its block is executed, and the entire chain is exited.
    2.  Only if the first condition is `false`, it then checks `elseif n < 0`. If this is `true`, its block is executed, and the chain is exited.
    3.  If all preceding `if` and `elseif` conditions are `false`, the final `else` block is executed as a fallback.

This structure is a direct equivalent to `if`/`else if`/`else` in C++/Rust and `if`/`elif`/`else` in Python. It's a clean way to handle a series of mutually exclusive conditions.

To run the script:

```shell
$ julia 0017_if_elseif_else.jl
The number 10 is positive.
The number -5 is negative.
The number 0 is zero.
```