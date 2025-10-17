### `0031_vector_views.jl`

```julia
# 0031_vector_views.jl

original_vector = [10, 20, 30, 40, 50]

# 1. Create a "view" of the vector using the @view macro.
#    This does NOT copy the data; it creates a lightweight object
#    that refers to the original vector's memory.
sub_view = @view original_vector[2:4]

println("Original vector: ", original_vector)
println("Sub-view: ", sub_view)
println("Type of sub-view: ", typeof(sub_view))

println("-"^20)

# 2. Modify an element in the original vector.
original_vector[2] = 999

# 3. Observe the results. The sub-view is AFFECTED because it shares
#    the same underlying data as the original vector.
println("Original vector after modification: ", original_vector)
println("Sub-view now reflects the change: ", sub_view)
```

-----

### Explanation

This script introduces **views**, Julia's high-performance, zero-copy solution for array slicing. This concept is the direct equivalent of `std::span` in C++, slices (`&[T]`) in Rust, or `memoryview` in Python.

  * **`@view` Macro**: To create a view, you prefix the standard slicing operation with the `@view` macro. Instead of allocating a new `Vector`, this creates a `SubArray` object.

  * **`SubArray`**: A `SubArray` is a lightweight wrapper that stores a reference to the original array along with information about the selected indices. It does **not** own its own data.

### Performance and Behavior ❗

This is the idiomatic way to handle slicing in performance-critical code.

  * **Zero-Copy**: Creating a view is extremely fast because no data is copied. The operation is allocation-free, which reduces the workload on the garbage collector and avoids memory bandwidth costs.
  * **Shared Memory**: As the example shows, since the view and the original vector share the same underlying data, any modification made through one is immediately visible in the other.

**Rule of Thumb**: When you need to pass a slice of an array to a function, always use a view to prevent unnecessary copying. Slicing with `my_array[start:end]` is for when you explicitly need an independent copy of the data.

To run the script:

```shell
$ julia 0031_vector_views.jl
Original vector: [10, 20, 30, 40, 50]
Sub-view: [20, 30, 40]
Type of sub-view: SubArray{Int64, 1, Vector{Int64}, Tuple{UnitRange{Int64}}, true}
--------------------
Original vector after modification: [10, 999, 30, 40, 50]
Sub-view now reflects the change: [999, 30, 40]
```