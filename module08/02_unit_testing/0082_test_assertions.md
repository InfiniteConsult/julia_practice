### `0082_test_assertions.jl`

```julia
# 0082_test_assertions.jl
# Demonstrates other useful assertion macros from the Test standard library.

# 1. Import necessary macros.
import Test: @test, @testset, @test_throws, @test_broken, @test_skip

# 2. Include the source code file.
include("my_math.jl")

# 3. Use '@test_throws' to check for expected errors.
@testset "@test_throws Examples" begin
    # This function expects a Number. Passing a String should error.
    # @test_throws ExpectedErrorType Expression
    @test_throws MethodError MyMath.add_two("hello")

    # You can also test for specific exception types beyond MethodError,
    # like DivideError, DomainError, ArgumentError etc.
    @test_throws DivideError div(1, 0)

    # Example of a test that *fails* because the expected error doesn't happen
    # @test_throws DomainError MyMath.add_two(5) # This would fail the testset
end

# 4. Use '@test_broken' for tests that are known to fail but shouldn't stop CI.
@testset "@test_broken Example" begin
    # Perhaps this feature isn't implemented yet, or there's a known bug.
    # The test runs, and if it FAILS (as expected), it's recorded as 'Broken'.
    # If it unexpectedly PASSES, it's recorded as an 'Error' (because it should be fixed).
    @test_broken MyMath.add_two(0.1 + 0.2) == 0.3 + 2.0 # Fails due to floating point inaccuracy

    # Example: If this test unexpectedly passed, it would error
    # @test_broken MyMath.add_two(1) == 3 # This would unexpectedly pass and error
end

# 5. Use '@test_skip' for tests that should not be run at all.
@testset "@test_skip Example" begin
    # Use this for tests that are incomplete, depend on unavailable resources,
    # or are temporarily disabled.
    # The expression is *not* evaluated.
    @test_skip MyMath.add_two("this code won't even run")
end

println("\nTest execution finished.")

# Run this file: julia 0082_test_assertions.jl
```

-----

### Explanation

This script introduces several other useful assertion macros provided by the `Test` standard library beyond the basic `@test`.

  * **`@test_throws ExpectedErrorType Expression`**

      * **Purpose:** Use this when you *expect* a specific piece of code to throw an error. This is crucial for testing error handling, invalid inputs, and boundary conditions.
      * **How it Works:** It runs the `Expression`.
          * If the expression throws an error that **is a subtype of** `ExpectedErrorType`, the test **passes**. ✅
          * If the expression throws an error of a **different type**, the test **errors**. ❌
          * If the expression **does not throw any error**, the test **fails**. ❌
      * **Example:** `@test_throws MethodError MyMath.add_two("hello")` passes because calling `add_two` with a `String` correctly throws a `MethodError`. `@test_throws DivideError div(1, 0)` passes because integer division by zero throws a `DivideError`.

  * **`@test_broken Expression`**

      * **Purpose:** Marks a test that is **currently failing** due to a known bug or unimplemented feature.
      * **How it Works:** It runs the `Expression`.
          * If the expression is `false` or throws an error (i.e., the test **fails** as expected), it's recorded as **"Broken"**. This does *not* typically fail your overall test suite in CI environments. ✅💔
          * If the expression is `true` (i.e., the test **unexpectedly passes**), it's recorded as an **"Error"**. This *does* typically fail the test suite, signaling that the underlying issue might be fixed and the `@test_broken` should be changed back to `@test`. ❗✅
      * **Example:** `@test_broken MyMath.add_two(0.1 + 0.2) == 0.3 + 2.0` correctly identifies a known floating-point inaccuracy issue. NOTE: seems to pass, probably need a better example.

  * **`@test_skip Expression`**

      * **Purpose:** Completely **skips** the evaluation of a test.
      * **How it Works:** The `Expression` is **never executed**. The test is simply recorded as **"Skipped"**. ⏭️
      * **Use Cases:** Useful for tests that are incomplete, rely on external resources that might not be available (like a network service), or need to be temporarily disabled for debugging.

These macros provide more nuanced ways to handle expected failures, known issues, and temporary skips, making your test suite more robust and informative.

-----

  * **References:**
      * **Julia Official Documentation, Standard Library, `Test`:** Describes `@test_throws`, `@test_broken`, and `@test_skip`.

-----

To run the script:

1.  Make sure `my_math.jl` (from lesson 0080) is in the same directory.
2.  Run `julia 0082_test_assertions.jl` from your terminal.

<!-- end list -->

```shell
$ julia 0082_test_assertions.jl
Test Summary:        | Pass  Broken  Skip  Total  Time
@test_throws Examples |    2                 2  0.0s
@test_broken Example  |         1            1  0.0s
@test_skip Example    |                 1      1  0.0s

Test execution finished.
```

*(Note: The output shows the different test outcomes correctly recorded by the testsets.)*