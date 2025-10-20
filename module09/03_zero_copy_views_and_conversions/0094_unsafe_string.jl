println("--- Creating String from Null-Terminated Pointer ---")

c_string_data = UInt8['H', 'e', 'l', 'l', 'o', '\0']
ptr_null = pointer(c_string_data)

julia_string_from_null = unsafe_string(ptr_null)

println("Original C data (bytes): ", c_string_data)
println("Julia string (from null): ", repr(julia_string_from_null))
println("Type: ", typeof(julia_string_from_null))
println("Length: ", length(julia_string_from_null))

println("\n--- Creating String from Pointer + Length ---")
c_buffer_data = UInt8['W', 'o', 'r', 'l', 'd']
ptr_len = pointer(c_buffer_data)
buffer_length = length(c_buffer_data)

julia_string_from_len = unsafe_string(ptr_len, buffer_length)

println("Original C buffer (bytes): ", c_buffer_data)
println("Julia string (from length): ", repr(julia_string_from_len))
println("Type: ", typeof(julia_string_from_len))
println("Length: ", length(julia_string_from_len))

println("\n--- Demonstrating the Copy (vs. unsafe_wrap) ---")
c_string_data[1] = UInt8('J')

println("Original C data modified: ", c_string_data)
println("Julia string (from null) is unchanged: ", repr(julia_string_from_null))
