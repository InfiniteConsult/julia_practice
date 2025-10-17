### `0045_mutating_functions_convention.jl`

```julia
# 0045_mutating_functions_convention.jl

# A mutable struct to hold some data
mutable struct Point
    x::Float64
    y::Float64
end

# 1. Non-mutating function: Creates and returns a NEW Point.
#    Does not end with '!'
function move_point(p::Point, dx::Float64, dy::Float64)
    # Create a new Point object with the modified coordinates
    return Point(p.x + dx, p.y + dy)
end

# 2. Mutating function: Modifies the original Point object IN-PLACE.
#    Ends with '!' by convention.
function move_point!(p::Point, dx::Float64, dy::Float64)
    p.x += dx
    p.y += dy
    # Typically returns the modified object, or nothing
    return p
end


# Create an initial point
p1 = Point(10.0, 20.0)
println("Original point p1: ", p1)

println("\n--- Calling non-mutating function ---")
# Call the non-mutating version
p2 = move_point(p1, 5.0, -5.0)
println("Returned new point p2: ", p2)
println("Original p1 remains unchanged: ", p1)

println("\n--- Calling mutating function ---")
# Call the mutating version on p1
move_point!(p1, 100.0, 100.0)
println("Original p1 IS NOW modified: ", p1)

```

-----

### Explanation

This script explains the crucial Julia **naming convention** for functions that modify their arguments: appending an exclamation mark (`!`).

  * **The `!` Convention**: If a function modifies the state of one or more of its input arguments (especially mutable collections like `Vector`s or `mutable struct`s), its name **should** end with `!`. This acts as a clear warning sign to the caller that the function has side effects and will change the input object.

  * **Non-Mutating (`move_point`)**: This function takes a `Point` and returns a **new** `Point` object with the updated coordinates. The original `p1` is completely untouched. This is often safer as it avoids unexpected side effects.

  * **Mutating (`move_point!`)**: This function directly modifies the fields (`p.x`, `p.y`) of the `Point` object passed into it. The original `p1` is altered.

  * **Why It Matters**:

      * **Clarity**: The `!` immediately tells you if a function might change your data.
      * **Performance**: Mutating functions (`!`) can often be more performant, especially when working with large data structures. Modifying data in-place avoids allocating new memory for a result, which reduces work for the garbage collector. However, this comes at the cost of potential side effects if the original object is used elsewhere.

  * **Not Enforced**: It's important to remember this is a **convention**, not a rule enforced by the compiler. You *can* write a function that modifies its arguments without a `!`, but it's strongly discouraged as it violates user expectations. Conversely, a function ending in `!` *should* modify at least one argument. Standard library functions strictly adhere to this convention (e.g., `sort` returns a sorted copy, `sort!` sorts the input vector in-place).

To run the script:

```shell
$ julia 0045_mutating_functions_convention.jl
Original point p1: Point(10.0, 20.0)

--- Calling non-mutating function ---
Returned new point p2: Point(15.0, 15.0)
Original p1 remains unchanged: Point(10.0, 20.0)

--- Calling mutating function ---
Original p1 IS NOW modified: Point(110.0, 120.0)
```