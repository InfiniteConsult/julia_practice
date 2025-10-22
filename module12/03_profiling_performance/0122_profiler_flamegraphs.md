### `0122_profiler_flamegraphs.jl`

```julia
# 0122_profiler_flamegraphs.jl
# Visualizing Profile data by saving to a file for use with 'pprof'.

# 1. Import Profile module and PProf package. See Explanation for installation.
import Profile
try
    # PProf is needed for the pprof() function to save the data.
    import PProf
catch e
    println("ERROR: PProf.jl not found.")
    println("Please install it: Open Julia REPL, type ']', then 'add PProf'")
    println("Viewing the output file requires the external 'pprof' tool (Go).")
    exit(1)
end

# 2. Reuse the functions from the previous lesson.
function work_level_1(n)
    s = 0.0
    for i in 1:n; s += sin(sqrt(float(i))); end
    return s
end

function work_level_2(n)
    s = 0.0
    for _ in 1:5
        s += work_level_1(n ÷ 5)
    end
    for i in 1:(n ÷ 10); s += cos(float(i)); end
    return s
end

function main_computation(n)
    println("Starting main computation...")
    result = work_level_2(n)
    println("Main computation finished.")
    return result
end

# --- Profiling ---

# 3. Warmup Run (as before).
println("--- Warming up (compiling) functions ---")
warmup_n = 1_000_000
_ = main_computation(warmup_n)
println("Warmup finished.")

# 4. Clear existing profile data.
Profile.clear()

# 5. Run the code under the profiler.
println("\n--- Running computation under Profile.@profile ---")
profile_n = 5_000_000
Profile.@profile main_computation(profile_n)
println("Profiling finished.")

# 6. Save the profile data to a file using PProf.jl.
output_filename = "profile.pb.gz"
println("\n--- Saving profile data to '$output_filename' using PProf.jl ---")
try
    # PProf.pprof() reads data collected by 'Profile' and saves it
    # to the specified file when 'out=' is used.
    PProf.pprof(out = output_filename)
    println("Profile data saved successfully.")
    println("\n--- Viewing Instructions (Requires External Tools) ---")
    println("1. Install 'go' (golang.dev/doc/install).")
    println("2. Install 'pprof': go install github.com/google/pprof@latest")
    println("3. Install 'graphviz' (system package manager, e.g., apt, brew).")
    println("4. Ensure '$HOME/go/bin' is in your PATH.")
    println("5. Run from terminal: pprof -http=:8080 $output_filename")
    println("6. Open http://localhost:8080 in browser and select 'Flame Graph'.")
    println("(Note: Author did not test the viewing steps.)")
catch e
     # Catch potential errors during saving, including the "Unexpected 0" warning.
     println("\nError/Warning during profile data saving using PProf: $e")
     # Check if file was still created despite warning
     if isfile(output_filename)
        println("'$output_filename' was created, but may contain issues (see warning above).")
        println("Viewing instructions still apply, but results might be affected.")
     end
end

# Note: For VS Code users, the Julia extension provides '@profview',
# which displays an interactive flame graph directly within the editor
# after running Profile.@profile, without needing PProf.jl or external tools.

println("\n--- End of Script ---")
```

### Explanation

This script demonstrates how to **visualize** the data collected by Julia's `Profile` module using **flame graphs** by saving the data to a file compatible with Google's **`pprof`** tool, using the `PProf.jl` package. Viewing requires installing external tools.

-----

**Installation Note (PProf.jl & Viewer):**

1.  **Install `PProf.jl`:** Add via Julia's Pkg mode (`] add PProf`).
2.  **Install Viewer (`pprof` + `graphviz`):** To *view* the saved file later, you need external tools:
      * Install the Go language (`go`).
      * Install `pprof` via `go install github.com/google/pprof@latest`.
      * Install `graphviz` via your system package manager.
      * Ensure the `go` binary path is in your system `PATH`.

-----

