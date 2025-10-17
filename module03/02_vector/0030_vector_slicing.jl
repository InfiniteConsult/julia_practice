original_vector = [10, 20, 30, 40, 50]

sub_vector = original_vector[2:4]

println("Original vector: ", original_vector)
println("Sub-vector (slice): ", sub_vector)
println("Type of sub-vector: ", typeof(sub_vector))

println("-"^20)

original_vector[2] = 999

println("Original vector after modification: ", original_vector)
println("Sub-vector remains unchanged: ", sub_vector)



