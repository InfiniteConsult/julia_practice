my_vector = [10, 20, 30]

println("Vector value: ", my_vector)
println("Vector type: ", typeof(my_vector))
println("Initial length: ", length(my_vector))

println("-"^20)

push!(my_vector, 40)
push!(my_vector, 50)

println("Vector after pushing elements: ", my_vector)
println("New length: ", length(my_vector))

println("-"^20)

println("Element at index 2: ", my_vector[2])
my_vector[2] = 25
println("Vector after modification: ", my_vector)