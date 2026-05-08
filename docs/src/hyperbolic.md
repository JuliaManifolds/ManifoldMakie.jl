# Plotting Hyperbolic data

## The 2D Hyperboloid

```@example
using GLMakie, ManifoldMakie, Manifolds
M = Hyperbolic(2)
fig, ax, pl = hyperboloidplot(M)
p = [0.0, 0.0, 1.0]
q = [2.0, 2.0, 3.0]
r = [2.0, -2.0, 3.0]
pts = Point3f.([p, q, r])
vecs = Vec3f.([log(M, p, q), log(M, q, p), log(M, r, p)])

scatter!(ax, M, pts, markersize = 20, color=:green)
arrows3d!(
    ax, M, pts, vecs; color = :blue,
    minshaftlength = 0, shaftlength=.99, shaftradius = 0.004,
    tipradius = 0.016, tiplength = 0.1,
)
fig
```

## The Poincaré Halfplane for 2D and 3D hyperbolic data

## The Poincaré disk and ball