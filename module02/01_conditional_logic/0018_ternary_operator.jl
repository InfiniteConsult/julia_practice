function get_parity_message(n)
    message = (n % 2 == 0) ? "even" : "odd"
    return "The number $n is $message"
end

println(get_parity_message(10))
println(get_parity_message(7))