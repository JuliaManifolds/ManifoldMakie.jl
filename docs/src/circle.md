# Plotting data on the Circle

For the circle there are two different representations: as angles in the interval ``[-π,π)``
or as complex numbers of absolute value 1.

## The real-valued Circle

TODO

## The complex circle

The complex numbers representing points on the circle in the complex plane can be used as follows

```@example
using Manifolds, ManifoldMakie, GLMakie

M = Manifolds.Circle(ℂ)
fig, ax, pl = circleplot(M)

p = 1.0 + 0.0im
q = 1/sqrt(2) -1/sqrt(2) * 1im
r = 0.9 + sqrt(0.19)im
pts = shortest_geodesic(M, p, q, 0:0.05:1.0)
vecs = [log(M, s, r) for s in pts]

arrows2d!(ax, M, pts, vecs; color = :blue)
scatter!(ax, M, pts; color = :green, markersize = 16)
scatter!(ax, M, [r,]; color = :orange, markersize = 16)
fig
```
