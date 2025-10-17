point = (x=10, y=20, label="Start")

println("NamedTuple value: ", point)
println("NamedTuple type: ", typeof(point))

println("-"^20)

println("Access via name (point.x): ", point.x)
println("Access via name (point.label): ", point.label)

println("-"^20)

println("Access via index (point[1]): ", point[1])
println("Access via index (point[3]): ", point[3])

println("Keys: ", keys(point))
println("Values: ", values(point))
