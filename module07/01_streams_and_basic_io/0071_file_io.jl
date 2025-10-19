const filename = "my_test_file.txt"

println("--- Writing using 'open...do' block ---")

try
    open(filename, "w") do f
        println("File opened successfully for writing.")
        write(f, "Hello, file!\n")
        print(f, "This is line 2.")
        println(f)
        println(f, "The value is: ", 123)
    end
    println("File writing complete, file closed.")
catch e
    println("Error during file writing: ", e)
end

println("\n--- Reading using 'open...do' block ---")
try
    open(filename, "r") do f
        println("File opened successfully for reading.")
        content = read(f, String)
        println("--- File Content ---")
        print(content)
        println("--- End of Content ---")
    end
    println("File reading complete, file closed.")
catch e
    println("error during file reading: ", e)
end


println("\n--- Appending using manual open/close ---")
f_manual = nothing
try
    global f_manual
    f_manual = open(filename, "a")
    println(f_manual, "Appending a new line.")
    close(f_manual)
    println("File appended and manually closed.")
catch e
    println("Error during manual append: ", e)
    if f_manual !== nothing && isopen(f_manual)
        close(f_manual)
        println("File closed after error.")
    end
end

try
    rm(filename)
    println("\nRemoved test file: ", filename)
catch e
    println("\nError removing test file: ", e)
end
