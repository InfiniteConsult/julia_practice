mutable struct Container
    value::Int
end


function process_container(obj)
    if obj != nothing && obj.value > 10
        println("Processing container with high value: ", obj.value)
    else
        println("Skipping, object is either nothing or its value is not > 10.")
    end
end


c1 = Container(20)
c2 = nothing

println("--- Processing a valid container ---")
process_container(c1)

println("\n--- Processing 'nothing' ---")
process_container(c2)
