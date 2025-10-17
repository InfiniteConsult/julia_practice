println("--- Demonstrating nested loops to create coordinate pairs ---")


for i in 1:3
    for j in 1:2
        println("Coordinate: (", i, ", ", j, ")")
    end
    println("--- Inner loop finished for i = ", i, " ---")
end
