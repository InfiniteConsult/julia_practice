### `0006_integers.jl`

```julia
# 0006_integers.jl (Corrected)

# By default, integer literals are of type Int64 on 64-bit systems
default_int = 100
println("Default integer type: ", typeof(default_int))

# You can specify the exact bit size
i8::Int8 = 127
i64::Int64 = 9_223_372_036_854_775_807 # Underscores can be used as separators
u8::UInt8 = 255

println("An 8-bit signed integer: ", i8)
println("A 64-bit signed integer: ", i64)
println("An 8-bit unsigned integer: ", u8)

println("-"^20)

# To demonstrate overflow, all operands must be of the same type.
# We explicitly construct an Int8 from the literal '2' before adding.
println("The maximum value for Int8 is: ", typemax(Int8))
overflowed_int = i8 + Int8(2) # This is now Int8(127) + Int8(2)
println("127 + 2 as Int8 results in: ", overflowed_int)
println("The minimum value for Int8 is: ", typemin(Int8))

```

### Explanation

This script covers Julia's primitive integer types and their overflow behavior.

  * **Sized Integers**: Julia provides a full range of standard integer types: `Int8`, `Int16`, `Int32`, `Int64`, `Int128` and their unsigned (`UInt...`) counterparts.
  * **Default Type**: The default type for an integer literal is `Int`, which is an alias for the platform's native word size (`Int64` on 64-bit systems).
  * **Type Construction**: You can construct a value of a specific type using `TypeName(value)`, for example, `Int8(2)`.

### Performance & Behavior Notes

  * **Memory Usage**: For large arrays, using the smallest appropriate integer type (e.g., `Vector{Int8}`) can significantly reduce memory usage.
  * **Overflow Behavior**: Julia's arithmetic operations **wrap around** on overflow *when all operands are of the same fixed-size integer type*. The expression `i8 + Int8(2)` performs `Int8` arithmetic, causing the value to wrap from the maximum (`127`) to the minimum (`-128`) and continue from there. This is a crucial distinction from operations involving mixed types, which promote to a larger type and do not wrap.

To run the corrected script:

```shell
$ julia 0006_integers.jl
Default integer type: Int64
An 8-bit signed integer: 127
A 64-bit signed integer: 9223372036854775807
An 8-bit unsigned integer: 255
--------------------
The maximum value for Int8 is: 127
127 + 2 as Int8 results in: -127
The minimum value for Int8 is: -128
```