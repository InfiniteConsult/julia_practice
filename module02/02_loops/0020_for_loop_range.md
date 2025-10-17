### `0020_for_loop_range.jl`

```julia
# 0020_for_loop_range.jl

println("--- Iterating from 1 to 5 ---")
# The expression '1:5' creates a UnitRange object.
for i in 1:5
    println("Current value of i is: ", i)
end

println("\n--- Iterating with a step ---")
# The expression '2:2:10' creates a StepRange object.
for j in 2:2:10
    println("Current value of j is: ", j)
end
```

### Explanation

This script introduces the `for` loop, Julia's primary construct for iteration.

  * **Syntax**: The basic structure is `for <variable> in <iterable> ... end`. The code inside the loop is executed for each element in the `<iterable>`.

  * **Ranges**:

      * **`UnitRange` (`start:stop`)**: The expression `1:5` creates a `UnitRange`, which is a lightweight object that represents the sequence of integers from 1 to 5. It is **performant** because it doesn't actually allocate memory to store all the numbers; it just tracks the start and end points.
      * **`StepRange` (`start:step:stop`)**: The expression `2:2:10` creates a `StepRange`, representing the sequence starting at 2, incrementing by 2, up to 10. This is also a very efficient object.

This is the direct equivalent of `for (int i = 1; i <= 5; ++i)` in C/C++/Rust or `for i in range(1, 6)` in Python.

To run the script:

```shell
$ julia 0020_for_loop_range.jl
--- Iterating from 1 to 5 ---
Current value of i is: 1
Current value of i is: 2
Current value of i is: 3
Current value of i is: 4
Current value of i is: 5

--- Iterating with a step ---
Current value of j is: 2
Current value of j is: 4
Current value of j is: 6
Current value of j is: 8
Current value of j is: 10
```