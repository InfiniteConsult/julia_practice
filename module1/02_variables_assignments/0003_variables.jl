x = 100
println("The value of x is: ", x)
println("The type of x is: ", typeof(x))

println("-"^20)

# Would have just killed type stability and performance
x = "Hello, Julia!"
println("The value of x is now: ", x)
println("The type of x is: ", typeof(x))