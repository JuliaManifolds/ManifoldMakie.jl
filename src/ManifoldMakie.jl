module ManifoldMakie

using GeometryBasics
using LinearAlgebra
using Manifolds
using Manifolds: Sphere
using Makie
using StaticArrays

# Generic Recipes
include("generic/geodesics.jl")
include("generic/nonmutating.jl")

include("circle.jl")
include("hyperbolic/hyperboloid.jl")
include("hyperbolic/poincareball.jl")
include("hyperbolic/poincarehalfspace.jl")
include("sphere.jl")
include("symmetricpositivedefinite.jl")

export Sphere
export scatter, scatter!
export geodesics, geodesics!
export circleplot, circleplot!
export circleimage, circleimage!
export hyperboloidplot, hyperboloidplot!
export poincareballplot, poincareballplot!
export poincarehalfspaceplot, poincarehalfspaceplot!
export scattergeodesics, scattergeodesics!
export sphereplot, sphereplot!


end # module ManifoldMakie
