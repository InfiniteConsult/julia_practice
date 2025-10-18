*This lesson requires you to first create a new file, `MyGeometry.jl`, containing the module from the previous lesson.*

### File 1: `MyGeometry.jl`

```julia
# MyGeometry.jl
# This file contains our module definition.

module MyGeometry

# 1. Define types
abstract type AbstractShape end

struct Circle <: AbstractShape
    radius::Float64
end

struct Rectangle <: AbstractShape
    width::Float64
    height::Float64
end

# 2. Define functions
function calculate_area(c::Circle)
    return π * c.radius^2
end

function calculate_area(r::Rectangle)
    return r.width * r.height
end

# 3. Define a "private" helper
function _helper_function()
    println("This is a private helper.")
end

# 4. Define a constant
const PI_Approximation = 3.14159

# We will add 'export' in a later lesson.
# For now, nothing is exported.

end # --- End of module MyGeometry ---
```

-----

### File 2: `0058_module_access.jl`

```julia
# 0058_module_access.jl

# 1. 'include()' parses and executes the contents of the file.
# This is like copy-pasting 'MyGeometry.jl' right here.
# This line finds the file, runs it, and the 'MyGeometry'
# module becomes defined in our 'Main' global scope.
include("MyGeometry.jl")

# 2. We can now access the module, just as before.
# We MUST use the qualified name (dot-notation).
println("--- Accessing module from separate file ---")

c = MyGeometry.Circle(5.0)
area = MyGeometry.calculate_area(c)

println("Created instance: ", c)
println("Calculated area: ", area)

# 3. The namespace 'Main' is *not* polluted.
# The name 'Circle' only exists *inside* MyGeometry.
# This line will fail, as 'Circle' is not defined in 'Main'.
try
    c_fail = Circle(2.0)
catch e
    println("\nCaught expected error:")
    println(e)
end
```

### Explanation

This script demonstrates the standard way to load a module from a separate file using `include()`.

  * **Core Concept: `include()`:**

      * The `include(path)` function is a simple, direct command. It tells Julia to "pause execution of this file, go read the file at `path`, execute all the code in it from top to bottom, and then come back and continue."
      * It is **equivalent to textual copy-pasting**. After the `include("MyGeometry.jl")` line, our script behaves *exactly* as if the entire `module MyGeometry ... end` block was written at that spot.
      * This is the primary mechanism for splitting a large program into multiple files.

  * **Namespace is Still Separate:**

      * A common mistake is to assume `include()` "imports" the names from the module. It does not.
      * `include()` simply runs the file. The file's code defines a *single* new name in our `Main` scope: the module object `MyGeometry`.
      * All the other names (`Circle`, `Rectangle`, `calculate_area`) still exist **only inside** the `MyGeometry` namespace.
      * The `try...catch` block proves this. Attempting to access `Circle` directly fails with a `MethodError` (or `UndefVarError`) because the name `Circle` does not exist in `Main`. You *must* still use the fully qualified name: `MyGeometry.Circle`.

  * **`include` vs. `using`/`import`:**

      * `include(filename)`: This is how you **load code from a file**. You do this *once* per file.
      * `using ModuleName` / `import ModuleName`: This is how you **bring names from an *already-loaded* module** into your current namespace. This is the subject of the next lesson.
      * The standard pattern is:
        1.  `include("MyGeometry.jl")` (to load the code and create the module)
        2.  `using .MyGeometry` (to make its exported names available)

  * **References:**

      * **Julia Official Documentation, Manual, "Modules":** "Files are included using the `include` function... The `include` function evaluates the contents of a source file in the context of the *calling* module."

To run the script:

*(You must have `MyGeometry.jl` in the same directory)*

```shell
$ julia 0058_module_access.jl
--- Accessing module from separate file ---
Created instance: MyGeometry.Circle(5.0)
Calculated area: 78.53981633974483

Caught expected error:
UndefVarError: `Circle` not defined
[...]
```