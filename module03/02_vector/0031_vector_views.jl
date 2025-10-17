original_vector = [10, 20, 30, 40, 50]

sub_view = @view original_vector[2:4]

println("Original vector: ", original_vector)
println("Sub-view: ", sub_view)
println("Type of sub-view: ", typeof(sub_view))

println("-"^20)

original_vector[2] = 999

println("Original vector after modification: ", original_vector)
println("Sub-view now reflects the change: ", sub_view)