println("--- dump(:(1 + 2 * 3)) ---")
ex1 = :(1 + 2 * 3)
dump(ex1)

println("\n" * "-"^30 * "\n")

println("--- dump(:(println(\"Hello \", name))) ---")
ex2 = :(println("Hello ", name))
dump(ex2)

println("\n" * "-"^30 * "\n")

println("--- dump(:(results[i] = compute(data[i]))) ---")
ex3 = :(results[i] = compute(data[i]))
dump(ex3)

println("\n" * "-"^30 * "\n")

println("--- dump(quote ... end) ---")
ex4 = quote
    x = 10
    if x > 5
        println("Greater")
    end
end
dump(ex4)