squares = [i ^ 2 for i in 1:5]

println("Vector of squares: ", squares)
println("Type: ", typeof(squares))

println("-"^20)

evens = [i for i in 1:10 if i % 2 == 0]

println("Vector of even numbers: ", evens)

println("-"^20)

evens_loop = Int[]
for i in 1:10
    if i % 2 == 0
        push!(evens_loop, i)
    end
end
println("Vector from manual loop: ", evens_loop)
