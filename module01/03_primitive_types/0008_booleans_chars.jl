is_active = true
is_complete = false

println("Value of is_active: ", is_active, ", Type: ", typeof(is_active))
println("Value of is_complete: ", is_complete, ", Type: ", typeof(is_complete))

println("-"^20)

# To all Python programmers: single quotes are supposed to be for char
letter_a = 'a'
unicode_char = 'Ω'

println("Value of letter_a: ", letter_a, ", Type: ", typeof(letter_a))
println("Value of unicode_char: ", unicode_char, ", Type: ", typeof(unicode_char))

code_point = UInt32(unicode_char)
println("The Unicode codepoint for 'Ω' is: ", code_point)