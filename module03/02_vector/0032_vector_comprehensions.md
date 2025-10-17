### `0032_vector_comprehensions.jl`

```julia
# 0032_vector_comprehensions.jl

# 1. A comprehension provides a concise way to create a new vector.
#    This creates a vector of the squares of numbers from 1 to 5.
squares = [i^2 for i in 1:5]

println("Vector of squares: ", squares)
println("Type: ", typeof(squares))

println("-"^20)

# 2. You can add a filter condition with an 'if' clause.
#    This creates a vector of only the even numbers from 1 to 10.
evens = [i for i in 1:10 if i % 2 == 0]

println("Vector of even numbers: ", evens)

println("-"^20)

# 3. The comprehension above is a more readable and equally performant
#    equivalent of writing the following manual loop:
evens_loop = Int[] # Create an empty vector of Integers
for i in 1:10
    if i % 2 == 0
        push!(evens_loop, i)
    end
end
println("Vector from manual loop: ", evens_loop)
```

### Explanation

This script introduces **comprehensions**, a powerful and concise syntax for creating collections. This feature will be immediately familiar to you from Python's list comprehensions.

  * **Syntax**: The basic structure is `[expression for variable in iterable]`. For each element in the `iterable`, the `expression` is evaluated, and the results are collected into a new `Vector`.

  * **Filtering**: You can add a conditional clause `if condition` at the end to filter which elements are processed. The `expression` is only evaluated for elements where the `condition` is `true`.

  * **Readability & Performance**: Comprehensions are often more readable than writing out a full `for` loop with `push!`. They are also just as **performant**. The Julia compiler is able to generate highly optimized code for comprehensions, often pre-calculating the size of the final vector and allocating it in a single step. This makes them the idiomatic choice for constructing a new vector based on an existing sequence.

To run the script:

```shell
$ julia 0032_vector_comprehensions.jl
Vector of squares: [1, 4, 9, 16, 25]
Type: Vector{Int64}
--------------------
Vector of even numbers: [2, 4, 6, 8, 10]
--------------------
Vector from manual loop: [2, 4, 6, 8, 10]
```