"""
    symmetricpositivedefinitedataimage(M::SymmetricPositiveDefinite, img)
    symmetricpositivedefinitedataimage(M::SymmetricPositiveDefinite, x, y, img)

or as shortcut also

    image(M::SymmetricPositiveDefinite, img)
    image(M::SymmetricPositiveDefinite, x, y, img)

Plot image data with values on the [`SymmetricPositiveDefinite`](@extref `Manifolds.SymmetricPositiveDefinite`)`(n)`, ``n=2,3`` manifold
as ellipses or ellipsoids, respectively.

As the colour scale we use the Riemannian anisotropy index from [Moakher and Batchelor (2006)](@cite MoakherBatchelor:2006),

``\\operatorname{GA}(p) =\\frac{\\mathrm{A}_{\\mathrm{R}}(P)}{1+\\mathrm{A}_{\\mathrm{R}}(p)}, \\quad\\text{where}\\quad \\mathrm{A}_{\\mathrm{R}}(p) = \\displaystyle\\sqrt{ \\frac{n-1}{n}\\displaystyle\\sum_{i=1}^n \\log^2(λ_i) - \\frac{2}{n}\\displaystyle\\sum_{1≤i<j≤n} \\log(λ_i)\\log(λ_j)},``

and ``λ_i``, ``i=1,…,n`` are the eigenvalues of the symmetric positive definite matrix ``p``.
"""
@recipe SymmetricPositiveDefiniteDataImage (
    M::Manifolds.SymmetricPositiveDefinite,
    x::Makie.EndPoints,
    y::Makie.EndPoints,
    image::AbstractMatrix{<:AbstractMatrix{<:Real}},
) begin
    "scale eigenvalues globally"
    scale_ev = 1.0
    "scale `:absolute` or `:relative`, i.e. after normalizing the larges Eigenvalue to be 1"
    scale_mode = :absolute
    Makie.mixin_generic_plot_attributes()...
    Makie.mixin_colormap_attributes()...
    colorrange = [0, 1]
    colormap = :viridis
end

#
#
# Helper for the coloring: Geometric anisotropy index, Moakher and Batchelor (2006)
function geometric_anisotropy_index(p::AbstractMatrix)
    return geometric_anisotropy_index(eigvals(p))
end
function geometric_anisotropy_index(λ::AbstractVector)
    n = length(λ)
    logλ = log.(λ)
    AR = sqrt((n - 1) / n * sum(logλ .^ 2) - 2 / n * sum(logλ[i] * logλ[j] for i in 1:n for j in (i + 1):n))
    return AR / (1 + AR)
end

#
# SPD(2) case

function Makie.plot!(
        I::SymmetricPositiveDefiniteDataImage{
            <:Tuple{
                Manifolds.SymmetricPositiveDefinite{Manifolds.TypeParameter{Tuple{2}}},
                <:Makie.EndPoints,
                <:Makie.EndPoints,
                <:AbstractMatrix{<:AbstractMatrix},
            },
        }
    )
    input_nodes = [:M, :x, :y, :image, :scale_ev, :scale_mode]
    # As outputs we want to obtain points and directions for an arrow 3D
    output_nodes = [:gridpts, :scales, :orientations, :colors]
    # This will register a computation in the graph, which connects a new set of
    # output_nodes to the given input_nodes in a way that can dynamically update.
    map!(I.attributes, input_nodes, output_nodes) do manifold, xr, yr, image, es, em
        pts = Point2f[]
        scales = Vec2f[]
        orientations = Float64[]
        colors = Float32[]
        m, n = size(image)
        λ_max = 0.0
        for (i, xi) in enumerate(range(xr[1], xr[2]; length = m)), (j, yj) in enumerate(range(yr[1], yr[2]; length = n))
            p = image[i, j]
            λ, V = eigen(p)
            λ_max = max(λ_max, maximum(λ))
            push!(pts, Point2f(xi, yj))
            push!(scales, Vec2f(λ...))
            push!(orientations, atan(V[2, 1], V[1, 1]))
            # use z component / height for coloring
            push!(colors, geometric_anisotropy_index(λ))
        end
        if em == :relative
            # scale such that the larges axis is 1, i.e. by 1/λ_max,
            es = es / λ_max
        end
        scales = es .* scales
        return (pts, scales, orientations, colors)
    end
    return scatter!(
        I, I.attributes, I.gridpts;
        color = I.colors, marker = :circle, #sadly a bit inconsistent, Makie.Circle(Point2f(0.0,0.0), 1.0) would have been nice
        markersize = I.scales, rotation = I.orientations, markerspace = :data,
    )
