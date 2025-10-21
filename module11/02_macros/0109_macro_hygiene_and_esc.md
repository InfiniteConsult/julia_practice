### `0109_macro_hygiene_and_esc.jl`

```julia
# 0109_macro_hygiene_and_esc.jl
# Explains macro hygiene and how to bypass it with esc().

# --- Part 1: Hygienic Macro (Default Behavior) ---
println("--- Part 1: Hygienic Macro ---")

macro hygienic_example()
    # This macro defines a variable 'x' internally.
    # Due to hygiene, this 'x' will be automatically renamed
    # by the compiler to avoid collision with any 'x' outside the macro.
    println("  (Macro Expansion Time: Defining hygienic 'x')")
    return quote
        local x = "Value from Hygienic Macro" # Renamed internally (e.g., ##x#123)
        println("  Inside generated code (Runtime): Hygienic x = ", x)
    end
end

# Define a global 'x' in the calling scope.
x = "Value from Global Scope"
println("Before macro call: Global x = ", x)

# Call the macro. The 'x' inside the macro's generated code
# will NOT interfere with the global 'x'.
@hygienic_example()

println("After macro call: Global x = ", x) # Remains unchanged


# --- Part 2: Unhygienic Macro (Using esc()) ---
println("\n--- Part 2: Unhygienic Macro (using esc()) ---")

macro unhygienic_assignment(varname, value)
    # This macro *intends* to assign to a variable in the *caller's* scope.
    println("  (Macro Expansion Time: Assigning to caller's variable)")
    # 'esc(varname)' tells the hygiene system NOT to rename 'varname'.
    # It ensures the assignment targets the variable from the calling scope.
    # 'value' is interpolated as usual.
    return :($(esc(varname)) = $value)
end

# 'y' does not exist yet in global scope.
# The macro call will create and assign to the global 'y'.
@unhygienic_assignment(y, 123)
println("After macro call: Global y = ", y) # y now exists and is 123

# Modify an existing variable 'x' using the unhygienic macro.
@unhygienic_assignment(x, "Value assigned via unhygienic macro")
println("After macro call: Global x = ", x) # x has been changed


# --- Part 3: Hygienic Wrapping Macro (Common Pattern) ---
println("\n--- Part 3: Hygienic Wrapping Macro (@simple_time) ---")

# A macro to time an expression, using hygiene correctly.
macro simple_time(expression_to_run)
    # Variables defined *by the macro* should be hygienic (local).
    # The code *provided by the user* needs to run in the caller's scope.
    return quote
        local start_ns = time_ns()
        # 'esc(expression_to_run)' ensures the user's code runs
        # correctly in their scope, seeing their variables.
        local result = $(esc(expression_to_run))
        local end_ns = time_ns()
        local elapsed_ms = (end_ns - start_ns) / 1_000_000
        println("Expression `", $(string(expression_to_run)), "` executed in: ", round(elapsed_ms, digits=3), " ms")
        # Ensure the macro call evaluates to the result of the user's expression
        result
    end
end

# Use the timing macro
z = 50
timed_result = @simple_time begin
    sleep(0.05) # Simulate work
    z * 2       # Access local variable 'z'
end
println("Result of timed expression: ", timed_result) # Should be 100
# 'start_ns', 'result', 'end_ns', 'elapsed_ms' from the macro do not leak.

```

-----

### Explanation

This script delves into **macro hygiene**, a crucial feature that makes macros safer and easier to compose, and introduces `esc()` for intentionally bypassing hygiene when needed.

## Core Concept: Macro Hygiene

  * **The Problem:** Imagine macros didn't have hygiene. If a macro defined an internal variable `x`, and the code calling the macro also used a variable `x`, the macro's variable could accidentally overwrite or interfere with the user's variable, leading to chaos.
  * **Hygiene Solution:** Julia macros are **hygienic by default**. The compiler automatically and invisibly **renames** variables introduced *within* the macro's generated code.
      * In `@hygienic_example`, the `local x = ...` inside the `quote` block does not refer to the global `x`. The compiler effectively renames the macro's `x` to something unique (like `##x#123`), ensuring it cannot clash with any `x` in the scope where the macro is called.
      * This allows macro authors to use common variable names internally without fear of breaking the user's code.

## Bypassing Hygiene: `esc(expression)`

  * **The Need:** Sometimes, a macro *intentionally* needs to interact with or modify variables in the **calling scope**. Common examples include macros that perform assignments (like `@unhygienic_assignment`) or macros that need to evaluate user-provided code within the user's context (like `@simple_time`).
  * **`esc()` Function:** The `esc(expression)` function is used *inside* the macro's returned `quote` block. It marks `expression` (which must be an `Expr` or `Symbol`) as needing to **"escape"** the hygiene mechanism.
      * When the compiler sees `esc(varname)` during macro expansion, it **does not rename** `varname`. It leaves the symbol exactly as it appeared in the macro call.
      * In `@unhygienic_assignment(y, 123)`, the macro receives `varname = :y` and `value = 123`. The returned expression `:($(esc(varname)) = $value)` becomes `:(y = 123)`. Since `y` was escaped, this assignment refers to the variable `y` in the *caller's* scope (creating it if it doesn't exist).

## The Hygienic Wrapping Pattern (`@simple_time`)

  * **Combining Hygiene and Escape:** Many useful macros *wrap* user-provided code, adding some functionality before and/or after. The `@simple_time` macro is a classic example.
  * **Correct Implementation:**
    1.  **Macro Variables:** Variables needed *by the macro itself* (`start_ns`, `result`, `end_ns`, `elapsed_ms`) should be declared `local` within the returned `quote` block. They will remain hygienic and won't clash with user variables.
    2.  **User Expression:** The code provided *by the user* (`expression_to_run`) **must be escaped** (`$(esc(expression_to_run))`). This ensures that when the user's code (e.g., `sleep(0.05); z * 2`) runs, it does so in the *caller's* scope, where variables like `z` are correctly defined.
  * **Result:** The macro adds timing logic using safe, hygienic internal variables, while correctly executing the user's code in their own context. The macro call evaluates to the *result* of the user's code (`result`), making it composable.

Understanding hygiene and `esc` is essential for writing correct and robust macros that interact predictably with the code that calls them. Use hygiene by default; use `esc` deliberately and carefully when interaction with the caller's scope is intended.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Metaprogramming", "Hygiene":** Provides a detailed explanation of hygiene and the `esc` function with examples.

-----

To run the script:

```shell
$ julia 0109_macro_hygiene_and_esc.jl
--- Part 1: Hygienic Macro ---
Before macro call: Global x = Value from Global Scope
  (Macro Expansion Time: Defining hygienic 'x')
  Inside generated code (Runtime): Hygienic x = Value from Hygienic Macro
After macro call: Global x = Value from Global Scope

--- Part 2: Unhygienic Macro (using esc()) ---
  (Macro Expansion Time: Assigning to caller's variable)
After macro call: Global y = 123
  (Macro Expansion Time: Assigning to caller's variable)
After macro call: Global x = Value assigned via unhygienic macro

--- Part 3: Hygienic Wrapping Macro (@simple_time) ---
Expression `begin
    #= ... =#
    sleep(0.05)
    #= ... =#
    Main.z * 2
end` executed in: 5X.XXX ms # Actual time will vary slightly
Result of timed expression: 100

```

*(The expansion time messages appear during compilation/loading. Runtime messages appear during execution. The exact timing will vary.)*