println("--- Primitive Types ---")
println("sizeof(Int8):         ", sizeof(Int8))
println("sizeof(Int16):        ", sizeof(Int16))
println("sizeof(Int32):        ", sizeof(Int32))
println("sizeof(Int64):        ", sizeof(Int64))
println("sizeof(Float64):      ", sizeof(Float64))
println("sizeof(Bool):         ", sizeof(Bool))

println("sizeof(Ptr{Nothing}): ", sizeof(Ptr{Nothing}))

println("\n--- isbits Structs ---")

struct Point
    x::Float64
    y::Float64
end
println("sizeof(Point):        ", sizeof(Point))

struct PaddedData
    a::Int8
    b::Int64
end
println("sizeof(PaddedData):   ", sizeof(PaddedData))

println("\n--- Non-isbits Types ---")

s = "hello"
v = [1, 2, 3]
println("sizeof(instance s):   ", sizeof(s))
println("sizeof(instance v):   ", sizeof(v))

println("\n--- Total Memory (Base.summarysize) ---")

println("Base.summarysize(s):  ", Base.summarysize(s))
println("Base.summarysize(v):  ", Base.summarysize(v))

p = Point(1.0, 2.0)
println("Base.summarysize(p):  ", Base.summarysize(p))
