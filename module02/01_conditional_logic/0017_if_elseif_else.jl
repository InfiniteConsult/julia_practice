function check_sign(n)
    if n > 0
        println("The number ", n, " is positive.")
    elseif n < 0
        println("The number ", n, " is negative.")
    else
        println("The number ", n, " is zero.")
    end
end

check_sign(10)
check_sign(-5)
check_sign(0)
