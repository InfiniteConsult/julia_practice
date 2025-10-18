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

try
    shape_fail = AbstractShape()
catch e
    println("Caught unexpected error:")
    println(e)
end

c = Circle(10.0)
r = Rectangle(5.0, 10.0)
s = MutableSquare(7.0)

println("\nConcrete instances:")
println("c = ", c)
println("r = ", r)
println("s = ", s)

println("\nType hierarchy checks:")
println("Circle <: AbstractShape? ", Circle <: AbstractShape)
println("Rectangle <: AbstractShape? ", Rectangle <: AbstractShape)
println("MutableSquare <: AbstractShape? ", MutableSquare <: AbstractShape)
println("typeof(c) <: AbstractShape? ", typeof(c) <: AbstractShape)

println("\n--- The Nuance of isbits ---")
println("isbits(c): ", isbits(c))
println("isbits(r): ", isbits(r))
println("isbits(s): ", isbits(s))

println("\nisbitstype(Circle): ", isbitstype(Circle))
println("isbitstype(Rectangle): ", isbitstype(Rectangle))
println("isbitstype(MutableSquare): ", isbitstype(MutableSquare))
