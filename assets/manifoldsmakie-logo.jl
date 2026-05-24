# ManifoldsMakie.jl logo
#
# Created as a mix between the description / code at
# jkrumbiegel.com/pages/2024-05-03-makie-logo
# and the code in TikZ for the Manifolds.jl logo at
# github.com/JuliaManifolds/Manifolds.jl/blob/master/logo/logo.tex
#
# Generated / mixed both codes with the help of Claude, but used several fixes to
# not define the whole sphere here.

using GLMakie
using LinearAlgebra
using Colors, FileIO, Images
using Manifolds

# ── Makie gradient colours ────────────────────────────────────────────────────
# Taken from the official Makie logo (jkrumbiegel.com/pages/2024-05-03-makie-logo)

const MAKIE_YELLOW = colorant"#e8cb26"
const MAKIE_BLUE = colorant"#3182bb"
const MAKIE_RED = colorant"#dd3366"

# The three Makie colour vertices are placed at the 2D projected positions of
# the three poles, so the gradient flows naturally across all caps.
# Assignment (matching the rotational arrangement of the Makie logo petals):
#   p1 = z = top          → yellow
#   p2 = x = bottom-left  → blue
#   p3 = y = bottom-right → red
const COLOR_VERTICES = [MAKIE_YELLOW, MAKIE_BLUE, MAKIE_RED]

# ── Settings ──────────────────────────────────────────────────────────────────

const DARK_MODE = true
const GEO_LINEWIDTH = 35.0
const MESH_LINEWIDTH = 5
const GEO_OPACITY = DARK_MODE ? 0.66 : 0.5
const MESH_OPACITY = DARK_MODE ? 0.7 : 0.5
const CAP_OPACITY = 1.0
const R = π / 5

# ── Sphere geometry ───────────────────────────────────────────────────────────

M = Manifolds.Sphere(2)

cap_point(p, e1, e2, r, θ) = exp(M, p, r .* (cos(θ) .* e1 .+ sin(θ) .* e2))

# ── Orthographic projection (az = 45°, el = 35°) ─────────────────────────────
# Verified against original logo pixel positions.

const AZ = deg2rad(45)
const EL = deg2rad(35)
const PROJ_RIGHT = [-sin(AZ), cos(AZ), 0.0]
const PROJ_UP = [-sin(EL) * cos(AZ), -sin(EL) * sin(AZ), cos(EL)]

proj2d(p) = [dot(p, PROJ_RIGHT), dot(p, PROJ_UP)]

# ── Barycentric Makie gradient ────────────────────────────────────────────────

# 2D projected pole positions (colour vertices)
const p1 = [0.0, 0.0, 1.0]
const p2 = [1.0, 0.0, 0.0]
const p3 = [0.0, 1.0, 0.0]

const V1 = proj2d(p1)   # yellow vertex
const V2 = proj2d(p2)   # blue vertex
const V3 = proj2d(p3)   # red vertex

"""Barycentric weights for point `p` w.r.t. triangle (v1, v2, v3)."""
function bary_weights(p, v1, v2, v3)
    den = (v2[2] - v3[2]) * (v1[1] - v3[1]) + (v3[1] - v2[1]) * (v1[2] - v3[2])
    abs(den) < 1.0e-14 && return (1 / 3, 1 / 3, 1 / 3)
    w1 = ((v2[2] - v3[2]) * (p[1] - v3[1]) + (v3[1] - v2[1]) * (p[2] - v3[2])) / den
    w2 = ((v3[2] - v1[2]) * (p[1] - v3[1]) + (v1[1] - v3[1]) * (p[2] - v3[2])) / den
    w3 = 1 - w1 - w2
    return (w1, w2, w3)
end

"""
Makie-gradient colour at 3D point `pt`.
Uses barycentric interpolation of the three Makie colours across the projected
triangle formed by the three poles, with weights raised to ^2.1 to sharpen
(matching the original Makie logo recipe by J. Krumbiegel).
"""
function makie_color(pt::Vector{Float64})
    p2 = proj2d(pt)
    w1, w2, w3 = bary_weights(p2, V1, V2, V3)
    w = clamp.((w1, w2, w3), 0, 1) .^ 0.66
    s = sum(w)
    s < 1.0e-14 && return RGB(1 / 3, 1 / 3, 1 / 3)
    w = w ./ s
    c1, c2, c3 = COLOR_VERTICES
    r = w[1] * red(c1) + w[2] * red(c2) + w[3] * red(c3)
    g = w[1] * green(c1) + w[2] * green(c2) + w[3] * green(c3)
    b = w[1] * blue(c1) + w[2] * blue(c2) + w[3] * blue(c3)
    return RGBf(r, g, b)
end

# ── Surface / line builders ───────────────────────────────────────────────────

"""Return (xs, ys, zs, cs) grid for a gradient-coloured spherical cap."""
function cap_surface(p, e1, e2; nr = 60, nθ = 120)
    rs = range(0, R; length = nr)
    θs = range(0, 2π; length = nθ)
    xs = [cap_point(p, e1, e2, r, θ)[1] for r in rs, θ in θs]
    ys = [cap_point(p, e1, e2, r, θ)[2] for r in rs, θ in θs]
    zs = [cap_point(p, e1, e2, r, θ)[3] for r in rs, θ in θs]
    cs = [makie_color(cap_point(p, e1, e2, r, θ)) for r in rs, θ in θs]
    return xs, ys, zs, cs
end

