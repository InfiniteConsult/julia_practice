struct Container{T}
    value::T
end

c_float = Container{Float64}(10.0)
println("Container with explicit Float64:")
println("  Value: ", c_float.value)
println("  Type:  ", typeof(c_float))

c_int = Container(20)
println("\nContainer with inferred Int64:")
println("  Value: ", c_int.value)
println("  Type:  ", typeof(c_int))

c_string = Container("Hello")
println("\nContainer with inferred String:")
println("  Value: ", c_string.value)
println("  Type:  ", typeof(c_string))

println("\n--- Performance: isbits checks ---")
println("isbitstype(Container{Float64}): ", isbitstype(Container{Float64}))
println("isbitstype(Container{String}):  ", isbitstype(Container{String}))
println("isbitstype(Container):          ", isbitstype(Container))
