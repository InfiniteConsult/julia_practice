println("--- Primitives ---")
println("isbitstype(Int64):   ", isbitstype(Int64))
println("isbitstype(Float64): ", isbitstype(Float64))
println("isbitstype(Bool):    ", isbitstype(Bool))
println("isbitstype(Char):    ", isbitstype(Char))

println("\n--- Immutable Composites ---")

struct Point
    x::Float64
    y::Float64
end
println("isbitstype(Point):          ", isbitstype(Point))

println("isbitstype(NTuple{3, Int}): ", isbitstype(NTuple{3, Int}))

struct LabeledPoint
    p::Point
    label::String
end
println("isbitstype(LabeledPoint):   ", isbitstype(LabeledPoint))

println("\n--- Mutables and References ---")
mutable struct MutablePoint
    x::Float64
    y::Float64
end
println("isbitstype(MutablePoint):   ", isbitstype(LabeledPoint))


println("isbitstype(String):         ", isbitstype(String))
println("isbitstype(Vector{Int}):    ", isbitstype(Vector{Int}))
println("isbitstype(Dict{Int, Int}): ", isbitstype(Dict{Int, Int}))
println("isbitstype(Channel{Int}):   ", isbitstype(Channel{Int}))

println("isbitstype(Number):         ", isbitstype(Number))
println("isbitstype(AbstractArray):  ", isbitstype(AbstractArray))
