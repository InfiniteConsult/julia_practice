import BenchmarkTools: @btime

include("my_math.jl")

function sum_of_add_two(n::Int)
    total = 0
    for i in 1:n
        total += MyMath.add_two(i)
    end
    return total
end

println("--- Benchmarking sum_of_add_two(1000) ---")

@btime sum_of_add_two(1000)

input_size = 10000
println("\n--- Benchmarking sum_of_add_two(input_size) ---")
@btime sum_of_add_two(input_size)
println("(Note: This result might be inaccurate, see next lesson on interpolation)")
