function is_true(label)
    println("Function '", label, "' was called and returns true.")
    return true
end


function is_false(label)
    println("Function '", label, "' was called and returns false.")
    return false
end

println("--- Demonstrating && (AND) ---")
println("Result: ", is_false("LHS") && is_true("RHS"))

println("\n--- Demonstrating || (OR) ---")
println("Result: ", is_true("LHS") || is_false("RHS"))

println("\n--- Demonstrating ! (NOT) ---")
println("Result: ", !is_false("NOT test"))