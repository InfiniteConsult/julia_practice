### `0035_dict_iteration.jl`

```julia
# 0035_dict_iteration.jl

http_codes = Dict(
    200 => "OK",
    404 => "Not Found",
    301 => "Moved Permanently"
)

println("--- Iterating over keys ---")
# The `keys()` function returns an iterable collection of the dictionary's keys.
for key in keys(http_codes)
    println("Key: ", key)
end

println("\n--- Iterating over values ---")
# The `values()` function returns an iterable collection of the dictionary's values.
for value in values(http_codes)
    println("Value: ", value)
end

println("\n--- Iterating over key-value pairs ---")
# Iterating directly over the dictionary yields key-value pairs.
for (key, value) in http_codes
    println("Code $key means '$value'")
end
```

-----

### Explanation

This script demonstrates the common ways to iterate over a `Dict`.

  * **`keys(dict)`**: This function returns an efficient iterator over the keys of the dictionary. You can use this when you only need to work with the keys.

  * **`values(dict)`**: Similarly, this function provides an iterator for the dictionary's values.

  * **Direct Iteration (Key-Value Pairs)**: The most common iteration pattern is to loop directly over the dictionary itself. When you do this, Julia yields a `Pair` object (`key => value`) for each element. You can immediately destructure this pair into separate `key` and `value` variables, as shown in the line `for (key, value) in http_codes`.

**Important Note**: The order of iteration over a standard `Dict` is not guaranteed. The elements will be returned based on the internal layout of the hash table, not the order in which they were inserted.

To run the script:

```shell
$ julia 0035_dict_iteration.jl
--- Iterating over keys ---
Key: 404
Key: 200
Key: 301

--- Iterating over values ---
Value: Not Found
Value: OK
Value: Moved Permanently

--- Iterating over key-value pairs ---
Code 404 means 'Not Found'
Code 200 means 'OK'
Code 301 means 'Moved Permanently'
```