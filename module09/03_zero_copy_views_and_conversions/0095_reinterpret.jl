A_float = Float64[1.0, -2.0, π, 0.0]
println("Original array (Float64): ", A_float)
println("Sizeof elements: ", sizeof(eltype(A_float)), " bytes")
println("First element bits: ", bitstring(A_float[1]))

println("\n--- Reinterpret: Float64 -> UInt64 ---")
B_uint = reinterpret(UInt64, A_float)

println("Reinterpreted array (UInt64): ", B_uint)
println("Sizeof elements: ", sizeof(eltype(B_uint)), " bytes")
println("First element bits: ", bitstring(B_uint[1]))
println("Type of reinterpreted array: ", typeof(B_uint))

println("\nModifying view B_uint[4] = 0x0000_0000_0000_0000")
B_uint[4] = 0x0000_0000_0000_0000

println("View B_uint is now: ", B_uint)

println("\nModifying view B_uint[1] using bitwise XOR...")
B_uint[1] = B_uint[1] ⊻ (UInt64(1) << 63)

println("View B_uint[1] is now (bits): ", bitstring(B_uint[1]))
println("Original A_float[1] is now: ", A_float[1])

println("\n--- Reinterpret: Float64 -> UInt8 ---")
C_uint8 = reinterpret(UInt8, A_float)

println("Reinterpreted array (UInt8): ", C_uint8)
println("Length of UInt8 array: ", length(C_uint8))
println("Type of reinterpreted array: ", typeof(C_uint8))

println("First 8 bytes (UInt8): ", C_uint8[1:8])

println("\n--- Reinterpret Single Values ---")

f_val::Float64 = -1.0
u_val::UInt64 = reinterpret(UInt64, f_val)

println("Value -1.0 (Float64): ", f_val)
println("Value -1.0 reinterpreted as UInt64 (hex): 0x", string(u_val, base=16))
println("Value -1.0 reinterpreted as UInt64 (bits): ", bitstring(u_val))
