function slow_operation(id::Int, duration::Float64)
    println("Task $id: Starting on thread ", Threads.threadid())
    sleep(duration)
    println("Task $id: Finished after $duration seconds.")
end

println("--- Part 1: @async without @sync ---")
println("Main code running on thread ", Threads.threadid())

t1 = @async slow_operation(1, 1.0)
t2 = @async slow_operation(2, 0.5)

println("Tasks 1 and 2 launched. Main code continues...")
sleep(1.5)
println("Main code finished Part 1.")


println("\n--- Part 2: @async within @sync ---")
println("Main code starting @sync block...")

@sync begin
    println("Inside @sync block, launching tasks...")
    @async slow_operation(3, 1.0)
    @async slow_operation(4, 0.5)
    println("Tasks 3 and 4 launched within @sync")
end

println("Main code finished @sync block. All tasks completed.")