### `0026_tuples.jl`

```julia
# 0026_tuples.jl

# 1. Tuples are created with parentheses and commas.
#    They are immutable and have a fixed size.
my_tuple = (10, "hello", true)

println("Tuple value: ", my_tuple)
println("Tuple type: ", typeof(my_tuple))

println("-"^20)

# 2. Elements are accessed with 1-based indexing.
first_element = my_tuple[1]
second_element = my_tuple[2]

println("First element: ", first_element)
println("Second element: ", second_element)

println("-"^20)

# 3. You can "destructure" a tuple to unpack its values into separate variables.
#    This is a common and efficient way to handle multiple return values from a function.
(a, b, c) = my_tuple

println("Unpacked variable 'a': ", a)
println("Unpacked variable 'b': ", b)
println("Unpacked variable 'c': ", c)

# 4. Attempting to modify a tuple will result in an error.
try
    my_tuple[1] = 20
catch e
    println("\nError trying to modify a tuple: ", e)
end
```

-----

### Explanation

This script introduces the **tuple**, a fixed-size, immutable collection of ordered elements. Its properties make it a highly performant data structure, very similar to a `std::tuple` in C++ or a tuple in Python.

  * **Creation**: Tuples are defined by enclosing comma-separated values in parentheses `()`. The type of the tuple, like `Tuple{Int64, String, Bool}`, is determined by the types of the elements it contains.

  * **Immutability**: Once a tuple is created, its contents cannot be changed. This makes it a safe and predictable data structure to pass around, as you can be certain it won't be modified.

  * **Access**: Elements are accessed using square brackets `[]` with **1-based indexing**, just like strings. `my_tuple[1]` retrieves the first element.

  * **Destructuring**: This is a powerful feature where you can unpack the elements of a tuple directly into variables. The syntax `(a, b, c) = my_tuple` assigns `my_tuple[1]` to `a`, `my_tuple[2]` to `b`, and so on. This is the idiomatic way to handle functions that return multiple values.

To run the script:

```shell
$ julia 0026_tuples.jl
Tuple value: (10, "hello", true)
Tuple type: Tuple{Int64, String, Bool}
--------------------
First element: 10
Second element: hello
--------------------
Unpacked variable 'a': 10
Unpacked variable 'b': hello
Unpacked variable 'c': true

Error trying to modify a tuple: MethodError(f=setindex!, args=(...))
```