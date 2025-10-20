import Base.Threads: @spawn, ReentrantLock, lock, unlock, nthreads
import Base: fetch

const counter_lock = ReentrantLock()

total_sum_correct = 0.0
num_increments = 1_000_000

println("--- Correctly calculating sum using Lock ---")
println("Using $(nthreads()) for $num_increments increments...")

tasks = Vector{Task}(undef, num_increments)

for i in 1:num_increments
    tasks[i] = @spawn begin
        lock(counter_lock) do
            global total_sum_correct += 1.0            
        end
    end
end

fetch.(tasks)
println("Loop finished.")
println("Correct Total Sum (with lock): ", total_sum_correct)
