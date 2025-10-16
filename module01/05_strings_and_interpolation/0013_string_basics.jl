single_line = "This is a standard string."
println(single_line)
println("Type: ", typeof(single_line))

println("-"^20)

multi_line = """
This is a multi-line string.
   The indentation on this line is preserved.
It can contain any character, like π or 😊.
"""
println(multi_line)

# Jeez, 1-based indexing. I've only encountered that in R before.
first_char = single_line[1]
println("The first character is: '", first_char, "', and its type is: ", typeof(first_char))

# Strings immutable like Python.
try
    single_line[1] = 't'
catch e
    println("Error trying to modify string: ", e)
end
