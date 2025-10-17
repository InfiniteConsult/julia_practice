### `0021_for_loop_collection.jl`

```julia
# 0021_for_loop_collection.jl

# A Vector is Julia's primary resizable array type.
fruits = ["Apple", "Banana", "Cherry"]

println("--- Iterating over a Vector of strings ---")
for fruit in fruits
    println("Processing: ", fruit)
end

println("\n--- Iterating with index and value using enumerate ---")
for (index, fruit) in enumerate(fruits)
    println("Item at index ", index, " is: ", fruit)
end
```

-----

### Explanation

This script shows how to iterate directly over the elements of a collection, which is one of the most common uses for a `for` loop.

  * **Direct Iteration**: The syntax `for fruit in fruits` iterates through each element of the `fruits` collection, assigning the element to the `fruit` variable for each pass of the loop. This is the direct equivalent of a range-based `for` loop in C++/Rust or a standard `for item in list` loop in Python. It's the most readable and idiomatic way to process every item in a collection.

  * **`enumerate()`**: If you need both the index and the value during iteration, the `enumerate()` function provides an efficient way to do so. It wraps the collection and, on each iteration, yields a tuple of `(index, value)`. This is preferable to manually managing an index counter (e.g., `i = 1; for fruit in fruits... i += 1`).

To run the script:

```shell
$ julia 0021_for_loop_collection.jl
--- Iterating over a Vector of strings ---
Processing: Apple
Processing: Banana
Processing: Cherry

--- Iterating with index and value using enumerate ---
Item at index 1 is: Apple
Item at index 2 is: Banana
Item at index 3 is: Cherry
```