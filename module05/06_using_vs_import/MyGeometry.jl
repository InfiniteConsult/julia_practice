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