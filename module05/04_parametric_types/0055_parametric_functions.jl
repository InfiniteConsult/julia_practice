struct Container{T}
    value::T
end

function get_value(c::Container{T})::T where {T}
    println("Generic 'get_value(c::Container{T})' called where T = ", T)
    return c.value
end

function get_value_and_type(c::Container{T})::Tuple{T, Type} where {T}
    println("Function 'get_value_and_type' called, where T = ", T)
    return (c.value, T)
end

function get_value(c::Container{String})::String
    println("Specific 'get_value(c::Container{String})' called!")
    return uppercase(c.value)
end

c_int = Container(100)
c_str = Container("hello")
c_flt = Container(3.14)

println("--- Calling generic methods ---")
val_int = get_value(c_int)
println("  Got value: ", val_int)

val_flt, type_flt = get_value_and_type(c_flt)
println("  Got value: ", val_flt, " | Got type: ", type_flt)

println("\n--- Calling specific method (dispatch) ---")
val_str = get_value(c_str)
println("  Got value: ", val_str)
