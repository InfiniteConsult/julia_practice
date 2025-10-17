### `0029_vector_basics.jl`

```julia
# 0029_vector_basics.jl

# 1. A Vector is created with square brackets.
#    It is a mutable, resizable, one-dimensional array.
my_vector = [10, 20, 30]

println("Vector value: ", my_vector)
println("Vector type: ", typeof(my_vector))
println("Initial length: ", length(my_vector))

println("-"^20)

# 2. Use `push!` to add elements to the end of the vector.
#    The '!' signifies that this function modifies its first argument.
push!(my_vector, 40)
push!(my_vector, 50)

println("Vector after pushing elements: ", my_vector)
println("New length: ", length(my_vector))

println("-"^20)

# 3. Access and modify elements using 1-based indexing.
#    Because Vectors are mutable, their elements can be changed.
println("Element at index 2: ", my_vector[2])
my_vector[2] = 25
println("Vector after modification: ", my_vector)
```

-----

### Explanation

This script introduces the **`Vector`**, which is Julia's fundamental, resizable, one-dimensional array. It's the direct equivalent of `std::vector` in C++, `Vec` in Rust, or `list` in Python.

  * **Creation**: Vectors are created using square brackets `[...]`. The type of the vector is inferred from the elements it contains. `[10, 20, 30]` creates a `Vector{Int64}`.

  * **Mutability**: Unlike tuples, vectors are **mutable**. You can add, remove, and change their elements after they are created.

  * **`push!()`**: The standard function for appending an element to the end of a vector is `push!`. The `!` at the end is a Julia convention indicating that the function **modifies** its first argument (in this case, `my_vector`).

  * **`length()`**: This function returns the number of elements currently in the vector.

  * **Access & Modification**: You can access and reassign elements using 1-based indexing (`my_vector[2] = 25`), just like you would with a standard C array or `std::vector`.

To run the script:

```shell
$ julia 0029_vector_basics.jl
Vector value: [10, 20, 30]
Vector type: Vector{Int64}
Initial length: 3
--------------------
Vector after pushing elements: [10, 20, 30, 40, 50]
New length: 5
--------------------
Element at index 2: 20
Vector after modification: [10, 25, 30, 40, 50]
```