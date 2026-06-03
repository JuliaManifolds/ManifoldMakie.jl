using GLMakie, Manifolds, ManifoldMakie, ReferenceTests, Test

@testset "Hyperbolic tests" begin
    @testset "Plots on the 2-dimensional hyperboloid model" begin
        M = Hyperbolic(2)
        p, q, r = [2.0, 0.0, sqrt(5)], [2.0, 2.0, 3.0], [2.0, -2.0, 3.0]
        P1 = [p, q, r]
        P2 = HyperboloidPoint.(P1)
        P3 = Point3f.(P1)
        X1 = [log(M, p, q), log(M, q, p), log(M, r, p)]
        X2 = HyperboloidTangentVector.(X1)
        X3 = Vec3f.(X1)
        # Now always all 3 variants should do the same
        # ... for scatter
        fig, ax, pl = scatter(M, P1, markersize = 20, color = :green)
        @test_reference "img/hyperbolic/scatter.png" fig
        fig, ax, pl = scatter(M, P2, markersize = 20, color = :green)
        @test_reference "img/hyperbolic/scatter.png" fig
        fig, ax, pl = scatter(M, P3, markersize = 20, color = :green)
        @test_reference "img/hyperbolic/scatter.png" fig
        # and for arrows3D
        fig, ax, pl = arrows3d(
            M, P1, X1; color = :blue, minshaftlength = 0, shaftlength = 0.99,
            shaftradius = 0.004, tipradius = 0.016, tiplength = 0.1,
        )
        @test_reference "img/hyperbolic/arrows3.png" fig
        fig, ax, pl = arrows3d(
            M, P2, X2; color = :blue, minshaftlength = 0, shaftlength = 0.99,
            shaftradius = 0.004, tipradius = 0.016, tiplength = 0.1,
        )
        @test_reference "img/hyperbolic/arrows3.png" fig
        fig, ax, pl = arrows3d(
            M, P3, X3; color = :blue, minshaftlength = 0, shaftlength = 0.99,
            shaftradius = 0.004, tipradius = 0.016, tiplength = 0.1,
        )
        @test_reference "img/hyperbolic/arrows3.png" fig

        # Geodesics
        fig, ax, pl = geodesics(M, P1; closed = true, color = :green, linewidth = 3)
        scattergeodesics!(ax, M, P1; closed = true, color = :blue, linewidth = 2, markersize = 12)
        @test_reference "img/hyperbolic/geodesics.png" fig
    end
    @testset "Poincare disc" begin
        M = Hyperbolic(2)

        pts = PoincareBallPoint.([[0.0, 0.0], [0.7, -0.7], [0.7, 0.7], [-0.7, 0.7], [-0.7, -0.7]])
        vecs = [
            0.25 * log(M, pts[1], pts[2]), [log(M, p, pts[1]) for p in pts[2:end]]...,
        ]
        fig, ax = Figure(M, eltype(pts); surfacealpha = 0.5, surfaceboundary = 1)
        scatter!(ax, M, pts; color = :blue, markersize = 8)
        arrows2d!(ax, M, pts, vecs; color = :green)
        geodesics!(ax, M, pts[2:end]; closed = true, color = :orange)
        @test_reference "img/hyperbolic/poincaredisc.png" fig
    end
    @testset "Poincare ball" begin

        M = Hyperbolic(3)
        pts = PoincareBallPoint.([[0.0, 0.0, 0.0], [0.5, 0.5, 0.5], [-0.5, 0.5, 0.5], [-0.5, -0.5, 0.5], [-0.5, -0.5, -0.5], [-0.5, 0.5, -0.5], [0.5, 0.5, -0.5]])
        vecs = [
            0.25 .* log(M, pts[1], pts[2]), [log(M, p, pts[1]) for p in pts[2:end]]...,
        ]
        fig, ax, pl = scatter(M, pts; color = :blue, markersize = 8)
        arrows3d!(ax, M, pts, vecs; color = :green)
        geodesics!(ax, M, pts[2:end]; closed = true, color = :orange)
        ax.azimuth = 0
        @test_reference "img/hyperbolic/poincareball.png" fig
    end
    @testset "Poincare half plane" begin
        M = Hyperbolic(2)

        pts = PoincareHalfSpacePoint.([[0.0, 1.0], [-0.3, 0.2], [-0.6, 0.4], [0.6, 0.4], [0.3, 0.2]])
        vecs = [
            log(M, pts[1], PoincareHalfSpacePoint([0.0, 0.6])), [log(M, p, pts[1]) for p in pts[2:end]]...,
        ]
        fig, ax = Figure(M, eltype(pts))
        scatter!(ax, M, pts; color = :blue, markersize = 8)
        arrows2d!(ax, M, pts, vecs; color = :green)
        geodesics!(ax, M, pts; closed = true, color = :orange)
        @test_reference "img/hyperbolic/halfplane.png" fig
    end
    @testset "Poincare half space" begin
        M = Hyperbolic(3)
        fig, ax, pl = poincarehalfspaceplot(M)

        pts = PoincareHalfSpacePoint.([[0.0, 0.0, 1.0], [0.0, -0.3, 0.2], [-0.6, 0.0, 0.4], [0.0, 0.6, 0.4], [0.3, 0.0, 0.2]])
        vecs = [
            log(M, pts[1], PoincareHalfSpacePoint([0.0, 0.0, 0.8])), [log(M, p, pts[1]) for p in pts[2:end]]...,
        ]
        scatter!(ax, M, pts; color = :blue, markersize = 8)
        arrows3d!(ax, M, pts, vecs; color = :green)
        geodesics!(ax, M, pts; closed = true, color = :orange)
        @test_reference "img/hyperbolic/halfspace.png" fig
    end
end
