### `0037_symbols.jl`

```julia
# 0037_symbols.jl

# --- Symbols (Guaranteed Interning & Fast Identity Check) ---
sym1 = :http_status
sym2 = :http_status
println("--- Symbols ---")
println("Symbols are guaranteed to be interned (a single object in memory).")
println("`sym1 === sym2` is `true` because it's a fast identity check: ", sym1 === sym2)

println("\n" * "-"^20 * "\n")

# --- Strings (Separate Objects & Slower Content Check) ---
# This helper function ensures we create new, distinct string objects.
function build_string(parts...)
    return join(parts)
end

str1 = build_string("http", "_", "status")
str2 = build_string("http", "_", "status")

println("--- Strings ---")
println("Dynamically created strings are separate objects in memory.")
println("Memory address of str1: ", pointer_from_objref(str1))
println("Memory address of str2: ", pointer_from_objref(str2))

# == checks for value equality by comparing content byte-by-byte.
println("`str1 == str2` is `true` because contents are the same: ", str1 == str2)

# For immutable types like String, === ALSO compares content byte-by-byte.
# It returns `true` because they are bitwise identical, despite being different objects.
println("`str1 === str2` is `true` because immutables are compared by content: ", str1 === str2)
```

-----

### Explanation

This script demonstrates the critical performance distinction between `Symbol`s and `String`s, which stems from how they are stored and compared.

  * **`Symbol` (Identity Comparison)**: A `Symbol` is **interned**, meaning the language *guarantees* that only one copy of `:http_status` exists in memory. When you compare two symbols with `===`, Julia performs a single, fast **identity check**, which is as cheap as comparing two integer pointers. (NOTE: I am not really sure if this is how it works but seems sensible for an interned string)

  * **`String` (Content Comparison)**: A `String` is an immutable, heap-allocated object. When you create strings at runtime, Julia allocates separate, distinct objects in memory. This is proven by the different memory addresses shown by `pointer_from_objref()`.

      * **`==`**: Compares the strings' values, which involves a **byte-by-byte comparison** of their content.
      * **`===`**: Because `String` is an immutable type, `===` also performs a **byte-by-byte content comparison**. It returns `true` because their contents are bitwise identical, even though they are different objects in memory.

### The Real Performance Takeaway

The crucial difference is not *what* `===` returns, but *how* the comparison is performed.

  * **`Symbol` `===` `Symbol`**: A single, fast machine instruction (pointer comparison).
  * **`String` `===` `String`**: A potentially slow, full-content comparison (like `memcmp` in C).

This is why `Symbol`s are vastly more performant as `Dict` keys or in any scenario requiring frequent comparisons.