### `0007_floats.jl`

```julia
# 0007_floats.jl

# By default, literals with a decimal point are Float64
f64 = 1.0
println("Default float type: ", typeof(f64))

# You can create a Float32 by using an 'f0' suffix
f32 = 1.5f0
println("A 32-bit float: ", typeof(f32))

# Scientific notation is also supported
small_num = 1e-5
println("Scientific notation (1e-5): ", small_num)

println("-"^20)

# Floating-point arithmetic follows IEEE 754 standards, including special values
positive_infinity = 1.0 / 0.0
negative_infinity = -1.0 / 0.0
not_a_number = 0.0 / 0.0

println("1.0 / 0.0 = ", positive_infinity)
println("-1.0 / 0.0 = ", negative_infinity)
println("0.0 / 0.0 = ", not_a_number)

# You can check for these special values
println("Is positive_infinity infinite? ", isinf(positive_infinity))
println("Is not_a_number a NaN? ", isnan(not_a_number))
```

### Explanation

This script introduces Julia's floating-point types and their special values, which will be familiar from C++ and Rust as they follow the IEEE 754 standard.

  * **Floating-Point Types**: Julia's main floating-point types are `Float32` (single precision) and `Float64` (double precision). `Float64` is the default for any literal containing a decimal point.

  * **Literals**:

      * A literal like `3.14` is automatically a `Float64`.
      * To create a `Float32` literal, you can use the `f0` suffix (e.g., `3.14f0`). This is a concise syntax similar to the `f` suffix in C/C++.
      * Scientific notation can be expressed with `e` or `E`, as in `6.022e23`.

  * **Special Values**: Standard floating-point arithmetic can result in three special values:

      * `Inf`: Infinity, resulting from operations like `1.0 / 0.0`.
      * `-Inf`: Negative infinity.
      * `NaN`: "Not a Number," resulting from undefined operations like `0.0 / 0.0`.

  * **Check Functions**: Julia provides `isinf()`, `isnan()`, and `isfinite()` to test for these special values.

### Performance Note

For general-purpose computing, the default `Float64` is recommended. However, for applications involving very large arrays of floating-point numbers (like in graphics, machine learning, or scientific simulation), explicitly using `Float32` can cut memory usage in half and may offer significant speedups on hardware optimized for single-precision arithmetic, such as GPUs.

To run the script:

```shell
$ julia 0007_floats.jl
Default float type: Float64
A 32-bit float: Float32
Scientific notation (1e-5): 1.0e-5
--------------------
1.0 / 0.0 = Inf
-1.0 / 0.0 = -Inf
0.0 / 0.0 = NaN
Is positive_infinity infinite? true
Is not_a_number a NaN? true
```