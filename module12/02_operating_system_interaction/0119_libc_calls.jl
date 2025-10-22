import Base.Libc: malloc, free, time
import Base.Libc: Clong, Cvoid, C_NULL

println("--- Using Libc Wrappers ---")

current_time_t = Libc.time()
println("Libc.time(): ", current_time_t)

println("\n--- Manual Memory Management (Outside GC) ---")

bytes_to_alloc = 10 * sizeof(Float64)
println("Allocating $bytes_to_alloc bytes using Libc.malloc...")

ptr_void = Libc.malloc(bytes_to_alloc)

if ptr_void == C_NULL
    error("Libc.malloc failed to allocate memory.")
end
println("Received raw pointer: ", ptr_void)

ptr_float = convert(Ptr{Float64}, ptr_void)
println("Typed pointer: ", ptr_float)

println("Writing values using unsafe_store!...")
for i in 1:10
    unsafe_store!(ptr_float, Float64(i * 1.1), i)
end

val5 = unsafe_load(ptr_float, 5)
val10 = unsafe_load(ptr_float, 10)
println("Value at index 5: ", val5)
println("Value at index 10: ", val10)

println("Freeing manually allocated memory using Libc.free...")
Libc.free(ptr_void)
println("Memory freed.")

println("\n--- Managing malloc'd Memory with unsafe_wrap(..., own=true) ---")

ptr_void_2 = Libc.malloc(bytes_to_alloc)
if ptr_void_2 == C_NULL; error("malloc failed"); end
ptr_float_2 = convert(Ptr{Float64}, ptr_void_2)
println("Allocated second block at: ", ptr_float_2)

owned_array = unsafe_wrap(Array, ptr_float_2, 10; own = true)

owned_array .= [Float64(i * 2.2) for i in 1:10]
println("Owned wrapped array: ", owned_array)


println("GC will free the memory for 'owned_array' when it's no longer reachable.")