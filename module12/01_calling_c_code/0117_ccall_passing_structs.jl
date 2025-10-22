import Base.Libc: Cdouble, Cvoid
import Libdl

struct Point
    x::Float64
    y::Float64
end


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

println("\n--- Calling C function with Julia isbits struct ---")

p = Point(10.0, 20.0)

p_ref = Ref(p)

println("Julia Point p: ", p)
println("Boxed Ref(p):  ", p_ref)
println("Value inside Ref before call: ", p_ref[])

result = try
    ccall(
        (:move_point, temp_lib_path),
        Cvoid,
        (Ref{Point}, Cdouble, Cdouble),
        p_ref, 5.0, -5.0
    )
    println("\nccall executed successfully.")
    true
catch e
    println("\nERROR during ccall: ", e)
    false
end

if result
    println("Value inside Ref after call:  ", p_ref[])
    println("Original variable 'p' (immutable) is unchanged: ", p)
end

try
    rm(temp_lib_path)
    println("\nRemoved temporary library: ", temp_lib_path)
catch e
    println("\nWarning: Could not remove temporary library '$temp_lib_path': ", e)
end