### `0057_module_basics.jl`

```julia
# 0057_module_basics.jl

# 1. Define a 'module' to create a new, separate namespace.
# Modules are Julia's primary way to organize code into logical units
# and prevent name collisions.
module MyGeometry

# 2. We can define types inside the module.
abstract type AbstractShape end

struct Circle <: AbstractShape
    radius::Float64
end

struct Rectangle <: AbstractShape
    width::Float64
    height::Float64
end

# 3. We can define functions inside the module.
function calculate_area(c::Circle)
    return π * c.radius^2
end

function calculate_area(r::Rectangle)
    return r.width * r.height
end

# 4. We can define private helper functions.
# By default, all names are "private" (not exported).
function _helper_function()
    println("This is a private helper.")
end

# 5. We can define global constants.
const PI_Approximation = 3.14159

end # --- End of module MyGeometry ---

# 6. The module 'MyGeometry' now exists as a global object.
println("--- Accessing the module from 'Main' ---")
println("Type of MyGeometry: ", typeof(MyGeometry))

# 7. To access anything *inside* the module, we MUST use dot-notation.
# This is called a "qualified name".
println("\nAccessing constant: ", MyGeometry.PI_Approximation)

# 8. Create an instance of a type defined in the module.
c = MyGeometry.Circle(10.0)
println("Created instance: ", c)

# 9. Call a function defined in the module.
area = MyGeometry.calculate_area(c)
println("Calculated area: ", area)
```

### Explanation

This script introduces **`module`s**, which are Julia's system for code organization, encapsulation, and namespace management. They are the direct equivalent of Python modules/packages, C++ namespaces, or Rust modules.

  * **Core Concept: Namespace**
    A `module` creates a new, isolated **global scope**. Names defined inside `module MyGeometry ... end` (like `Circle` or `calculate_area`) are completely separate from names defined outside (in the default `Main` scope).

      * This is the primary tool for building large applications. It prevents you from accidentally overwriting a function from another library that has the same name. For example, `MyGeometry.calculate_area` is a different function from `SomeOtherLibrary.calculate_area`.

  * **Accessing Module Contents: Dot Notation**

      * Once the `MyGeometry` module is defined, it exists as a single object in the `Main` (top-level) scope.
      * To access any name *inside* this module from the *outside*, you **must** use a **qualified name** with dot notation.
      * `MyGeometry.Circle` refers to the `Circle` `struct` defined inside `MyGeometry`.
      * `MyGeometry.calculate_area(c)` refers to the `calculate_area` function inside `MyGeometry`.

  * **Encapsulation (Privacy)**

      * By default, all names defined inside a module are "private" in the sense that they are not exported. You can *always* access them with the dot notation (e.g., `MyGeometry._helper_function()`), so it's not "true" privacy like in C++.
      * The `export` keyword (covered in a later lesson) is used to *publicly* list which names are intended for users, allowing them to be brought into scope with `using`.
      * The convention is that names beginning with an underscore (e.g., `_helper_function`) are considered internal to the module and should not be used by external code, even though it's technically possible.

  * **Modules and Files**

      * This example shows a module defined in the *same file* it's used in.
      * The more common pattern is to put `module MyGeometry ... end` in its own file (e.g., `MyGeometry.jl`) and then load it into another file using `include("MyGeometry.jl")`. This will be the subject of the next lesson.

  * **References:**

      * **Julia Official Documentation, Manual, "Modules":** "Modules are separate global variable workspaces... This prevents unrelated code from accidentally clobbering one another's global variables."
      * **Julia Official Documentation, Manual, "Modules":** "A module is a new global scope... code in one module cannot directly access a global variable in another module."

To run the script:

```shell
$ julia 0057_module_basics.jl
--- Accessing the module from 'Main' ---
Type of MyGeometry: Module

Accessing constant: 3.14159
Created instance: MyGeometry.Circle(10.0)
Calculated area: 314.1592653589793
```