end


# Conversion (actually works for all SPDs)
function Makie.convert_arguments(
        P::Type{<:SymmetricPositiveDefiniteDataImage}, M::Manifolds.SymmetricPositiveDefinite, img::AbstractMatrix{<:AbstractMatrix}
    )
    m, n = size(img)
    # We transpose as it is common for mages, the first direction is X, the second the y acis
    return Makie.convert_arguments(P, M, Makie.EndPoints(1, m), Makie.EndPoints(1, n), img)
end
function Makie.convert_arguments(
        P::Type{<:SymmetricPositiveDefiniteDataImage}, M::Manifolds.SymmetricPositiveDefinite, x::Makie.EndPoints, y::Makie.EndPoints, img::AbstractMatrix{<:AbstractMatrix}
    )
    return (M, x, y, img)
end

function Makie.image(
        M::SymmetricPositiveDefinite{Manifolds.TypeParameter{Tuple{2}}}, args...;
        size = (1024, 1024), backgroundcolor = :white, show_axis = false, aspect = Makie.DataAspect(), kwargs...
    )
    fig = Figure(backgroundcolor = backgroundcolor, size = size)
    ax = Axis(fig[1, 1], aspect = aspect)
    if !show_axis
        hidedecorations!(ax)
        hidespines!(ax)
    end
    pl = symmetricpositivedefinitedataimage!(ax, M, args...; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
Makie.image!(ax, M::SymmetricPositiveDefinite{Manifolds.TypeParameter{Tuple{2}}}, args...; kwargs...) = symmetricpositivedefinitedataimage!(ax, M, args...; kwargs...)

#
# SPD(3) case

function Makie.plot!(
        I::SymmetricPositiveDefiniteDataImage{
            <:Tuple{
                <:Manifolds.SymmetricPositiveDefinite{Manifolds.TypeParameter{Tuple{3}}},
                <:Makie.EndPoints,
                <:Makie.EndPoints,
                <:AbstractMatrix{<:AbstractMatrix},
            },
        }
    )
    # We use the four converted arguments as input nodes for our computation.
    # These match the types in the tuple above, i.e. M;, x, y, img
    input_nodes = [:M, :x, :y, :image, :scale_ev, :scale_mode]
    # As outputs we want to obtain points and directions for an arrow 3D
    output_nodes = [:gridpts, :scales, :orientations, :colors]
    # This will register a computation in the graph, which connects a new set of
    # output_nodes to the given input_nodes in a way that can dynamically update.
    map!(I.attributes, input_nodes, output_nodes) do manifold, xr, yr, image, es, em
        pts = Point3f[]
        scales = Vec3f[]
        orientations = Vec3f[]
        colors = Float32[]
        m, n = size(image)
        λ_max = 0.0
        for (i, xi) in enumerate(range(xr[1], xr[2]; length = m)), (j, yj) in enumerate(range(yr[1], yr[2]; length = n))
            p = image[i, j]
            λ, V = eigen(p)
            λ_max = max(λ_max, maximum(λ))
            push!(pts, Point3f(xi, yj, 0.0))
            push!(scales, Vec3f(λ...))
            push!(orientations, V * [0.0, 0.0, 1.0])
            # use z component / height for coloring
            push!(colors, geometric_anisotropy_index(λ))
        end
        if em == :relative
            # scale such that the larges axis is 1, i.e. by 1/λ_max,
            es = es / λ_max
        end
        scales = es .* scales
        return (pts, scales, orientations, colors)
    end
    meshscatter!(
        I, I.attributes, I.gridpts;
        color = I.colors,
        marker = Makie.Sphere(Point3f(0, 0, 0), 1.0),
        markersize = I.scales,
        rotation = I.orientations,
    )
    return I
end

function Makie.image(
        M::SymmetricPositiveDefinite{Manifolds.TypeParameter{Tuple{3}}}, args...;
        size = (1024, 1024), backgroundcolor = :white, show_axis = false, aspect = :data, elevation = π / 2, azimuth = π / 2, kwargs...
    )
    fig = Figure(backgroundcolor = backgroundcolor, size = size)
    ax = Axis3(fig[1, 1], aspect = aspect, elevation = elevation, azimuth = azimuth)
    if !show_axis
        hidedecorations!(ax)
        hidespines!(ax)
    end
    pl = symmetricpositivedefinitedataimage!(ax, M, args...; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
Makie.image!(ax, M::SymmetricPositiveDefinite{Manifolds.TypeParameter{Tuple{3}}}, args...; kwargs...) = symmetricpositivedefinitedataimage!(ax, M, args...; kwargs...)
