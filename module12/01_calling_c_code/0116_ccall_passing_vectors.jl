import Base.Libc: Csize_t, Cdouble
import Libdl

const c_code_sum = """
#include <stddef.h> // for size_t
double sum_array(const double* arr, size_t len) {
    double sum = 0.0;
    for (size_t i = 0; i < len; i++) {
        sum += arr[i];
    }
    return sum;
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
        return abspath(lib_filename) # Return full path
    catch e
        println("ERROR compiling C code: ", e)
        return nothing
    end
end

const temp_lib_path = compile_c_code(c_code_sum, "libtempsum")
if temp_lib_path === nothing
    println("Exiting due to compilation failure.")
    exit(1)
end

println("\n--- Calling C function with Julia Vector ---")
julia_vector = Float64[1.1, 2.2, 3.3, 4.4, 5.5]

ptr_to_data = pointer(julia_vector)
vector_length = length(julia_vector)

println("Julia Vector: ", julia_vector)
println("Pointer to data: ", ptr_to_data)
println("Vector length: ", vector_length)

result = try
    ccall(
        (:sum_array, temp_lib_path),
        Cdouble,
        (Ptr{Cdouble}, Csize_t),
        ptr_to_data, vector_length
    )
catch e
    println("ERROR during ccall: ", e)
    NaN
end

if !isnan(result)
    println("\nResult from C's sum_array: ", result)
    julia_sum = sum(julia_vector)
    println("Julia's sum():             ", julia_sum)
    println("Results approximately equal: ", result ≈ julia_sum)
end

try
    rm(temp_lib_path)
    println("\nRemoved temporary library: ", temp_lib_path)
catch e
    println("\nWarning: Could not remove temporary library '$temp_lib_path': ", e)
end