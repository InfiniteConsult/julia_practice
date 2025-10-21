println("--- Quoting Code ---")

ex1 = :(1 + 2 * 3)
ex2 = quote
    x = 10
    y = x + 5
end

println("Quoted expression 1: ", ex1)
println("Type of ex1: ", typeof(ex1))

println("\nQuoted block expression 2: ")
println(ex2)
println("Type of ex2: ", typeof(ex2))

println("\n--- Inspecting Expr ---")

println("ex1.head: ", ex1.head)
println("ex1.args: ", ex1.args)

operator = ex1.args[1]
arg1 = ex1.args[2]
sub_expression = ex1.args[3]

println("  Operator: ", operator, " (Type: ", typeof(operator), ")")
println("  Argument 1: ", arg1, " (Type: ", typeof(arg1), ")")
println("  Argument 2: ", sub_expression, " (Type: ", typeof(sub_expression), ")")

println("  Sub-expression head: ", sub_expression.head)
println("  Sub-expression args: ", sub_expression.args)

println("\nex2.head: ", ex2.head)
println("ex2.args (lines/expressions in block): ")
for arg in ex2.args
    println(" ", arg, " (Type: ", typeof(arg), ")")
end

println("\n--- Symbols ---")
sym_var = :my_variable
sym_op = :+
sym_kw = :if

println("Symbol sym_var: ", sym_var)
println("Type of sym_var: ", typeof(sym_var))

println("\n--- Building Expressions ---")
ex_manual = Expr(:call, :*, :a, :b)
ex_assign = Expr(:(=), :result, ex_manual)

println("Manually built expression: ", ex_assign)

println("\n--- Evaluating Expressions (eval) ---")

a = 5
b = 6

println("Before eval: a=$a, b=$b")
eval(ex_assign)

println("After eval: result=$result")
