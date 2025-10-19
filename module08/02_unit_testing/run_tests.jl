import Test: @test

include("my_math.jl")

println("Running basic tests...")

@test MyMath.add_two(3) == 5
@test MyMath.add_two(0) == 2

# @test MyMath.add_two(1) == 4

println("\nBasic tests finished.")