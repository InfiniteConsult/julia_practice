mutable struct Point
    x::Float64
    y::Float64
end

function move_point(p::Point, dx::Float64, dy::Float64)
    return Point(p.x + dx, p.y + dy)
end

function move_point!(p::Point, dx::Float64, dy::Float64)
    p.x += dx
    p.y += dy
    return p
end

p1 = Point(10.0, 20.0)
println("Original point p1: ", p1)

println("\n--- Calling non-mutating function ---")
p2 = move_point(p1, 5.0, -5.0)
println("Returned new point p2: ", p2)
println("Original p1 remains unchanged: ", p1)

println("\n--- Calling mutating function ---")
move_point!(p1, 100.0, 100.0)
println("Original p1 IS NOW modified: ", p1)
