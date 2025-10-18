include("MyGeometry.jl")

println("--- Method1: Full QUalification ---")
c1 = MyGeometry.Circle(1.0)
println("  Created: ", c1)
println("  Area:    ", MyGeometry.calculate_area(c1))

println("\n--- Method 2: import MyGeometry: Circle ---")

import .MyGeometry: Circle, calculate_area

c2 = Circle(2.0)
area2 = calculate_area(c2)

println("  Created: ", c2)
println("  Area:    ", calculate_area(c2))

try
    r_fail = Rectangle(1.0, 1.0)
catch e
    println("  Caught expected error: ", e)
end
r_ok = MyGeometry.Rectangle(1.0, 1.0)
println("  Created Rectangle via qualified name: ", r_ok)

println("\n--- Method 3: using MyGeometry ---")

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
