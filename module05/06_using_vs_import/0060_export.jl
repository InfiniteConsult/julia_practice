include("MyGeometry2.jl")


println("--- Demonstrating 'using .MyGeometry2' ---")
using .MyGeometry2

c = Circle(10.0)
area = calculate_area(c)

println("  Created instance: ", c)
println("  Calculated area: ", area)

try
    _helper_function()
catch e
    println("\n  Caught expected error (not exported): ", e)
end

println("  Calling private function with qualification:")
MyGeometry2._helper_function()