import Base.Libc: Clong, Cvoid, C_NULL

println("--- Calling C Standard Library Functions via ccall ---")

println("\n--- Calling time(NULL) [Using Explicit Path] ---")

const ACTUAL_LIBC_PATH = "/usr/lib/x86_64-linux-gnu/libc.so.6"
println("Using explicit libc path: ", ACTUAL_LIBC_PATH)

current_time_t = try
    ccall(
        (:time, ACTUAL_LIBC_PATH),
        Clong,
        (Ptr{Cvoid},),
        C_NULL
    )
catch e
    println("ERROR calling time with explicit path '$ACTUAL_LIBC_PATH': ", e)
    Clong(-1)
end

if current_time_t != -1
    println("Result of C's time(NULL): ", current_time_t)
    println("Type of result:           ", typeof(current_time_t))
    println("Julia's time():           ", time())
end

println("\n--- Calling clock() [Using \"\" Library Path] ---")

const LIBC_LOOKUP_CURRENT = ""

ticks = try
    ccall(
        (:clock, LIBC_LOOKUP_CURRENT),
        Clong,
        ()
    )
catch e
    println("ERROR calling clock with \"\" library path: ", e)
    Clong(-1)
end

if ticks != -1
    println("Result of C's clock(): ", ticks, " ticks")
    const CLOCKS_PER_SEC = 1_000_000 
    time_in_seconds = ticks / CLOCKS_PER_SEC
    println("Time in seconds (approx): ", time_in_seconds)
end

println("\n--- Calling getpid() [Using :libc Symbol - Might Fail] ---")

pid = try
     ccall(
        (:getpid, :libc),
        Cint,
        ()
    )
catch e
    println("ERROR calling getpid with :libc symbol: ", e)
    println("  This demonstrates that ':libc' lookup can sometimes fail,")
    println("  especially in non-standard environments. Using \"\" might be more robust.")
    Cint(-1)
end

if pid != -1
    println("Result of C's getpid(): ", pid)
    println("Julia's getpid():       ", getpid())
else
    println("Trying getpid() again using \"\" library path...")
    pid_fallback = try
        ccall((:getpid, ""), Cint, ())
    catch e_fallback
        println("  ERROR calling getpid with \"\" as well: ", e_fallback)
        Cint(-1)
    end
    if pid_fallback != -1
        println("  Result using \"\": ", pid_fallback, " (Success)")
    end
end