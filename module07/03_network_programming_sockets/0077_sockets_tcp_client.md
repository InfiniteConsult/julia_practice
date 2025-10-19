### `0077_sockets_tcp_client.jl`

```julia
# 0077_sockets_tcp_client.jl

# Import the Sockets standard library
import Sockets

# Define the host and port of the server we want to connect to.
# This should match the HOST and PORT in the server script (0076).
const SERVER_HOST = Sockets.localhost
const SERVER_PORT = 8080

println("--- Starting TCP Client ---")
println("Attempting to connect to $SERVER_HOST:$SERVER_PORT...")

# Initialize socket variable for the finally block
# We use 'Ref' trick or declare outside if needed in 'finally' reliably
# Simpler: Use @isdefined check in finally block

try
    local client_socket # Declare local to avoid scope ambiguity warning
    # 1. Connect to the server.
    #    'Sockets.connect()' attempts to establish a TCP connection.
    #    It blocks until the connection succeeds or fails.
    #    On success, it returns a TCPSocket representing the connection.
    client_socket = Sockets.connect(SERVER_HOST, SERVER_PORT)
    server_addr = Sockets.getpeername(client_socket) # Get server IP and port
    println("Successfully connected to server at $server_addr")

    # 2. Start interaction loop.
    println("Enter messages to send to the server. Type 'quit' to exit.")
    while true
        # Read a line of input from the user's terminal (stdin).
        print("> ") # Prompt
        user_input = readline()

        # Send the user's input to the server using 'write()'.
        # We must add the newline character for the server's 'readline()'.
        bytes_written = write(client_socket, user_input * "\n")
        println("Client: Sent $bytes_written bytes: ", repr(user_input * "\n"))

        # If the user typed 'quit', break the loop after sending.
        if user_input == "quit"
            # Read the server's final "Goodbye!" message before closing.
            if !eof(client_socket)
                server_response = readline(client_socket)
                println("Client: Received: ", repr(server_response))
            end
            break
        end

        # Read the server's echo response using 'readline()'.
        # This blocks until the server sends a line ending in '\n'.
        if !eof(client_socket) # Check if server closed connection unexpectedly
            server_response = readline(client_socket)
            println("Client: Received: ", repr(server_response))
        else
            println("Client: Server closed the connection unexpectedly.")
            break
        end
    end # End of while loop

catch e
    # Handle connection errors (e.g., server not running)
    println("\nClient Error: $e")
    println("Ensure the server script (0076_sockets_tcp_server.jl) is running.")
finally
    # 3. Ensure the socket is closed if it was successfully opened.
    #    Check '@isdefined' in case 'connect' failed before assignment.
    if @isdefined(client_socket) && client_socket !== nothing && isopen(client_socket)
        println("\nClient: Closing connection.")
        close(client_socket)
    end
    println("Client finished.")
end

```

### Explanation

This script demonstrates how to create a simple **TCP client** using the `Sockets` library. It connects to the echo server created in the previous lesson (`0076_sockets_tcp_server.jl`), sends user input to it, and prints the server's response.

  * **Core Concept: Client Connection**
    While a server `listen`s and `accept`s, a client actively initiates a connection using `Sockets.connect()`.

  * **Steps to Create a Client:**

    1.  **`Sockets.connect(HOST, PORT)`:** This function attempts to establish a TCP connection to the server running at the specified `HOST` and `PORT`.
          * **Blocking:** This call **blocks** until the TCP handshake completes successfully or an error occurs (e.g., the server isn't running (`ECONNREFUSED`), a firewall blocks the connection, or it times out).
          * **Return Value:** On success, it returns a `TCPSocket` object, which is an `IO` stream representing the established two-way communication channel with the server.
    2.  **Interact using `IO` functions:** Once connected, the `client_socket` is used just like any other `IO` stream (e.g., the file stream from `open()`).
          * **`write(socket, data)`:** Sends data *to* the server. We append `\n` because our server uses `readline()`, which expects newline-terminated messages.
          * **`readline(socket)`:** Reads data *from* the server, blocking until a complete line (ending in `\n`) is received.
          * **`eof(socket)`:** Checks if the server has closed its end of the connection.
    3.  **`close(socket)`:** When the client is finished interacting, it **must close** its socket using `close(client_socket)`. This signals the server that the conversation is over and releases the associated operating system resources. Using `try...finally` ensures the socket is closed even if errors occur during communication. The `@isdefined` check in `finally` ensures we don't try to close a socket that was never successfully created (e.g., if `connect` itself failed).

  * **Client-Server Interaction:**
    This script, together with the server script, forms a complete client-server application.

      * The client connects.
      * The client reads user input from the terminal (`stdin`).
      * The client sends the input (plus `\n`) to the server (`write`).
      * The server reads the line (`readline`).
      * The server sends the echoed response (plus `\n`) back (`write`).
      * The client reads the echo (`readline`) and displays it.
      * This continues until the client sends `"quit"`.

  * **Error Handling:** The `try...catch` block is essential for handling potential network errors, most commonly `Sockets.ECONNREFUSED` if the server is not running when the client tries to connect.

  * **References:**

      * **Julia Official Documentation, Standard Library, `Sockets`:** Documents `connect`, `TCPSocket`, etc.
      * **Julia Official Documentation, Base Documentation, `readline`:** "Read a single line of text from the given I/O stream..."

To run the script:

1.  **Start the server first:** In one terminal, run `julia 0076_sockets_tcp_server.jl`. Wait until it says `Waiting for a new client connection...`.
2.  **Run the client:** In a *second* terminal, run `julia 0077_sockets_tcp_client.jl`.
3.  You should see the client connect successfully.
4.  Type messages (e.g., `Hello Server!`) in the client terminal and press Enter. The server should echo them back.
5.  Type `quit` in the client terminal to disconnect cleanly.
6.  You can then stop the server with `Ctrl+C`.

*(Expected output will show the connection message, prompts, sent/received lines, and disconnection messages.)*