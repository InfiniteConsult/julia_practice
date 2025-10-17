function double(x)
    return x * 2
end
numbers = [1, 2, 3, 4]
doubled_numbers = map(double, numbers)
println("Doubled with standard function: ", doubled_numbers)

println("-"^20)

doubled_anon = map(x -> x * 2, numbers)
println("Doubled with anonymous function: ", doubled_anon)

list1 = [10, 20]
list2 = [1, 2]
sums = map((a, b) -> a + b, list1, list2)
println("Sums using multi-arg anonymous function: ", sums)

println("-"^20)

multiplier = 3
multiplied_capture = map(x -> x * multiplier, numbers)
println("Using captured variable 'multiplier': ", multiplied_capture)
