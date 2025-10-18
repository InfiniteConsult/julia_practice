import InteractiveUtils: @code_warntype

function add_one_stable(x::Int64)
    return x + 1
end

function add_one_stable_float(x::Float64)
    return x + 1.0
end

function add_one_generic(x::T) where {T<:Number}
    return x + one(T)
end

function analyse_stable()
    println("--- @code_warntype for add_one_stable(1) ---")
    @code_warntype add_one_stable(1)
    println("--- @code_warntype for add_one_stable_float(1.0) ---")
    @code_warntype add_one_stable_float(1.0)
    println("--- @code_warntype for add_one_generic(1) ---")
    @code_warntype add_one_generic(1)
    println("--- @code_warntype for add_one_generic(1.0) ---")
    @code_warntype add_one_generic(1.0)
end

analyse_stable()
