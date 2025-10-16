### `0005_unicode_names.jl`

```julia
# 0005_unicode_names.jl

# Standard variable names work as expected
radius = 5

# Julia allows many Unicode characters, like Greek letters, in variable names
π = 3.14159
δ = 0.01

# These variables can be used in calculations just like any other
circumference = 2 * π * radius
area = π * radius^2

println("Radius (r): ", radius)
println("Pi (π): ", π)
println("Delta (δ): ", δ)
println("-"^20)
println("Calculated Circumference: ", circumference)
println("Calculated Area: ", area)
```

### Explanation

This script demonstrates a unique and powerful feature of Julia: its first-class support for Unicode in variable names.

  * **Unicode Identifiers**: You can use a vast array of Unicode characters, including most mathematical symbols and Greek letters, as valid variable names. This allows your code to more closely resemble the mathematical formulas it represents, which can significantly improve readability in scientific and technical domains.

  * **How to Type Them**: In the Julia REPL and many code editors (like VS Code with the Julia extension), you can type these symbols using their LaTeX names followed by the `Tab` key.

      * To get `π`, type `\pi` and then press `Tab`.
      * To get `δ`, type `\delta` and then press `Tab`.

This feature is not just cosmetic; it's a fundamental part of the language that encourages writing clear, descriptive, and notationally familiar code.

To run the script:

```shell
$ julia 0005_unicode_names.jl
Radius (r): 5
Pi (π): 3.14159
Delta (δ): 0.01
--------------------
Calculated Circumference: 31.4159
Calculated Area: 78.53975
```