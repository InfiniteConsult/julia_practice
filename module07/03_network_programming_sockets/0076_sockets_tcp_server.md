### `0076_sockets_tcp_server.jl`

```julia
# 0076_sockets_tcp_server.jl

# Import the Sockets standard library
import Sockets

# Define the host IP and port to listen on.
# Sockets.localhost (typically 127.0.0.1) means listen only for connections
# from the same machine. Use Sockets.ip"0.0.0.0" to listen on all interfaces.
const HOST = Sockets.localhost
const PORT = 8080

println("--- Starting TCP Echo Server ---")
println("Listening on $HOST:$PORT...")

# 1. Create a TCP Server object.
#    'listen()' binds to the address and starts listening for connections.
#    It returns a TCPServer object, which is itself an IO stream used
#    only for accepting new connections.
server = Sockets.listen(HOST, PORT)

try
    # 2. Loop indefinitely to accept incoming connections.
    while true
        println("\nServer: Waiting for a new client connection...")
        # 3. Accept a connection.
        #    'accept()' blocks until a client connects.
        #    It returns a TCPSocket object representing the connection to *that* client.
        #    The TCPSocket is also an IO stream (subtype of IO).
        client_socket = Sockets.accept(server)
        client_addr = Sockets.getpeername(client_socket) # Get client IP and port
        println("Server: Accepted connection from $client_addr")

        # 4. Handle the client connection asynchronously.
        #    We launch a new Task for each client using '@async'.
        #    This allows the server to immediately go back to 'accept()'
        #    and handle other clients concurrently without blocking.
        @async begin
            println("  [Client $client_addr]: Handling connection in new Task.")
            try
                # 5. Interact with the client using the client_socket IO stream.
                while !eof(client_socket) # Loop until client closes connection
                    # Read a line of text sent by the client.
                    line = readline(client_socket)
                    println("  [Client $client_addr]: Received: ", repr(line)) # repr shows quotes/newlines

                    # Check if client wants to quit
                    if line == "quit"
                        println("  [Client $client_addr]: Quit command received. Closing connection.")
                        write(client_socket, "Goodbye!\n")
                        break # Exit the while loop for this client
                    end

                    # Echo the line back to the client.
                    response = "Server Echo: " * line * "\n"
                    write(client_socket, response)
                    println("  [Client $client_addr]: Sent: ", repr(response))
                end
            catch e
                # Handle potential errors during client communication (e.g., connection reset)
                println("  [Client $client_addr]: Error: $e")
            finally
                # 6. Ensure the client socket is closed when done or on error.
                println("  [Client $client_addr]: Closing socket.")
                close(client_socket)
            end
        end # End of @async block for this client
    end # End of while true loop (accepting connections)
catch e
    # Handle potential errors with the server itself (e.g., port already in use)
    println("Server Error: $e")
finally
    # 7. Ensure the main server socket is closed when the server stops.
    println("\nServer: Shutting down.")
    close(server)
end
```

### Explanation

This script demonstrates how to create a basic **TCP server** using Julia's built-in `Sockets` standard library. The server listens for incoming connections and handles each client concurrently using `@async`, echoing back any text the client sends.

  * **Core Concept: Server Socket vs. Client Socket**
    Networking involves two types of sockets:

    1.  **Server Socket (`TCPServer`):** Created by `Sockets.listen()`. Its *only* job is to wait for incoming connection requests on a specific IP address and port. It acts like a receptionist waiting for the phone to ring.
    2.  **Client Socket (`TCPSocket`):** Created by `Sockets.accept()` on the server side (or `Sockets.connect()` on the client side). This represents the **actual two-way communication channel** with a *specific* client. It's the phone line used for the conversation after the receptionist connects the call. Both `TCPServer` and `TCPSocket` are subtypes of `IO`.

  * **Steps to Create a Server:**

    1.  **`Sockets.listen(HOST, PORT)`:** Binds the server to the specified `HOST` IP address and `PORT` number. If the port is already in use, this will error. It returns the `TCPServer` object.
    2.  **`while true ... Sockets.accept(server) ... end`:** The main server loop. `Sockets.accept(server)` **blocks** execution until a client attempts to connect. When a client connects, `accept` returns a **new `TCPSocket` object** dedicated to that client.
    3.  **`@async begin ... end`:** To handle multiple clients simultaneously, we immediately launch a **new `Task`** using `@async` to handle the `client_socket`. The main server loop then instantly goes back to `accept`, ready for the next client, without waiting for the first client's session to finish. This is crucial for server responsiveness.
    4.  **Client Handling Loop (`while !eof(...) ... end`):** Inside the `@async` block, we interact with the specific client using the `client_socket` (which is an `IO` stream). We use standard `IO` functions like `readline()` to receive data and `write()` to send data. The `eof(client_socket)` function checks if the client has closed their end of the connection. `Sockets.getpeername(client_socket)` retrieves the IP address and port of the connected client.
    5.  **`close(client_socket)`:** When communication with a specific client is finished (or an error occurs), its dedicated `TCPSocket` **must be closed** within the `@async` task to release the connection resources. Using `try...finally` guarantees this.
    6.  **`close(server)`:** When the server itself shuts down (e.g., due to an error or `Ctrl+C`), the main listening `TCPServer` socket must also be closed to unbind the port. The outer `try...finally` ensures this.

  * **Concurrency Model:**
    This server uses the **Task-per-Client** concurrency model. Each incoming connection spawns a new Julia `Task`. Thanks to Julia's efficient, non-blocking I/O and lightweight tasks, this model can handle many concurrent connections effectively on a single OS thread (though multi-threading can be added for CPU-bound work within tasks).

  * **`repr()` Function:** We use `repr(line)` in the output. This function provides a string representation that includes quotes and escape sequences (like `\n`), making it clearer exactly what data was received or sent over the network.

  * **References:**

      * **Julia Official Documentation, Standard Library, `Sockets`:** Documents `listen`, `accept`, `connect`, `getpeername`, `TCPSocket`, etc.
      * **Julia Official Documentation, Manual, "Networking and Streams":** Provides examples of socket programming.

To run the script:

1.  Save the code as `0076_sockets_tcp_server.jl`.
2.  Run it from your terminal: `julia 0076_sockets_tcp_server.jl`
3.  The server will start and print `Listening on 127.0.0.1:8080...` and `Waiting for a new client connection...`. It is now waiting.
4.  You will need a **client** (like the one in the next lesson, or a tool like `telnet` or `netcat`) to connect to it. For example, in another terminal: `telnet 127.0.0.1 8080`.
5.  Type messages in the `telnet` window and press Enter. The server should echo them back. Type `quit` to disconnect that client.
6.  Press `Ctrl+C` in the server's terminal to stop it.

*(Expected output when running and connecting with a client will show the accept/receive/send messages, including the client address from `getpeername`.)*