println("--- Part 1: Hygienic Macro ---")

macro hygienic_example()
    println("  (Macro Expansion Time: Defining hygienic 'x')")
    return quote
        local x = "Value from Hygienic Macro"
        println("  Inside generated code (Runtime): Hygienic x = ", x)
    end
end

x  = "Value from Global Scope"
println("Before macro call: Global x = ", x)

@hygienic_example()

println("After macro call: Global x = ", x)

println("\n--- Part 2: Unhygienic Macro (using esc()) ---")

macro unhygienic_assignment(varname, value)
    println("  (Macro Expansion Time: Assigning to caller's variable)")
    return :($(esc(varname)) = $value)
end

@unhygienic_assignment(y, 123)
println("After macro call: Global y = ", y)

@unhygienic_assignment(x, "Value assigned via unhygenic macro")
println("After macro call: Global x = ", x)

println("\n--- Part 3: Hygienic Wrapping Macro (@simple_time) ---")
macro simple_time(expression_to_run)
    return quote
        local start_ns = time_ns()
        local result = $(esc(expression_to_run))
        local end_ns = time_ns()
        local elapsed_ms = (end_ns - start_ns) / 1_000_000
        println("Expression `", $(string(expression_to_run)), "` executed in: ", round(elapsed_ms, digits=3), "ms")
        result
    end
end

z = 50
timed_result = @simple_time begin
    sleep(0.05)
    z * 2
end
println("Result of timed expression: ", timed_result)
