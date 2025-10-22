import Base.Libc: Cint, Cvoid
import Libdl

const c_code_callback = """
#include <stddef.h> // For NULL

typedef int (*compare_func)(int a, int b);

int do_comparison(int a, int b, compare_func func_ptr) {
    if (func_ptr == NULL) return -999;
    // Call the function provided by Julia
    return func_ptr(a, b);
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

const temp_lib_path = compile_c_code(c_code_callback, "libtempcallback")
if temp_lib_path === nothing
    println("Exiting due to compilation failure.")
    exit(1)
end

println("\n--- Calling C function with Julia Callback ---")

function julia_comparator(a::Cint, b::Cint)::Cint
    println("--- Julia Callback 'julia_comparator' Executing ---")
    println("    Received: a=$a, b=$b")
    if a > b
        return Cint(1)
    elseif a < b
        return Cint(-1)
    else
        return Cint(0)
    end
end

c_func_ptr = @cfunction(julia_comparator, Cint, (Cint, Cint))
println("Generated C function pointer: ", c_func_ptr)

result = try
    ccall(
        (:do_comparison, temp_lib_path),
        Cint,
        (Cint, Cint, Ptr{Cvoid}),
        Cint(10), Cint(5), c_func_ptr
    )
catch e
    println("ERROR during ccall: ", e)
    Cint(-999)
end

println("\nccall to 'do_comparison' finished.")
println("Result returned from C (via Julia callback): ", result)

try
    rm(temp_lib_path)
    println("\nRemoved temporary library: ", temp_lib_path)
catch e
    println("\nWarning: Could not remove temporary library '$temp_lib_path': ", e)
end