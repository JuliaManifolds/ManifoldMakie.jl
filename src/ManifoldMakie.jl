module ManifoldMakie

using GeometryBasics
using Manifolds
using Manifolds: Sphere
using Makie
import Makie: scatter, scatter!

# Generic Recipes
include("geodesics.jl")

include("hyperbolic.jl")
include("sphere.jl")

export Sphere
export scatter, scatter!
export geodesics, geodesics!
export hyperboloidplot, hyperboloidplot!
export scattergeodesics, scattergeodesics!
end # module ManifoldMakie
