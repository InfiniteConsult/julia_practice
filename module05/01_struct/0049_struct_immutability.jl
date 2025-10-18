struct Point
    x::Float64
    y::Float64
end

p1 = Point(10.0, 20.0)
println("Original point p1: ", p1)

try
    p1.x = 30.0
catch e
    println("\nCaught unexpected error:")
    println(e)
end

p2 = Point(p1.x + 5.0, p1.y)
println("\nCreated new point p2: ", p2)
println("Original point p1 is unchanged: ", p1)

