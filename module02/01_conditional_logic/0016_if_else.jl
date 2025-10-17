function check_parity(n)
    if n % 2 == 0
        println("The number ", n, " is even.")
    else
        println("The number ", n, " is odd.")
    end
end

check_parity(10)
check_parity(7)
