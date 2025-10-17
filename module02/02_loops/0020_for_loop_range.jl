println("--- Iterating from 1 to 5 ---")
println("typeof(1:5) ", typeof(1:5))
for i in 1:5
    println("Current value of i is: ", i)
end


println("\n--- Iterating with a step ---")
println("typeof(1:5) ", typeof(2:2:10))
for j in 2:2:10
    println("Current value of j is: ", j)
end
