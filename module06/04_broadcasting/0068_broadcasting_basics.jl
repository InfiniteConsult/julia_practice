function square_element(x::Number)
    return x * x
end

numbers = [1, 2, 3, 4]

try
    result_fail = square_element(numbers)
catch e
    println("Caught expected error (scalar function on vector):")
    println(e)
end

result_broadcast = square_element.(numbers)

println("\nResult of broadcasting square_element.(numbers): ", result_broadcast)
println("Type of result: ", typeof(result_broadcast)) # A new Vector

plus_one = numbers .+ 1
times_two = numbers .* 2
powers = numbers .^ 2

println("\nBroadcasting operators:")
println("  numbers .+ 1: ", plus_one)
println("  numbers .* 2: ", times_two)
println("  numbers .^ 2: ", powers)

a = [10, 20]
b = [1, 2]
sums_broadcast = a .+ b
println("\nBroadcasting a .+ b: ", sums_broadcast)

sums_scalar = a .+ 100
println("Broadcasting a .+ 100: ", sums_scalar)
