mutable struct MutablePoint
    x::Float64
    y::Float64
end

p1 = MutablePoint(10.0, 20.0)
println("Original mutable point p1: ", p1)

println("\nMutating p1.x = 30.0...")
p1.x = 30.0
println("Mutated point p1: ", p1)

p1.y += 5.0
println("Mutated point p1 again: ", p1)
println("isbits(p1) ", isbits(p1))
