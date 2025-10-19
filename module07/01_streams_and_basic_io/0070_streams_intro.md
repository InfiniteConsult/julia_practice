### `0070_streams_intro.md`

Input/Output (I/O) is fundamental to any real-world application, involving reading data from files, writing to the network, or interacting with other processes. Julia provides a clean and unified abstraction for all these operations through the **`IO` abstract type**, often referred to as a **stream**.

---

## The `IO` Abstraction

* **Core Concept:** `abstract type IO end` defines the **interface** for all byte streams in Julia. It's a contract, not a concrete object. Any type that subtypes `IO` represents a sequence of bytes that can be read from or written to.
* **Why Abstract?** You don't just "read data"; you read data *from* something specific (a file, a network socket, an in-memory buffer). The `IO` type allows us to write **generic functions** that work correctly regardless of the underlying source or destination of the bytes.
* **Common Concrete Subtypes:**
    * **`IOStream`:** Represents a file opened on the filesystem. Created by `open()`.
    * **`TCPSocket`:** Represents a network connection. Created by `Sockets.connect()` or `Sockets.accept()`.
    * **`Pipe`:** Represents a connection between processes (e.g., standard input/output).
    * **`IOBuffer`:** An in-memory buffer that acts like a stream. Useful for building data before writing it elsewhere.

---

## Generic Stream Functions

The power of the `IO` abstraction comes from the generic functions that operate on *any* `IO` subtype. You don't need separate functions for writing to a file versus writing to a socket.

* **Writing:**
    * `write(io::IO, x)`: Writes the canonical binary representation of `x` to the stream. Crucial for raw data.
    * `print(io::IO, args...)`: Writes the textual representation of `args` (like `string(arg)`).
    * `println(io::IO, args...)`: Same as `print`, but adds a newline (`\n`).
* **Reading:**
    * `read(io::IO, T)`: Reads a single value of binary type `T` (e.g., `read(io, UInt8)`).
    * `read(io::IO, nb::Integer)`: Reads `nb` bytes into a `Vector{UInt8}`.
    * `read(io::IO)`: Reads all remaining bytes into a `Vector{UInt8}`.
    * `readline(io::IO)`: Reads a line of text (up to `\n`), returning it as a `String`.
    * `readchomp(io::IO)`: Reads all remaining data as a string, removing trailing whitespace.
    * `readstring(io::IO)`: Reads all remaining data as a string.
* **Other Operations:**
    * `close(io::IO)`: Closes the stream, releasing associated resources (like file handles or network ports).
    * `flush(io::IO)`: Forces any buffered output to be written to the underlying device.
    * `seek(io::IO, pos)`: Moves the stream's current position (for seekable streams like files or `IOBuffer`).
    * `eof(io::IO)`: Checks if the end of the stream has been reached.

---

## Significance for Systems Programming

* **Unified Interface:** The `IO` system means you can write generic data processing logic (e.g., parsing a specific binary format) that works identically whether the data comes from a file, a network socket, or an in-memory buffer.
* **Performance:** While the interface is generic, Julia compiles specialized, fast methods for concrete types like `IOStream` or `TCPSocket`. When you `write` to a file, it ultimately compiles down to efficient system calls.
* **Resource Management:** Understanding that streams represent underlying OS resources (file descriptors, sockets) is crucial. They **must be closed** to avoid resource leaks. The `open(...) do ... end` pattern (next lesson) is the standard, safe way to manage this automatically.

In the following lessons, we will see how to create and use specific `IO` subtypes like `IOStream` and `IOBuffer`.

---
* **References:**
    * **Julia Official Documentation, Manual, "Networking and Streams":** Introduces the `IO` type and basic stream operations.
    * **Julia Official Documentation, Base Documentation, "I/O and Network":** Lists the concrete subtypes and the generic functions available for `IO` objects.