abstract type AbstractShape end

struct Circle <: AbstractShape
    radius::Float64
end

struct Rectangle <: AbstractShape
    width::Float64
    height::Float64
end

mutable struct MutableSquare <: AbstractShape
    side::Float64
end

function calculate_area(s::AbstractShape)
    error("calculate_area not implemented for type ", typeof(s))
end

function calculate_area(c::Circle)
    return π * c.radius ^ 2
end

function calculate_area(r::Rectangle)
    return r.width * r.height
end

shapes = [Circle(1.0), Rectangle(2.0, 3.0), Circle(4.0)]

println("--- Processing heterogenous array of shapes ---")
for shape in shapes
    area = calculate_area(shape)
    println("Shape: ", shape, " | Area: ", area)
end

println("\n--- Testing unimplemented type ---")
s = MutableSquare(5.0)
try
    calculate_area(s)
catch e
    println("Caught expected error:")
    println(e)
end


