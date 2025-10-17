my_tuple = (10, "hello", true)
println("Tuple value: ", my_tuple)
println("Tuple type: ", typeof(my_tuple))

println("-"^20)

first_element = my_tuple[1]
second_element = my_tuple[2]

println("First element: ", first_element)
println("Second element: ", second_element)

println("-"^20)

(a, b, c) = my_tuple

println("Unpacked variable 'a': ", a)
println("Unpacked variable 'b': ", b)
println("Unpacked variable 'c': ", c)

try
    my_tuple[1] = 20
catch e
    println("\nError trying to modify a tuple: ", e)
end
