function get_first_element(arr::Vector{T}) where {T}
    println("Generic method called for Vector of type: ", T)
    if isempty(arr)
        return nothing
    else
        return arr[1]
    end
end

function get_first_element(arr::Vector{String})
    println("Specific method called for Vector{String}")
    if isempty(arr)
        return nothing
    else
        return uppercase(arr[1])
    end
end

int_vector = [10, 20, 30]
string_vector = ["apple", "banana"]
float_vector = [1.1, 2.2]
empty_vector = Int[]

println("--- Calling get_first_element() ---")

first_int = get_first_element(int_vector)
println("First int: ", first_int)

println("-"^20)

first_string = get_first_element(string_vector)
println("First string (uppercase): ", first_string)

println("-"^20)

first_float = get_first_element(float_vector)
println("First float: ", first_float)

println("-"^20)

first_empty = get_first_element(empty_vector)
println("First empty: ", first_empty)