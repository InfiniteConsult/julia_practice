import Base.Libc: Cint, Clong, Csize_t, Cdouble, Cfloat, Cchar

println("--- Mapping C Types to Julia Types in ccall ---")

y_jl::Float64 = 1.0
x_jl::Float64 = -1.0

libm_spec = ""

result = try
    ccall(
        (:atan2, libm_spec),
        Cdouble,
        (Cdouble, Cdouble),
        y_jl,
        x_jl
    )
catch e
    println("ERROR calling atan2: ", e)
    NAN
end

if !isnan(result)
    println("C's atan2($y_jl, $x_jl):   ", result)
    julia_result = atan(y_jl, x_jl)
    println("Julia's atan($y_jl, $x_jl): ", julia_result)
    println("Results are approx equal: ", result ≈ julia_result)
end

println("\n--- Verifying C Type Sizes on this Platform ---")
println("sizeof(Cint):      ", sizeof(Cint))
println("sizeof(Clong):     ", sizeof(Clong))
println("sizeof(Clonglong): ", sizeof(Clonglong))
println("sizeof(Csize_t):   ", sizeof(Csize_t))
println("sizeof(Cchar):     ", sizeof(Cchar))
println("sizeof(Cfloat):    ", sizeof(Cfloat))
println("sizeof(Cdouble):   ", sizeof(Cdouble))