### `0078_pkg_mode.md`

Julia comes with a built-in **package manager**, `Pkg`, which handles installing, updating, and managing project dependencies (the libraries your code uses). The easiest way to interact with `Pkg` is through its dedicated **REPL mode**.

-----

## Entering and Exiting Pkg Mode

  * **How to Enter:** From the standard Julia REPL (`julia>`), simply type the **right square bracket `]`** key. The prompt will change to a blue `pkg>`.
    ```julia
    julia> ]
    pkg>
    ```
  * **How to Exit:** Press **Backspace** (if the current line is empty) or **Ctrl+C**. The prompt will return to `julia>`.

-----

## Basic Pkg Commands

Once in `pkg>` mode, you use simple commands to manage your environment:

  * **`status` (or `st`)**: Shows the packages currently installed in the **active environment**, along with their versions. This is the first command you should use to see what's going on.
    ```pkg> st
    Status `~/.julia/environments/v1.10/Project.toml`
    [7876af07] Example v0.5.1
    ```
  * **`activate .`**: This is crucial for **project-specific environments**. It tells Pkg to manage dependencies for the *current directory* (`.`). If `Project.toml` and `Manifest.toml` files don't exist, it creates them. If they do exist, it makes that project the active environment. **Always use this** when starting a new project.
    ```pkg> activate .
    Activating project at `~/MyJuliaProject`
    ```
  * **`add PackageName`**: Adds a package (like `BenchmarkTools` or `JSON`) to the active environment. Pkg downloads it from the central registry, resolves its dependencies, and adds it to your `Project.toml` and `Manifest.toml` files.
    ```pkg> add BenchmarkTools
    Resolving package versions...
    Updating `~/MyJuliaProject/Project.toml`
    [6e4b80f9] + BenchmarkTools
    Updating `~/MyJuliaProject/Manifest.toml`
    [...]
    ```
  * **`rm PackageName`**: Removes a package from the active environment.
    ```pkg> rm BenchmarkTools
    Updating `~/MyJuliaProject/Project.toml`
    [6e4b80f9] - BenchmarkTools
    Updating `~/MyJuliaProject/Manifest.toml`
    [...]
    ```
  * **`update` (or `up`)**: Updates all packages in the active environment to their latest compatible versions, respecting the constraints in `Project.toml`.
    ```pkg> up
    Updating registry at `~/.julia/registries/General.toml`
    No Changes to `~/MyJuliaProject/Project.toml`
    No Changes to `~/MyJuliaProject/Manifest.toml`
    ```
  * **`help`**: Shows a list of available Pkg commands.

-----

## Why Environments Matter

Using `activate .` creates an **isolated environment** for each project. This means:

1.  **Reproducibility:** Project A can use version 1.0 of a package, while Project B uses version 2.0, without conflicts. The `Manifest.toml` file (next lesson) records the *exact* versions, ensuring anyone else can reproduce your environment perfectly.
2.  **Dependency Management:** Pkg handles finding and installing all the *indirect* dependencies (libraries that your libraries depend on).

The `pkg>` mode provides a convenient, interactive way to manage these environments directly within Julia.

-----

  * **References:**
      * **Julia Official Documentation, `Pkg.jl` Manual:** Comprehensive guide to the package manager.
      * **Julia Official Documentation, Manual, "Getting Started", "Interacting With Julia":** Briefly mentions the REPL modes including Pkg mode.