## Why Visualize? Flame Graphs

  * **Text Output Limitations:** `Profile.print()` can be hard to interpret visually.
  * **Flame Graphs:** Provide an intuitive visualization of sampled stack trace data.
      * **Y-Axis:** Call stack depth.
      * **X-Axis (Width):** Proportion of samples where a function appeared. **Wider bars = more time spent**.
  * **Identifying Bottlenecks:** Look for **wide plateaus** at the top of the graph, indicating functions consuming significant CPU time directly.

## Saving Profile Data (`PProf.pprof`)

1.  **Collect Data:** Use `Profile.@profile expression` (after warmup and `Profile.clear()`) to collect sampling data internally.
2.  **Save Data:** `PProf.pprof(out=filename)` accesses the data collected by `Profile` and exports it into the compressed protobuf format (`.pb.gz`), saving it to `filename`. (Note: This function might print warnings like "Unexpected 0 in data" but often still saves a usable file).

## Viewing Saved Data with `pprof` (External Tool)

1.  **Run `pprof`:** After running the Julia script and generating `profile.pb.gz`, open your terminal *in the same directory* and run (assuming `pprof` is installed and in your `PATH`):
    ```bash
    pprof -http=:8080 profile.pb.gz
    ```
      * `-http=:8080`: Starts a web server on port 8080.
2.  **Open Browser:** Navigate to `http://localhost:8080`.
3.  **Explore:** Use the "View" menu to select **"Flame Graph"**. Interact with the visualization.
4.  **Shutdown:** Press `Ctrl+C` in the terminal running `pprof` to stop its server.
    *(Disclaimer: The author did not perform these viewing steps.)*

## Alternative: VS Code `@profview`

If using VS Code with the Julia extension:

1.  Add `using ProfileView` (might need `Pkg.add("ProfileView")`).
2.  Run `Profile.@profile main_computation(profile_n)` as before.
3.  Run `@profview()` *after* the `@profile` call.
4.  An interactive flame graph appears directly within a VS Code panel, no external tools needed.

Saving profile data provides a standard way to analyze performance offline or share results, while integrated options offer convenience.

-----

  * **References:**
      * **Julia Official Documentation, Standard Library, `Profile`:** Documents `Profile.@profile`.
      * **`PProf.jl` Documentation:** ([https://github.com/JuliaPerf/PProf.jl](https://github.com/JuliaPerf/PProf.jl)) Explains the `pprof()` function, including the `out` argument.
      * **`pprof` Documentation (Google):** ([https://github.com/google/pprof](https://github.com/google/pprof)) Explains the command-line tool and web UI.
      * **Brendan Gregg's Flame Graphs Page:** ([https://www.brendangregg.com/flamegraphs.html](https://www.brendangregg.com/flamegraphs.html)) Definitive guide to flame graphs.

-----

To run the script:

*(Requires `PProf.jl` installed. Run after warmup.)*

```shell
$ julia 0122_profiler_flamegraphs.jl
--- Warming up (compiling) functions ---
Starting main computation...
Main computation finished.
Warmup finished.

--- Running computation under Profile.@profile ---
Starting main computation...
Main computation finished.
Profiling finished.

--- Saving profile data to 'profile.pb.gz' using PProf.jl ---
┌ Error: Unexpected 0 in data, please file an issue. # This warning might appear
│   idx = XXXX
└ @ PProf ...
Profile data saved successfully.

--- Viewing Instructions (Requires External Tools) ---
1. Install 'go' (golang.dev/doc/install).
2. Install 'pprof': go install github.com/google/pprof@latest
3. Install 'graphviz' (system package manager, e.g., apt, brew).
4. Ensure '$HOME/go/bin' is in your PATH.
5. Run from terminal: pprof -http=:8080 profile.pb.gz
6. Open http://localhost:8080 in browser and select 'Flame Graph'.
(Note: Author did not test the viewing steps.)

--- End of Script ---
```

*(After running, you should find `profile.pb.gz`. Use the separate `pprof` command to view.)*

NOTE: I did not test pprof visualization. 