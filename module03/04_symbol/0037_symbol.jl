sym1 = :http_status
sym2 = :http_status
println("--- Symbols ---")
println("Symbols are guaranteed to be interned (a single object in memory).")
println("`sym1 === sym2` is `true` because it's a fast identity check: ", sym1 === sym2)

println("\n" * "-"^20 * "\n")

function build_string(parts...)
    return join(parts)
end

str1 = build_string("http", "_", "status")
str2 = build_string("http", "_", "status")

println("--- Strings ---")
println("Dynamically created strings are separate objects in memory.")
println("Memory address of str1: ", pointer_from_objref(str1))
println("Memory address of str2: ", pointer_from_objref(str2))

println("`str1 == str2` is `true` because contents are the same: ", str1 == str2)
println("`str1 === str2` is `true` because immutables are compared by content: ", str1 === str2)