"""
    hyperboloidplot(M::Hyperbolic{ManifoldsBase.TypeParameter{Tuple{2}}}; kwargs...)

Draw the [`Hyperbolic`](@extref `Manifolds.Hyperbolic`)`(2)` in the [hyperboloid]() model as a (transparent) surface with an overlaid wireframe.
This can be combined with
* [`scatter`](@extref `Makie.scatter`)`(M, pts)` to plot points thereon
* [`arrows3d`](@extref `Makie.arrows3d`)`(M, pts, vecs)` to plot tangent vectors
* [`geodesics`](@ref)`(M, pst)` and [`scattergeodesics`](@ref)`(M, pst)` to draw geodesics

```julia
fig, ax, p = hyperboloidplot(Hyperbolic(2))
```
"""
@recipe HyperboloidPlot (M,) begin
    "Color of the wireframe lines drawn on top of the surface."
    wirecolor = (:lightsteelblue, 0.4)
    "Tessellation resolution (segments of the wireframe in every direction)."
    wires = 24
    "linewidth of the wire"
    wirewidth = 0.5
    "Solid color of the surface."
    surfacecolor = :white
    "Surface alpha (0 = transparent, 1 = opaque)."
    surfacealpha = 0.5
    "range for the x-dimension"
    xlims = [-3, 3]
    "range for the y-dimension"
    ylims = [-3, 3]
    # add the other default plot attributes here as well
    Makie.mixin_generic_plot_attributes()...
end

function Makie.plot!(p::HyperboloidPlot{<:Tuple{Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}}})
    # create a new compute edge
    # with [:M, :wires] as input nodes (these must already exist)
    # with :sphere_mesh as the output node (this will be created)
    # running the computation defined in the do ... end block
    # where :M is M and :wires is mapped to n
    x = range(; start = p[:xlims][][1], stop = p[:xlims][][2], length = 10 * p[:wires][])
    y = range(; start = p[:ylims][][1], stop = p[:ylims][][2], length = 10 * p[:wires][])
    z = [sqrt(1 + X^2 + Y^2) for X in x, Y in y]
    surface!(
        p, x, y, z;
        colormap = [p[:surfacecolor][]], alpha = p[:surfacealpha][], transparency = true,
    )
    # a wireframe atop
    x = range(; start = p[:xlims][][1], stop = p[:xlims][][2], length = p[:wires][])
    y = range(; start = p[:ylims][][1], stop = p[:ylims][][2], length = p[:wires][])
    z = [sqrt(1 + X^2 + Y^2) for X in x, Y in y]
    wireframe!(p, x, y, z; color = p[:wirecolor][], linewidth = p[:wirewidth][], transparency = true)
    return p
end

#
#
# Overwrite sphereplot (as a bit of a hack) to remove axes and use the nice default sphere from the docs?
function hyperboloidplot(
        M::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}};
        size = (1024, 1024), backgroundcolor = :white, show_axis = false, kwargs...
    )
    fig = Figure(backgroundcolor = backgroundcolor, size = size, kwargs...)
    ax = LScene(fig[1, 1], show_axis = show_axis, kwargs...)
    pl = hyperboloidplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
# For `scatter(M, pts)`, `lines(M, pts)`, `scatterlines(M, pts)`
# (and any other PointBased plot) work on a manifold via this overload.
# We do not have to transform the points
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts)
    return Makie.convert_arguments(P, pts)
end
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::Vector{<:HyperboloidPoint})
    return Makie.convert_arguments(P, [p. value for p in pts])
end

# For arrows3d(M, pts, vecs) we want to combine the classical scatter with arrows,
# where we assume that vecs[i] is in the tangent space of pts[1]
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts, vecs)
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), pts)[1],
        convert_arguments(Makie.PointBased(), vecs)[1],
    )
end
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::Vector{<:HyperboloidPoint}, vecs::Vector{<:HyperboloidTangentVector})
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), [p.value for p in pts])[1],
        convert_arguments(Makie.PointBased(), [v.value for v in vecs])[1],
    )
end
