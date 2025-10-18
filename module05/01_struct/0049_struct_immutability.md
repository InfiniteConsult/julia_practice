### `0049_struct_immutability.jl`

```julia
# 0049_struct_immutability.jl

# 1. Define the same immutable 'Point' struct
struct Point
    x::Float64
    y::Float64
end

# 2. Create an instance
p1 = Point(10.0, 20.0)
println("Original point p1: ", p1)

# 3. Attempt to modify a field of the immutable struct
try
    p1.x = 30.0
catch e
    println("\nCaught expected error:")
    println(e)
end

# 4. The "correct" way to "modify" an immutable object
# is to create a new one based on the old one.
p2 = Point(p1.x + 5.0, p1.y)
println("\nCreated new point p2: ", p2)
println("Original point p1 is unchanged: ", p1)
```

### Explanation

This script demonstrates the core concept of **immutability**, which is the default behavior for Julia `struct`s.

  * **Core Concept:** An immutable object is one whose state **cannot be modified** after it is created. The `struct Point` we defined is immutable. When we create `p1`, the values `10.0` and `20.0` are locked in.

  * **The Error:** The line `p1.x = 30.0` attempts to assign a new value to the `x` field. This is a fundamental violation of the `struct`'s immutable contract. Julia intercepts this and fails, resulting in a `Setfield! Error` which explicitly states that `Point` is immutable and its fields cannot be changed.

  * **Why Immutability is a Feature, Not a Bug:**

    1.  **Performance:** Immutability is a powerful signal to the compiler. Because the compiler *knows* the data inside `p1` will never change, it can perform aggressive optimizations. It can store `p1` directly in **CPU registers**, allocate it on the **stack** (which is much faster than the heap), or even eliminate the object entirely and just inline its fields.
    2.  **Thread Safety:** Immutable objects are inherently **thread-safe**. You can share `p1` across thousands of threads, and no locks are needed because no thread can *write* to it. This eliminates an entire class of complex concurrency bugs.
    3.  **Program Logic:** It makes code easier to reason about. When you pass `p1` to a function, you are 100% guaranteed that the function cannot change it, preventing "action at a distance" bugs.

  * **The Idiomatic Pattern:** The idiomatic way to "modify" an immutable object is to create a **new** object. The line `p2 = Point(p1.x + 5.0, p1.y)` does not change `p1`. It reads the values from `p1`, creates a *brand new* `Point` in memory, and assigns it to `p2`. The original `p1` remains untouched. This is a fundamental pattern in high-performance and functional programming.

  * **References:**

      * **Julia Official Documentation, Manual, Types:** "Code using immutable objects can be easier to reason about... An object with an immutable type may be copied freely by the compiler since its immutability makes it impossible to programmatically distinguish between the original object and a copy."
      * **Julia Official Documentation, Manual, Types (on Mutability):** "It is not permitted to modify the value of an immutable type."

To run the script:

```shell
$ julia 0049_struct_immutability.jl
Original point p1: Point(10.0, 20.0)

Caught expected error:
Setfield! Error: 'Point' is immutable
[...]

Created new point p2: Point(15.0, 20.0)
Original point p1 is unchanged: Point(10.0, 20.0)
```