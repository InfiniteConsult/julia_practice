### `0059_using_vs_import.jl`

```julia
# 0059_using_vs_import.jl

# 1. First, we MUST load the code from the file.
# 'include' executes the file, defining the 'MyGeometry' module
# in our current (Main) scope.
include("MyGeometry.jl")

# We will now explore the three different ways to access
# the contents of the *already-loaded* 'MyGeometry' module.

# --- Method 1 (Recommended): Full Qualification ---
# We do nothing special, and just use the fully qualified name.
# This is what we did in the previous lesson.
println("--- Method 1: Full Qualification ---")
c1 = MyGeometry.Circle(1.0)
println("  Created: ", c1)
println("  Area:    ", MyGeometry.calculate_area(c1))


# --- Method 2 (Safe & Explicit): 'import .MyGeometry: Name, ...' ---
println("\n--- Method 2: import .MyGeometry: Circle ---")

# The '.' is critical. It tells Julia to look for 'MyGeometry'
# *relative* to our current module (Main), not in the list
# of installed packages.
import .MyGeometry: Circle, calculate_area

# Now we can call 'Circle' and 'calculate_area' directly.
c2 = Circle(2.0) # This is MyGeometry.Circle
area2 = calculate_area(c2) # This is MyGeometry.calculate_area
println("  Created: ", c2)
println("  Area:    ", area2)

# However, 'Rectangle' was *not* imported. We must still qualify it.
try
    r_fail = Rectangle(1.0, 1.0)
catch e
    println("  Caught expected error: ", e)
end
# This is the correct, qualified way:
r_ok = MyGeometry.Rectangle(1.0, 1.0)
println("  Created Rectangle via qualified name: ", r_ok)


# --- Method 3 (Discouraged): 'using .MyGeometry' ---
println("\n--- Method 3: using .MyGeometry ---")

# NEVER EVER DO THIS. DON'T EVEN TRY.
# There are cosmic forces at play here, who sense everying time
# you use 'using'. You do not want to incur their wrath.
# Stay away from importing the entire namespace into the global scope.
# Just don't do it.
# It's not worth it.
using .MyGeometry

# But since we didn't 'export' anything, we aren't bringing anything into
# scope

try
    # This fails, because 'Rectangle' was not exported.
    r = Rectangle(3.0, 3.0)
catch e
    println("  Caught expected error: ", e)
end

# We *still* have to use the qualified name.
r = MyGeometry.Rectangle(3.0, 3.0)
println("  Must still use qualified name: ", r)
```

### Explanation

This script demonstrates the critical differences between `import` and `using` for controlling how names from a module are accessed. A clean, explicit namespace is a key component of robust, maintainable systems.

  * **Step 0: `include()` and `.` Syntax**

      * First, we *must* call `include("MyGeometry.jl")`. This is the **loader**. It executes the file, which defines the `MyGeometry` module object inside our current module (which is `Main` by default).
      * **The `.` Prefix:** When we write `import MyGeometry`, Julia assumes we mean an *installed package* from our environment. This fails. The `.` prefix in `import .MyGeometry` is critical: it makes the path **relative**. It tells Julia, "Look for a module named `MyGeometry` that is *already loaded inside my current module*." This is the correct way to refer to modules you have loaded with `include`.

  * **Method 1: Full Qualification (Safest)**
    This is the simplest, safest, and most explicit method. You use the full `MyGeometry.Circle` and `MyGeometry.calculate_area` names.

      * **Pro:** It is 100% clear where `Circle` and `calculate_area` are defined. There is zero chance of a name collision.
      * **Con:** It can be verbose.

  * **Method 2: `import .MyGeometry: Name` (Recommended)**
    This is the recommended pattern for balancing clarity and convenience.

      * `import .MyGeometry: Circle, calculate_area` states, "From the `MyGeometry` module in my current scope, bring *only* the `Circle` and `calculate_area` names into my namespace."
      * **Pro:** It is still explicit. A developer reading the top of the file sees a precise list of imported names. You can use `Circle` directly, but `Rectangle` (which we didn't import) still requires `MyGeometry.Rectangle`.
      * **Con:** You have to list every name you want to use.

  * **Method 3: `using .MyGeometry` (Strongly Discouraged)**
    This command is the most "magical" and the most likely to cause problems in large projects.

      * **`using` vs. `export`:** `using .MyGeometry` tells Julia, "Find all names that `MyGeometry` has *publicly exported* and dump them into my current scope." Our `MyGeometry.jl` file does not contain an `export` statement yet, so it exports *nothing*. This is why `using .MyGeometry` does not make `Rectangle` available.
      * **The "Namespace Pollution" Problem:** Even if our module *did* export `Rectangle`, `using .MyGeometry` is discouraged. If you have ten `using` statements at the top of your file and you see the name `Rectangle()` in your code, you have no way of knowing which of those ten modules it came from. This is "namespace pollution."
      * **Guideline:** Avoid `using`. It makes code harder to read and debug by obscuring the origin of names. The explicit `import .MyGeometry: ...` or fully qualified `MyGeometry.Rectangle` are strongly preferred for writing clear, maintainable, and unambiguous code.

  * **References:**

      * **Julia Official Documentation, Manual, "Modules":** "The `import ... :` syntax allows importing specific names from a module... The `using` keyword... brings *all exported* names from a module into the current scope."
      * **Julia Official Documentation, Manual, "Code Loading":** Explains relative imports: "A `using` or `import` statement with a leading dot (`.`) is a *relative* import."

To run the script:

*(You must have `MyGeometry.jl` from lesson 0058 in the same directory)*

```shell
$ julia 0059_using_vs_import.jl
--- Method 1: Full Qualification ---
  Created: MyGeometry.Circle(1.0)
  Area:    3.141592653589793

--- Method 2: import .MyGeometry: Circle ---
  Created: Circle(2.0)
  Area:    12.566370614359172
  Caught expected error: UndefVarError: `Rectangle` not defined
  Created Rectangle via qualified name: MyGeometry.Rectangle(1.0, 1.0)

--- Method 3: using .MyGeometry ---
  Caught expected error: UndefVarError: `Rectangle` not defined
  Must still use qualified name: MyGeometry.Rectangle(3.0, 3.0)
```