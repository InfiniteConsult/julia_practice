### `0038_symbol_performance.md`

(NOTE: I am really unsure if any of this is right)

### Explanation

For performance, the distinction between a `Symbol` and a `String` is one of the most important in Julia. While both can represent text, their performance characteristics for comparisons are fundamentally different, which directly impacts their use as dictionary keys.

---
## The Performance Difference: Identity vs. Value

A `Symbol` is an **interned string**. The language *guarantees* that only one copy of a particular symbol exists in memory. This means comparing two symbols for equality is as fast as comparing two integers.

A `String` is a **heap-allocated object**. When you create strings at runtime (e.g., by reading from a file), new, distinct objects are allocated.

Let's analyze what happens during a comparison, which is a key step in a dictionary lookup:

* **`sym1 === sym2`**: This is an **identity check**. Because `:http_status` is guaranteed to be a single, unique object in memory, this comparison is a single, fast machine instruction—essentially a pointer comparison.

* **`str1 == str2`**: This is a **value check**. It must compare the content of the two string objects byte-by-byte to ensure they are the same. For long strings, this can be significantly slower than a simple pointer check.

### Why This Matters for `Dict` Keys

When you use an object as a key in a `Dict`, Julia needs to find the correct value. This involves two main steps:

1.  **Hashing**: Calculating a hash value from the key to quickly find the right "bucket" in the hash table. Both `Symbol` and `String` have fast hash functions.
2.  **Equality Checking**: If multiple keys have the same hash (a "hash collision"), Julia must compare your key with the keys in the bucket to find the exact match.

This second step is where the performance difference becomes critical:
* **With `Symbol` keys**: The equality check is a lightning-fast `===` identity check.
* **With `String` keys**: The equality check is a potentially slow, byte-by-byte `==` value check.

**Rule of Thumb**: When you need to use a text-based identifier as a key in a performance-sensitive `Dict` or in any situation requiring many comparisons, **always prefer `Symbol` over `String`**.