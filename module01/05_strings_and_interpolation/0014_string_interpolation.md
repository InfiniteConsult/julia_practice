### `0014_string_interpolation.jl`

```julia
# 0014_string_interpolation.jl

name = "Julia"
year = 2012
version = 1.10

# 1. Basic interpolation with the '$' symbol
#    The variable's value is inserted directly into the string.
intro = "My name is $name. I was released in $year."
println(intro)

println("-"^20)

# 2. Expression interpolation with '$(...)'
#    Any Julia expression inside the parentheses will be evaluated,
#    and its result will be inserted into the string.
current_year = 2025
age_calculation = "It is now $current_year, so I am $(current_year - year) years old."
println(age_calculation)

# You can even call functions inside the expression.
version_info = "My current version is $(version), and uppercase it is $(uppercase(string(version)))"
println(version_info)
```

-----

### Explanation

This script demonstrates string interpolation, which is Julia's most efficient and common method for constructing strings from other values.

  * **Syntax**: Interpolation is performed inside double-quoted strings (`"..."`).

      * **`$` for Variables**: A dollar sign (`$`) followed by a variable name inserts the value of that variable.
      * **`$(...)` for Expressions**: A dollar sign followed by parentheses (`$(...)`) evaluates any Julia code within the parentheses and inserts the result.

  * **Performance**: String interpolation is extremely performant. Unlike manual string concatenation (e.g., `"a" * "b" * "c"`), which creates multiple intermediate strings, interpolation calculates the final size and builds the new string in a single, optimized operation. This is the preferred method for building strings from parts, especially in performance-sensitive code.

To run the script:

```shell
$ julia 0014_string_interpolation.jl
My name is Julia. I was released in 2012.
--------------------
It is now 2025, so I am 13 years old.
My current version is 1.1, and uppercase it is 1.1
```