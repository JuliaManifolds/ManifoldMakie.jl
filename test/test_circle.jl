using GLMakie, Manifolds, ManifoldMakie, ReferenceTests, Test

@testset "Plotting data on the Circle" begin
    @testset "On the complex circle" begin
        M = Manifolds.Circle(ℂ)
        fig, ax, pl = circleplot(M)

        p = 1.0 + 0.0im
        q = 1 / sqrt(2) - 1 / sqrt(2) * 1im
        r = 0.9 + sqrt(0.19)im
        pts = shortest_geodesic(M, p, q, 0:0.05:1.0)
        vecs = [log(M, s, r) for s in pts]

        arrows2d!(ax, M, pts, vecs; color = :blue)
        scatter!(ax, M, pts; color = :green, markersize = 16)
        scatter!(ax, M, [r]; color = :orange, markersize = 16)
        @test_reference "img/circle/complex-scatter.png" fig
    end
    @testset "On the real circle" begin
        M = Manifolds.Circle(ℝ)
        fig, ax, pl = circleplot(M)

        x = 0:0.25:5
        y = (mod.((x ./ 2) .^ 2 .- 0.4 .+ π, 2π)) .- π
        y2 = (mod.((x) .^ 2 .- 0.4 .+ π, 2π)) .- π

        lines!(ax, M, y; color = :green)
        scatter!(ax, M, x, y2; color = :green)
        @test_reference "img/circle/real-scatter.png" fig
    end
end
