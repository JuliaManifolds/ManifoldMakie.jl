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
function Makie.convert_arguments(P::Makie.PointBased, M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{1}}}, pts::V) where {V <: AbstractVector{<:AbstractVector}}
    return Makie.convert_arguments(P, M, Point2f.(pts))
end
# we already have P3fs, just pass down
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{1}}}, pts::V) where {V <: AbstractVector{<:Point}}
    return Makie.convert_arguments(P, pts)
end
# S2
function Makie.convert_arguments(P::Makie.PointBased, M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts::V) where {V <: AbstractVector{<:AbstractVector}}
    return Makie.convert_arguments(P, M, Point3f.(pts))
end
# we already have P3fs, just pass down
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts::V) where {V <: AbstractVector{<:Point}}
    return Makie.convert_arguments(P, pts)
end

# For arrows2d(M, pts, vecs) we want to combine the classical scatter with arrows,
# where we assume that vecs[i] is in the tangent space of pts[1]
# (a) From Manifolds.jl
function Makie.convert_arguments(
        P::Makie.ArrowLike, M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{1}}}, pts::V, vecs::W
    ) where {V <: AbstractVector{<:AbstractVector}, W <: AbstractVector{<:AbstractVector}}
    return Makie.convert_arguments(P, M, Point2f.(pts), Vec2f.(vecs))
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
        P::Makie.ArrowLike, M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts::V, vecs::W
    ) where {V <: AbstractVector{<:AbstractVector}, W <: AbstractVector{<:AbstractVector}}
    return Makie.convert_arguments(P, M, Point3f.(pts), Vec3f.(vecs))
end
# (b) already in Point3f
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts::V, vecs::W) where {V <: AbstractVector{<:Point}, W <: AbstractVector{<:Vec}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), pts)[1], convert_arguments(Makie.PointBased(), vecs)[1],
    )
end

#
#
# image!(ax, M, img) and image!(ax, M, x, y, img) to plot a sphere-values image as a quiver
# not yet sure how to handle the image() case to do a 3D plot then, we will see.

"""
    image(M, x, y, image)
    image(M, image)

as an alias for

    spheredataimage(M, x, y, image)
    spheredataimage(M, image)

Plots an image on a rectangle bounded by `x` and `y` (defaults to size of image).
"""
@recipe SphereDataImage (
    M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}},
    x::Makie.EndPoints,
    y::Makie.EndPoints,
    image::AbstractMatrix{<:AbstractVector{<:Real}},
) begin
    Makie.mixin_generic_plot_attributes()...
    Makie.mixin_colormap_attributes()...
    fxaa = false
    colormap = :viridis
end

function Makie.plot!(
        I::SphereDataImage{
            <:Tuple{
                <:Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}},
                <:Makie.EndPoints,
                <:Makie.EndPoints,
                <:AbstractMatrix{<:AbstractVector},
            },
        }
    )
    # We use the four converted arguments as input nodes for our computation.
    # These match the types in the tuple above, i.e. M;, x, y, img
    input_nodes = [:M, :x, :y, :image]
    # As outputs we want to obtain points and directions for an arrow 3D
    output_nodes = [:gridpts, :gridves, :color_z]
    # This will register a computation in the graph, which connects a new set of
    # output_nodes to the given input_nodes in a way that can dynamically update.
    map!(I.attributes, input_nodes, output_nodes) do manifold, xr, yr, image
        pts = Point3f[]
        vecs = Vec3f[]
        colors = Float32[]
        m, n = size(image)
        for (i, xi) in enumerate(range(xr[1], xr[2]; length = m)), (j, yj) in enumerate(range(yr[1], yr[2]; length = n))
            v = image[i, j]
            push!(pts, Point3f(xi, yj, 0.0))
            push!(vecs, Vec3f(v[1], v[2], v[3]))
            # use z component / height for coloring
            push!(colors, v[end])
        end
        return (pts, vecs, colors)
    end
    arrows3d!(I, I.attributes, I.gridpts, I.gridves; colormap = :viridis, color = I.color_z)
    return I
end
function Makie.convert_arguments(
        P::Type{<:SphereDataImage}, M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, img::AbstractMatrix{<:AbstractVector}
    )
    m, n = size(img)
    # We transpose as it is common for mages, the first direction is X, the second the y acis
    return Makie.convert_arguments(P, M, Makie.EndPoints(1, m), Makie.EndPoints(1, n), img)
end
function Makie.convert_arguments(
        P::Type{<:SphereDataImage}, M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, x::Makie.EndPoints, y::Makie.EndPoints, img::AbstractMatrix{<:AbstractVector}
    )
    return (M, x, y, img)
end
function Makie.image(
        M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, args...;
        size = (1024, 1024), backgroundcolor = :white, show_axis = false, aspect = :data, elevation = π / 2, azimuth = π / 2, kwargs...
    )
    fig = Figure(backgroundcolor = backgroundcolor, size = size)
    ax = Axis3(fig[1, 1], aspect = aspect, elevation = elevation, azimuth = azimuth)
    if !show_axis
        hidedecorations!(ax)
        hidespines!(ax)
    end
    pl = spheredataimage!(ax, M, args...; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
Makie.image!(ax, M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, args...; kwargs...) = spheredataimage!(ax, M, args...; kwargs...)