"""Return mesh lines as a vector of (xs, ys, zs) tuples."""
function cap_mesh_lines(p, e1, e2; n_rings = 6, n_radial = 9, nθ = 120, nr_radial = 50)
    lines = NTuple{3, Vector{Float64}}[]
    rs = range(0, R; length = n_rings)
    θs = range(0, 2π; length = nθ)
    # Concentric rings (skip centre r=0 and boundary r=R)
    for r in rs[2:(end - 1)]
        pts = [cap_point(p, e1, e2, r, θ) for θ in θs]
        push!(lines, (getindex.(pts, 1), getindex.(pts, 2), getindex.(pts, 3)))
    end
    # Radial spokes
    rs_fine = range(0, R; length = nr_radial)
    for θ in range(0, 2π; length = n_radial + 1)[1:(end - 1)]
        pts = [cap_point(p, e1, e2, r, θ) for r in rs_fine]
        push!(lines, (getindex.(pts, 1), getindex.(pts, 2), getindex.(pts, 3)))
    end
    return lines
end

"""Return (xs, ys, zs) for a geodesic arc between poles `p` and `q`."""
function geodesic_line(p, q; n = 200)
    pts = shortest_geodesic(M, p, q, range(0, 1; length = n))
    return 1.05 * getindex.(pts, 1), 1.05 * getindex.(pts, 2), 1.05 * getindex.(pts, 3)
end

# ── Scene ─────────────────────────────────────────────────────────────────────

fig = Figure(; size = (800, 800), backgroundcolor = DARK_MODE ? :black : :white)

ax = Axis3(
    fig[1, 1];
    aspect = :data,
    azimuth = AZ,
    elevation = EL,
    backgroundcolor = DARK_MODE ? :black : :white,
    # Hide all decorations
    xgridvisible = false, ygridvisible = false, zgridvisible = false,
    xspinesvisible = false, yspinesvisible = false, zspinesvisible = false,
    xticksvisible = false, yticksvisible = false, zticksvisible = false,
    xlabelvisible = false, ylabelvisible = false, zlabelvisible = false,
    xticklabelsvisible = false, yticklabelsvisible = false, zticklabelsvisible = false,
    protrusions = 0,
)

# Pole positions and their tangent bases
poles = [p1, p2, p3]
bases = [
    get_vectors(M, p1, get_basis(M, p1, DefaultOrthonormalBasis())),
    get_vectors(M, p2, get_basis(M, p2, DefaultOrthonormalBasis())),
    get_vectors(M, p3, get_basis(M, p3, DefaultOrthonormalBasis())),
]

# ── Draw caps ─────────────────────────────────────────────────────────────────

for (p, (e1, e2)) in zip(poles, bases)
    xs, ys, zs, cs = cap_surface(p, e1, e2)
    surface!(
        ax, xs, ys, zs;
        color = cs,
        shading = NoShading,
        transparency = false,
    )
end

# ── Draw mesh lines ───────────────────────────────────────────────────────────

for (p, (e1, e2)) in zip(poles, bases)
    for (lx, ly, lz) in cap_mesh_lines(p, e1, e2)
        lines!(
            ax, lx, ly, lz;
            color = DARK_MODE ? (:white, MESH_OPACITY) : (:black, MESH_OPACITY),
            linewidth = MESH_LINEWIDTH,
            linestyle = (:dot, :dense),
        )
    end
end

# ── Draw geodesics ────────────────────────────────────────────────────────────

for (pa, pb) in [(p1, p2), (p1, p3), (p2, p3)]
    lx, ly, lz = geodesic_line(pa, pb)
    lines!(
        ax, lx, ly, lz;
        color = DARK_MODE ? (:white, GEO_OPACITY) : (:black, GEO_OPACITY),
        linecap = :round,
        linewidth = GEO_LINEWIDTH,
    )
end

# Tight limits computed from the actual geometry (caps + geodesics).
# All three axes are symmetric: points span [-sin(R), 1] ≈ [-0.5878, 1.0].
# A small pad of 0.03 keeps the rim just clear of the viewport edge.
lim_lo = -0.62
lim_hi = 1.06
limits!(ax, lim_lo, lim_hi, lim_lo, lim_hi, lim_lo, lim_hi)


display(fig)

name = DARK_MODE ? "logo_dark" : "logo"
save(name * ".png", fig; px_per_unit = 8)

img = load(name * ".png")  # Array of RGB/RGBA pixels
# Convert to RGBA
img_rgba = RGBA.(img)

# Replace background colour with transparent
# Use white background for cleanest keying (no dark halo around colored caps)
bg = DARK_MODE ? RGBA(colorant"black") : RGBA(colorant"white")
tol = 0.03


img_transparent = map(img_rgba) do px
    dist = abs(red(px) - red(bg)) + abs(green(px) - green(bg)) + abs(blue(px) - blue(bg))
    dist < tol ? RGBA(red(px), green(px), blue(px), 0.0) : px
end

# ── 3. Tight crop ────────────────────────────────────────────────────────────

# Find rows and columns that contain at least one non-transparent pixel
α_mat = alpha.(img_transparent)          # matrix of alpha values
row_any = vec(any(α_mat .> 0, dims = 2))   # true for each row with content
col_any = vec(any(α_mat .> 0, dims = 1))   # true for each column with content

row_min, row_max = findfirst(row_any), findlast(row_any)
col_min, col_max = findfirst(col_any), findlast(col_any)

# Optionally: add a small padding (in pixels) so nothing is flush against the edge
pad = 8
row_min = max(1, row_min - pad)
row_max = min(size(img_transparent, 1), row_max + pad)
col_min = max(1, col_min - pad)
col_max = min(size(img_transparent, 2), col_max + pad)

img_cropped = img_transparent[row_min:row_max, col_min:col_max]
img_orig_cropped = img[row_min:row_max, col_min:col_max]

save(name * ".png", img_orig_cropped)
save(name * "_transparent.png", img_cropped)
