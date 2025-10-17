http_codes = Dict(
    200 => "OK",
    404 => "Not found",
    500 => "Internal Server Error"
)

println("Dictionary value: ", http_codes)
println("Dictionary type: ", typeof(http_codes))


println("-"^20)

println("Code 200 means: ", http_codes[200])

http_codes[302] = "Found"
http_codes[500] = "Server Error"
println("Updated dictionary: ", http_codes)

println("-"^20)

key_to_check = 404

if haskey(http_codes, key_to_check)
    println("Key $key_to_check exists with value: ", http_codes[key_to_check])
else
    println("Key $key_to_check does not exist.")
end

value = get(http_codes, 999, "Unknown Code")
println("Value for non-existent key 999: ", value)
