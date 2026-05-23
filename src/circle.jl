"""
    circleplot(::Manifolds.Circle{ℝ}; kwargs...)
    circleplot(::Manifolds.Circle{ℂ}; kwargs...)

Draw a plot for data on the [`Circle`](@extref `Manifolds.Circle`).
For the real-valued case this is a plot on an interval [-π,π), for the complex case a circle in the complex plane.


This can be combined with
* [`scatter`](@extref `Makie.scatter`)`(M, pts)` to plot points thereon
* [`arrows2d`](@extref `Makie.arrows3d`)`(M, pts, vecs)` to plot tangent vectors (for the complex case)
* [`lines`](@extref Makie.lines)`(M, pst)` and [`scatterlines`](@extref Makie.scatterlines)`(M, pst)` to signals (only on the real circle),
  where jumps larger than ``π`` are not drawn

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

# Real case
function Makie.plot!(p::CirclePlot{<:Tuple{Manifolds.Circle{ℝ}}})
    #Fake elements?
    scatter!(p, Point3f(NaN))
    return p
end
function circleplot(
        M::Manifolds.Circle{ℝ};
        size = (1024, 1024), backgroundcolor = :white, kwargs...
    )
    fig = Figure(; backgroundcolor = backgroundcolor, size = size)
    ax = Axis(
        fig[1, 1];
        yticks = ([-π, -π / 2, 0.0, π / 2, π], ["-π", L"-\frac{π}{2}", "0", L"\frac{π}{2}", L"π"]), limits = (nothing, (-π, π)),
        kwargs...
    )
    ax.topspinecolor = :lightgray
    hidespines!(ax, :r)
    pl = circleplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end

# For `scatter(M, pts)`, `lines(M, pts)`, `scatterlines(M, pts)`
# (and any other PointBased plot) work on a manifold via this overload.
# We do not have to transform the points
function Makie.convert_arguments(P::Makie.PointBased, M::Manifolds.Circle{ℝ}, pts::V) where {V <: AbstractVector{<:Real}}
    # Remove vertical lines by adding NaN entries to stop lines
    v = Point2f[]
    n = length(pts)
    for i in 1:n
        push!(v, Point2f(i, pts[i]))
        (i < n) && abs(pts[i] - pts[i + 1]) > π && push!(v, Point2f(NaN, NaN))
    end
    return Makie.convert_arguments(P, M, v)
end
function Makie.convert_arguments(P::Makie.PointBased, M::Manifolds.Circle{ℝ}, x, pts::V) where {V <: AbstractVector{<:Real}}
    v = Point2f[]
    n = length(pts)
    for i in 1:n
        push!(v, Point2f(x[i], pts[i]))
        (i < n) && abs(pts[i] - pts[i + 1]) > π && push!(v, Point2f(NaN, NaN))
    end
    return Makie.convert_arguments(P, M, v)
end
# we already have P2fs, just pass down
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Circle{ℝ}, pts::V) where {V <: AbstractVector{<:Point}}
    return Makie.convert_arguments(P, pts)
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
function Makie.convert_arguments(P::Makie.PointBased, M::Manifolds.Circle{ℂ}, pts::V) where {V <: AbstractVector{<:Complex}}
    return Makie.convert_arguments(P, M, [ Point2f(real(p), imag(p)) for p in pts])
end
# we already have Point2fs, just pass down
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Circle{ℂ}, pts::V) where {V <: AbstractVector{<:Point}}
    return Makie.convert_arguments(P, pts)
end

# For arrows2d(M, pts, vecs) we want to combine the classical scatter with arrows,
# where we assume that vecs[i] is in the tangent space of pts[1]
# (a) From Manifolds.jl
function Makie.convert_arguments(
        P::Makie.ArrowLike, M::Manifolds.Circle{ℂ}, pts::V, vecs::W
    ) where {V <: AbstractVector{<:Complex}, W <: AbstractVector{<:Complex}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jl
    return Makie.convert_arguments(
        P, M, [ Point2f(real(p), imag(p)) for p in pts], [ Vec2f(real(v), imag(v)) for v in vecs],
    )
end
# (b) already in Point2f / Vec2f
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Circle{ℂ}, pts::V, vecs::W) where {V <: AbstractVector{<:Point}, W <: AbstractVector{<:Vec}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jl
    return (
        convert_arguments(Makie.PointBased(), pts)[1], convert_arguments(Makie.PointBased(), vecs)[1],
    )
end

"""
    circleimage(::Manifolds.Circle{ℝ}; kwargs...)

Start a plot for 2D data with values on the [`Circle`](@extref `Manifolds.Circle`)
represented in angles an interval [-π,π).

This can be combined with
* [`image`](@extref `Makie.image`)`(M, img)` to show the image of the data.

## Examples

```julia
fig, ax, p = circleimage(Manifolds.Circle(ℂ))
```
"""
@recipe CircleImage (M,) begin
    Makie.mixin_generic_plot_attributes()...
end

# Real case
function Makie.plot!(p::CircleImage{<:Tuple{Manifolds.Circle{ℝ}}})
    #Fake elements?
    scatter!(p, Point3f(NaN))
    return p
end
function circleimage(
        M::Manifolds.Circle{ℝ};
        size = (1024, 1024), backgroundcolor = :white, aspect = Makie.DataAspect(), kwargs...
    )
    fig = Figure(; backgroundcolor = backgroundcolor, size = size)
    ax = Axis(
        fig[1, 1]; aspect = aspect, kwargs...
    )
    Colorbar(
        fig[1, 2];
        limits = (-π, π),
        colormap = :hsv,
        ticks = ([-π, -π / 2, 0.0, π / 2, π], ["-π", L"-\frac{π}{2}", "0", L"\frac{π}{2}", L"π"]),
    )
    pl = circleimage!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end

# For just image data without x and y
function Makie.convert_arguments(
        P::Makie.ImageLike, M::Manifolds.Circle{ℝ}, img::I
    ) where {I <: AbstractMatrix{<:Real}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jl
    return Makie.convert_arguments(P, Manifolds.sym_rem.(img))
end
# For image data with axis x and y
function Makie.convert_arguments(P::Makie.ImageLike, ::Manifolds.Circle{ℝ}, x, y, img::I) where {I <: AbstractMatrix{<:Real}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jl
    return Makie.convert_arguments(P, x, y, Manifolds.sym_rem.(img))
end
