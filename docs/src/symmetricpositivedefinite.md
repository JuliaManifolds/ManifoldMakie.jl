# Plotting data of symmetric Positive Definnite Matrices

For signals or images of [`SymmetricPositiveDefinite`](@extref `Manifolds.SymmetricPositiveDefinite`)`(n)` can be plotted for the cases `n=2,3` as [Ellipse](https://en.wikipedia.org/wiki/Ellipse)s and [Ellipsoid](https://en.wikipedia.org/wiki/Ellipsoid)s, respectively.

Both follow the same idea, that a data point ``p ∈ \mathcal P(n)$`` the [Eigenvalues](https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors) ``λ_1,…,λ_n`` are all positive and the since ``p`` is [diagonalizable](https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors#Diagonalization_and_the_eigendecomposition)
the corresponding Eigenvectors ``v_1,…v_n`` form a basis of ``ℝ^n`` they can serve as the [principal axes](https://en.wikipedia.org/wiki/Ellipse#Principal_axes) with the eigenvalues as axis lengths.

## Plotting Ellipses

```@example
using GLMakie, LinearAlgebra, ManifoldMakie, Manifolds
R(α) = [cos(α) -sin(α); sin(α) cos(α)]
n = 32
M = SymmetricPositiveDefinite(2)
data = [ R(π*(x+y))' * diagm([1.0 + x + y, 1.0/(1.0 + x + y)]) * R(π*(x+y)) for x ∈ range(0,1,n), y ∈ range(0,1,n)]
image(M, data)
```

## Plotting Ellipsoids

When the scale is not so anisotropic, we can also set the color scale ourselves.
Here the maximum anisotropy index is about `0.64` so to color this a bit better we set the range

Since the Eigenvalues here would even reach up to 4.7 we use a relative scaling.
With the default scaling of `1.0` none of the ellipsoids would ever touch. Here,
we can scale that a bit up to obtain a slightly denser overall impression.

```@example
using GLMakie, LinearAlgebra, ManifoldMakie, Manifolds, ManoptExamples
M = SymmetricPositiveDefinite(3)
data = ManoptExamples.artificial_SPD_image(64);
image(M, data; scale_ev = 1.75, scale_mode = :relative, colorrange = [0,0.64])
```

## Function Reference

```@docs
ManifoldMakie.symmetricpositivedefinitedataimage
```

## Literature

```@bibliography
Pages = ["symmetricpositivedefinite.md"]
Canonical=false
```
