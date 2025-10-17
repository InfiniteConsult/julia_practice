using Printf

function with_resource(func::Function, resource_name::String)
    println("Acquiring resource: ", resource_name)
    resource_id = rand(1000:9999)
    try
        result = func(resource_id)
        println("Function executred, result: ", result)
    catch e
        println("An error occurred: ", e)
    finally
        println("Releasing resource: ", resource_name, " (ID: ", resource_id, ")")
    end
end

println("--- Calling with standard anonymous function ---")
with_resource(id -> @sprintf("Processing resource %d", id), "MyData")

println("\n" * "-"^20 * "\n")

println("")

with_resource("MyData") do id
    println("Inside the do block, working with ID: ", id)
    processed_data = @sprintf("Processed resource %d successfully", id)
    processed_data
end