using GLMakie, Manifolds, ManifoldMakie, ReferenceTests, Test

@testset "Plots on the 2-Sphere" begin
    M = Manifolds.Sphere(2)
    fig, ax, pl = sphereplot(M)
    @test_reference "img/sphere/sphere.png" fig

    p = [0.0, 0.0, 1.0]
    q = [0.0, 1 / sqrt(2), -1 / sqrt(2)]
    r = [1 / sqrt(2), 0.0, 1 / sqrt(2)]
    P = shortest_geodesic(M, p, q, 0:0.05:1.0)
    pts = Point3f.(P)
    scatter!(ax, M, pts; color = :green, markersize = 16)

    @test_reference "img/sphere/scatter.png" fig
end
