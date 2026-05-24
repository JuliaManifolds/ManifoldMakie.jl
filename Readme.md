<div align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://github.com/JuliaManifolds/ManifoldMakie.jl/raw/master/docs/src/assets/logo-text-readme-dark.png">
      <img alt="ManifoldMakie.jl logo with text on the side" src="https://github.com/JuliaManifolds/ManifoldMakie.jl/raw/master/docs/src/assets/logo-text-readme.png">
    </picture>
</div>

[![docs][docs-dev-img]][docs-dev-url] [![CI][ci-img]][ci-url] [![runic][runic-img]][runic-url] [![codecov][codecov-img]][codecov-url]

Plotting receipts for manifold-valued data.

## Statement of need

Ih [Manifolds.jl](https://juliamanifolds.github.io/Manifolds.jl/) as well as a bit in [Manopt.jl](https://manopjl.org) there exist a few methods to visualise data living on a [Riemannian manifold](https://en.wikipedia.org/wiki/Riemannian_manifold). These methods are a bit outdated and do not follow the idea of modularising implementations.

This package is an approach to renew these methods using plotting Receipts from [Makie.jl](https://docs.makie.org/stable/) to provide a unified approach to visualising manifold-valued data.

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://JuliaManifolds.github.io/ManifoldMakie.jl/dev/

[codecov-img]: https://codecov.io/gh/JuliaManifolds/ManifoldMakie.jl/graph/badge.svg?token=1OBDY03SUP
[codecov-url]: https://codecov.io/gh/JuliaManifolds/ManifoldMakie.jl

[ci-img]: https://github.com/JuliaManifolds/ManifoldMakie.jl/actions/workflows/ci.yml/badge.svg
[ci-url]: https://github.com/JuliaManifolds/ManifoldMakie.jl/actions/workflows/ci.yml

[runic-img]: https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black
[runic-url]: https://github.com/fredrikekre/Runic.jl
