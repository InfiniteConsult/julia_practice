### `0027_named_tuples.jl`

```julia
# 0027_named_tuples.jl

# 1. A NamedTuple is created with a syntax similar to a tuple,
#    but each element is given a name.
point = (x=10, y=20, label="Start")

println("NamedTuple value: ", point)
println("NamedTuple type: ", typeof(point))

println("-"^20)

# 2. Elements can be accessed like struct fields using dot notation.
#    This is the primary and most readable way to access them.
println("Access via name (point.x): ", point.x)
println("Access via name (point.label): ", point.label)

println("-"^20)

# 3. It is still a tuple, so you can also access elements by index.
println("Access via index (point[1]): ", point[1])
println("Access via index (point[3]): ", point[3])

# You can also get its keys and values
println("Keys: ", keys(point))
println("Values: ", values(point))
```

### Explanation

This script introduces the **`NamedTuple`**, which combines the performance and immutability of a tuple with the readability of a `struct`.

  * **Syntax**: A `NamedTuple` is created by assigning names to each element within the parentheses: `(name1 = value1, name2 = value2)`. The resulting type includes the names and the types of the values, like `NamedTuple{(:x, :y, :label), Tuple{Int64, Int64, String}}`.

  * **Access**: The key advantage of a `NamedTuple` is that you can access its elements using dot notation (`point.x`), which makes the code self-documenting. You can still access elements by their 1-based index (`point[1]`) just like a regular tuple.

  * **Use Case**: `NamedTuple`s are extremely useful as lightweight, "anonymous" structs. They are perfect for returning multiple, clearly-labeled values from a function without the need to define a formal `struct` type beforehand. Because they are immutable and have a fixed structure known at compile time, they are just as **performant** as regular tuples.

To run the script:

```shell
$ julia 0027_named_tuples.jl
NamedTuple value: (x = 10, y = 20, label = "Start")
NamedTuple type: NamedTuple{(:x, :y, :label), Tuple{Int64, Int64, String}}
--------------------
Access via name (point.x): 10
Access via name (point.label): Start
--------------------
Access via index (point[1]): 10
Access via index (point[3]): Start
Keys: (:x, :y, :label)
Values: (10, 20, "Start")
```
