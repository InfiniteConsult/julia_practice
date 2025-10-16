f64 = 1.0
println("Default float type: ", typeof(f64))

f32 = 1.5f0
println("A 32-bit float: ", typeof(f32))

println("-"^20)

positive_∞ = 1.0 / 0.0
negative_∞ = -1.0 / 0.0
not_a_number = 0.0 / 0.0


println("1.0 / 0.0 = ", positive_∞)
println("-1.0 / 0.0 = ", negative_∞)
println("0.0 / 0.0 = ", not_a_number)

println("Is positive_infinity infinite? ", isinf(positive_∞))
println("Is not_a_number a NaN? ", isnan(not_a_number))