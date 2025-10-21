### `0112_eval_and_world_age.md`

While Julia *can* execute code represented as data structures (`Expr`) at runtime using the `eval()` function, this approach is fundamentally different from compile-time metaprogramming (macros, `@generated` functions) and generally unsuitable for high-performance code. Understanding `eval`'s limitations and the related "world age" concept solidifies *why* compile-time code generation is preferred.

-----

## Runtime Code Execution: `eval()`

  * **What it does:** `eval(expression::Expr)` takes an `Expr` object and executes it as code within the **global scope** of the module where `eval` is called. It effectively invokes the Julia compiler and execution engine **at runtime**.
  * **Example:** `eval(:(x = 10 + 5))` compiles and runs `x = 15`, creating or modifying the global variable `x`.

-----

## Why `eval()` is Slow and Problematic for Performance

1.  **Runtime Compilation Overhead:** Every time `eval` is called with a new expression (or one that hasn't been cached), it must invoke the Julia compiler (type inference, optimization, machine code generation). This is a significant overhead compared to executing already-compiled code.
2.  **Global Scope:** `eval` operates in the global scope. As established in Module 6, code relying heavily on **non-constant global variables** is inherently **type-unstable** and slow because the compiler cannot specialize code effectively. `eval` compounds this problem by both reading *and potentially defining* global variables dynamically.
3.  **Type Instability:** Because `eval` runs arbitrary code at runtime, the compiler usually cannot predict the type of the value returned by `eval`, leading to type instability in the code that uses the result.

-----

## The "World Age" Problem

This is a subtle but important concept related to Julia's JIT compilation and method dispatch, which particularly affects runtime `eval`.

  * **Compilation and World Age:** Julia compiles functions *just-in-time*. When a function is compiled, it "knows about" all the methods and global variables that exist at that specific moment (its "world age"). Julia maintains a global counter for this "world age," incrementing it whenever a new method is defined or a relevant global changes.
  * **The Rule:** A function running in an older "world" **cannot call** methods defined in a newer "world." This prevents inconsistencies during dynamic code updates.
  * **`eval` Creates a New World:** When `eval` defines a new function or method at runtime, it **increments the world age counter**.
  * **The Conflict:** If you call `eval` *inside* a function `f` to define a new function `g`, and then immediately try to call `g()` from within that *same* execution of `f`, you will likely get a `MethodError`. Why? Because `f` was compiled in an older world age and doesn't "see" the `g` function that `eval` just created in the newer world.
  * **Example:**
    ```julia
    function run_eval()
        println("Current world: ", Base.get_world_counter())
        eval(:(function my_new_func() println("Hello from new func!") end))
        println("World after eval: ", Base.get_world_counter()) # Incremented!
        try
            my_new_func() # Error! run_eval() lives in the older world.
        catch e
            println("Caught Error: ", e)
        end
    end
    # run_eval() # This would error inside
    ```

-----

## `Base.invokelatest()`: The Slow Workaround

  * **Purpose:** `Base.invokelatest(f, args...)` is designed specifically to overcome the world age problem for **interactive use** (like the REPL).
  * **How it Works:** It explicitly tells Julia: "Look up the *absolute newest* definition of function `f` (in the latest world age) and call it with `args`, even if my current function doesn't know about it yet."
  * **Performance:** `invokelatest` is **extremely slow** and **type-unstable** by design. It involves runtime method lookups and cannot be optimized by the compiler. It completely defeats the purpose of Julia's JIT specialization.
  * **Guideline:** `invokelatest` is a tool for REPLs, debuggers, and interactive widgets. It should **never** appear in performance-critical code.

-----

## Conclusion: Compile-Time Metaprogramming is Key

  * `eval` and `invokelatest` are for **runtime flexibility**, primarily in interactive contexts. They come at a significant performance cost.
  * High-performance code generation in Julia relies on **compile-time metaprogramming**:
      * **Macros (`@macro`)**: Transform **syntax** at parse time.
      * **Generated Functions (`@generated`)**: Generate specialized code based on **types** at compile time.
  * These tools allow you to perform complex code generation and optimization *before* runtime, leveraging Julia's JIT compiler to produce efficient, specialized machine code, thus achieving true zero-cost abstractions. If you feel the need to use `eval` within a performance-sensitive function, it's almost always a sign that a macro or `@generated` function is the more appropriate (and faster) solution.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Metaprogramming", "Eval":** Describes `eval` and its global scope behavior.
      * **Julia Official Documentation, Manual, "Calling C and Fortran Code" / "Embedding Julia" / `devdocs`:** Discussions of the "world age counter" often appear in advanced sections related to compilation and runtime interaction.
      * **Julia Official Documentation, Base Documentation, `Base.invokelatest`:** Explains its purpose for calling functions defined after the caller was compiled. Explicitly notes performance implications.