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
include("sphere.jl")

export Sphere
export scatter, scatter!
export geodesics, geodesics!
export hyperboloidplot, hyperboloidplot!
export poincareballbplot, poincareballbplot!
export scattergeodesics, scattergeodesics!
end # module ManifoldMakie
