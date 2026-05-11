module ManifoldMakie

using GeometryBasics
using Manifolds
using Manifolds: Sphere
using Makie
import Makie: scatter, scatter!

# Generic Recipes
include("generic/geodesics.jl")

include("hyperbolic/hyperboloid.jl")
include("hyperbolic/poincareball.jl")
include("hyperbolic/poincarehalfspace.jl")
include("sphere.jl")

export Sphere
export scatter, scatter!
export geodesics, geodesics!
export hyperboloidplot, hyperboloidplot!
export poincareballbplot, poincareballbplot!
export poincarehalfspaceplot, poincarehalfspaceplot!
export scattergeodesics, scattergeodesics!
end # module ManifoldMakie
