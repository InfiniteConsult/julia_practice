### `0046_anonymous_functions.jl`

```julia
# 0046_anonymous_functions.jl

# 1. Standard function for mapping (e.g., doubling numbers)
function double(x)
    return x * 2
end
numbers = [1, 2, 3, 4]
doubled_numbers = map(double, numbers)
println("Doubled with standard function: ", doubled_numbers)

println("-"^20)

# 2. Using an anonymous function directly within the map call.
#    The syntax `x -> x * 2` creates a function without a name.
doubled_anon = map(x -> x * 2, numbers)
println("Doubled with anonymous function: ", doubled_anon)

println("-"^20)

# 3. Anonymous functions can take multiple arguments.
#    Here, we use `map` to add elements from two lists.
list1 = [10, 20]
list2 = [1, 2]
sums = map((a, b) -> a + b, list1, list2)
println("Sums using multi-arg anonymous function: ", sums)

println("-"^20)

# 4. Anonymous functions implicitly capture variables from their surrounding scope.
multiplier = 3
multiplied_capture = map(x -> x * multiplier, numbers)
println("Using captured variable 'multiplier': ", multiplied_capture)
```

-----

### Explanation

This script introduces **anonymous functions**, also known as **lambda functions**. These are functions defined without being given a specific name. They are essential for functional programming patterns and are frequently used as arguments to higher-order functions like `map`.

  * **Syntax (`->`)**: The core syntax for creating an anonymous function is `arguments -> expression`.

      * `x -> x * 2`: Defines a function that takes one argument `x` and returns `x * 2`.
      * `(a, b) -> a + b`: Defines a function that takes two arguments `a` and `b` and returns their sum.

  * **`map()` Function**: The `map(function, collection)` function is a standard higher-order function. It applies the given `function` to each element of the `collection` and returns a new collection containing the results.

  * **Use Case**: Anonymous functions are ideal when you need a simple function just once, typically as an argument to another function. Instead of defining a separate named function (like `double`), you can define the operation inline with `x -> x * 2`, making the code more concise.

  * **Closures (Variable Capture)**: Anonymous functions automatically "capture" variables from the scope in which they are defined. In the last example, the function `x -> x * multiplier` uses the `multiplier` variable defined outside of it. This behavior, where a function remembers the environment it was created in, is called a **closure**.

To run the script:

```shell
$ julia 0046_anonymous_functions.jl
Doubled with standard function: [2, 4, 6, 8]
--------------------
Doubled with anonymous function: [2, 4, 6, 8]
--------------------
Sums using multi-arg anonymous function: [11, 22]
--------------------
Using captured variable 'multiplier': [3, 6, 9, 12]
```