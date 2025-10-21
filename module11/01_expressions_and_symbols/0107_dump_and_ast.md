### `0107_dump_and_ast.jl`

```julia
# 0107_dump_and_ast.jl
# Using dump() to inspect the structure of Expr objects (AST).

# 1. Basic arithmetic expression
println("--- dump(:(1 + 2 * 3)) ---")
# Quoting captures the code as an Expr object.
ex1 = :(1 + 2 * 3)
# dump() provides a detailed, recursive view of the object's structure.
dump(ex1)

println("\n" * "-"^30 * "\n") # Separator

# 2. Function call expression
println("--- dump(:(println(\"Hello \", name))) ---")
ex2 = :(println("Hello ", name))
dump(ex2)

println("\n" * "-"^30 * "\n")

# 3. Assignment expression with array indexing
println("--- dump(:(results[i] = compute(data[i]))) ---")
ex3 = :(results[i] = compute(data[i]))
dump(ex3)

println("\n" * "-"^30 * "\n")

# 4. Block expression (e.g., from 'begin...end' or multi-line quote)
println("--- dump(quote ... end) ---")
ex4 = quote
    x = 10
    if x > 5
        println("Greater")
    end
end
dump(ex4)
```

-----

### Explanation

This script introduces the **`dump()`** function, an indispensable tool for metaprogramming in Julia. It allows you to visualize the detailed internal structure of any Julia object, and it's particularly useful for understanding the **Abstract Syntax Tree (AST)** represented by **`Expr`** objects.

## Core Concept: Visualizing the AST

  * **`Expr` Review:** As seen in the previous lesson, Julia code captured by quoting (`:` or `quote...end`) is stored as nested `Expr` objects. An `Expr` has a `.head` (a `Symbol` indicating the operation type) and `.args` (a `Vector{Any}` containing the parts).
  * **`dump(object)`:** This built-in function provides a **recursive, indented printout** of the structure and fields of any Julia object. When applied to an `Expr`, it reveals the entire tree structure of the captured code.
  * **Why Use `dump()`?** When writing macros (which receive `Expr` objects as input), you *need* to know the exact structure of the code you are receiving to correctly transform it. `dump()` is your primary tool for inspecting these input expressions during macro development and debugging.

## Analyzing the Output

Let's examine the `dump` output for each example:

1.  **`dump(:(1 + 2 * 3))`**

      * Shows the top-level `Expr` with `head: call` and `args: [+, 1, Expr]`. This confirms that `1 + ...` is treated as a function call to `+`.
      * Recursively shows the nested `Expr` for `2 * 3` also having `head: call` and `args: [*, 2, 3]`.
      * This reveals the **operator precedence** and nesting captured in the AST.

2.  **`dump(:(println("Hello ", name)))`**

      * `head: call`.
      * `args: [println (GlobalRef), "Hello " (String), name (Symbol)]`.
      * Illustrates how function names (`println`), literal strings, and variable names (`name`, represented as a `Symbol`) appear within the `.args` list.

3.  **`dump(:(results[i] = compute(data[i])))`**

      * Top-level `head: =` (assignment).
      * `args[1]` is an `Expr` representing the left-hand side `results[i]`, with `head: ref` (array reference/indexing) and `args: [results, i]`.
      * `args[2]` is an `Expr` representing the right-hand side `compute(data[i])`, with `head: call` and `args: [compute, Expr]`, where the nested `Expr` is for `data[i]` (`head: ref`, `args: [data, i]`).
      * Shows how complex statements involving assignments, function calls, and indexing are represented as nested trees.

4.  **`dump(quote ... end)`**

      * Top-level `head: block`.
      * `args` contains a sequence of items representing the lines within the block, often alternating between `LineNumberNode` (for debugging info) and `Expr` objects for each actual statement (like the assignment `x = 10` (`head: =`) and the `if` statement (`head: if`)).
      * Shows the structure for multi-line code blocks.

By using `dump()`, you gain a precise understanding of how Julia represents syntax internally. This knowledge is crucial before attempting to write macros that manipulate or generate code effectively.

-----

  * **References:**
      * **Julia Official Documentation, Base Documentation, `dump`:** "Show every part of the representation of a value."
      * **Julia Official Documentation, Manual, "Metaprogramming", "Expressions":** Describes the `Expr` structure that `dump` visualizes.

-----

To run the script:

```shell
$ julia 0107_dump_and_ast.jl
--- dump(:(1 + 2 * 3)) ---
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol +
    2: Int64 1
    3: Expr
      head: Symbol call
      args: Array{Any}((3,))
        1: Symbol *
        2: Int64 2
        3: Int64 3

------------------------------

--- dump(:(println("Hello ", name))) ---
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol println
    2: String "Hello "
    3: Symbol name

------------------------------

--- dump(:(results[i] = compute(data[i]))) ---
Expr
  head: Symbol =
  args: Array{Any}((2,))
    1: Expr
      head: Symbol ref
      args: Array{Any}((2,))
        1: Symbol results
        2: Symbol i
    2: Expr
      head: Symbol call
      args: Array{Any}((2,))
        1: Symbol compute
        2: Expr
          head: Symbol ref
          args: Array{Any}((2,))
            1: Symbol data
            2: Symbol i

------------------------------

--- dump(quote ... end) ---
Expr
  head: Symbol block
  args: Array{Any}((3,))
    1: LineNumberNode
      line: Int64 36
      file: Symbol ## path to file ##
    2: Expr
      head: Symbol =
      args: Array{Any}((2,))
        1: Symbol x
        2: Int64 10
    3: Expr
      head: Symbol if
      args: Array{Any}((2,))
        1: Expr
          head: Symbol call
          args: Array{Any}((3,))
            1: Symbol >
            2: Symbol x
            3: Int64 5
        2: Expr
          head: Symbol block
          args: Array{Any}((2,))
            1: LineNumberNode
              line: Int64 38
              file: Symbol ## path to file ##
            2: Expr
              head: Symbol call
              args: Array{Any}((2,))
                1: Symbol println
                2: String "Greater"

```

*(File paths and line numbers in the output will vary.)*