using GLMakie, Manifolds, ManifoldMakie, ManoptExamples, ReferenceTests, Test

@testset "Plotting data on the Circle" begin
    @testset "On the complex circle" begin
        M = Manifolds.Circle(ℂ)

        p = 1.0 + 0.0im
        q = 1 / sqrt(2) - 1 / sqrt(2) * 1im
        r = 0.9 + sqrt(0.19)im
        pts = shortest_geodesic(M, p, q, 0:0.05:1.0)
        vecs = [log(M, s, r) for s in pts]

        fig, ax, pl = arrows2d(M, pts, vecs; color = :blue)
        scatter!(ax, M, pts; color = :green, markersize = 16)
        scatter!(ax, M, [r]; color = :orange, markersize = 16)
        @test_reference "img/circle/complex-scatter.png" fig

        fig2, ax2, pl2 = scatter(M, pts; color = :green, markersize = 16)
        @test_reference "img/circle/complex-scatter2.png" fig2
    end
    @testset "On the real circle" begin
        M = Manifolds.Circle(ℝ)

        x = 0:0.25:5
        y = (mod.((x ./ 2) .^ 2 .- 0.4 .+ π, 2π)) .- π
        y2 = (mod.((x) .^ 2 .- 0.4 .+ π, 2π)) .- π

        fig, ax, pl = lines(M, y; color = :green)
        scatter!(ax, M, x, y2; color = :green)
        @test_reference "img/circle/real-scatter.png" fig

        circleplot!(ax, M) # check that this does not fail and here – does nothing
        @test_reference "img/circle/real-scatter.png" fig
    end
    @testset "Circle Image" begin
        img = sym_rem.(ManoptExamples.artificialIn_SAR_image(256))
        M = Manifolds.Circle(ℝ)
        fig, ax, pl = image(M, img)
        @test_reference "img/circle/image.png" fig

        circleimage!(ax, M) # check that this does not fail and here – does nothing
        @test_reference "img/circle/image.png" fig


        # also works with ranges x and y
        figax = circleimage(M)
        fig = figax.figure
        ax = figax.axis
        image!(ax, M, (1, 128), (1, 128), img)
        @test_reference "img/circle/image.png" fig
    end
end
