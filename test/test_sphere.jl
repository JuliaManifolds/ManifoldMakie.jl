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

    # Geodesics
    fig, ax, pl = sphereplot(M)
    p1, p2, p3 = [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]
    p1b, p2b, = [1 / sqrt(2), 0, 1 / sqrt(2)], [0, 1 / sqrt(2), 1 / sqrt(2)]
    geodesics!(ax, M, Point3f.([p1, p2, p3]); closed = true, color = :green, linewidth = 3)
    scattergeodesics!(ax, M, Point3f.([p1b, p2b, p3]); closed = true, color = :blue, linewidth = 2, markersize = 12)
    @test_reference "img/sphere/geodesics.png" fig
end
