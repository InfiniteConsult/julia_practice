import Test: @test, @testset

include("my_math.jl")

@testset "MyMath.add_two Tests" begin
    @test MyMath.add_two(3) == 5
    @test MyMath.add_two(0) == 2
    @test MyMath.add_two(-5) == -3

    @testset "Floating Point Tests" begin
        @test MyMath.add_two(1.5) ≈ 3.5
        @test MyMath.add_two(-0.5) ≈ 1.5
    end

    @testset "Failing Test Example" begin
        @test MyMath.add_two(10) == 11
    end
end

println("\nTest execution finished.")