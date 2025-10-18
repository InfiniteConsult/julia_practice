import InteractiveUtils: @code_warntype

function unstable_type_based_on_value(x::Int)
    if x > 0
        return x
    else
        return float(x)
    end
end

function unstable_variable_type()
    y = 1
    if rand() > 0.5
        y = 1.0
    end
    return y
end

function analyse_unstable()
    println("--- @code_warntype for unstable_type_based_on_value(1) ---")
    @code_warntype unstable_type_based_on_value(1)
    println("\n--- @code_warntype for unstable_variable_type() ---")
    @code_warntype unstable_variable_type()
end

analyse_unstable()
