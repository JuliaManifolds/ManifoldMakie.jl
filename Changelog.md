# Changelog

All notable Changes to the Julia package `ManifoldMakie.jl` are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] June 1st, 2026

### Added

* `scatter`, `lines`, `arrows2d`, `arrows3d` and `geodesics` now set up the right plot
  according to the manifold and data passed, i.e.
  - the circle in the complex plane is drawn before any of these functions “take over” in
    their mutating variant.
  - the 1- and 2-sphere
  - all three representations of hyperbolic space
* `geodesics` and `scattergeodesics` now also always generate the correct plot first.

These functions have a uniform interface: they pass `axis=` and `figure=` down to the
Figure to be created and `plot=` as that functions kwargs. Their own `kwargs they pass to their mutating variant.

### Changed

* internally the elements returned were not as unified as originally intended. This bug is now fixed:
  - all `Figure(M)` calls now return a `FigureAxis`. The all accept `axis=` and `figure=` and pass their keyword arguments to the internal plot
  - all non-mutating functions now return a `FigureAxisPlot`
  - the mutating ones are actually recipes and hence return the plot they modified

## [0.1.0] May 25, 2026

Initial release.

### Added

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
