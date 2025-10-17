function process_unannotated(data)
    println("Processing data of type: ", typeof(data))
    return data
end

function calculate_area(width::Int, height::Int)
    return width * height
end

function get_int_length(s::String)::Int
    len = length(s)
    return len
end

println("--- Unannotated ---")
process_unannotated(10)
process_unannotated("hello")


println("\n--- Annotated Arguments ---")
area = calculate_area(5, 4)
println("Calculated area: ", area)

try
    calculate_area(5.0, 4)
catch e
    println("Error calling with wrong type: ", e)
end

println("\n--- Annotated Return Type ---")
str_len = get_int_length("Julia")
println("Length of 'Julia': ", str_len)
println("Return type is indeed Int: ", typeof(str_len))
