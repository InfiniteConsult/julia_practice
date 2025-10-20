import Base.Threads: @spawn, threadid
import Base: fetch

function cpu_intensive_work(id::Int, iterations::Int)
    println("Task $id: Starting on thread ", threadid())
    sum_val = 0.0
    for i in 1:iterations
        sum_val += sin(sqrt(float(i)))
    end
    println("Task $id: Finished on thread ", threadid(), " | Result: ", sum_val)
    return (id, sum_val)
end

println("Main script running on thread: ", threadid())
num_tasks = 4
iterations_per_task = 50_000_000

println("Spawning $num_tasks parrallel tasks using Threads.@spawn")

tasks = Vector{Task}(undef, num_tasks)

for i in 1:num_tasks
    tasks[i] = @spawn cpu_intensive_work(i, iterations_per_task)
end

println("All tasks spawned. Main thread continues while tasks run in parallel.")
println("Waiting for tasks to complete by calling fetch()...")

results = Vector{Any}(undef, num_tasks)
for i in 1:num_tasks
    println("Main: Waiting for Task ", i, "...")
    task_result = fetch(tasks[i])
    results[i] = task_result
    println("Main: Fetched result from Task ", i)
end

println("\nAll tasks complete.")
println("Collected results:")
for res in results
    println(" ", res)
end