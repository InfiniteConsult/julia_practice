import InteractiveUtils: @code_warntype

non_const_global = 100

function use_non_const_global()
    return non_const_global * 2
end

const const_global = 200

function use_const_global()
    return const_global * 2
end

function analyze_globals()
    println("--- @code_warntype for use_non_const_global() ---")
    @code_warntype use_non_const_global()

    println("\n--- @code_warntype for use_const_global() ---")
    @code_warntype use_const_global()

    println("\n--- Runtime Results ---")
    res_non_const = use_non_const_global()
    println("Result (non-const global): ", res_non_const)

    global non_const_global = "Changed!"
    println("Non-const global changed to: ", non_const_global)

    res_const = use_const_global()
    println("Result (const global): ", res_const)

    try
        global const_global = "Cannot do this"
    catch e
        println("Caught expected error trying to change const global type: ", e)
    end
end

analyze_globals()
