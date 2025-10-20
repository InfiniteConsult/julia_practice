println("--- Mutable Struct ---")


mutable struct MyData
    val::Int64
end

d = MyData(100)

ptr_d_obj = pointer_from_objref(d)

println("Object d: ", d)
println("Pointer to d object (Ptr{Nothing}): ", ptr_d_obj)

println("\n--- Array ---")
A = [10, 20, 30]

ptr_A_data = pointer(A)
println("Array A: ", A)
println("Pointer to A's data (Ptr{Int64}): ", ptr_A_data)

ptr_A_header = pointer_from_objref(A)
println("Pointer to A's *header* (Ptr{Nothing}): ", ptr_A_header)

println("\n--- Immutable isbits Struct ---")
struct Point
    x::Float64
    y::Float64
end

p = Point(1.0, 2.0)
println("Point p: ", p)

p_boxed = Ref(p)
ptr_p_ref_obj = pointer_from_objref(p_boxed)
println("Boxed Point (Ref): ", p_boxed)
println("Pointer to Ref object: ", ptr_p_ref_obj)

ptr_p_data_in_ref = Base.unsafe_convert(Ptr{Point}, p_boxed)
println("Pointer to Point data inside Ref: ", ptr_p_data_in_ref)
