import SIMD: Vec, vload, vloada, sum
import BenchmarkTools: @btime

const N = 4
const VecType = Vec{N, Float64}

function sum_explicit_simd(A::Vector{Float64})
    @assert length(A) % N == 0 "Array length must be a multiple of SIMD width ($N)"
    vsum1 = zero(VecType)

    @inbounds for i in 1:N:length(A)
        v = vload(VecType, pointer(A, i))
        vsum1 += v
    end
    total_sum = sum(vsum1)

    return total_sum
end

len = 1_000_000
A = rand(Float64, len)

try
    include("0103_simd_macro.jl")
    println("Benchmarking previous @simd version:")
    @btime sum_array_simd($A)
catch e
    println("Could not load sum_array_simd for comparison: $e")
end

println("\nBenchmarking explicit SIMD (SIMD.jl):")
@btime sum_explicit_simd($A)