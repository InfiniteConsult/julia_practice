import Sockets


const HOST = Sockets.localhost
const PORT = 8080

println("--- Starting TCP Echo Server ---")
println("Listening on $HOST:$PORT...")

server = Sockets.listen(HOST, PORT)

try
    while true
        println("\nServer: Waiting for a new client connection...")
        client_socket = Sockets.accept(server)
        client_addr = Sockets.getpeername(client_socket)
        println("Server: Accepted connection from $client_addr")

        @async begin
            println("  [Client $client_addr]: Handling connection in new Task.")
            try
                while !eof(client_socket)
                    line = readline(client_socket)
                    println("  [Client $client_addr]: Received: ", repr(line))
                    if line == "quit"
                        println("  [Client $client_addr]: Quit command received. Closing connection.")
                        write(client_socket, "Goodbye!\n")
                        break
                    end

                    response = "Server Echo: " * line * "\n"
                    write(client_socket, response)
                    println("  [Client $client_addr]: Sent: ", repr(response))
                end
            catch ea
                println("  [Client $client_addr]: Error $e")
            finally
                println("  [Client $client_addr]: Closing socket.")
                close(socket)
            end
        end
    end
catch e
    println("Server Error: $e")
finally
    println("\nServer: Shutting down.")
    close(server)
end