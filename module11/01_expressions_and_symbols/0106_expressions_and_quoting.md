### `0106_expressions_and_quoting.jl`

```julia
# 0106_expressions_and_quoting.jl
# Introduces Expr, Symbol, and quoting: Code as Data.

# --- Quoting ---
println("--- Quoting Code ---")

# 1. The colon ':' followed by parentheses '(...)' or a 'begin...end' block
#    is the "quoting" syntax. It prevents execution and captures the
#    code structure as data.
ex1 = :(1 + 2 * 3)
ex2 = quote
    x = 10
    y = x + 5
end

println("Quoted expression 1: ", ex1)
println("Type of ex1: ", typeof(ex1)) # Expr

println("\nQuoted block expression 2: ")
println(ex2)
println("Type of ex2: ", typeof(ex2)) # Expr

# --- Expr: The Structure of Code ---
println("\n--- Inspecting Expr ---")

# 2. An 'Expr' object represents a piece of Julia code internally.
#    It has two main fields:
#    - 'head': A Symbol indicating the kind of expression (e.g., :call, :(=), :block).
#    - 'args': A Vector{Any} containing the parts (arguments) of the expression.

println("ex1.head: ", ex1.head) # :call (because '+' is a function call)
println("ex1.args: ", ex1.args) # [:+ (Symbol), 1 (Int), :(2 * 3) (Expr)]

# Accessing parts of the expression tree
operator = ex1.args[1]
arg1 = ex1.args[2]
sub_expression = ex1.args[3]

println("  Operator: ", operator, " (Type: ", typeof(operator), ")") # Symbol
println("  Argument 1: ", arg1, " (Type: ", typeof(arg1), ")")     # Int64
println("  Argument 2: ", sub_expression, " (Type: ", typeof(sub_expression), ")") # Expr

# Inspect the sub-expression
println("  Sub-expression head: ", sub_expression.head) # :call
println("  Sub-expression args: ", sub_expression.args) # [:*, 2, 3]

# Inspect the block expression
println("\nex2.head: ", ex2.head) # :block
println("ex2.args (lines/expressions in block): ")
for arg in ex2.args
    println("  ", arg, " (Type: ", typeof(arg), ")") # LineNumberNode or Expr
end

# --- Symbols ---
println("\n--- Symbols ---")

# 3. A 'Symbol' is an "interned string" used to represent identifiers
#    (variable names, function names, operators, keywords) in the code structure.
#    It's created with a colon ':'.
sym_var = :my_variable
sym_op = :+
sym_kw = :if

println("Symbol sym_var: ", sym_var)
println("Type of sym_var: ", typeof(sym_var)) # Symbol
# Symbols guarantee that identical names point to the same object (interning),
# making comparisons very fast (relevant from Module 3).

# --- Building Expressions Programmatically ---
println("\n--- Building Expressions ---")

# 4. You can construct Expr objects directly.
#    Expr(head::Symbol, args...)
ex_manual = Expr(:call, :*, :a, :b) # Equivalent to :(a * b)
ex_assign = Expr(:(=), :result, ex_manual) # Equivalent to :(result = a * b)

println("Manually built expression: ", ex_assign)

# --- Evaluating Expressions ---
println("\n--- Evaluating Expressions (eval) ---")

# 5. 'eval(expr)' takes an Expr object and executes it in the
#    *global scope* of the current module at *runtime*.
a = 5
b = 6
# 'result' does not exist yet.

println("Before eval: a=$a, b=$b")
# eval(ex_assign) will execute 'result = a * b'
eval(ex_assign)

# 'result' now exists as a global variable.
println("After eval: result=$result")

# 6. WARNING: 'eval' is generally SLOW and should be AVOIDED in
#    performance-critical code. It invokes the compiler at runtime
#    and operates on global variables. Macros and @generated functions
#    perform code generation at compile time.
```

-----

### Explanation

This script introduces the fundamental concepts underpinning Julia's metaprogramming capabilities: the ability to treat **code as data** using **`Expr`** objects, \*\*`Symbol`\*\*s, and the **quoting** syntax.

