struct PaddedData
    a::Int8
    b::Int64
end

struct OptimizedData
    b::Int64
    a::Int8
end

struct CompactData
    a::Int64
    b::Int32
    c::Int16
    d::Int8
end

println("--- Data Alignment Requirements ---")

println("Alignment of Int8:          ", Base.datatype_alignment(Int8))
println("Alignment of Int64:         ", Base.datatype_alignment(Int64))

println("Alignment of PaddedData:    ", Base.datatype_alignment(PaddedData))
println("Alignment of OptimizedData: ", Base.datatype_alignment(OptimizedData))
println("Alignment of CompactData:   ", Base.datatype_alignment(CompactData))

println("\n--- Field Offsets (Proof of Padding) ---")

println("--- PaddedData (size $(sizeof(PaddedData))) ---")
println("Offset of a (field 1): ", fieldoffset(PaddedData, 1))
println("Offset of b (field 2): ", fieldoffset(PaddedData, 2))


println("--- OptimizedData (size $(sizeof(OptimizedData))) ---")
println("Offset of b (field 1): ", fieldoffset(OptimizedData, 1))
println("Offset of a (field 2): ", fieldoffset(OptimizedData, 2))

println("--- CompactData (size $(sizeof(CompactData))) ---")
println("Offset of a (field 1): ", fieldoffset(CompactData, 1))
println("Offset of b (field 2): ", fieldoffset(CompactData, 2))
println("Offset of c (field 3): ", fieldoffset(CompactData, 3))
println("Offset of d (field 4): ", fieldoffset(CompactData, 4))
