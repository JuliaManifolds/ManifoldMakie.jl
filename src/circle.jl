"""
    circleplot(::Manifolds.Circle{ℝ}; kwargs...)
    circleplot(::Manifolds.Circle{ℂ}; kwargs...)

Draw a plot for data on the [`Circle`](@extref `Manifolds.Circle`).
For the real-valued case this is a plot on an interval [-π,π), for the complex case a circle in the complex plane.

This can be combined with
* [`scatter`](@extref `Makie.scatter`)`(M, pts)` to plot points thereon
* [`arrows3d`](@extref `Makie.arrows3d`)`(M, pts, vecs)` to plot tangent vectors
* [`geodesics`](@ref)`(M, pst)` and [`scattergeodesics`](@ref)`(M, pst)` to draw geodesics

## Examples

```julia
fig, ax, p = circleplot(Manifolds.Circle(ℂ))
```
"""
@recipe CirclePlot (M,) begin
    "Circle alpha (0 = transparent, 1 = opaque) in the complex case (`Circle(ℂ)`)"
    alpha = 0.33
    "Color of the circle in the complex case (`Circle(ℂ)`)"
    color = :black
    "line width of the circle in the complex plane (`Circle(ℂ)`))"
    linewidth = 2
    # add the other default plot attributes here as well
    Makie.mixin_generic_plot_attributes()...
end

# Complex case
function Makie.plot!(p::CirclePlot{<:Tuple{Manifolds.Circle{ℂ}}})
    map!(p.attributes, [:M], :circle) do M
        return GeometryBasics.Circle(Point2f(0, 0), 1.0f0)
    end
    lines!(p, p.circle; color = p.color, alpha = p.alpha, linewidth = p.linewidth)
    return p
end

function circleplot(
        M::Manifolds.Circle{ℂ};
        size = (1024, 1024), backgroundcolor = :white, show_axis = false, aspect = Makie.DataAspect(), kwargs...
    )
    fig = Figure(; backgroundcolor = backgroundcolor, size = size)
    ax = Axis(fig[1, 1])
    ax.aspect = aspect
    if !show_axis
        hidedecorations!(ax)
        hidespines!(ax)
    end
    pl = circleplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end

# For `scatter(M, pts)`, `lines(M, pts)`, `scatterlines(M, pts)`
# (and any other PointBased plot) work on a manifold via this overload.
# We do not have to transform the points
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Circle{ℂ}, pts::V) where {V <: AbstractVector{<:Complex}}
    return Makie.convert_arguments(P, [ Point2f(real(p), imag(p)) for p in pts])
end
# we already have P3fs, just pass down
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Circle{ℂ}, pts::V) where {V <: AbstractVector{<:Point}}
    return Makie.convert_arguments(P, pts)
end

# For arrows2d(M, pts, vecs) we want to combine the classical scatter with arrows,
# where we assume that vecs[i] is in the tangent space of pts[1]
# (a) From Manifolds.jl
function Makie.convert_arguments(
        ::Makie.ArrowLike, ::Manifolds.Circle{ℂ}, pts::V, vecs::W
    ) where {V <: AbstractVector{<:Complex}, W <: AbstractVector{<:Complex}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jl
    return (
        convert_arguments(Makie.PointBased(), [ Point2f(real(p), imag(p)) for p in pts])[1],
        convert_arguments(Makie.PointBased(), [ Vec2f(real(v), imag(v)) for v in vecs])[1],
    )
end
# (b) already in Point2f / Vec2f
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Circle{ℂ}, pts::V, vecs::W) where {V <: AbstractVector{<:Point}, W <: AbstractVector{<:Vec}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jl
    return (
        convert_arguments(Makie.PointBased(), pts)[1], convert_arguments(Makie.PointBased(), vecs)[1],
    )
end
