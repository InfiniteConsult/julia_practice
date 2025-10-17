### `0023_loop_control.jl`

```julia
# 0023_loop_control.jl

println("--- Using 'continue' and 'break' in a loop from 1 to 10 ---")

for i in 1:10
    # If i is 3, skip the rest of this iteration and start the next one.
    if i == 3
        println("Skipping 3 with 'continue'...")
        continue
    end

    # If i is 8, terminate the loop completely.
    if i == 8
        println("Exiting loop at 8 with 'break'...")
        break
    end

    println("Processing number: ", i)
end

println("Loop finished.")
```

-----

### Explanation

This script demonstrates the two essential keywords for controlling the flow of a loop: `continue` and `break`. Their behavior is identical to their counterparts in C, C++, Rust, and Python.

  * **`continue`**: This keyword immediately stops the current iteration of the loop. The program "skips" the rest of the code in the loop's body for the current element and moves on to the next one. In the example, when `i` is 3, the `println("Processing...")` line is never reached.

  * **`break`**: This keyword immediately terminates the innermost loop it is in. Execution jumps to the first line of code after the loop's `end` block. In the example, once `i` reaches 8, the loop stops entirely, and numbers 9 and 10 are never processed.

These keywords are fundamental tools for handling special cases or termination conditions within an iterative process.

To run the script:

```shell
$ julia 0023_loop_control.jl
--- Using 'continue' and 'break' in a loop from 1 to 10 ---
Processing number: 1
Processing number: 2
Skipping 3 with 'continue'...
Processing number: 4
Processing number: 5
Processing number: 6
Processing number: 7
Exiting loop at 8 with 'break'...
Loop finished.
```