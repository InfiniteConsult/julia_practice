### `0002_repl_modes.md`

### Explanation

Julia's REPL (Read-Eval-Print Loop) is more than just a command line; it's an interactive environment with several distinct modes, each with its own prompt and purpose. You switch between them using single keystrokes.

-----

### 1\. Julian Mode (`julia>`)

This is the default mode for writing and executing Julia code.

  * **Prompt**: `julia>`
  * **Purpose**: To evaluate Julia expressions. You can define variables, call functions, and test code snippets here.

<!-- end list -->

```julia
julia> 1 + 1
2

julia> my_variable = "Hello from the REPL"
"Hello from the REPL"
```

-----

### 2\. Help Mode (`help?>`)

This mode is for accessing Julia's built-in documentation.

  * **Prompt**: `help?>`
  * **How to Enter**: Type `?` in Julian mode.
  * **How to Exit**: Press `Backspace` or `Ctrl+C`.

<!-- end list -->

```julia
julia> ?
help?> println

  println([io::IO], xs...)

  Print a string or representation of values xs to io, followed by a newline. If io is not supplied, prints to stdout.

help?>
```

-----

### 3\. Pkg Mode (`pkg>`)

This mode provides an interface to Julia's built-in package manager, `Pkg`.

  * **Prompt**: `pkg>`
  * **How to Enter**: Type `]` in Julian mode.
  * **How to Exit**: Press `Backspace` or `Ctrl+C`.

You use this mode to add, remove, and update dependencies for your project.

```julia
julia> ]
pkg> status
  Project MultiLanguageHttpClient v0.1.0
  Status `~/MultiLanguageHttpClient/Project.toml` (empty project)

pkg> add Sockets
  Updating registry at `~/.julia/registries/General`
  Resolving package versions...
  Updating `~/Multi-Language-HTTP-Client/Project.toml`
  [6eb21f48] + Sockets
  ...
```

-----

### 4\. Shell Mode (`shell>`)

This mode allows you to run shell commands directly from within Julia.

  * **Prompt**: `shell>`
  * **How to Enter**: Type `;` in Julian mode.
  * **How to Exit**: Press `Backspace` or `Ctrl+C`.

This is useful for file system operations or running other command-line tools without leaving the Julia REPL.

```julia
julia> ;
shell> ls -l
total 4
-rw-r--r-- 1 user user 44 Oct 16 12:00 0001_hello_world.jl
drwxr-xr-x 2 user user  4 Oct 16 12:00 Project.toml

shell>
```