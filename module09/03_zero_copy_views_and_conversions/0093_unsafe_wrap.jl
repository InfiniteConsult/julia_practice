println("--- Wrapping a Julia Array's Pointer (Borrowing) ---")

julia_data = Float64[1.1, 2.2, 3.3, 4.4, 5.5]
ptr_julia = pointer(julia_data)
num_elements = length(julia_data)

wrapped_array = unsafe_wrap(Array, ptr_julia, num_elements; own = false)

println("Original Julia data: ", julia_data)
println("Wrapped array view:  ", wrapped_array)
println("Type of wrapped array: ", typeof(wrapped_array))

println("\nModifying wrapped_array[1] = 99.9")
wrapped_array[1] = 99.9

println("Wrapped array view is now: ", wrapped_array)
println("Original Julia data is now: ", julia_data)

println("\n--- Wrapping Externally Allocated Memory (Taking Ownership) ---")
bytes_to_alloc = 3 * sizeof(Int64)
ptr_malloc_void = Libc.malloc(bytes_to_alloc)
if ptr_malloc_void == C_NULL
    error("malloc failed")
end

ptr_malloc_int = convert(Ptr{Int64}, ptr_malloc_void)
println("Allocated external memory at: ", ptr_malloc_int)

owned_array = unsafe_wrap(Array, ptr_malloc_int, 3; own = true)

owned_array[1] = 1000
owned_array[2] = 2000
owned_array[3] = 3000
println("Owned wrapped array: ", owned_array)

println("\nFinished unsafe_wrap examples.")