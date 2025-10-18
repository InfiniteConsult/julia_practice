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