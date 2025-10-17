function add_numbers(x::Int, y::Int)
    result = x + y
    result
end

multiple_numbers(x, y) = x * y

sum_result = add_numbers(5, 3)
product_result = multiple_numbers(5, 3)

println("Result of add_numbers(5, 3): ", sum_result)
println("Result of multiply_numbers(5, 3): ", product_result)

function check_positive(n)
    if n > 0
        "Positive"
    else
        "Non-positive"
    end
end

println("Check positive for 10: ", check_positive(10))
println("Check positive for -2: ", check_positive(-2))
