NON_CONST_GLOBAL = 100

const CONST_GLOBAL = 200

function get_non_const()
    return NON_CONST_GLOBAL * 2
end

function get_const()
    return CONST_GLOBAL * 2
end


println("This script demonstrates the performance difference between constant and non-constant globals.")
println("The real difference is seen by inspecting the compiled code, not just by timing this simple script.")
println("\nIn the Julia REPL, run the following commands to see the difference:")
println("  include(\"0004_constants.jl\")")
println("  @code_warntype get_non_const()")
println("  @code_warntype get_const()")

# We can call the functions to show they work
println("\nResult from non-constant global: ", get_non_const())
println("Result from constant global: ", get_const())


# julia> @code_warntype get_non_const()
# MethodInstance for get_non_const()
#   from get_non_const() @ Main ~/repos/julia_practice/module1/02_variables_assignments/0004_constants.jl:5
# Arguments
#   #self#::Core.Const(Main.get_non_const)
# Body::Any
# 1 ─ %1 = Main.:*::Core.Const(*)
# │   %2 = Main.NON_CONST_GLOBAL::Any
# │   %3 = (%1)(%2, 2)::Any
# └──      return %3


# julia> @code_warntype get_const()
# MethodInstance for get_const()
#   from get_const() @ Main ~/repos/julia_practice/module1/02_variables_assignments/0004_constants.jl:9
# Arguments
#   #self#::Core.Const(Main.get_const)
# Body::Int64
# 1 ─ %1 = Main.:*::Core.Const(*)
# │   %2 = Main.CONST_GLOBAL::Core.Const(200)
# │   %3 = (%1)(%2, 2)::Core.Const(400)
# └──      return %3
