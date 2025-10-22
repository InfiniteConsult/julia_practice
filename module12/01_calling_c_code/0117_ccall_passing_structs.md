### `0117_ccall_passing_structs.jl`

```julia
# 0117_ccall_passing_structs.jl
# Demonstrates passing an isbits struct by reference (pointer) to C.

import Base.Libc: Cdouble, Cvoid
import Libdl

# --- Julia Struct Definition ---

# 1. Define an immutable 'isbits' struct in Julia.
#    Its memory layout will be identical to the corresponding C struct.
struct Point # isbits, 16 bytes
    x::Float64 # 8 bytes
    y::Float64 # 8 bytes
end

# --- C Code Simulation ---
# C struct equivalent:
# typedef struct {
#     double x;
#     double y;
# } Point;
#
# C function that modifies a Point via pointer:
# void move_point(Point* p, double dx, double dy) {
#     p->x += dx;
#     p->y += dy;
# }

# Compile the C code into a temporary shared library
const c_code_point = """
#include <stddef.h>

typedef struct {
    double x;
    double y;
} Point;

void move_point(Point* p, double dx, double dy) {
    if (p != NULL) { // Basic null check
        p->x += dx;
        p->y += dy;
    }
}
"""

function compile_c_code(c_code, lib_name)
    lib_filename = lib_name * "." * Libdl.dlext
    if isnothing(Sys.which("gcc"))
        error("gcc not found. Please install gcc to run this example.")
    end
    compile_cmd = `gcc -fPIC -shared -x c -o $lib_filename -`
    println("Compiling C code to $lib_filename...")
    try
        open(compile_cmd, "w", stdout) do io
            print(io, c_code)
        end
        println("Compilation successful.")
        return abspath(lib_filename)
    catch e
        println("ERROR compiling C code: ", e)
        return nothing
    end
end

const temp_lib_path = compile_c_code(c_code_point, "libtemppoint")
if temp_lib_path === nothing
    println("Exiting due to compilation failure.")
    exit(1)
end

# --- Julia Data and ccall ---
println("\n--- Calling C function with Julia isbits struct ---")

# 2. Create an instance of the Julia struct.
p = Point(10.0, 20.0)

# 3. Prepare argument for passing *by pointer* to C.
#    The C function expects 'Point*'. We cannot pass 'p' directly,
#    as that would pass the 16-byte value itself (pass-by-value).
#    We need to pass its *address*.
#    The safe way to do this for an isbits value is using 'Ref(value)'.
#    'Ref(p)' creates a GC-managed box holding 'p', allowing a stable pointer.
p_ref = Ref(p) # Type is Base.RefValue{Point}

println("Julia Point p: ", p)
println("Boxed Ref(p):  ", p_ref)
println("Value inside Ref before call: ", p_ref[]) # Use [] to get value from Ref

# 4. Perform the ccall.
#    Map C 'Point*' to Julia 'Ref{Point}' in the ArgTypes tuple.
#    ccall automatically uses Base.unsafe_convert(Ptr{Point}, p_ref) internally.
result = try
    ccall(
        (:move_point, temp_lib_path), # Function name and library path
        Cvoid,                       # Return type: void
        (Ref{Point}, Cdouble, Cdouble), # Arg types: (Point*, double, double)
        p_ref, 5.0, -5.0             # Arg values: pass the Ref object
    )
    println("\nccall executed successfully.")
    true
catch e
    println("\nERROR during ccall: ", e)
    false
end

# --- Verification and Cleanup ---
if result
    # 5. Check the value *inside* the Ref object after the call.
    #    The C function modified the data held within the Ref.
    println("Value inside Ref after call:  ", p_ref[])
    # The original immutable 'p' variable is *unchanged*.
    println("Original variable 'p' (immutable) is unchanged: ", p)
end

try
    rm(temp_lib_path)
    println("\nRemoved temporary library: ", temp_lib_path)
catch e
    println("\nWarning: Could not remove temporary library '$temp_lib_path': ", e)
end
```

-----

### Explanation

This script demonstrates how to pass a Julia **`isbits struct`** (like our immutable `Point`) **by reference (as a pointer)** to a C function that expects to receive and potentially modify a C `struct` via a pointer.

## Core Concept: Identical Memory Layout & Passing Pointers

  * **`isbits struct` Layout:** As established in Module 9, an immutable Julia `struct` containing only `isbits` fields (like `Point` with its `Float64`s) has a **memory layout identical** to its corresponding C `struct`. This allows direct memory sharing.
  * **C Expects Pointers:** C functions often modify structs passed to them by taking a **pointer** (`Point* p`) rather than receiving the struct by value (`Point p`). Passing by pointer allows the C function to modify the original struct data in the caller's memory.
  * **Julia `Ref{T}` for `T*`:** When a C function expects a pointer `T*` where `T` is an `isbits` type (like `Point*`), the idiomatic and safe way to pass a Julia value `p` of type `T` is:
    1.  Wrap the Julia value in a `Ref`: `p_ref = Ref(p)`. This creates a small, GC-managed object on the heap that contains the `isbits` data (`p`).
    2.  Specify `Ref{Point}` as the corresponding Julia type in the `ccall` `ArgTypes` tuple.
    3.  Pass the `p_ref` object itself as the argument value to `ccall`.
  * **Behind the Scenes:** `ccall` recognizes the `Ref{Point}` argument type. It uses the internal function `Base.unsafe_convert(Ptr{Point}, p_ref)` (as seen in lesson 0091) to get a stable, GC-safe `Ptr{Point}` pointing to the data *inside* the `Ref` object. This raw pointer is then passed to the C function.

## How Modification Works

  * The C function `move_point` receives the `Ptr{Point}`.
  * It dereferences the pointer (`p->x`, `p->y`) and modifies the bytes **at that memory address**.
  * This memory address belongs to the data stored *inside* the Julia `Ref` object (`p_ref`).
  * After the `ccall` returns, the data within `p_ref` has been changed by the C code. We can observe this by accessing the value using `p_ref[]`.
  * **Immutability Note:** The original immutable variable `p` remains unchanged. The `Ref(p)` constructor copied the *value* of `p` into the mutable `Ref` container. The C function modified the data *inside the container*, not the original immutable `p`.

This `Ref{T}` mechanism provides a safe and standard way to bridge Julia's value types (`isbits struct`) with C's common pattern of passing structs by pointer for modification.

-----

  * **References:**
      * **Julia Official Documentation, Manual, "Calling C and Fortran Code", "Passing Pointers for Modifying Inputs":** Explains the use of `Ref{T}` for passing pointers to `isbits` types to C for modification.
      * **Julia Official Documentation, Base Documentation, `Ref`:** "Used to pass references to objects..."

-----

To run the script:

*(Requires `gcc` available.)*

```shell
$ julia 0117_ccall_passing_structs.jl
Compiling C code to libtemppoint.so...
Compilation successful.

--- Calling C function with Julia isbits struct ---
Julia Point p: Point(10.0, 20.0)
Boxed Ref(p):  Base.RefValue{Point}(Point(10.0, 20.0))
Value inside Ref before call: Point(10.0, 20.0)

ccall executed successfully.
Value inside Ref after call:  Point(15.0, 15.0)
Original variable 'p' (immutable) is unchanged: Point(10.0, 20.0)

Removed temporary library: /path/to/libtemppoint.so
```

*(Path and memory addresses will vary. The key is that `p_ref[]` shows the modified values.)*