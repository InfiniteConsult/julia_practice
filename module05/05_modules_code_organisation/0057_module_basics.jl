module MyGeometry

abstract type AbstractShape end

struct Circle <: AbstractShape
    radius::Float64
end


struct Rectangle <: AbstractShape
    width::Float64
    height::Float64
end

function calculate_area(c::Circle)
    return π * c.radius^2
end

function calculate_area(r::Rectangle)
    return r.width * r.height
end

function _helper_function()
    println("This is a private helper.")
end

const PI_Approximation = 3.14159

end

println("--- Accessing the module from 'Main' ---")
println("Type of MyGeometry: ", typeof(MyGeometry))

println("\nAccessing constant: ", MyGeometry.PI_Approximation)

c = MyGeometry.Circle(10.0)
println("Created instance: ", c)


area = MyGeometry.calculate_area(c)
println("Calculated area: ", area)
