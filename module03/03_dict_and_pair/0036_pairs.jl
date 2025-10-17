pair_obj = (200 => "OK")

println("Value of the pair objectL ", pair_obj)
println("Type of the pair object: ", typeof(pair_obj))

println("First element: ", pair_obj.first)
println("Second element: ", pair_obj.second)

println("-"^20)

dict_syntax = Dict(404 => "Not Found", 500 => "Internal Server Error")
pair1 = Pair(404, "Not Found")
pair2 = Pair(500, "Internal Server Error")
dict_constructor = Dict(pair1, pair2)

println("Dicts are equivalent: ", dict_syntax == dict_constructor)
