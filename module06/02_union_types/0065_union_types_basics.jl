const my_dictionary = Dict("a" => 1, "b" => 2)

function safe_get(key::String)::Union{Int64, Nothing}
    if haskey(my_dictionary, key)
        return my_dictionary[key]
    else
        return nothing
    end
end

println("--- Calling safe_get ---")

key_success = "a"
result_success = safe_get(key_success)

println("Result for key '$key_success': ", result_success)
println("Type of result: ", typeof(result_success))

if result_success !== nothing
    println("  Success! Value is: ", result_success * 10)
else
    println("  Key '$key_success' not found.")
end

println("-"^20)

key_fail = "c"
result_fail = safe_get(key_fail)

println("Result for key '$key_fail': ", result_fail)
println("Type of result: ", typeof(result_fail))

if result_fail !== nothing
    println("  Success! Value is: ", result_fail * 10)
else
    println("  Key '$key_fail' not found.")
end

println("\n--- isbits checks ---")
println("isbits(result_success): ", isbits(result_success))
println("isbits(result_fail):    ", isbits(result_fail))

println("isbitstype(Union{Int64, Nothing}): ", isbitstype(Union{Int64, Nothing}))