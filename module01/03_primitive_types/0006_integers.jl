default_int = 100
println("Default integer type: ", typeof(default_int))


i8::Int8 = 127
i64::Int64 = 9_223_372_036_854_775_807
u8::UInt8 = 255

println("An 8-bit signed integer: ", i8)
println("A 64-bit signed integer: ", i64)
println("An 8-bit unsigned integer: ", u8)

println("-"^20)

println("The maximum value for Int8 is: ", typemax(Int8))
overflowed_int = i8 + Int8(2)
println("127 + 2 as Int8 results in: ", overflowed_int)
println("The minimum value for Int8 is: ", typemin(Int8))