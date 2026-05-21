"""
    sphereplot(::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{n}}}; kwargs...)

Draw the [`Sphere`](@extref `Manifolds.Sphere`)`(n)`, ``n=1,2`` as a (transparent) surface with an overlaid wireframe.

This can be combined with
* [`scatter`](@extref `Makie.scatter`)`(M, pts)` to plot points thereon
* [`arrows3d`](@extref `Makie.arrows3d`)`(M, pts, vecs)` to plot tangent vectors
* [`geodesics`](@ref)`(M, pst)` and [`scattergeodesics`](@ref)`(M, pst)` to draw geodesics

## Examples

```julia
fig, ax, p = sphereplot(Manifolds.Sphere(2))
```

for the 2-sphere ``𝕊^2`` embedded in ``ℝ^3``


 ```julia
fig, ax, p = sphereplot(Manifolds.Sphere(1))
```

for the cyclic data on ``𝕊^1`` embedded in ``ℝ^2``
"""
@recipe SpherePlot (M,) begin
    "Color of the wireframe lines drawn on top of the surface (``𝕊^2``)."
    wirecolor = (:lightsteelblue, 0.4)
    "Tessellation resolution (segments of the wireframe in every direction, ``𝕊^2``)."
    wires = 24
    "linewidth of the wire (``𝕊^2``)"
    wirewidth = 0.5
    "Solid color of the surface (``𝕊^2``) or boundary (``𝕊^1``)."
    surfacecolor = :white
    "Surface alpha (0 = transparent, 1 = opaque)."
    surfacealpha = 0.33
    "thickness of the boundary surface (only ``𝕊^1``)"
    surfaceboundary = 2
    # add the other default plot attributes here as well
    Makie.mixin_generic_plot_attributes()...
end

#
#
# 𝕊^1
function Makie.plot!(p::SpherePlot{<:Tuple{Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{1}}}}})
    map!(p.attributes, [:M], :circle) do M
        return GeometryBasics.Circle(Point2f(0, 0), 1.0f0)
    end
    lines!(p, p.circle; color = p.surfacecolor, alpha = p.surfacealpha, linewidth = p.surfaceboundary)
    return p
end

function sphereplot(
        M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{1}}};
        size = (1024, 1024), backgroundcolor = :white, show_axis = false, aspect = Makie.DataAspect(), kwargs...
    )
    fig = Figure(; backgroundcolor = backgroundcolor, size = size)
    ax = Axis(fig[1, 1])
    ax.aspect = aspect
    if !show_axis
        hidedecorations!(ax)
        hidespines!(ax)
    end
    pl = sphereplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end

function Makie.plot!(p::SpherePlot{<:Tuple{Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}}})
    # create a new compute edge
    # with [:M, :wires] as input nodes (these must already exist)
    # with :sphere_mesh as the output node (this will be created)
    # running the computation defined in the do ... end block
    # where :M is M and :wires is mapped to n
    map!(p.attributes, [:M, :wires], :sphere_mesh) do M, n
        return GeometryBasics.uv_normal_mesh(Tessellation(Makie.Sphere(Point3f(0), 1.0f0), n))
    end
    # A solid surface
    mesh!(
        p, p.sphere_mesh;
        color = p.surfacecolor, alpha = p.surfacealpha, transparency = true,
    )
    # a wireframe atop
    wireframe!(p, p.sphere_mesh; color = p.wirecolor, linewidth = p.wirewidth, transparency = true)
    return p
end

#
#
# Overwrite sphereplot (as a bit of a hack) to remove axes and use the nice default sphere from the docs?
function sphereplot(
        M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}};
        size = (1024, 1024), backgroundcolor = :white, show_axis = false, aspect = :data, kwargs...
    )
    fig = Figure(; backgroundcolor = backgroundcolor, size = size)
    ax = Axis3(fig[1, 1], aspect = aspect)
    if !show_axis
        hidedecorations!(ax)
        hidespines!(ax)
    end
    ax.azimuth = π / 4
    pl = sphereplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
# For `scatter(M, pts)`, `lines(M, pts)`, `scatterlines(M, pts)`
# (and any other PointBased plot) work on a manifold via this overload.
# We do not have to transform the points
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{1}}}, pts::V) where {V <: AbstractVector{<:AbstractVector}}
    return Makie.convert_arguments(P, Point2f.(pts))
end
# we already have P3fs, just pass down
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{1}}}, pts::V) where {V <: AbstractVector{<:Point}}
    return Makie.convert_arguments(P, pts)
end
# S2
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts::V) where {V <: AbstractVector{<:AbstractVector}}
    return Makie.convert_arguments(P, Point3f.(pts))
end
# we already have P3fs, just pass down
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts::V) where {V <: AbstractVector{<:Point}}
    return Makie.convert_arguments(P, pts)
end

# For arrows2d(M, pts, vecs) we want to combine the classical scatter with arrows,
# where we assume that vecs[i] is in the tangent space of pts[1]
# (a) From Manifolds.jl
function Makie.convert_arguments(
        ::Makie.ArrowLike, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{1}}}, pts::V, vecs::W
    ) where {V <: AbstractVector{<:AbstractVector}, W <: AbstractVector{<:AbstractVector}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), Point2f.(pts))[1], convert_arguments(Makie.PointBased(), Vec2f.(vecs))[1],
    )
end
# (b) already in Point2f
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{1}}}, pts::V, vecs::W) where {V <: AbstractVector{<:Point}, W <: AbstractVector{<:Vec}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), pts)[1], convert_arguments(Makie.PointBased(), vecs)[1],
    )
end

# For arrows3d(M, pts, vecs) we want to combine the classical scatter with arrows,
# where we assume that vecs[i] is in the tangent space of pts[1]
# (a) From Manifolds.jl
function Makie.convert_arguments(
        ::Makie.ArrowLike, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts::V, vecs::W
    ) where {V <: AbstractVector{<:AbstractVector}, W <: AbstractVector{<:AbstractVector}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), Point3f.(pts))[1], convert_arguments(Makie.PointBased(), Vec3f.(vecs))[1],
    )
end
# (b) already in Point3f
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts::V, vecs::W) where {V <: AbstractVector{<:Point}, W <: AbstractVector{<:Vec}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), pts)[1], convert_arguments(Makie.PointBased(), vecs)[1],
    )
end
