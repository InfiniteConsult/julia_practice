import Sockets

const SERVER_HOST = Sockets.localhost
const SERVER_PORT = 8080

println("--- Starting TCP Client ---")
println("Attempting to connect to $SERVER_HOST:$SERVER_PORT...")

try
    local client_socket
    client_socket = Sockets.connect(SERVER_HOST, SERVER_PORT)
    server_addr = Sockets.getpeername(client_socket)
    println("Successfully connected to server at $server_addr")

    println("Enter messages to send to the server. Type 'quit' to exit.")
    while true
        print("> ")
        user_input = readline()

        bytes_written = write(client_socket, user_input * "\n")
        println("Client: Sent $bytes_written bytes: ", repr(user_input * "\n"))
        if user_input == "quit"
           server_response = readline(client_socket)
           println("Client: Received: ", repr(server_response))
           break
        end

        if !eof(client_socket)
           server_response = readline(client_socket)
           println("Client: Received: ", repr(server_response))
        else
           println("Client: Server closed the connection unexpectedly")
           break
        end
    end
catch e
    println("\nClient Error: $e")
    println("Ensure the server script (0076_sockets_tcp_server.jl) is running.")
finally
    if @isdefined(client_socket) && client_socket !== nothing && isopen(client_socket)
        println("\nClient: Closing connection.")
        close(client_socket)
    end
    println("Client finished.")
end