## Core Concept: Code as Data (`Expr`)

  * In Julia, code can be represented as a data structure *before* it's compiled or executed. The primary data structure for this is `Expr`.
  * **`Expr` Objects:** An `Expr` represents a compound piece of Julia syntax, like a function call, an assignment, a block of code, or a loop. It essentially represents a node in the code's **Abstract Syntax Tree (AST)**.
  * **Structure:** An `Expr` has two main components:
      * `.head`: A `Symbol` indicating the *type* of expression (e.g., `:call` for a function call, `:=` for assignment, `:block` for a sequence of statements, `:if` for an if-statement).
      * `.args`: A `Vector{Any}` containing the *parts* or arguments of the expression. These parts can be literal values (like `1`, `"hello"`), `Symbol`s, or even other nested `Expr` objects.

## Quoting (`:` or `quote ... end`)

  * **Purpose:** The quoting syntax (`:(...)` or `quote ... end`) is how you **capture** Julia code as an `Expr` data structure *without executing it*.
  * **Example:** `ex1 = :(1 + 2 * 3)` does not calculate `7`. It creates an `Expr` object representing the addition and multiplication operations. Inspecting `ex1.head` (`:call`) and `ex1.args` (`[:+, 1, :(2 * 3)]`) reveals this structure. The `:(2 * 3)` is itself a nested `Expr`.
  * **Blocks:** `quote ... end` is useful for capturing multi-line blocks of code. The resulting `Expr` typically has `.head == :block`, and its `.args` contain the individual expressions and line number information from the block.

## Symbols (`:name`)

  * **Purpose:** A `Symbol` is a special, **interned** string used primarily to represent **identifiers** (names) within code structures. Function names (`:+`, `:sin`), variable names (`:x`, `:my_variable`), keywords (`:if`, `:for`), and expression heads (`:call`, `:block`) are represented as `Symbol`s within an `Expr`.
  * **Interning:** "Interned" means that only one `Symbol` object exists for any given name. `:x === :x` is always true, and this comparison is as fast as comparing integers (relevant from Module 3 on Symbols vs. Strings). This makes them efficient keys for representing code structure.

## Building and Evaluating Expressions

  * **Programmatic Construction:** You can build `Expr` objects manually using `Expr(head, args...)`. This is what macros often do internally to construct the code they will return. `Expr(:(=), :result, Expr(:call, :*, :a, :b))` programmatically builds the AST for `result = a * b`.
  * **`eval(expr)`:** This function takes an `Expr` object and **executes** it within the **global scope** of the current module at **runtime**.
  * **`eval` Warning:** While useful for demonstration or interactive use, `eval` should generally be **avoided** in performance-sensitive code. It has significant overhead because:
    1.  It often involves invoking the compiler **at runtime**.
    2.  It operates in the **global scope**, which hinders compiler optimizations (due to potential type instability, as seen in Module 6).
  * **Metaprogramming Goal:** The goal of high-performance metaprogramming (using macros and generated functions) is to perform code generation and transformation **at compile time**, avoiding runtime `eval`.

Understanding `Expr`, `Symbol`, and quoting is the foundation for writing macros, which manipulate these code structures before compilation.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Metaprogramming", "Expressions":** Explains `Expr`, `Symbol`, quoting (`quote`), and `dump`.
      * **Julia Official Documentation, Manual, "Metaprogramming", "Eval":** Describes `eval` and its scope implications.

-----

To run the script:

```shell
$ julia 0106_expressions_and_quoting.jl
--- Quoting Code ---
Quoted expression 1: 1 + 2 * 3
Type of ex1: Expr

Quoted block expression 2:
quote
    #= ... =#
    x = 10
    #= ... =#
    y = x + 5
end
Type of ex2: Expr

--- Inspecting Expr ---
ex1.head: call
ex1.args: Any[:+, 1, :($(Expr(:call, :*, 2, 3)))]
  Operator: + (Type: Symbol)
  Argument 1: 1 (Type: Int64)
  Argument 2: 2 * 3 (Type: Expr)
  Sub-expression head: call
  Sub-expression args: Any[:*, 2, 3]

ex2.head: block
ex2.args (lines/expressions in block):
  LineNumberNode("...", :none) (Type: LineNumberNode)
  :($(Expr(:(=), :x, 10))) (Type: Expr)
  LineNumberNode("...", :none) (Type: LineNumberNode)
  :($(Expr(:(=), :y, Expr(:call, :+, :x, 5)))) (Type: Expr)

--- Symbols ---
Symbol sym_var: my_variable
Type of sym_var: Symbol

--- Building Expressions ---
Manually built expression: result = a * b

--- Evaluating Expressions (eval) ---
Before eval: a=5, b=6
After eval: result=30
```

*(LineNumberNode details and exact Expr printing might vary slightly.)*