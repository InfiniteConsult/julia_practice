import InteractiveUtils: @code_lowered, @code_typed

println("--- Standard Function ---")

function get_container_description_runtime(container)
    if isa(container.value, Int)
        return "Container holds an Integer"
    elseif isa(container.value, String)
        return "Container holds a String"
    else
        return "Container holds Other type"
    end
end

struct Container{T}
    value::T
end

c_int = Container(10)
c_str = Container("hello")

println("Runtime dispatch:")
println("  Input Container{Int}: ", get_container_description_runtime(c_int))
println("  Input Container{String}: ", get_container_description_runtime(c_str))

println("\n--- @generated Function ---")
@generated function get_container_description_compiletime(c::Container{T}) where {T}
    println("  (@generated running for T = $T)")
    if T <: Integer
        return quote
            "Container holds an Integer (determined at compile time)"
        end
    elseif T == String
        return quote
            "Container holds a String (determined at compile time)"
        end
    else
        return quote
            "Container holds Other type (determined at compile time)"
        end
    end
end

println("\nCompile-time dispatch:")

println("  Input Container{Int}: ", get_container_description_compiletime(c_int))
println("  Input Container{Int} (again): ", get_container_description_compiletime(c_int))
println("  Input Container{String}: ", get_container_description_compiletime(c_str))

println("\n--- Inspecting Code ---")
println("Code for runtime version (Container{Int}):")

println(@code_typed get_container_description_runtime(c_int))

println("\nCode for compile-time version (Container{Int}):")
println(@code_typed get_container_description_compiletime(c_int))
