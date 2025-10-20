import Base.Threads: @spawn, Atomic, atomic_add!, atomic_cas!, nthreads

import Base: fetch

total_atomic = Atomic{Int}(0)
num_increments = 1_000_000

println("--- Correctly calculating sum using Atomics (Lock-Free) ---")
println("Using $(nthreads()) threads for $num_increments increments...")

tasks = Vector{Task}(undef, num_increments)

for i in 1:num_increments
    tasks[i] = @spawn begin
        atomic_add!(total_atomic, 1)
    end
end

fetch.(tasks)

final_value = total_atomic[]

println("Loop finished.")
println("Correct Atomic Total Sum: ", final_value)

println("\n--- Demonstrating Compare-And_Swap (CAS) ---")
current_val = total_atomic[]
expected = current_val
desired_new = current_val + 100

println("Current atomic value: ", current_val)
println("Attempting CAS: Expected=$expected, New=$desired_new")

old_val_read = atomic_cas!(total_atomic, expected, desired_new)

println("Value returned by CAS: ", old_val_read)

if old_val_read == expected
    println("CAS successful!")
    println("New atomic value: ", total_atomic[])
else
    println("CAS failed! Another thread likely modified the value.")
    println("Current atomic value remains: ", total_atomic[])
end

expected_wrong = current_val - 1
println("\nAttempting CAS with wrong expected value: Expected=$expected_wrong, New=0")
old_val_read_fail = atomic_cas!(total_atomic, expected_wrong, 0)

println("Value returned by failing CAS: ", old_val_read_fail)
if old_val_read_fail == expected_wrong
    println("CAS successful (unexpected!).")
else
    println("CAS failed as expected.")
    println("Atomic value is unchanged: ", total_atomic[])
end