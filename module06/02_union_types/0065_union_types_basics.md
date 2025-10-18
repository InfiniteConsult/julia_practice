### `0065_union_types_basics.jl`

```julia
# 0065_union_types_basics.jl

# 1. Define a function that might fail predictably.
# A dictionary lookup is a perfect example: the key might not exist.
const my_dictionary = Dict("a" => 1, "b" => 2)

# 2. Function returning a Union type for error handling.
# The return type annotation 'Union{Int64, Nothing}' explicitly states
# that this function will return *either* an Int64 on success
# or the special value 'nothing' on failure.
function safe_get(key::String)::Union{Int64, Nothing}
    if haskey(my_dictionary, key)
        return my_dictionary[key] # Returns Int64
    else
        return nothing           # Returns Nothing
    end
end

# 3. Call the function and handle the Union result.
println("--- Calling safe_get ---")

key_success = "a"
result_success = safe_get(key_success)

# Check the type of the result
println("Result for key '$key_success': ", result_success)
println("Type of result: ", typeof(result_success)) # Int64

# Idiomatic check for the 'nothing' failure case
if result_success !== nothing
    println("  Success! Value is: ", result_success * 10)
else
    println("  Key '$key_success' not found.")
end

println("-"^20)

key_fail = "c"
result_fail = safe_get(key_fail)

println("Result for key '$key_fail': ", result_fail)
println("Type of result: ", typeof(result_fail)) # Nothing

if result_fail !== nothing
    println("  Success! Value is: ", result_fail * 10)
else
    println("  Key '$key_fail' not found.")
end

# 4. 'isbitstype' vs 'isbits' check
println("\n--- isbits checks ---")
# isbits(x) is true if typeof(x) is an isbitstype
println("isbits(result_success): ", isbits(result_success)) # true (Int64 is isbits)
println("isbits(result_fail):    ", isbits(result_fail))    # true (Nothing is isbits)

# The Union *type* itself is not isbits because it's abstract.
println("isbitstype(Union{Int64, Nothing}): ", isbitstype(Union{Int64, Nothing})) # false
```

### Explanation

This script introduces **`Union` types**, demonstrating their idiomatic use for handling predictable failure conditions in a type-stable and efficient way.

  * **Core Concept: `Union{TypeA, TypeB, ...}`**
    A `Union` type represents a value that could be one of several specified types. `Union{Int64, Nothing}` means "this variable can hold *either* an `Int64` *or* the value `nothing`."

  * **Error Handling Pattern:**
    Returning a `Union` like `Union{ResultType, Nothing}` (or `Union{ResultType, ErrorCode}`) is Julia's preferred pattern for functions that might fail in expected ways. Instead of throwing an exception (which is computationally expensive), the function returns a value indicating success or failure.

      * `safe_get` implements this: on success, it returns the `Int64` value; on failure (key not found), it returns the special singleton value `nothing`.
      * The **caller** is then responsible for checking the return type. The idiomatic check is `if result !== nothing`. The `!==` operator checks for strict identity (and type) and is very fast.

  * **Performance: Small `Union`s are Efficiently Stored**

      * While the `Union{Int64, Nothing}` *type itself* is technically abstract and therefore `isbitstype` returns `false`, Julia's compiler includes **crucial optimizations** for small unions like this, especially when they are used **inside arrays or structs**.
      * **How? (Inline Storage + Type Tag):** The compiler stores the data **inline** (using enough space for the largest member, `Int64`) and uses a hidden **type tag** byte to track whether an `Int64` or `Nothing` is currently stored.
      * **Result:** Accessing values from such a `Union` field or array element is very fast (check tag, read inline data) and avoids heap allocation ("boxing") and pointer chasing. Checking `if result !== nothing` compiles down to a simple, fast check of this internal type tag.
      * This optimization makes the `Union{ResultType, Nothing}` pattern a high-performance alternative to exceptions for predictable failure modes.

  * **`isbits` vs. `isbitstype` Clarification:**

      * `isbitstype(T::Type)` asks: "Does the type `T` itself describe a single, fixed, C-like memory layout?" For `Union{Int64, Nothing}`, the answer is **`false`** because the `Union` type is abstract; its representation depends on the current value.
      * `isbits(x)` asks: "Is the *value* `x` of an `isbits` type?" Since both `Int64` and `Nothing` are `isbits` types, `isbits(result_success)` and `isbits(result_fail)` both return **`true`**.

  * **Contrast with Exceptions:**
    This `Union` return pattern should be preferred over `try...catch` for common, expected failure modes like dictionary lookups, parsing attempts (`tryparse`), or finding items in a list. Exceptions are reserved for truly *exceptional* or unexpected errors where the high cost of stack unwinding is acceptable.

  * **References:**

      * **Julia Official Documentation, Manual, "Types", "Union Types":** "Union types are a special abstract type..."
      * **Julia Official Documentation, `devdocs`, "isbits Union Optimizations":** Details how Julia stores `isbits Union` fields and arrays inline using type tags for performance, confirming the efficiency despite the `Union` type being abstract.
      * **Julia Official Documentation, `isbits(x)` and `isbitstype(T)`:** Clarify the distinction between checking a value and checking a type.

To run the script:

```shell
$ julia 0065_union_types_basics.jl
--- Calling safe_get ---
Result for key 'a': 1
Type of result: Int64
  Success! Value is: 10
--------------------
Result for key 'c': nothing
Type of result: Nothing
  Key 'c' not found.

--- isbits checks ---
isbits(result_success): true
isbits(result_fail):    true
isbitstype(Union{Int64, Nothing}): false
```