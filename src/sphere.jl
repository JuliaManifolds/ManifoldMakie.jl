@doc """
    scatter(M::Manifolds.Sphere{ℝ, TypeParameter{Tuple{2}}}, pts; kwargs...)

for a vector `pts` of points on the [`Sphere`](@extref `Manifolds.Sphere`)`(2)`
plot them on a sphere

## Arguments

* `M` the sphere to indicate we want to scatter plot manifold-valued data
* `pts` a vector of unit vectors

## Keyword arguments
* one for the number of wired
* one for the color of the wire
* one for the solid sphere color
* one for the solid sphere transparency

...all others are passed on to [`scatter`](@extref `Makie.scatter`)
"""
function Makie.scatter(M::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts; kwargs...)
    # plot a sphere in 3D
    # (a) wireframe
    # (b) transparent
    # scatter points
    return scatter(pts; kwargs...)
end
