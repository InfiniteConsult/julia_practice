### `0034_dict_basics.jl`

```julia
# 0034_dict_basics.jl

# 1. A Dictionary (Dict) is created with the Dict() constructor.
#    The `key => value` syntax creates a Pair object.
http_codes = Dict(
    200 => "OK",
    404 => "Not Found",
    500 => "Internal Server Error"
)

println("Dictionary value: ", http_codes)
println("Dictionary type: ", typeof(http_codes))

println("-"^20)

# 2. Access values using the key in square brackets.
println("Code 200 means: ", http_codes[200])

# 3. Add a new key-value pair or update an existing one.
http_codes[302] = "Found"       # Add a new pair
http_codes[500] = "Server Error"  # Update an existing value
println("Updated dictionary: ", http_codes)

println("-"^20)

# 4. Use `haskey()` to check if a key exists before accessing it.
key_to_check = 404
if haskey(http_codes, key_to_check)
    println("Key $key_to_check exists with value: ", http_codes[key_to_check])
else
    println("Key $key_to_check does not exist.")
end

# 5. Use `get()` for safe access with a default fallback value.
#    This is often more concise than an if/else block.
value = get(http_codes, 999, "Unknown Code")
println("Value for non-existent key 999: ", value)
```

-----

### Explanation

This script introduces the **`Dict`**, Julia's primary hash map or associative array. It's the direct equivalent of `std::unordered_map` in C++, `HashMap` in Rust, or `dict` in Python.

  * **Creation**: A `Dict` is created with the `Dict()` constructor, which takes a collection of `Pair` objects. The most common way to create these pairs is with the intuitive `key => value` syntax. Julia infers the types, so the example creates a `Dict{Int64, String}`.

  * **Access and Modification**: Like vectors, `Dict`s are **mutable**. You use square bracket syntax (`my_dict[key]`) to both access and assign values. If the key already exists, the value is updated; otherwise, a new key-value pair is created.

  * **Safe Access**: Accessing a non-existent key with `my_dict[key]` will throw a `KeyError`. To avoid this, you have two primary methods for safe access:

    1.  **`haskey(dict, key)`**: This function returns `true` or `false`, allowing you to check for a key's existence inside an `if` statement.
    2.  **`get(dict, key, default)`**: This is often the preferred method. It attempts to retrieve the value for the key. If the key doesn't exist, it returns the `default` value you provide instead of throwing an error.

To run the script:

```shell
$ julia 0034_dict_basics.jl
Dictionary value: Dict(404 => "Not Found", 200 => "OK", 500 => "Internal Server Error")
Dictionary type: Dict{Int64, String}
--------------------
Code 200 means: OK
Updated dictionary: Dict(404 => "Not Found", 200 => "OK", 500 => "Server Error", 302 => "Found")
--------------------
Key 404 exists with value: Not Found
Value for non-existent key 999: Unknown Code
```