using Makie, Manifolds, ManifoldMakie, Test

@testset "ManifoldMakie" begin
    include("test_circle.jl")
    include("test_sphere.jl")
    include("test_hyperbolic.jl")
    include("test_symmetricpositivedefinite.jl")
end
