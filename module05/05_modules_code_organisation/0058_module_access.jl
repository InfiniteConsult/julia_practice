include("MyGeometry.jl")

println("--- Accessing module from separate file ---")
c = MyGeometry.Circle(5.0)
area = MyGeometry.calculate_area(c)

println("Created instance: ", c)
println("Calculated area: ", area)

try
    c_fail = Circle(2.0)
catch e
    println("\nCaught expected error:")
    println(e)
end