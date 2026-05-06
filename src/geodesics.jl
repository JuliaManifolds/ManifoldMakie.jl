"""
    geodesics(M, points)

Creates a connected geodesic plot connecting all or `points` sequentially.

`NaN` values are displayed as gaps in the line.
"""
@recipe Geodesics (M, points) begin
    Makie.documented_attributes(Lines)...
    "Set the number of samples used per geodesic"
    samples = 100
    "Set the curve to be closed by connecting the last and first point as well"
    closed = false
end

function Makie.plot!(p::Geodesics{<:Tuple{AM, V}}) where {AM <: Manifolds.AbstractManifold, V}
    # accessing input variables and properties seems a bit tricky here?!
    # This idea is taken from the docs of Makie.Computed
    M = p[:M][]
    points = p[:points][]
    n = length(points)
    s = p[:samples][]
    for i in 1:(n - 1)
        p1 = points[i]
        p2 = points[i + 1]
        pts = shortest_geodesic(M, p1, p2, range(; start = 0.0, stop = 1.0, length = s))
        lines!(p, p.attributes, M, Point3f.(pts))
    end
    if p[:closed][]
        p1 = points[end]
        p2 = points[1]
        pts = shortest_geodesic(M, p1, p2, range(; start = 0.0, stop = 1.0, length = s))
        lines!(p, p.attributes, M, Point3f.(pts))
    end
    return p
end
