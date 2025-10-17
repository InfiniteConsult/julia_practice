function create_greeting(name::String; greeting::String="Hello", punctuation::String="!")
    return "$greeting, $name$punctuation"
end


default_greeting = create_greeting("Julia")
println("Default greeting: ", default_greeting)

custom_greeting1 = create_greeting("World", greeting="Hi")
println("Custom greeting 1: ", custom_greeting1)

custom_greeting2 = create_greeting("Developers", punctuation="!!!", greeting="Welcome")
println("Custom greeting 2: ", custom_greeting2)

formal_greeting = create_greeting("Dr. Turing"; greeting="Good day")
println("Formal greeting: ", formal_greeting)
