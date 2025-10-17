### `0028_tuple_performance.md`

### Explanation

For a systems programmer, understanding *why* a data structure is fast is as important as knowing how to use it. Tuples and `NamedTuple`s are among the most performant data structures in Julia because of how the compiler treats them.

-----

## Why Tuples are Fast

A tuple in Julia is conceptually very similar to a `struct` in C.

Consider this C `struct`:

```c
struct Point {
    int x;
    double y;
};
```

And this Julia `NamedTuple`:

```julia
point = (x=10, y=3.14)
```

The Julia compiler can optimize the `NamedTuple` to have a memory layout and performance profile that is virtually identical to the C `struct`. Here’s why:

1.  **Immutable**: Because tuples cannot be changed after creation, the compiler has a strong guarantee about their state. It knows the values and types inside a tuple are fixed for its entire lifetime.

2.  **Fixed-Size and Type-Stable**: The size, type, and order of elements in a tuple are known at compile time. This allows the compiler to generate specialized, highly efficient machine code to access its elements. There is no dynamic lookup; accessing `point.x` can be compiled down to a simple memory offset from a base pointer, just like accessing a member of a C `struct`.

3.  **Stack Allocation**: For small, simple tuples (containing primitive types like numbers), the compiler will often allocate them directly on the **stack** instead of the heap. Stack allocation is significantly faster than heap allocation because it's just a matter of moving the stack pointer. This completely avoids the overhead of the garbage collector (GC), making their use in tight loops extremely cheap.

In summary, you should feel confident using tuples and `NamedTuple`s in performance-critical code. They are not like Python tuples, which carry extra overhead. Julia tuples are lightweight, compile-time constructs that map very closely to the efficient memory layouts you are used to in C, C++, and Rust.