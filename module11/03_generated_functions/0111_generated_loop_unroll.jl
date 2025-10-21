import BenchmarkTools: @btime

function dot_runtime(a::Union{Tuple, AbstractVector}, b::Union{Tuple, AbstractVector})
    len_a = length(a)
    len_b = length(b)

    if len_a != len_b
        throw(DimensionMismatch("Vectors must have same length"))
    end

    s = 0.0
    @inbounds for i in 1:len_a
        s += a[i] * b[i]
    end
    return s
end

@generated function dot_compiletime_unrolled(
    a::NTuple{N, T},
    b::NTuple{N, T}
) where {N, T<:Number}
    println("  (@generated running dot_unrolled for N=$N, T=$T)")
    if N == 0
        return :(zero(Float64))
    end

    ex = :(a[1] * b[1])
    for i in 2:N
        ex = :($ex + a[$i] * b[$i])
    end

    println("    Generated code for N=$N: ", ex)
    return ex
end

println("\n--- Benchmarking ---")

a_ntup = (1.0, 2.0, 3.0, 4.0)
b_ntup = (5.0, 6.0, 7.0, 8.0)

a_vec = [1.0, 2.0, 3.0, 4.0]
b_vec = [5.0, 6.0, 7.0, 8.0]

println("Benchmarking dot_runtime (Vector input):")
@btime dot_runtime($a_vec, $b_vec)

println("\nBenchmarking dot_compiletime_unrolled (NTuple input):")
@btime dot_compiletime_unrolled($a_ntup, $b_ntup)

println("\n--- Verification ---")
res_runtime = dot_runtime(a_vec, b_vec)
res_unrolled = dot_compiletime_unrolled(a_ntup, b_ntup)
println("Runtime result:   ", res_runtime)
println("Unrolled result:  ", res_unrolled)
println("Results match:    ", res_runtime ≈ res_unrolled)