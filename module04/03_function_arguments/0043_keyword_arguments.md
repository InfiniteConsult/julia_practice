### `0043_keyword_arguments.jl`

```julia
# 0043_keyword_arguments.jl

# 1. Define a function with keyword arguments after a semicolon.
#    Keyword arguments must have default values.
function create_greeting(name::String; greeting::String="Hello", punctuation::String="!")
    return "$greeting, $name$punctuation"
end

# 2. Call the function using only positional arguments.
#    Keyword arguments will use their default values.
default_greeting = create_greeting("Julia")
println("Default greeting: ", default_greeting)

# 3. Call the function, overriding some keyword arguments by name.
#    The order of keyword arguments does not matter.
custom_greeting1 = create_greeting("World", greeting="Hi")
println("Custom greeting 1: ", custom_greeting1)

custom_greeting2 = create_greeting("Developers", punctuation="!!!", greeting="Welcome")
println("Custom greeting 2: ", custom_greeting2)

# 4. Mixing positional and keyword arguments.
#    Positional arguments must always come before keyword arguments.
#    This syntax is clear: create_greeting("Positional"); kw1=val1, kw2=val2...
formal_greeting = create_greeting("Dr. Turing"; greeting="Good day")
println("Formal greeting: ", formal_greeting)
```

-----

### Explanation

This script introduces **keyword arguments**, which allow you to pass arguments to a function by name, making the call site more readable and allowing for optional parameters with default values. 🏷️

  * **Syntax**: Keyword arguments are defined in the function signature **after** a semicolon (`;`). Each keyword argument must be given a **default value**.

    ```julia
    function func(positional_arg; keyword_arg1=default1, keyword_arg2=default2)
        # ...
    end
    ```

  * **Calling**: When calling a function with keyword arguments:

      * You can omit them entirely, in which case their default values are used (`create_greeting("Julia")`).
      * You can provide values for specific keywords using the `keyword=value` syntax (`greeting="Hi"`).
      * The order in which you provide keyword arguments does not matter (`punctuation="!!!", greeting="Welcome"` works).
      * All **positional arguments** (if any) must come **before** any keyword arguments.

  * **Use Cases**: Keyword arguments are excellent for:

      * Functions with many arguments where specifying them by name improves clarity.
      * Optional configuration parameters.
      * Providing a more stable API (adding new keyword arguments doesn't break existing calls that don't use them).

This feature is very similar to keyword arguments in Python.

To run the script:

```shell
$ julia 0043_keyword_arguments.jl
Default greeting: Hello, Julia!
Custom greeting 1: Hi, World!
Custom greeting 2: Welcome, Developers!!!
Formal greeting: Good day, Dr. Turing!
```