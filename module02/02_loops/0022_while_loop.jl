println("-- Countdown from 5 using a while loop ---")
n = 5

while n > 0
    println("Current value of n is: ", n)
    global n -= 1
end

println("Blast off!")
