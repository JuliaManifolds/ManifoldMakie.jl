# Changelog

All notable Changes to the Julia package `ManifoldMakie.jl` are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] May 25, 2026

Initial release.

## Added

* a `circleimage(Manifold.Circle(ℝ))` to plot angle-valued image data
* a `circleplot(Manifolds.Circle(𝔽))` for the real and complex circle representation
* a `sphereplot(Manifolds.Sphere(n))` for `n=1,2` to start a plot with a sphere to put points on.
* a `hyperboloidplot(Hyperbolic(n))` for `n=2,3` to start a plot in the hyperboloid model.
* a `poincareballplot(Hyperbolic(n))` for `n=2,3` o start a plot in the Poincaré disc or ball model.
* a `poincarehalfspaceplot(Hyperbolic(n))` for `n=2,3` to start a plot in the Poincaré hal plane or half space model.
* a `spheredataimage(M, img)` to plot 2D matrices containing data on the sphere in every entry.
  as an alias, also `image(M, img)` can be used, when `M` is the 2-sphere.
* a `symmetricpositivedefinitedataimage(M, img)`
  as an alias, also `image(M, img)` can be used, when `M` is the 2x2 or 3x3 s.p.d. matrices manifold.
