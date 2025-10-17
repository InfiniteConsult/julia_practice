fruits = ["Apple", "Banana", "Cherry"]

println("--- Iterating over a Vector of strings ---")
for fruit in fruits
    println("Processing: ", fruit)
end

println("\n--- Iterating with index and value using enumerate ---")
for (index, fruit) in enumerate(fruits)
    println("Item at index ", index, " is: ", fruit)
end