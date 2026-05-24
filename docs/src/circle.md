# Plotting data on the Circle

For the circle there are two different representations: as angles in the interval ``[-π,π)``
or as complex numbers of absolute value 1.

## The real-valued Circle

For signals on the circle, we can plot them in a usual scatter

```@example
using Manifolds, ManifoldMakie, GLMakie

x = 0:0.25:5
y = (mod.((x./2).^2 .- 0.4 .+ π, 2π)) .- π
y2 = (mod.((x).^2 .- 0.4 .+ π, 2π)) .- π

M = Manifolds.Circle(ℝ)
fig, ax, pl = circleplot(M)
lines!(ax, M, y; color = :green)
scatter!(ax, M, x, y2; color = :green)
fig
```

For images, we can also color them (automatically) in hue

```@example
using Manifolds, ManifoldMakie, ManoptExamples, GLMakie

img = sym_rem.(ManoptExamples.artificialIn_SAR_image(128))
M = Manifolds.Circle(ℝ)
fig, ax, pl = circleimage(M)
image!(ax, M, img)
fig
```

where the default colormap for these plots is changed to `:hsv`.

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

## Function reference

```@docs
ManifoldMakie.circleimage
ManifoldMakie.circleplot
```
