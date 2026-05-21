# Plotting data on Spheres

On a sphere we can plot points and tangent vectors with the default
[`scatter`](@extref `Makie.scatter`) and [`arrows3d`](@extref `Makie.arrows3d`).
To start a plot on a manifold, there is usually a `manifoldplot` function, here [`sphereplot`](@ref)
to set up the figure and add here for example the sphere the data lives on.

## The 1D Sphere ``𝕊^1``

For the one-dimensional sphere, we obtain unit vectors in ``ℝ^2`` or in other words points on the circle.

```@example
using Manifolds, ManifoldMakie, GLMakie

M = Manifolds.Sphere(1)
# Since S2 is the default case and its color is white, set S1 surface/boundary color
fig, ax, pl = sphereplot(M; surfacecolor=:gray)

p = [1.0, 0.0]
q = [1/sqrt(2), -1/sqrt(2)]
r = [1/sqrt(2), 1/sqrt(2)]
pts = shortest_geodesic(M, p, q, 0:0.05:1.0)
vecs = [log(M, s, r) for s in pts]

arrows2d!(ax, M, pts, vecs; color = :blue)
scatter!(ax, M, pts; color = :green, markersize = 16)
scatter!(ax, M, [r,]; color = :orange, markersize = 16)
fig
```

## The 2D Sphere ``𝕊^2``

On a sphere we can plot points and tangent vectors with the default
[`scatter`](@extref `Makie.scatter`) and [`arrows3d`](@extref `Makie.arrows3d`).
To start a plot on a manifold, there is usually a `manifoldplot` function, here [`sphereplot`](@ref)
to set up the figure and add here for example the sphere the data lives on.

```@example
using Manifolds, ManifoldMakie, GLMakie

M = Manifolds.Sphere(2)
fig, ax, pl = sphereplot(M)

p = [0.0, 0.0, 1.0]
q = [0.0, 1/sqrt(2), -1/sqrt(2)]
r = [1/sqrt(2), 0.0, 1/sqrt(2)]
pts = shortest_geodesic(M, p, q, 0:0.05:1.0)
vecs = [log(M, s, r) for s in pts]

arrows3d!(
    ax, M, pts, vecs; color = :blue,
    minshaftlength = 0, shaftlength=.99, shaftradius = 0.004, tipradius = 0.016, tiplength = 0.1,
)
scatter!(ax, M, pts; color = :green, markersize = 16)
scatter!(ax, M, [r,]; color = :orange, markersize = 16)
fig
```

We can also use the [`geodesics`](@ref) and [`scattergeodesics`](@ref) functions here.

```@example
using Manifolds, ManifoldMakie, GLMakie

M = Manifolds.Sphere(2)
fig, ax, pl = sphereplot(M)

p1, p2, p3 = [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]
p1b, p2b, = [1/sqrt(2), 0, 1/sqrt(2)], [0, 1/sqrt(2), 1/sqrt(2)]

geodesics!(ax, M, Point3f.([p1, p2, p3]); closed = true, color = :green, linewidth = 3)
scattergeodesics!(ax, M, Point3f.([p1b, p2b, p3]); closed = true, color = :blue, linewidth = 2, markersize = 12)
fig
```

## Function reference

```@docs
ManifoldMakie.sphereplot
```