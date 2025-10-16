### `0015_string_concatenation.jl`

```julia
# 0015_string_concatenation.jl

# The '*' operator is used for simple string concatenation.
str1 = "Hello"
str2 = "World"
combined = str1 * ", " * str2 * "!"
println("Concatenated with '*': ", combined)

println("-"^20)

# --- Performance Demonstration ---

# Method 1: Inefficiently building a string in a loop with '*'.
# This is slow because it creates a new string in every iteration.
parts = ["a", "b", "c", "d", "e"]
s_slow = ""
for part in parts
    global s_slow  # Super important because for loop is a "soft scope".
                   # Without declaring the global Julia tries to create a local.
    s_slow *= part
end
println("Result from slow loop: ", s_slow)


# Method 2: The performant and idiomatic way using 'join()'.
# This calculates the final size once and builds the string efficiently.
s_fast = join(parts)
println("Result from fast join: ", s_fast)
```

-----

### Explanation

This script demonstrates how to join strings and highlights the critical performance difference between concatenation in a loop and using the `join()` function.

  * **`*` Operator**: For joining a small, fixed number of strings, the `*` operator is a perfectly readable and acceptable choice. `str1 * str2` creates a new string containing the contents of `str1` followed by `str2`.

### Performance in Loops ❗

This is a crucial performance concept that translates directly from languages like Python.

  * **Inefficient Loop (`*=`):** When you use `s_slow *= part` inside a loop, you are not modifying the string `s_slow`. Because strings are immutable, Julia must allocate a **brand new string** that is large enough to hold the old `s_slow` plus the new `part`, copy the contents of both into it, and then reassign the name `s_slow` to this new string. In a loop with many iterations, this results in excessive memory allocations and copying, leading to very poor performance.

  * **Performant `join()`:** The `join()` function is the correct and idiomatic way to combine a collection of strings. It first iterates through the collection to calculate the total size of the final string. Then, it allocates a single block of memory of the correct size and copies each part into it just once. This "calculate-then-allocate" strategy avoids creating many intermediate strings and is dramatically faster.

**Rule of Thumb**: Always use `join()` when combining a variable number of strings, especially from within a loop.

To run the script:

```shell
$ julia 0015_string_concatenation.jl
Concatenated with '*': Hello, World!
--------------------
Result from slow loop: abcde
Result from fast join: abcde
```