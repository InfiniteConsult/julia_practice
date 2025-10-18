*This lesson requires a new module file, `MyGeometry2.jl`, to demonstrate the `export` keyword.*

### File 1: `MyGeometry2.jl`

```julia
# MyGeometry2.jl
# This file defines a module that uses the 'export' keyword.

module MyGeometry2

# 1. 'export' lists the names that are considered the "public API"
#    of this module. These are the names that 'using .MyGeometry2'
#    will bring into the main namespace.
export AbstractShape, Circle, Rectangle, calculate_area

# 2. Define types
abstract type AbstractShape end

struct Circle <: AbstractShape
    radius::Float64
end

struct Rectangle <: AbstractShape
    width::Float64
    height::Float64
end

# 3. Define functions
function calculate_area(c::Circle)
    return π * c.radius^2
end

function calculate_area(r::Rectangle)
    return r.width * r.height
end

# 4. This helper function is *NOT* exported.
# It is "private" and can only be accessed via
# the qualified name 'MyGeometry2._helper_function()'.
function _helper_function()
    println("This is a private helper.")
end

end # --- End of module MyGeometry2 ---
```

-----

### File 2: `0060_export.jl`

```julia
# 0060_export.jl

# 1. Load the new module file.
include("MyGeometry2.jl")

# 2. Demonstrate 'using .MyGeometry2'
# Because MyGeometry2.jl *uses* 'export', this command
# now dumps all exported names into our 'Main' scope.
println("--- Demonstrating 'using .MyGeometry2' ---")
using .MyGeometry2

# 3. We can now access the *exported* names directly.
# This is "namespace pollution" - it's unclear where
# 'Circle' and 'calculate_area' are coming from.
c = Circle(10.0)
area = calculate_area(c)

println("  Created instance: ", c)
println("  Calculated area: ", area)

# 4. The *non-exported* name '_helper_function' is not in scope.
# This correctly fails.
try
    _helper_function()
catch e
    println("\n  Caught expected error (not exported): ", e)
end

# 5. We can still access the non-exported name *with qualification*.
# 'export' only controls 'using'; it does not prevent
# direct, qualified access.
println("  Calling private function with qualification:")
MyGeometry2._helper_function()
```

### Explanation

This script completes our module lessons by introducing the **`export`** keyword, which creates a module's "public API."

  * **Core Concept: `export`**
    The `export` keyword specifies a list of names that are intended for public use. It works hand-in-hand with `using`:

      * `export Circle, calculate_area` says: "If a user writes `using .MyGeometry2`, I give them permission to pull `Circle` and `calculate_area` into their namespace."
      * `_helper_function` was **not** in the `export` list, so `using .MyGeometry2` does **not** bring it into the namespace.

  * **`using` Re-examined (The "Polluting" Behavior)**
    As this lesson shows, `using .MyGeometry2` now "works." It finds the `export` list and defines `Circle`, `Rectangle`, `AbstractShape`, and `calculate_area` in our `Main` scope.

      * **The Problem:** While this is convenient for small scripts, it is **strongly discouraged** in any serious project. When you read the line `c = Circle(10.0)`, you have no immediate, local information to tell you *which* module defined `Circle`. If you have ten `using` statements, you would have to check all ten modules to find its origin.
      * This is known as **namespace pollution**, and it makes code difficult to read, debug, and maintain.

  * **`export` Does Not Mean "Private"**
    A critical, final point: `export` does not enforce privacy. As shown in step 5, you can *always* access any name inside a module using the fully qualified `MyGeometry2._helper_function()` syntax.

      * `export` is not a security feature; it is a **namespace management** feature. It's a "politeness" contract that allows `using` to be convenient, but it doesn't (and shouldn't) stop a determined user from accessing internal functions.
      * The underscore prefix (e.g., `_helper_function`) is the *real* "do not touch" signal to other developers.

  * **Final Guideline:**

    1.  **Full Qualification:** `MyGeometry2.Circle(10.0)` is the clearest and safest method.
    2.  **Explicit Import:** `import .MyGeometry2: Circle` is the best compromise.
    3.  **`using` (and `export`):** Avoid this pattern in favor of the first two. It is better to be explicit about where your names come from.

  * **References:**

      * **Julia Official Documentation, Manual, "Modules":** "`export` specifies which names a module provides for other modules to use... When `using M`, only the names exported by `M` are brought into scope."

To run the script:

*(You must have `MyGeometry2.jl` from this lesson in the same directory)*

```shell
$ julia 0060_export.jl
--- Demonstrating 'using .MyGeometry2' ---
  Created instance: Circle(10.0)
  Calculated area: 314.1592653589793

  Caught expected error (not exported): UndefVarError: `_helper_function` not defined
  Calling private function with qualification:
This is a private helper.
```