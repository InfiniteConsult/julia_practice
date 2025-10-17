### `0030_vector_slicing.jl`

```julia
# 0030_vector_slicing.jl

original_vector = [10, 20, 30, 40, 50]

# 1. Create a "slice" of the vector from the 2nd to the 4th element.
#    In Julia, this operation creates a new Vector, copying the elements.
sub_vector = original_vector[2:4]

println("Original vector: ", original_vector)
println("Sub-vector (slice): ", sub_vector)
println("Type of sub-vector: ", typeof(sub_vector))

println("-"^20)

# 2. Modify an element in the original vector.
original_vector[2] = 999

# 3. Observe the results. The sub-vector is unaffected because it's a separate copy.
println("Original vector after modification: ", original_vector)
println("Sub-vector remains unchanged: ", sub_vector)
```

-----

### Explanation

This script demonstrates **slicing**, a common operation for extracting a sub-section of an array. It also reveals a critical performance behavior in Julia.

  * **Syntax**: Slicing is done using the range syntax `[start:end]` inside the indexing brackets. `original_vector[2:4]` creates a new sequence containing the elements from index 2 up to and including index 4.

### Performance Note ❗

This is a crucial concept for a systems programmer. By default, **slicing an array in Julia creates a copy**, not a view or a reference.

  * **What it means**: The expression `original_vector[2:4]` allocates new memory for a new `Vector`, and then copies the values (`20`, `30`, `40`) from the original vector into this new one. The variable `sub_vector` points to this completely independent object.

  * **Implications**: While safe, this behavior can be very **inefficient** if you are working with large arrays or performing slicing inside a performance-critical loop. It leads to unnecessary memory allocations and data copying, which can hurt performance and increase pressure on the garbage collector.

The next lesson will introduce **views**, which are Julia's high-performance, zero-copy solution to this problem.

To run the script:

```shell
$ julia 0030_vector_slicing.jl
Original vector: [10, 20, 30, 40, 50]
Sub-vector (slice): [20, 30, 40]
Type of sub-vector: Vector{Int64}
--------------------
Original vector after modification: [10, 999, 30, 40, 50]
Sub-vector remains unchanged: [20, 30, 40]
```