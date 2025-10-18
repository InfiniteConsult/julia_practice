abstract type AbstractContainer{T} end

struct ConcreteContainer{T} <: AbstractContainer{T}
    value::T
end

struct StringContainer <: AbstractContainer{String}
    name::String
    value::String
end

function get_abstract_value(c::S) where {T, S <: AbstractContainer{T}}
    println("Dispatching to generic AbstractContainer{T} method where T=", T)
    return T
end

function process_text_container(c::AbstractContainer{String})
    println("Dispatching to specific AbstractContainer{String} method.")
end

c_int = ConcreteContainer(10)
c_str = ConcreteContainer("Hello")
s_str = StringContainer("ID", "Data")

println("--- Calling generic get_abstract_value ---")
get_abstract_value(c_int)
get_abstract_value(c_str)
get_abstract_value(s_str)

println("\n--- Calling specific process_text_container ---")
# process_text_container(c_int)  # Would fail
# ERROR: LoadError: MethodError: no method matching process_text_container(::ConcreteContainer{Int64})
# The function `process_text_container` exists, but no method is defined for this combination of argument types.

# Closest candidates are:
#   process_text_container(::AbstractContainer{String})
#    @ Main ~/repos/julia_practice/module05/04_parametric_types/0056_parametric_abstract.jl:17

# Stacktrace:
#  [1] top-level scope
#    @ ~/repos/julia_practice/module05/04_parametric_types/0056_parametric_abstract.jl:31
#  [2] include(mod::Module, _path::String)
#    @ Base ./Base.jl:306
#  [3] exec_options(opts::Base.JLOptions)
#    @ Base ./client.jl:317
#  [4] _start()
#    @ Base ./client.jl:550
# in expression starting at /home/warren_jitsing/repos/julia_practice/module05/04_parametric_types/0056_parametric_abstract.jl:31

process_text_container(c_str)
process_text_container(s_str)

println("\n--- Type hierarchy checks ---")
println("ConcreteContainer{Int64} <: AbstractContainer{Int64}?  ", ConcreteContainer{Int64} <: AbstractContainer{Int64})
println("StringContainer <: AbstractContainer{String}?      ", StringContainer <: AbstractContainer{String})
println("StringContainer <: AbstractContainer{Int64}?      ", StringContainer <: AbstractContainer{Int64})
