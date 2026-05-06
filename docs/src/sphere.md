# Plotting data on the 2D Sphere

```@example
using Manifolds, ManifoldsMakie, GLMakie

M = Manifolds.Sphere(2)
fig = Figure(backgroundcolor = :white, size = (900,900))
ax = LScene(fig[1, 1], show_axis = false)

sphereplot!(ax, M;
    surfacecolor = :white, surfacealpha = 0.3,
    wirecolor = (:lightsteelblue, 0.4), wires = 28, wirewidth = .5
)
p = [0.0, 0.0, 1.0]
q = [0.0, 1/sqrt(2), -1/sqrt(2)]
r = [1/sqrt(2), 0.0, 1/sqrt(2)]
P = shortest_geodesic(M, p, q, 0:0.05:1.0)
X = [log(M, s, r) for s in P]
pts = Point3f.(P)
vecs = Vec3f.(X)

scatter!(ax, M, pts; color = :green, markersize = 8)
scatter!(ax, M, [Point3f(r),]; color = :orange, markersize = 8)
arrows3d!(ax, M, pts, vecs; color = :blue,
    minshaftlength = 0, shaftlength=.99, shaftradius = 0.005,
    tipradius = 0.02, tiplength = 0.1)
fig
```

## Function reference

```@docs
ManifoldsMakie.sphereplot
```