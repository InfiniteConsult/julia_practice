function compute_value(id::Int, duration::Float64)
    println("Task $id: Starting computation...")
    sleep(duration)
    result = id * 100
    println("Task $id: Finished computation, returning $result.")
    return result
end

println("--- Launching tasks with @async ---")

task_a = @async compute_value(1, 1.0)
task_b = @async compute_value(2, 0.5)

println("Tasks launched. Main code continues...")
println("Type of task_a: " , typeof(task_a))

println("\nWaiting for Task B...")
result_b = fetch(task_b)
println("Result from Task B: ", result_b)
println("Type of result_b: ", typeof(result_b))

println("\nWaiting for Task A...")
result_a = fetch(task_a)
println("Result from Task B: ", result_a)
println("Type of result_b: ", typeof(result_a))


println("\n--- Fetching after @sync ---")
local result_c, result_d
@sync begin
    local task_c = @async compute_value(3, 0.8)
    local task_d = @async compute_value(4, 0.3)
end

tasks = []

@sync begin
    push!(tasks, @async compute_value(5, 0.6))
    push!(tasks, @async compute_value(6, 0.2))
end


println("Fetching results after @sync using a collection:")
results = fetch.(tasks)
println("Results [5, 6]: ", results)

println("\nMain code finished.")
