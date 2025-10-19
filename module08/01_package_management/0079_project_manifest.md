### `0079_project_manifest.md`

When you use `Pkg.jl` commands like `activate .` and `add PackageName`, two crucial files are created and managed in your project directory: `Project.toml` and `Manifest.toml`. Understanding their roles is essential for managing dependencies and ensuring your project is **reproducible**.

-----

## `Project.toml` - Your Direct Dependencies

  * **Purpose:** This file lists the packages that your project **directly depends on**. It specifies the **names** of these packages and the **range of versions** that are compatible with your code.
  * **Format:** It uses the [TOML](https://toml.io/en/) (Tom's Obvious, Minimal Language) format, which is designed to be easy for humans to read.
  * **Example `Project.toml`:**
    ```toml
    [deps]
    BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
    JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"

    [compat]
    julia = "1.6" # Specifies compatible Julia versions
    BenchmarkTools = "1.0" # Allows version 1.0 or any later 1.x version
    JSON = "0.21" # Allows version 0.21 or any later 0.x version
    ```
  * **Key Sections:**
      * **`[deps]`:** Lists the direct dependencies by name and their **UUID** (Universally Unique Identifier). The UUID is how `Pkg` uniquely identifies packages, even if names clash. `Pkg add PackageName` automatically finds the UUID and adds it here.
      * **`[compat]`:** This is the most important section for **version constraints**. It tells `Pkg` which versions of Julia and which versions of each dependency are compatible with your project.
          * `julia = "1.6"` means your code requires Julia version 1.6 or higher (but less than 2.0).
          * `BenchmarkTools = "1.0"` uses semantic versioning (SemVer) compatibility rules. It means your code works with version 1.0 and any later *minor* or *patch* release within version 1 (e.g., 1.1, 1.2.3), but **not** version 2.0. This prevents breaking changes from major version updates. `Pkg add` usually adds a compatible entry here automatically.
  * **Version Control:** You **should commit** `Project.toml` to your version control system (like Git). It defines the intended dependencies of your project.

-----

## `Manifest.toml` - The Exact Blueprint 📜

  * **Purpose:** This file is an **exact snapshot** of *all* the packages in your project environment, including not just your direct dependencies (`Project.toml`) but also **all indirect dependencies** (dependencies of dependencies, recursively). Crucially, it lists the **exact version** of every single package used.
  * **Format:** Also TOML, but much longer and more detailed. It's primarily intended for `Pkg` to read, not for humans to edit directly.
  * **Example Snippet `Manifest.toml`:**
    ```toml
    # This file is machine-generated - editing it directly is not advised

    julia_version = "1.10.0"

    [[deps.BenchmarkTools]]
    deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
    git-tree-sha1 = "..."
    uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
    version = "1.3.1"

    [[deps.JSON]]
    deps = ["Dates", "Mmap"]
    git-tree-sha1 = "..."
    uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
    version = "0.21.3"

    # ... entries for Dates, Logging, Mmap, Printf, Statistics, UUIDs, etc. ...
    ```
  * **Reproducibility:** This file is the key to **100% reproducible builds**. When someone else (or you, on a different machine or later time) clones your project and runs `Pkg.instantiate()`, `Pkg` reads *only* `Manifest.toml`. It ignores `Project.toml`'s version ranges and installs the *exact* versions specified in the manifest. This guarantees everyone runs the code with the exact same set of dependencies, eliminating "works on my machine" problems.
  * **Version Control:** You **should commit** `Manifest.toml` to your version control system alongside `Project.toml`.

-----

## The Workflow

1.  **Start:** `cd MyProject; julia`
2.  **Activate:** `pkg> activate .` (Creates `Project.toml` if needed)
3.  **Add:** `pkg> add PackageA PackageB` (Adds to `[deps]` in `Project.toml`, adds compat entries, resolves *all* dependencies, and writes exact versions to `Manifest.toml`)
4.  **Develop:** Write your code (`import .MyModule: ...` etc.)
5.  **Share:** Commit `Project.toml`, `Manifest.toml`, and your source code (`src/`, `test/`) to Git.
6.  **Collaborator Clones:** `git clone ...; cd MyProject; julia`
7.  **Instantiate:** `pkg> activate .; instantiate` (`instantiate` reads `Manifest.toml` and installs the exact versions listed). Now the collaborator has an identical environment.

Understanding these two files is fundamental to professional Julia development, ensuring projects are manageable, shareable, and reproducible.

-----

  * **References:**
      * **Julia Official Documentation, `Pkg.jl` Manual, "Project.toml and Manifest.toml":** Provides the definitive explanation of these files.
      * **TOML Specification:** [https://toml.io/en/](https://toml.io/en/)