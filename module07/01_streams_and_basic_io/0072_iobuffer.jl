io = IOBuffer()

write(io, "Hello")
print(io, ", ")
println(io, "World!")
write(io, UInt8(0xFF))

println("Current buffer size: ", io.size, "bytes")

data_bytes = take!(io)
println("Data as bytes: ", data_bytes)
println("Type of data: ", typeof(data_bytes))
println("Buffer size after take!: ", io.size)


write(io, "Line 1\n")
write(io, "Line 2")

println("\n--- Reading as String ---")
println("Buffer size before reading string: ", io.size)

seekstart(io)
println("Position after seekstart: ", position(io))

content_string = read(io, String)
println("Content as string:\n", content_string)
println("Type of content: ", typeof(content_string))
println("Position after reading string: ", position(io))

println("\n--- Efficient String Building ---")
buffer = IOBuffer()
for i in 1:5
    print(buffer, "Item ", i, "; ")
end
final_string = String(take!(buffer))
println("Build string: ", final_string)

close(io)
close(buffer)
println("Buffers closed.")


# --- Investigation: IOBuffer Resizing (Not part of article) ---
println("\n--- Investigating IOBuffer Resizing ---")

investigation_buffer = IOBuffer()
println("Initial state:")
println("  Size: $(investigation_buffer.size) bytes")
println("  Capacity (maxsize): $(investigation_buffer.maxsize) bytes")

# Write ~512 KB
kb_512 = 512 * 1024
data_512kb = rand(UInt8, kb_512)
write(investigation_buffer, data_512kb)
println("\nAfter writing 512 KB:")
println("  Size: $(investigation_buffer.size) bytes")
println("  Capacity (maxsize): $(investigation_buffer.maxsize) bytes") # Should have grown

# Take the data
taken_data = take!(investigation_buffer)
println("\nAfter take!:")
println("  Size: $(investigation_buffer.size) bytes") # Should be 0
println("  Capacity (maxsize): $(investigation_buffer.maxsize) bytes") # Does it reset?

# Write ~16 MB
mb_16 = 16 * 1024 * 1024
data_16mb = rand(UInt8, mb_16)
write(investigation_buffer, data_16mb)
println("\nAfter writing 16 MB:")
println("  Size: $(investigation_buffer.size) bytes")
println("  Capacity (maxsize): $(investigation_buffer.maxsize) bytes") # Should have grown significantly

# Empty the buffer using seekstart + truncate
seekstart(investigation_buffer)
truncate(investigation_buffer, 0)
println("\nAfter seekstart() + truncate(0):")
println("  Size: $(investigation_buffer.size) bytes") # Should be 0
println("  Capacity (maxsize): $(investigation_buffer.maxsize) bytes") # Does it reset?

close(investigation_buffer)
println("\nInvestigation buffer closed.")


# --- Investigation: IOBuffer with Supplied Vector (Not part of article) ---
println("\n--- Investigating IOBuffer with Supplied Vector ---")

# 1. Create our initial vector
initial_size = 10 # Start small
backing_vector = Vector{UInt8}(undef, initial_size)
println("Initial state:")
println("  Vector length: $(length(backing_vector)) bytes")
# We cannot check capacity directly.

# 2. Create IOBuffer with the vector, making it writable
# WARNING: IOBuffer now "takes ownership" conceptually
investigation_buffer = IOBuffer(backing_vector; write=true)
println("IOBuffer created with backing_vector:")
println("  IOBuffer size: $(investigation_buffer.size) bytes") # Should be 0 initially

# 3. Write data *within* the initial size
write(investigation_buffer, "Hello") # 5 bytes < 10
println("\nAfter writing 'Hello' (5 bytes):")
println("  IOBuffer size: $(investigation_buffer.size) bytes")
println("  Backing vector length: $(length(backing_vector)) bytes") # Should still be 10

# 4. Write data that *exceeds* the initial size
# This will likely force IOBuffer to resize its internal storage.
# It *might* resize our 'backing_vector' in place, or it might
# allocate a completely new vector internally.
write(investigation_buffer, " World! This is a longer string.") # > 10 bytes total
println("\nAfter writing more data (exceeding initial 10 bytes):")
println("  IOBuffer size: $(investigation_buffer.size) bytes")
println("  Backing vector length: $(length(backing_vector)) bytes") # Did it change? Maybe, maybe not.

# 5. Let's see the content via take!
seekstart(investigation_buffer) # Need to rewind before take!
taken_data = take!(investigation_buffer)
println("\nAfter take!:")
println("  Taken data length: $(length(taken_data)) bytes")
println("  IOBuffer size: $(investigation_buffer.size) bytes") # Should be 0
println("  Backing vector length: $(length(backing_vector)) bytes") # Unlikely to shrink

# 6. Check if the original vector reference was modified (unlikely but possible)
println("First 5 bytes of original backing_vector now: ", backing_vector[1:min(5, end)])

close(investigation_buffer)
println("\nInvestigation buffer closed.")
