### `0081_testset_test.jl`

```julia
# 0081_testset_test.jl
# Demonstrates using @testset for better test organization.

# 1. Import macros from the 'Test' library.
#    We now import '@testset' in addition to '@test'.
import Test: @test, @testset

# 2. Include the source code file we want to test.
include("my_math.jl")

# 3. Use '@testset' to group related tests.
#    The string argument provides a descriptive name for the group.
@testset "MyMath.add_two Tests" begin
    # 4. Place individual '@test' calls inside the 'begin...end' block.
    @test MyMath.add_two(3) == 5
    @test MyMath.add_two(0) == 2
    @test MyMath.add_two(-5) == -3

    # 5. Testsets can be nested for further organization.
    @testset "Floating Point Tests" begin
        # Use '≈' (\approx<tab>) for approximate floating-point comparison.
        @test MyMath.add_two(1.5) ≈ 3.5
        @test MyMath.add_two(-0.5) ≈ 1.5
    end

    # 6. Include a failing test to see the output.
    @testset "Failing Test Example" begin
        @test MyMath.add_two(10) == 11 # This will fail
    end
end # End of "MyMath.add_two Tests" testset

println("\nTest execution finished.")

# Run this file: julia 0081_testset_test.jl
```

-----

### Explanation

This script introduces the **`@testset`** macro, which is the standard and highly recommended way to **organize** tests and get **summarized results**.

## `  @testset `

  * **Grouping Tests:** `@testset "Description" begin ... end` groups related `@test` calls under a descriptive name. This makes it much easier to understand the structure of your test suite. You can **nest testsets** to create hierarchical organization (e.g., grouping all tests for a module, then sub-groups for each function).
  * **Summarized Output:** This is the primary benefit. Instead of just running silently on success, `@testset` **counts** the number of passing and failing tests within it. At the end of the testset, it prints a **summary** line. If all tests within the set pass, it prints a concise "Pass" summary. If any test fails, it prints the details of the failure *and* a summary indicating how many passed and failed. This makes it much easier to quickly see the overall status of your tests.
  * **Failure Isolation (Default):** By default, if one `@test` within a `@testset` fails, the testset records the failure but **continues executing** the remaining tests within that set. This helps you see *all* failures in a group at once, rather than stopping at the first one. (This behavior can be changed with options if needed).
  * **Floating-Point Comparison (`≈`):** When testing floating-point numbers, direct equality (`==`) is often unreliable due to tiny precision errors. The `Test` library automatically loads the `isapprox` function (aliased as `≈`, typed `\approx<tab>`). Using `@test a ≈ b` checks if `a` and `b` are approximately equal within a default tolerance, which is the correct way to compare floats.

Using `@testset` transforms your tests from simple assertion scripts into a structured, informative test suite, which is essential for maintaining larger projects.

-----

  * **References:**
      * **Julia Official Documentation, Standard Library, `Test`, "Organizing Tests":** Explains `@testset` and its benefits.
      * **Julia Official Documentation, Standard Library, `Test`, "Testing Floating Point Numbers":** Recommends using `isapprox` or `≈`.

-----

To run the script:

1.  Make sure `my_math.jl` (from lesson 0080) is in the same directory.
2.  Run `julia 0081_testset_test.jl` from your terminal.

<!-- end list -->

```shell
$ julia 0081_testset_test.jl
Test Summary:           | Pass  Fail  Total  Time
MyMath.add_two Tests    |    5     1      6  0.0s
  Floating Point Tests  |    2            2  0.0s
  Failing Test Example  |          1      1  0.0s
    Test Failed at 0081_testset_test.jl:30
      Expression: MyMath.add_two(10) == 11
       Evaluated: 12 == 11
```

*(Note: The exact time will vary. The output clearly shows the nested structure, the failure details, and the final summary.)*

```shell

Test execution finished.
```