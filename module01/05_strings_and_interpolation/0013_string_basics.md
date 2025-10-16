### `0013_string_basics.jl`

```julia
# 0013_string_basics.jl

# A standard, single-line string is created with double quotes.
single_line = "This is a standard string."
println(single_line)
println("Type: ", typeof(single_line))

println("-"^20)

# Multi-line strings are created with triple-double quotes.
# Indentation and newlines within the quotes are preserved.
multi_line = """
This is a multi-line string.
  The indentation on this line is preserved.
It can contain any character, like π or 😊.
"""
println(multi_line)

# Strings are sequences, and you can access characters by index.
# Note: Julia uses 1-based indexing, not 0-based like C++/Python/Rust.
first_char = single_line[1]
println("The first character is: '", first_char, "', and its type is: ", typeof(first_char))

# Attempting to modify a character will cause an error because strings are immutable.
try
    single_line[1] = 't'
catch e
    println("Error trying to modify string: ", e)
end
```

### Explanation

This script covers the basics of creating and interacting with strings in Julia.

  * **Literals**:

      * Single-line strings are enclosed in double quotes (`"`).
      * Multi-line strings are enclosed in triple-double quotes (`"""`). This is a convenient feature for embedding blocks of text, similar to Python's triple quotes.

  * **Encoding**: Julia strings are UTF-8 encoded by default. This means they can natively store any Unicode character without any special handling.

  * **1-Based Indexing**: A major difference from C/C++/Python/Rust is that Julia uses **1-based indexing**. The first element of any sequence is at index `1`.

  * **Immutability**: Strings in Julia are **immutable**. You cannot change the characters of an existing string. When you "modify" a string (e.g., through concatenation), you are actually creating a completely new string in memory. This is a critical design feature that ensures safety and predictable performance, as the compiler doesn't need to worry about the string's contents changing unexpectedly.

  * **`String` vs. `Char`**: When you index into a `String`, you get a value of type `Char`, which represents a single Unicode code point.

To run the script:

```shell
$ julia 0013_string_basics.jl
This is a standard string.
Type: String
--------------------
This is a multi-line string.
  The indentation on this line is preserved.
It can contain any character, like π or 😊.

The first character is: 'T', and its type is: Char
Error trying to modify string: MethodError(f=setindex!, args=(...))
```