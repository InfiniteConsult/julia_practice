### `0024_nested_loops.jl`

```julia
# 0024_nested_loops.jl

println("--- Demonstrating nested loops to create coordinate pairs ---")

# The outer loop iterates from 1 to 3
for i in 1:3
    # The inner loop iterates from 1 to 2
    for j in 1:2
        # This line is executed for every combination of i and j.
        println("Coordinate: (", i, ", ", j, ")")
    end
    # This line is executed after the inner loop completes for a given i.
    println("--- Inner loop finished for i = ", i, " ---")
end
```

### Explanation

This script shows a **nested loop**, where one loop is placed inside another.

  * **Execution Flow**: The inner loop (`for j in 1:2`) runs to completion for **each single iteration** of the outer loop (`for i in 1:3`).

    1.  The outer loop starts with `i = 1`.
    2.  The inner loop then runs completely for `j = 1` and `j = 2`.
    3.  The outer loop moves to `i = 2`.
    4.  The inner loop runs completely again for `j = 1` and `j = 2`.
    5.  This process repeats until the outer loop is finished.

  * **Compact Syntax**: Julia also offers a more compact syntax for nested loops, which is often more readable:

    ```julia
    for i in 1:3, j in 1:2
        println("Coordinate: (", i, ", ", j, ")")
    end
    ```

    This single loop header is equivalent to the two separate `for` blocks.

Nested loops are commonly used for tasks like iterating over 2D arrays (matrices), generating combinations, or creating coordinate grids.

To run the script:

```shell
$ julia 0024_nested_loops.jl
--- Demonstrating nested loops to create coordinate pairs ---
Coordinate: (1, 1)
Coordinate: (1, 2)
--- Inner loop finished for i = 1 ---
Coordinate: (2, 1)
Coordinate: (2, 2)
--- Inner loop finished for i = 2 ---
Coordinate: (3, 1)
Coordinate: (3, 2)
--- Inner loop finished for i = 3 ---
```