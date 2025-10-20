import BenchmarkTools: @btime

function sum_array_standard(A::Vector{Float64})
    total = 0.0
    @inbounds for i in eachindex(A)
        total += A[i]
    end
    return total
end

function sum_array_simd(A::Vector{Float64})
    total = 0.0
    @inbounds @simd for i in eachindex(A)
        total += A[i]
    end
    return total
end

A = rand(Float64, 1_000_000)

println("Benchmarking standard loop: ")
@btime sum_array_standard($A)

println("\nBenchmarking with @simd:")
@btime sum_array_simd($A)