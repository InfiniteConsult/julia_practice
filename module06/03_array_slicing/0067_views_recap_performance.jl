import BenchmarkTools: @btime

function process_data(data::AbstractVector{Float64})
    total = 0.0
    @inbounds for i in eachindex(data)
        total += data[i]
    end
    return total
end

N = 1_000_000
original_vector = rand(Float64, N)

start_idx = 1
end_idx = 500_000


println("--- Benchmarking Slice (Copying) ---")
@btime process_data(original_vector[$start_idx:$end_idx])

println("\n--- Benchmarking View (Zero-Copy) ---")
@btime process_data(@view original_vector[$start_idx:$end_idx])

view_obj = @view original_vector[start_idx:end_idx]

println("\nType of view object: ", typeof(view_obj))
println("Does view share memory with original? ", Base.mightalias(original_vector, view_obj))
