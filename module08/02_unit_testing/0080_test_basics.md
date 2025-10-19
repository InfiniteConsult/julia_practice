### `0080_test_basics.jl`

*This lesson requires creating **two** files: the code to be tested (`my_math.jl`) and the test script itself (`run_tests.jl`).*

-----

#### File 1: `my_math.jl`

```julia
# my_math.jl
# Contains the function(s) we want to test.

# (We define it inside a module for good practice, though not strictly required)
module MyMath

# Function to test: adds 2 to its input
function add_two(x)
    return x + 2
end

end # module MyMath
```

-----

#### File 2: `run_tests.jl`

```julia
# run_tests.jl
# Contains the tests for the code in my_math.jl

# 1. Import the '@test' macro from the standard 'Test' library.
#    'Test' is always available, no need to add it via Pkg.
import Test: @test

# 2. Include the source code file we want to test.
#    This executes 'my_math.jl', defining the 'MyMath' module.
include("my_math.jl")

# 3. Write a basic test using the '@test' macro.
#    '@test' evaluates the expression that follows it.
#    - If the expression is 'true', the test passes (silently by default).
#    - If the expression is 'false', the test fails (prints an error).
#    - If the expression throws an error, the test errors.
println("Running basic tests...")

# Test case 1: Check if adding 2 to 3 gives 5.
@test MyMath.add_two(3) == 5

# Test case 2: Check if adding 2 to 0 gives 2.
@test MyMath.add_two(0) == 2

# Test case 3: A failing test (uncomment to see failure)
# println("\nRunning a failing test...")
# @test MyMath.add_two(1) == 4 # This will fail

println("\nBasic tests finished.")

# You run this file from the command line: julia run_tests.jl
```

-----

### Explanation

This script introduces the built-in **`Test` standard library**, which is Julia's primary tool for writing **unit tests**. Unit tests are small, automated checks that verify the correctness of individual pieces of code (like functions).

  * **Core Concept:** Testing is fundamental to writing reliable software. The `Test` library provides macros and functions to make writing and running these checks easy.

  * **Structure: Code File vs. Test File**

      * It's standard practice to keep your main application code (e.g., `my_math.jl`) separate from your test code (e.g., `run_tests.jl`).
      * The test file uses `include("my_math.jl")` to load the code it needs to test. This ensures the tests run against the actual source code.

  * **The `@test` Macro:**

      * This is the most basic assertion tool. You wrap a boolean expression inside `@test`.
      * `@test MyMath.add_two(3) == 5`: This checks if the result of calling `MyMath.add_two(3)` is equal (`==`) to `5`.
      * **Pass:** If the expression evaluates to `true`, the test passes. By default, passing tests don't print anything to keep output clean.
      * **Fail:** If the expression evaluates to `false` (like in the commented-out example where `1 + 2 == 4` is false), the `@test` macro prints a detailed failure message, including the expression, the expected value, and the actual result.
      * **Error:** If evaluating the expression *itself* throws an error (e.g., if `add_two` was called with a `String`), the test errors and prints the exception.

  * **Running Tests:** You typically run your test suite by executing the test script directly from the terminal: `julia run_tests.jl`. A clean run (no output other than your `println` statements) means all tests passed.

  * **Why Test?** Automated tests catch regressions (when a change breaks existing functionality), document how code is supposed to work, and give you confidence to refactor and improve your code base.

  * **References:**

      * **Julia Official Documentation, Standard Library, `Test`:** Complete guide to the testing framework.

To run the script:

1.  Save the first code block as `my_math.jl`.
2.  Save the second code block as `run_tests.jl` in the *same directory*.
3.  Run `julia run_tests.jl` from your terminal.

<!-- end list -->

```shell
$ julia run_tests.jl
Running basic tests...

Basic tests finished.
```

*(If you uncomment the failing test, you will see detailed failure output.)*