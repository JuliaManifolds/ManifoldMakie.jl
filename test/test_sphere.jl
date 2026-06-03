using GLMakie, Manifolds, ManifoldMakie, ManoptExamples, ReferenceTests, Test

@testset "Plots for data on the sphere" begin
    @testset "Plots on the 1-sphere" begin
        M = Manifolds.Sphere(1)
        p = [1.0, 0.0]
        q = [1 / sqrt(2), -1 / sqrt(2)]
        r = [1 / sqrt(2), 1 / sqrt(2)]
        pts = shortest_geodesic(M, p, q, 0:0.05:1.0)
        vecs = [log(M, s, r) for s in pts]

        fig, ax, pl = arrows2d(M, pts, vecs; color = :blue)
        scatter!(ax, M, pts; color = :green, markersize = 16)
        scatter!(ax, M, [r]; color = :orange, markersize = 16)
        @test_reference "img/sphere/S1-scatter.png" fig
    end
    @testset "Plots on the 2-Sphere" begin
        M = Manifolds.Sphere(2)
        s_fig, ax = Figure(M)
        @test_reference "img/sphere/sphere.png" s_fig

        p = [0.0, 0.0, 1.0]
        q = [0.0, 1 / sqrt(2), -1 / sqrt(2)]
        r = [1 / sqrt(2), 0.0, 1 / sqrt(2)]
        P = shortest_geodesic(M, p, q, 0:0.05:1.0)
        pts = Point3f.(P)
        fig, ax, pl = scatter(M, pts; color = :green, markersize = 16)
        @test_reference "img/sphere/scatter.png" fig
        # our plots can convert themselves, so this should do the same
        scatter!(ax, M, P; color = :green, markersize = 16)
        @test_reference "img/sphere/scatter.png" fig

        X = [log(M, s, r) for s in P]
        vecs = Vec3f.(X)
        fig2, ax2, pl2 = arrows3d(
            M, pts, vecs; color = :blue,
            minshaftlength = 0, shaftlength = 0.99, shaftradius = 0.004, tipradius = 0.016, tiplength = 0.1,
        )
        @test_reference "img/sphere/arrows3.png" fig2

        # Also check that the plots themselves convert, so this should di the same as the one before
        fig3, ax3, pl3 = arrows3d(
            M, P, X; color = :blue,
            minshaftlength = 0, shaftlength = 0.99, shaftradius = 0.004, tipradius = 0.016, tiplength = 0.1,
        )

        @test_reference "img/sphere/arrows3.png" fig3

        # Geodesics
        p1, p2, p3 = [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]
        p1b, p2b, = [1 / sqrt(2), 0, 1 / sqrt(2)], [0, 1 / sqrt(2), 1 / sqrt(2)]
        fig4, ax4, pl4 = geodesics(M, [p1, p2, p3]; closed = true, color = :green, linewidth = 3)
        scattergeodesics!(ax4, M, [p1b, p2b, p3]; closed = true, color = :blue, linewidth = 2, markersize = 12)
        @test_reference "img/sphere/geodesics.png" fig4

        fig5, ax5, pl5 = scattergeodesics(M, [p1b, p2b, p3]; closed = true, color = :blue, linewidth = 2, markersize = 12)
        @test_reference "img/sphere/geodesics2.png" fig5

    end
    @testset "2D data of unit norm vectors" begin
        M = Manifolds.Sphere(2)
        img = ManoptExamples.artificial_S2_whirl_image()
        fig1 = image(M, img)
        @test_reference "img/sphere/S2-data1.png" fig1
        fig2 = Figure()
        ax = Axis3(fig2[1, 1]; aspect = :data, elevation = π / 2, azimuth = π / 2)
        hidedecorations!(ax)
        hidespines!(ax)
        image!(ax, M, img)
        @test_reference "img/sphere/S2-data2.png" fig2
    end
end
