using Makie, Manifolds, ManifoldMakie, Test

@testset "ManifoldMakie" begin
    include("test_sphere.jl")
    include("test_hyperbolic.jl")
end
