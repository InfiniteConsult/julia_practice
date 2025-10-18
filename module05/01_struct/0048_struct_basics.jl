struct Point
    x::Float64
    y::Float64
end

p1 = Point(10.0, 20.0)

println("Accessing field p1.x", p1.x)
println("Accessing field p1.y", p1.y)

println("\nInstance p1: ", p1)
println("Type of p1: ", typeof(p1))
println("isbits(p1) ", isbits(p1))

p2 = Point(10, 20)
println("Constructed from Ints: ", p2)
println("Type of p2: ", typeof(p2))

p3 = Point(10, 20.0)
println("Constructed from Int/Float: ", p3)

try
    p_fail = Point("hello", 20.0)
catch e
    println("\nError (as expected) on non-convertible type: ")
    println(e)
end