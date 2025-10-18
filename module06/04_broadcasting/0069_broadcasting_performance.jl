import BenchmarkTools: @btime

x = rand(Float64, 1_000_000)

println("--- Benchmarking Fused Broadcasting (Allocating): sin.(x .* 2.0 .+ 1.0) ---")
@btime sin.(($x) .* 2.0 .+ 1.0);

println("\n--- Benchmarking Non-Fused Operations (Allocating) ---")
function non_fused_calculation(x)
    temp1 = x .* 2.0
    temp2 = temp1 .+ 1.0
    result = sin.(temp2)
    return result
end

@btime non_fused_calculation($x);

println("\n--- Benchmarking Manual Loop (Allocating) ---")
function manual_loop_calculation(x)
    result = similar(x)
    @inbounds for i in eachindex(x)
        val_step1 = x[i] * 2.0
        val_step2 = val_step1 + 1.0
        result[i] = sin(val_step2)
    end
    return result
end

@btime manual_loop_calculation($x);

function inplace_calculation_view!(y_view, x_view)
    x_view .= sin.(x_view .* 2.0 .+ 1.0)
end

println("\n--- Benchmarking In-Place Broadcasting on View ---")
x_view = @view x[1:end]
x_view_copy = copy(x_view)
@btime inplace_calculation_view!($x_view_copy, $x_view_copy);