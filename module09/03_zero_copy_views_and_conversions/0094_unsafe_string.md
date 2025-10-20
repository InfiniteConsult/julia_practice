### `0094_unsafe_string.jl`

```julia
# 0094_unsafe_string.jl
# Creates a Julia String by COPYING data from a raw pointer.

# --- Case 1: Null-Terminated C String ---
println("--- Creating String from Null-Terminated Pointer ---")

# 1. Simulate a C string: Vector{UInt8} ending with 0x00.
#    This data is managed by Julia's GC.
c_string_data = UInt8['H', 'e', 'l', 'l', 'o', '\0'] # '\0' is the null terminator
ptr_null = pointer(c_string_data) # Gets a Ptr{UInt8}

# 2. Use 'unsafe_string(pointer)'
#    This function reads bytes starting at 'ptr_null' and *copies* them
#    into a NEW, heap-allocated Julia String.
#    It stops copying when it encounters the first null byte (0x00).
#    The null byte itself is NOT included in the Julia String.
julia_string_from_null = unsafe_string(ptr_null)

println("Original C data (bytes): ", c_string_data)
println("Julia string (from null): ", repr(julia_string_from_null)) # Use repr to see quotes
println("Type: ", typeof(julia_string_from_null))
println("Length: ", length(julia_string_from_null)) # Length is 5, excludes null

# --- Case 2: Pointer to Data with Known Length ---
println("\n--- Creating String from Pointer + Length ---")

# 3. Simulate a buffer without a null terminator (e.g., from network).
c_buffer_data = UInt8['W', 'o', 'r', 'l', 'd']
ptr_len = pointer(c_buffer_data)
buffer_length = length(c_buffer_data) # 5

# 4. Use 'unsafe_string(pointer, length)'
#    This function reads *exactly* 'length' bytes starting at 'ptr_len'
#    and *copies* them into a NEW Julia String.
#    It does NOT look for a null terminator.
julia_string_from_len = unsafe_string(ptr_len, buffer_length)

println("Original C buffer (bytes): ", c_buffer_data)
println("Julia string (from length): ", repr(julia_string_from_len))
println("Type: ", typeof(julia_string_from_len))
println("Length: ", length(julia_string_from_len)) # Length is 5

# --- Demonstrating the Copy ---
println("\n--- Demonstrating the Copy (vs. unsafe_wrap) ---")

# 5. Modify the original C data *after* creating the Julia string.
c_string_data[1] = UInt8('J') # Change 'H' to 'J'

# 6. The Julia string remains UNCHANGED because it's a copy.
println("Original C data modified: ", c_string_data)
println("Julia string (from null) is unchanged: ", repr(julia_string_from_null)) # Still "Hello"

```

-----

### Explanation

This script introduces `unsafe_string()`, the standard function for creating a Julia `String` object from a raw pointer (`Ptr{UInt8}`), typically obtained from C code. Crucially, unlike `unsafe_wrap` for arrays, `unsafe_string` **always copies** the data.

## Core Concept: Copying Bytes into a `String`

  * **`unsafe_string(pointer::Ptr{UInt8})`:**
      * **Purpose:** Converts a **null-terminated** C-style string (`char*`) into a Julia `String`.
      * **Behavior:** It starts reading bytes from the memory address `pointer`. It **copies** each byte into a newly allocated Julia `String` object until it encounters the **first null byte (`0x00`)**. The null byte itself is **not included** in the resulting `String`.
      * **Use Case:** This is the primary function for handling strings returned by C functions that follow the null-termination convention.
  * **`unsafe_string(pointer::Ptr{UInt8}, length::Integer)`:**
      * **Purpose:** Converts a sequence of bytes of a **known length** (which might **not** be null-terminated) into a Julia `String`.
      * **Behavior:** It reads exactly `length` bytes starting from `pointer` and **copies** them into a newly allocated Julia `String`. It does **not** look for, require, or stop at null bytes.
      * **Use Case:** Essential for handling data from sources where the length is provided separately, such as network packets, fixed-width fields in binary files, or C APIs that return a `char*` and a `size_t`.

## Why `unsafe_string` *Copies* (Unlike `unsafe_wrap`)

This copying behavior is deliberate and important for safety and correctness, distinguishing it fundamentally from `unsafe_wrap(Array, ...)`:

1.  **Immutability:** Julia `String`s are **immutable**. Once created, their content cannot be changed. If `unsafe_string` created a *view* (like `unsafe_wrap`), modifying the original C buffer later would violate the Julia `String`'s immutability guarantee. By copying, the Julia `String` becomes independent of the original C memory. (The script demonstrates this: changing `c_string_data` does *not* affect `julia_string_from_null`).
2.  **Ownership & GC:** The copied data is stored in a new `String` object managed by Julia's Garbage Collector (GC). The GC knows how to track and eventually free this memory. The original C pointer might point to memory managed by C (e.g., `malloc`/`free`) or temporary stack memory; Julia cannot safely manage that memory directly through a `String` view.
3.  **UTF-8 Validation (Implicit):** While `unsafe_string` itself might not strictly validate during the copy for performance, the resulting `String` object is expected to hold valid UTF-8 data. Copying provides an opportunity (even if sometimes deferred) to ensure this, whereas a direct view would expose Julia code to potentially invalid byte sequences from C.

While the copy introduces a small performance cost compared to a zero-copy view, it's necessary to maintain the guarantees and safety of Julia's immutable `String` type when interfacing with potentially volatile C memory.

-----

  * **References:**
      * **Julia Official Documentation, Base Documentation, `unsafe_string`:** "Copy data from a `Ptr{UInt8}` into a `String`." Describes both the null-terminated and length-based versions.

-----

To run the script:

```shell
$ julia 0094_unsafe_string.jl
--- Creating String from Null-Terminated Pointer ---
Original C data (bytes): UInt8[0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x00]
Julia string (from null): "Hello"
Type: String
Length: 5

--- Creating String from Pointer + Length ---
Original C buffer (bytes): UInt8[0x57, 0x6f, 0x72, 0x6c, 0x64]
Julia string (from length): "World"
Type: String
Length: 5

--- Demonstrating the Copy (vs. unsafe_wrap) ---
Original C data modified: UInt8[0x4a, 0x65, 0x6c, 0x6c, 0x6f, 0x00]
Julia string (from null) is unchanged: "Hello"
```