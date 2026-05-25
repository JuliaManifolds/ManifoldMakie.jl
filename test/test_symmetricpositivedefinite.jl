using GLMakie, LinearAlgebra, ManifoldMakie, Manifolds, ManoptExamples, ReferenceTests, Test

@testset "Plots for data of symmetric positive defninite matrices" begin
    @testset "Plots for SPD(2) data" begin
        R(α) = [cos(α) -sin(α); sin(α) cos(α)]
        n = 32
        M = SymmetricPositiveDefinite(2)
        data = [ R(π * (x + y))' * diagm([1.0 + x + y, 1.0 / (1.0 + x + y)]) * R(π * (x + y)) for x in range(0, 1, n), y in range(0, 1, n)]
        fig1, ax1, pl1 = image(M, data)
        @test_reference "img/symmetricpositivedefinite/SPD2-image.png" fig1
        fig2 = Figure()
        ax = Axis(fig2[1, 1], aspect = Makie.DataAspect())
        hidedecorations!(ax)
        hidespines!(ax)
        image!(ax, M, data)
        @test_reference "img/symmetricpositivedefinite/SPD2-image2.png" fig2
    end

    @testset "Plots for SPD(3) data" begin
        M = Manifolds.SymmetricPositiveDefinite(3)
        data = ManoptExamples.artificial_SPD_image(32)
        fig1, ax1, pl1 = image(M, data; scale_ev = 2.0, scale_mode = :relative)
        @test_reference "img/symmetricpositivedefinite/SPD3-image.png" fig1
        fig2 = Figure()
        ax = Axis3(fig2[1, 1]; aspect = :data, elevation = π / 2, azimuth = π / 2)
        hidedecorations!(ax)
        hidespines!(ax)
        image!(ax, M, data; scale_ev = 2.0, scale_mode = :relative)
        @test_reference "img/symmetricpositivedefinite/SPD3-image2.png" fig2
    end
end
