### `0009_arithmetic_operators.jl`

```julia
# 0009_arithmetic_operators.jl

a = 10
b = 3

# Standard arithmetic operators
addition = a + b
subtraction = a - b
multiplication = a * b
exponentiation = a ^ b # Note: ^ is for power, not XOR

println("a + b = ", addition)
println("a - b = ", subtraction)
println("a * b = ", multiplication)
println("a ^ b = ", exponentiation)

println("-"^20)

# Julia has two types of division
float_division = a / b
integer_division = a ÷ b # Type this with \div<tab>
remainder = a % b

println("Floating-point division (a / b): ", float_division)
println("Integer division (a ÷ b): ", integer_division)
println("Remainder (a % b): ", remainder)
```

### Explanation

This script covers Julia's standard arithmetic operators, highlighting the important distinction between the two division operators.

  * **Standard Operators**: Julia uses the expected symbols for addition (`+`), subtraction (`-`), multiplication (`*`), exponentiation (`^`), and remainder (`%`).
      * **Note**: Coming from C/C++/Rust, be aware that `^` is for exponentiation, not bitwise XOR (which is done with the `xor()` function or the `⊻` symbol).

### Division Operators

Julia provides two distinct division operators to avoid ambiguity, which is a common source of bugs in other languages.

  * `/` **(Floating-Point Division)**: This operator *always* performs floating-point division and will always return a floating-point number, even if the inputs are integers. This is identical to Python 3's `/` operator.

      * `10 / 2` results in `5.0`.

  * `÷` **(Integer Division)**: This operator (typed as `\div` followed by `Tab`) performs Euclidean division, truncating the result to an integer. This is the equivalent of integer division in C/C++ or the `//` operator in Python.

      * `10 ÷ 3` results in `3`.

To run the script:

```shell
$ julia 0009_arithmetic_operators.jl
a + b = 13
a - b = 7
a * b = 30
a ^ b = 1000
--------------------
Floating-point division (a / b): 3.3333333333333335
Integer division (a ÷ b): 3
Remainder (a % b): 1
```