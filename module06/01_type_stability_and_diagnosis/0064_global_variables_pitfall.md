### `0064_global_variable_pitfall.jl`

```julia
# 0064_global_variable_pitfall.jl
import InteractiveUtils: @code_warntype

# --- Case 1: Non-Constant Global ---

# 1. Define a global variable WITHOUT 'const'.
# Its type can change at any time.
non_const_global = 100

# 2. Define a function that uses the non-constant global.
function use_non_const_global()
    # The compiler cannot know the type of 'non_const_global'.
    # It might be an Int, or it might change to a String later.
    return non_const_global * 2
end

# --- Case 2: Constant Global ---

# 3. Define a global variable WITH 'const'.
# This is a promise to the compiler: the *type* of this
# variable will NEVER change (though its value can if mutable).
const const_global = 200

# 4. Define a function that uses the constant global.
function use_const_global()
    # The compiler knows 'const_global' will always be an Int.
    # It can generate specialized, fast code.
    return const_global * 2
end

# --- Analysis ---
function analyze_globals()
    println("--- @code_warntype for use_non_const_global() ---")
    # This will show type instability (Body::Any or similar).
    @code_warntype use_non_const_global()

    println("\n--- @code_warntype for use_const_global() ---")
    # This will show type stability (Body::Int64).
    @code_warntype use_const_global()

    # Demonstrate that the functions work at runtime
    println("\n--- Runtime Results ---")
    res_non_const = use_non_const_global()
    println("Result (non-const global): ", res_non_const)

    # We can even change the non-const global's type (bad practice!)
    global non_const_global = "Changed!"
    println("Non-const global changed to: ", non_const_global)
    # Calling the function again would now error at runtime

    res_const = use_const_global()
    println("Result (const global): ", res_const)

    # Attempting to change the type of a const global errors
    try
        global const_global = "Cannot do this"
    catch e
        println("Caught expected error trying to change const global type: ", e)
    end
end

analyze_globals()
```

### Explanation

This script revisits a critical performance pitfall: accessing **non-constant global variables** from within functions. It demonstrates why this leads to type instability and how the `const` keyword solves the problem.

  * **The Problem: Non-`const` Globals**

      * When you define a global variable like `non_const_global = 100`, you are telling the compiler very little. The type of this variable could change at *any moment* during the program's execution (as shown when we reassign it to a `String`).
      * Inside the function `use_non_const_global()`, when the compiler sees `non_const_global * 2`, it has **no way to know** what type `non_const_global` will have *at runtime*. It cannot specialize the code. It must generate slow, generic code that:
        1.  Looks up the current value and type of `non_const_global` **at runtime**.
        2.  Performs **dynamic dispatch** to find the correct `*` method for whatever type it found.

  * **Diagnosis with `@code_warntype`:**

      * Running `@code_warntype use_non_const_global()` confirms this instability. The output will show `Body::Any` (or some other non-concrete type, often in red). This is the compiler telling you it cannot predict the return type because it depends on the unpredictable type of the global variable.

  * **The Solution: `const` Globals**

      * The `const const_global = 200` declaration is a **promise** to the compiler: "The *type* of `const_global` will *always* be `Int64`." (Note: If `const_global` was a mutable object like a `Vector`, its *contents* could still change, but it would always *refer* to that same `Vector`).
      * Inside `use_const_global()`, the compiler now **knows for certain** that `const_global` is an `Int64`. It can generate fast, specialized machine code that directly multiplies two integers.

  * **Diagnosis with `@code_warntype`:**

      * Running `@code_warntype use_const_global()` shows the fix. The output will be `Body::Int64` (green). The compiler is confident about the return type because the global's type is guaranteed.

  * **Rule of Thumb:** **Always** declare global variables used in performance-critical code as `const`. If you need a global whose *type* might change, reconsider your design – perhaps pass it as a function argument instead. Accessing non-`const` globals is one of the most common and easily fixed sources of poor performance in Julia.

  * **References:**

      * **Julia Official Documentation, Manual, "Performance Tips":** "Avoid global variables." and "Declare variables as constant." These sections explicitly warn about the performance cost and recommend `const`.

To run the script:

*(Note: The exact output is verbose. Focus on the `Body::` lines.)*

```shell
$ julia 0064_global_variable_pitfall.jl
--- @code_warntype for use_non_const_global() ---
Variables
  #self#::Core.Const(use_non_const_global)
Body::Any # <--- Warning! Instability from non-const global
[...]

--- @code_warntype for use_const_global() ---
Variables
  #self#::Core.Const(use_const_global)
Body::Int64 # <--- Good! Type stable due to const global
[...]

--- Runtime Results ---
Result (non-const global): 200
Non-const global changed to: Changed!
Result (const global): 400
Caught expected error trying to change const global type: [...] invalid redefinition of constant const_global
```