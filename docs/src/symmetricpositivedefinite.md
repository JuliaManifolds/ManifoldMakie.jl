# Plotting data of symmetric Positive Definnite Matrices

For signals or images of [`SymmetricPositiveDefinite`](@extref `Manifolds.SymmetricPositiveDefinite`)`(n)` can be plotted for tne cases `n=2,3` as [Ellipse](https://en.wikipedia.org/wiki/Ellipse)s and [Ellipsoid](https://en.wikipedia.org/wiki/Ellipsoid)s, respectively.

Both follow the same idea, that a data point ``p ∈ \mathcal P(n)$`` the [Eigenvalues](https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors) ``λ_1,…,λ_n`` are all positive and the since ``p`` is [diagonalizable](https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors#Diagonalization_and_the_eigendecomposition)
the corresponding Eigenvectors ``v_1,…v_n`` form a basis of ``ℝ^n`` they can serve as the [principal axes](https://en.wikipedia.org/wiki/Ellipse#Principal_axes) with the eigenvalues as axis lengths.

## Plotting Ellipses

```@example
using GLMakie, LinearAlgebra, ManifoldMakie, Manifolds
R(α) = [cos(α) sin(α); -sin(α) cos(α)]
n = 20
M = SymmetricPositiveDefinite(2)

data = [ R(x+y)' * diagm([1.0 + x + y, 1.0/(1.0 + x + y)]) * R(x+y) for x ∈ range(0,1,n), y ∈ range(0,1,n)]

# image(M, data)
nothing
```

## Plotting Ellipsoids

```@example
using GLMakie, LinearAlgebra, ManifoldMakie, Manifolds, ManoptExamples
M = SymmetricPositiveDefinite(3)
data = ManoptExamples.artificial_SPD_image(64);
image(M, data; scale_ev = 2.0, scale_mode = :relative)
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
