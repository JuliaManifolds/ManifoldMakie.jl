# Allocating variants
function Makie.lines(M::Manifolds.AbstractManifold, args...; figure = Dict{Symbol, Any}(), axis = Dict{Symbol, Any}(), plot = Dict{Symbol, Any}(), kwargs...)
    fig, ax = Figure(M, eltype(first(args)); figure = figure, axis = axis, plot...)
    pl = lines!(ax, M, args...; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
function Makie.scatter(M::Manifolds.AbstractManifold, args...; figure = Dict{Symbol, Any}(), axis = Dict{Symbol, Any}(), plot = Dict{Symbol, Any}(), kwargs...)
    fig, ax = Figure(M, eltype(first(args)); figure = figure, axis = axis, plot...)
    pl = scatter!(ax, M, args...; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
function Makie.arrows2d(M::Manifolds.AbstractManifold, args...; figure = Dict{Symbol, Any}(), axis = Dict{Symbol, Any}(), plot = Dict{Symbol, Any}(), kwargs...)
    fig, ax = Figure(M, eltype(first(args)); figure = figure, axis = axis, plot...)
    pl = arrows2d!(ax, M, args...; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
function Makie.arrows3d(M::Manifolds.AbstractManifold, args...; figure = Dict{Symbol, Any}(), axis = Dict{Symbol, Any}(), plot = Dict{Symbol, Any}(), kwargs...)
    fig, ax = Figure(M, eltype(first(args)); figure = figure, axis = axis, plot...)
    pl = arrows3d!(ax, M, args...; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
