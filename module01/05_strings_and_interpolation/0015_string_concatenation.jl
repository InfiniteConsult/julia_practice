str1 = "Hello"
str2 = "World"
combined = str1 * ", " * str2 * "!"
println("Concatenated with '*': ", combined)

println("-"^20)

parts = ["a", "b", "c", "d", "e"]
s_slow = ""
for part in parts
    global s_slow
    s_slow *= part
end
println("Result from slow loop: ", s_slow)

s_fast = join(parts)
println("Result from fast join: ", s_fast)
