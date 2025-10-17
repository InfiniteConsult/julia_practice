println("--- Using 'continue' and 'break' in a loop from 1 to 10 ---")

for i in 1:10
    if i == 3
        println("Skipping 3 with 'continue'")
        continue
    end

    if i == 8
        println("Exiting loop at 8 with 'break'...")
        break
    end

    println("Processing number: ", i)
end

println("loop finished")
