A = [10, 20, 30, 40]
p = pointer(A)

println("Original array: ", A)
println("Pointer p (points to A[1]): ", p)
println("Element size: ", sizeof(eltype(A)), " bytes")

println("\n--- Reading using unsafe_load ---")
val1 = unsafe_load(p)
val2 = unsafe_load(p, 2)
val3 = unsafe_load(p, 3)

println("Value at index 1 (offset 0): ", val1)
println("Value at index 2 (offset 8): ", val2)
println("Value at index 3 (offset 16): ", val3)

println("\n--- Writing using unsafe_store! ---")

println("Storing 999 at index 4 (offset 24)...")
unsafe_store!(p, 999, 4)

println("Array after unsafe_store!: ", A)

println("\n--- Pointer Arithmetic (C-style) ---")
p_plus_8_bytes = p + sizeof(Int64)
p_plus_16_bytes = p + 2 * sizeof(Int64)

val2_arith = unsafe_load(p_plus_8_bytes)
val3_arith = unsafe_load(p_plus_16_bytes)

println("Value at p + 8 bytes: ", val2_arith)
println("Value at p + 16 bytes: ", val3_arith)

out_of_bounds_index = 100
try
    println("Attempting unsafe_store! at index $out_of_bounds_index (out of bounds)...")
    unsafe_store!(p, -1, out_of_bounds_index)
    println("...Memory potentially corrupted (no crash this time).")
    garbage = unsafe_load(p, out_of_bounds_index)
    println("Read garbage: ", garbage)
catch
    println("Caught error (lucky if it happens immediately): ", e)
end

if A[4] == 999
    unsafe_store!(p, 40, 4)
end

println("Array after potential out-of-bounds write attempt: ", A)