"""
    poincarehalfspaceplot(M::Hyperbolic{ManifoldsBase.TypeParameter{Tuple{2}}}; kwargs...)
    poincarehalfspaceplot(M::Hyperbolic{ManifoldsBase.TypeParameter{Tuple{3}}}; kwargs...)

Draw the [`Hyperbolic`](@extref `Manifolds.Hyperbolic`)`(n)`, `n` either `2` or `3`, in the [Poiuncaré half plane model](https://en.wikipedia.org/wiki/Poincaré_half-plane_model),
which more generally is a half space for more than the 2D case.
This can be combined with
* [`scatter`](@extref `Makie.scatter`)`(M, pts)` to plot points thereon
* [`arrows3d`](@extref `Makie.arrows3d`)`(M, pts, vecs)` to plot tangent vectors
* [`geodesics`](@ref)`(M, pst)` and [`scattergeodesics`](@ref)`(M, pst)` to draw geodesics

## Keyword Arguments

* `size = (1024, 1024)` passed to the generated [`Figure`](@extref `Makie.Figure`)
* `backgroundcolor = :white` passed to the generated [`Figure`](@extref `Makie.Figure`)
* `axis = Dict{Symbol, Any}()` specify keywords to pass to the internal [`Axis`](@extref `Makie.Axis`)
* `figure = Dict{Symbol, Any}()` specify keywords to pass to the internal [`Figure`](@extref `Makie.Figure`)

all other keyword arguments are passed to the internal `plot!` call, so they can also be used
to modify the listed properties below.

## Example

```julia
fig, ax = poincarehalfspaceplot(Hyperbolic(2))
```

## Alias

`Figure(M, PoincareBallPoint; kwargs...)`

"""
@recipe PoincareHalfSpacePlot (M,) begin
    Makie.mixin_generic_plot_attributes()...
end
Makie.Figure(M::Hyperbolic, ::Type{<:PoincareHalfSpacePoint}; kwargs...) = poincarehalfspaceplot(M; kwargs...)

function Makie.plot!(p::PoincareHalfSpacePlot{<:Tuple{Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}}})
    #Fake elements?
    scatter!(p, Point3f(NaN))
    return p
end
function Makie.plot!(p::PoincareHalfSpacePlot{<:Tuple{Hyperbolic{Manifolds.TypeParameter{Tuple{3}}}}})
    #Fake elements?
    scatter!(p, Point3f(NaN))
    return p
end
#
#
# Overwrite poincareballplot (as a bit of a hack) to remove axes and use the nice default sphere from the docs?
function poincarehalfspaceplot(
        M::Hyperbolic{Manifolds.TypeParameter{Tuple{2}}};
        size = (1024, 1024), backgroundcolor = :white,
        limits = (nothing, nothing, 0.0, nothing), #to not change x and only lower y
        figure = Dict{Symbol, Any}(), axis = Dict{Symbol, Any}(), kwargs...
    )
    fig = Figure(; backgroundcolor = backgroundcolor, size = size, figure...)
    ax = Axis(fig[1, 1]; limits = limits, axis...)
    #we only have positive y values, so we set the spines accordingly to not show [:b]ottom
    hidespines!(ax, :b)
    pl = poincarehalfspaceplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
#
#
# Overwrite hyperboloidplot (as a bit of a hack) to remove axes and use the nice default sphere from the docs?
function poincarehalfspaceplot(
        M::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{3}}};
        size = (1024, 1024), backgroundcolor = :white,
        figure = Dict{Symbol, Any}(), axis = Dict{Symbol, Any}(), kwargs...
    )
    fig = Figure(; backgroundcolor = backgroundcolor, size = size, figure...)
    ax = Axis3(fig[1, 1], axis...)
    # 1. Set z floor to 0, leave upper limit as auto
    zlims!(ax, 0, nothing)
    pl = poincarehalfspaceplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end

function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::V) where {V <: AbstractVector{<:PoincareHalfSpacePoint}}
    return Makie.convert_arguments(P, [Point2f(p.value) for p in pts])
end
# If we already get `<:Point` this is already defined in hyperboloid

function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::AbstractVector{<:PoincareHalfSpacePoint}, vecs::AbstractVector{<:PoincareHalfSpaceTangentVector})
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), [Point2f(p.value) for p in pts])[1],
        convert_arguments(Makie.PointBased(), [Point2f(v.value) for v in vecs])[1],
    )
end
# If we already get `<:Point` and `<:Vecs` this is already defined in hyperboloid

function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{3}}}, pts::V) where {V <: AbstractVector{<:PoincareHalfSpacePoint}}
    return Makie.convert_arguments(P, [Point3f(p.value) for p in pts])
end
# If we already get `<:Point` this is already defined in hyperboloid

function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{3}}}, pts::AbstractVector{<:PoincareHalfSpacePoint}, vecs::AbstractVector{<:PoincareHalfSpaceTangentVector})
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), [Point3f(p.value) for p in pts])[1],
        convert_arguments(Makie.PointBased(), [Point3f(v.value) for v in vecs])[1],
    )
end
# If we already get `<:Point` and `<:Vecs` this is already defined in hyperboloid
