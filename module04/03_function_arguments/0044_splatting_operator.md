### `0044_splatting_operator.jl`

```julia
# 0044_splatting_operator.jl

# 1. A function that takes a variable number of arguments.
#    `numbers...` collects all remaining arguments into a tuple named 'numbers'.
function sum_all(label::String, numbers...)
    total = 0
    for n in numbers
        total += n
    end
    println(label, ": ", total)
end

# 2. Call the function with individual arguments.
println("--- Calling with individual arguments ---")
sum_all("Individual args", 1, 2, 3, 4)

println("\n--- Calling with splatting ---")

# 3. Use the splatting operator '...' to pass elements from a collection
#    as individual arguments.
my_numbers = [10, 20, 30]
# This is equivalent to calling sum_all("Splatting", 10, 20, 30)
sum_all("Splatting", my_numbers...)

# It also works with tuples
my_tuple = (100, 200)
sum_all("Splatting tuple", my_tuple...)
```

-----

### Explanation

This script introduces the **splatting operator (`...`)**, which unpacks the elements of a collection into individual arguments for a function call. This is a powerful feature for working with functions that accept a variable number of arguments (varargs). ☄️

  * **Varargs Functions (`numbers...`)**: In the function definition `sum_all(label::String, numbers...)`, the `...` after `numbers` indicates that this parameter will collect any number of subsequent positional arguments into a single **tuple** named `numbers`. This is similar to `*args` in Python or variadic templates in C++.

  * **Splatting Operator (`...`)**: When *calling* a function, placing `...` after a collection (like a `Vector` or `Tuple`) **unpacks** its elements and passes them as separate positional arguments.

      * `sum_all("Splatting", my_numbers...)` takes the elements `10, 20, 30` from `my_numbers` and effectively calls `sum_all("Splatting", 10, 20, 30)`.

  * **Use Cases**: Splatting is commonly used when:

      * You have a list or tuple of values that you need to pass to a function designed to accept them individually (like `sum_all` or functions like `max()`, `min()`).
      * You are forwarding arguments from one varargs function to another.

To run the script:

```shell
$ julia 0044_splatting_operator.jl
--- Calling with individual arguments ---
Individual args: 10

--- Calling with splatting ---
Splatting: 60
Splatting tuple: 300
```