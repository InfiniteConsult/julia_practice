http_codes = Dict(
    200 => "OK",
    404 => "Not Found",
    301 => "Moved Permanently"
)


println("--- Iterating over keys ---")
for key in keys(http_codes)
    println("Key: ", key)
end


println("\n--- Iterating over values ---")
for value in values(http_codes)
    println("Value: ", value)
end

println("\n--- Iterating over key-value pairs ---")
for (key, value) in http_codes
    println("Code $key means '$value'")
end