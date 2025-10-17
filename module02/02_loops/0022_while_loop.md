### `0022_while_loop.jl`

```julia
# 0022_while_loop.jl

println("--- Countdown from 5 using a while loop ---")

# Initialize a counter variable outside the loop
n = 5

# The loop will continue as long as n is greater than 0
while n > 0
    println("Current value of n is: ", n)
    # It is crucial to update the condition variable inside the loop
    global n -= 1
end

println("Blast off!")
```

-----

### Explanation

This script demonstrates the `while` loop, which executes a block of code repeatedly as long as a specified condition remains true.

  * **Syntax**: The structure is `while <condition> ... end`.

  * **Execution Flow**: Before each iteration, the `<condition>` is evaluated. If it's `true`, the body of the loop is executed. If it's `false`, the loop terminates, and execution continues after the `end` keyword.

  * **Loop Variable**: It's the programmer's responsibility to ensure the condition eventually becomes false. In this example, `n -= 1` decrements the counter in each iteration. Forgetting this line would result in an infinite loop, as `n` would always be `5`.

  * **`global` Keyword**: Just like in the `for` loop example, because we are modifying a global variable `n` from within the "soft scope" of the `while` loop, we must use `global n -= 1` to explicitly state our intent to modify the global variable.

`while` loops are best used when the number of iterations isn't known beforehand and depends on a state that changes within the loop.

To run the script:

```shell
$ julia 0022_while_loop.jl
--- Countdown from 5 using a while loop ---
Current value of n is: 5
Current value of n is: 4
Current value of n is: 3
Current value of n is: 2
Current value of n is: 1
Blast off!
```