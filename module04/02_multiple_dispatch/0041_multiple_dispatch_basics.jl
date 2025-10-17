function process(data::Int)
    println("Processing an Integer: ", data * 2)
end

function process(data::String)
    println("Processing a String: ", uppercase(data))
end

function process(data::Any)
    println("Processing data of generic type '", typeof(data), "': ", data)
end


println("--- Calling process() with different types ---")
process(10)
process("hello")
process(3.14)
process([1, 2, 3])

