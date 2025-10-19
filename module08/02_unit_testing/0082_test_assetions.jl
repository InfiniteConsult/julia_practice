import Test: @test, @testset, @test_throws, @test_broken, @test_skip

include("my_math.jl")

@testset "@test_throws Example" begin
    @test_throws MethodError MyMath.add_two("hello")

    @test_throws DivideError div(1, 0)
    # @test_throws DomainError MyMath.add_two(5)
end

@testset "@test_broken Example" begin
    @test_broken MyMath.add_two(0.1 + 0.2) == 0.3 + 2.0 # Not actually broken. Probably floating point still accurate
    # @test_broken MyMath.add_two(1) == 3
end

@testset "@test_skip Example" begin
    @test_skip MyMath.add_two("this code won't even run")
end

println("\nTest execution finished.")