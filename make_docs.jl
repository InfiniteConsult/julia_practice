# make_docs.jl
# A simple static site generator for the Julia Crash Course.
# It walks the module directories, concatenates all markdown files,
# and embeds them into a single, self-contained HTML file.
import Dates

# --- Configuration ---
const ROOT_DIR = "."
const OUTPUT_HTML = "index.html"
const MODULE_PREFIX = "module"
const DOC_EXTENSION = ".md"

# Dictionary mapping module directory names to human-readable titles
const MODULE_TITLES = Dict(
    "module01" => "Getting Started: Basics",
    "module02" => "Control Flow",
    "module03" => "Collections",
    "module04" => "Functions and Dispatch",
    "module05" => "Your Own Types and Code Organization",
    "module06" => "High-Performance Techniques",
    "module07" => "I/O and Concurrency",
    "module08" => "Project Tooling",
    "module09" => "Memory, Data Layout and Unsafe Operations",
    "module10" => "Advanced Parallelism and Thread Safety"
    # Add future modules here as needed
)

# --- Helper Functions ---

# Formats directory names like "01_REPL" into "REPL"
function format_name(dir_name)
    name_part = replace(dir_name, r"^\d+_" => "")
    return titlecase(replace(name_part, "_" => " "))
end

# Safely reads a file, returning an empty string on error.
function safe_read(filepath)
    try
        return read(filepath, String)
    catch e
        println("Warning: Could not read file '$filepath'. Error: $e")
        return ""
    end
end

# Escapes characters for safe embedding within a JavaScript template literal (`...`).
function escape_for_js_template(md_content)
    content = replace(md_content, "\\" => "\\\\")
    content = replace(content, "`" => "\\`")
    content = replace(content, "\${" => "\\\${")
    return content
end


# --- Main Logic ---

function build_docs()
    println("Starting documentation build...")
    markdown_buffer = IOBuffer()

    # Find and sort all 'moduleXX' directories
    module_dirs = filter(d -> startswith(d, MODULE_PREFIX) && isdir(joinpath(ROOT_DIR, d)), readdir(ROOT_DIR))
    sort!(module_dirs, by = d -> parse(Int, match(r"module(\d+)", d).captures[1]))

    println("Found modules: ", module_dirs)

    for mod_dir in module_dirs
        mod_path = joinpath(ROOT_DIR, mod_dir)
        mod_num = parse(Int, match(r"module(\d+)", mod_dir).captures[1])
        # Look up the human-readable title from the dictionary
        mod_title = get(MODULE_TITLES, mod_dir, "Module $mod_num") # Fallback to number if not found
        println("Processing Module $mod_num: $mod_title...")

        # Add Module Heading using the title
        write(markdown_buffer, "# Module $mod_num: $mod_title\n\n")

        # Find and sort subsections within the module
        subsection_dirs = filter(d -> isdir(joinpath(mod_path, d)), readdir(mod_path))
        sort!(subsection_dirs) # Simple alphabetical sort is fine due to numbered prefixes

        for sub_dir in subsection_dirs
            sub_path = joinpath(mod_path, sub_dir)
            sub_name = format_name(sub_dir)
            println("  Processing Subsection: $sub_name...")

            # Add Subsection Heading
            write(markdown_buffer, "## $sub_name\n\n")

            # Find and sort markdown files within the subsection
            md_files = filter(f -> endswith(f, DOC_EXTENSION) && isfile(joinpath(sub_path, f)), readdir(sub_path))
            sort!(md_files)

            for md_file in md_files
                file_path = joinpath(sub_path, md_file)
                println("    Adding file: $md_file")
                content = safe_read(file_path)
                write(markdown_buffer, content)
                write(markdown_buffer, "\n\n---\n\n") # Add a horizontal rule between files
            end
        end
        write(markdown_buffer, "\n")
    end

    full_markdown = String(take!(markdown_buffer))
    escaped_markdown = escape_for_js_template(full_markdown)

    timestamp = Dates.format(Dates.now(), "yyyy-mm-dd HH:MM:SS")

    println("Generating HTML...")

