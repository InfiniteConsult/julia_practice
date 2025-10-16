### `0003_variables.jl`

```julia
# 0003_variables.jl

# 1. Assign an integer value to a variable named 'x'
x = 100
println("The value of x is: ", x)
println("The type of x is: ", typeof(x))

println("-"^20) # Print a separator line

# 2. Reassign a new value of a different type (a String) to the same variable
x = "Hello, Julia!"
println("The value of x is now: ", x)
println("The type of x is now: ", typeof(x))
```

### Explanation

This script demonstrates fundamental variable assignment and the dynamic nature of Julia's type system.

  * **Assignment**: The `=` operator is used to assign or *bind* a value to a variable name.

  * **Dynamic Types**: Unlike C++ or Rust, you do not need to declare a variable's type before using it. Julia is dynamically typed, which means a variable is simply a name bound to a value, and the type is associated with the value itself, not the variable name. As shown in the example, the variable `x` can first hold an integer (`Int64` by default on a 64-bit system) and then be reassigned to hold a `String`.

  * **`typeof()`**: This built-in function returns the type of the value that its argument currently refers to. It's a useful tool for interactive exploration and debugging.

To run the script:

```shell
$ julia 0003_variables.jl
The value of x is: 100
The type of x is: Int64
--------------------
The value of x is now: Hello, Julia!
The type of x is now: String
```