# --- HTML Template ---
    html_content = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Julia Performance Crash Course</title>

        <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/julia.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/bash.min.js"></script>

        <style>
            :root {
                --sidebar-bg: #f7f7f7;
                --text-color: #333;
                --link-color: #007bff;
                --hover-bg: #e9e9e9;
                --border-color: #ddd;
                --code-bg: #282c34; /* Match atom-one-dark */
            }
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                line-height: 1.6;
                margin: 0;
                padding: 0;
                color: var(--text-color);
                background-color: #fff;
            }
            .container {
                display: flex;
            }
            #sidebar {
                width: 280px;
                background-color: var(--sidebar-bg);
                border-right: 1px solid var(--border-color);
                padding: 1.5em;
                height: 100vh;
                overflow-y: auto;
                position: sticky;
                top: 0;
            }
            #sidebar h1 {
                margin-top: 0;
                font-size: 1.5em;
                color: #000;
            }
            #sidebar ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            #sidebar li a {
                text-decoration: none;
                color: var(--text-color);
                display: block;
                padding: 0.4em 0.5em;
                border-radius: 4px;
                transition: background-color 0.2s;
            }
            #sidebar li a:hover {
                background-color: var(--hover-bg);
            }
            main {
                flex-grow: 1;
                padding: 2em 4em;
                max-width: 900px;
                margin: 0 auto;
            }
            h1, h2 {
                border-bottom: 1px solid var(--border-color);
                padding-bottom: 0.3em;
                margin-top: 1.5em; /* Add space above headings */
            }
            pre code.hljs {
                padding: 1em;
                border-radius: 5px;
                background-color: var(--code-bg);
                overflow-x: auto; /* Allow horizontal scroll for long code lines */
            }
            code {
                font-family: "SF Mono", "Menlo", "Consolas", monospace;
                font-size: 0.9em; /* Slightly smaller code font */
            }
            /* Inline code background slightly different */
            p > code, li > code, td > code {
                 background-color: #f0f0f0;
                 padding: 0.2em 0.4em;
                 border-radius: 3px;
            }
            blockquote {
                border-left: 4px solid var(--border-color);
                padding-left: 1em;
                color: #666;
                margin-left: 0;
                background-color: #f9f9f9; /* Slight background for blockquotes */
            }
            table {
                border-collapse: collapse;
                width: 100%;
                margin: 1em 0;
            }
            th, td {
                border: 1px solid var(--border-color);
                padding: 0.5em;
                text-align: left;
            }
            th {
                background-color: var(--sidebar-bg);
            }
            hr {
                border: none;
                border-top: 2px solid var(--hover-bg);
                margin: 2.5em 0; /* More space around separators */
            }
            /* Adjustments for smaller screens */
            @media (max-width: 768px) {
                .container { flex-direction: column; }
                #sidebar { position: static; width: 100%; height: auto; max-height: 40vh; /* Limit sidebar height on mobile */ border-right: none; border-bottom: 1px solid var(--border-color); }
                main { padding: 1.5em; }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <nav id="sidebar">
                <h1>Crash Course</h1>
                <ul id="toc-list"></ul>
                <hr>
                <p style="font-size: 0.8em; color: #666;">Generated: $timestamp</p>
            </nav>
            <main id="content">
                <p>Loading content...</p>
            </main>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // The entire concatenated markdown content is embedded here.
                const markdownContent = `$(escaped_markdown)`;

                // Configure marked.js (no highlight option needed here)
                marked.setOptions({
                    langPrefix: 'hljs language-' // Match highlight.js CSS prefix
                });

                // Render the Markdown to HTML and inject it into the main content area
                const contentDiv = document.getElementById('content');
                contentDiv.innerHTML = marked.parse(markdownContent);

                // --- Apply Syntax Highlighting ---
                // Tell highlight.js to find and highlight all code blocks within the contentDiv
                contentDiv.querySelectorAll('pre code').forEach((block) => {
                    // Remove leading/trailing empty lines often added by markdown parsers
                    block.textContent = block.textContent.trim();
                    hljs.highlightElement(block);
                });

                // --- Generate Table of Contents (TOC) ---
                const tocList = document.getElementById('toc-list');
                const headings = contentDiv.querySelectorAll('h1, h2');
                headings.forEach((heading, index) => {
                    const level = heading.tagName === 'H1' ? 1 : 2;
                    // Create a unique ID for each heading to link to
                    const idText = (heading.textContent || '').trim();
                    const id = idText.toLowerCase().replace(/[^a-z0-9]+/g, '-') + '-' + index;
                    heading.id = id;

                    const listItem = document.createElement('li');
                    const link = document.createElement('a');
                    link.href = '#' + id;
                    link.textContent = idText; // Use trimmed text

                    if (level === 1) {
                        link.style.fontWeight = 'bold';
                        link.style.marginTop = '0.75em';
                        link.style.fontSize = '1.1em';
                    } else {
                        link.style.paddingLeft = '1.5em';
                    }
                    listItem.appendChild(link);
                    tocList.appendChild(listItem);
                });
            });
        </script>
    </body>
    </html>
    """
    

    # Write the final HTML to the output file
    try
        open(OUTPUT_HTML, "w") do f
            write(f, html_content)
        end
        println("Successfully generated '$OUTPUT_HTML'")
    catch e
        println("Error writing HTML file: $e")
    end
end

# --- Run the Build ---
build_docs()