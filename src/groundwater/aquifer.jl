"""
    Aquifer

Abstract type representing an aquifer, either confined or unconfined.

The vertically averaged governing equation of an unconfined, inhomogeneous and
isotropic aquifer in one dimension can be written as:

S * ∂ϕ / ∂t = ∂ / ∂x * (kH * ∂ϕ / ∂x) + Q

with:
* S: storativity (or storage coefficient)
* ϕ: hydraulic head (groundwater level)
* t: time
* k: conductivity
* H: H the (saturated) aquifer height: groundwater level - aquifer bottom
  elevation
* η: elevation of aquifer bottom
* Q: fluxes from boundary conditions (e.g. recharge or abstraction)

The simplest finite difference formulation is forward in time, central in space,
and can be written as:

Sᵢ * (ϕᵢᵗ⁺¹ - ϕᵢᵗ) / Δt = -Cᵢ₋₁ * (ϕᵢ₋₁ - ϕᵢ) -Cᵢ * (ϕᵢ₊₁ - ϕᵢ) + Qᵢ

with:
* ᵢ as cell index
* ᵗ as time index
* Δt as step size
* Cᵢ₋₁ as the intercell conductance between cell i-1 and i
* Cᵢ as the intercell conductance between cell i and i+1

Conductance is defined as:

C = kH * w / l

with:
* w the width of the cell to cell connection
* l the length of the cell to cell connection

k and H may both vary in space; intercell conductance is therefore an average
using the properties of two cells. See the documentation below.

There is only one unknown, ϕᵢᵗ⁺¹. Reshuffling terms:

ϕᵢᵗ⁺¹ = ϕᵢᵗ + (Cᵢ₋₁ * (ϕᵢ - ϕᵢ₋₁) + Cᵢ * (ϕᵢ₊₁ - ϕᵢ) + Qᵢ) * Δt / Sᵢ

This can be generalized to two dimensions, for both regular and irregular cell
connectivity.

See this paper for more details:
     Chu, W. S., & Willis, R. (1984). An explicit finite difference model for
     unconfined aquifers. Groundwater, 22(6), 728-734.

Boundary conditions can be classified into three categories:
* specified head (Dirichlet)
* specified flux (Neumann)
* head-dependent flux (Robin)

Neumann and Robin conditions are implemented by adding to or subtracting from a
net (lumped) cell flux. Dirichlet conditions are special cased, since they
cannot (easily) be implemented via the flux, but the head is set directly
instead.
"""
abstract type Aquifer end

abstract type AquiferBoundaryCondition end

"""
    ConfinedAquifer{T} <: Aquifer

Confined aquifers are overlain by a poorly permeable confining layer (e.g.
clay). No air can get in to fill the pore space so that the aquifer always
remains fully saturated. For a confined aquifer, water will always flow along
the complete height over the aquifer and transmissivity kH (m d⁻¹) is a
constant.

Specific storage is the amount of water an aquifer releases per unit change in
hydraulic head, per unit volume of aquifer, as the aquifer and the groundwater
itself is compressed. Its value is much smaller than specific yield, between
1E-5 (stiff) and 0.01 (weak).

NOTA BENE: **specific** storage is per m of aquifer (conf. specific weight).
**Storativity** or (**storage coefficient**) is for the entire aquifer (conf.
transmissivity).
"""
@get_units @grid_loc struct ConfinedAquifer{T} <: Aquifer
    head::Vector{T} | "m"  # hydraulic head [m]
    k::Vector{T} | "m d-1"  # horizontal conductivity [m d⁻¹]
    top::Vector{T} | "m" # top of groundwater layer [m]
    bottom::Vector{T} | "m" # bottom of groundwater layer
    area::Vector{T} | "m2" # area of cell
    specific_storage::Vector{T} | "m m-1 m-1" # [m m⁻¹ m⁻¹]
    storativity::Vector{T} | "m m-1" # [m m⁻¹]
    conductance::Vector{T} | "m2 d-1" # Confined aquifer conductance is constant
    volume::Vector{T} | "m3" # total volume of water that can be released
end

"""
    UnconfinedAquifer{T} <: Aquifer

The upper boundary of an unconfined aquifer is the water table (the phreatic
surface).

Specific yield (or drainable porosity) represents the volumetric fraction the
aquifer will yield when all water drains and the pore volume is filled by air
instead. Specific yield will vary roughly between 0.05 (clay) and 0.45 (peat)
(Johnson, 1967).
"""
@get_units @grid_loc struct UnconfinedAquifer{T} <: Aquifer
    head::Vector{T} | "m"  # hydraulic head [m]
    k::Vector{T} | "m d-1"  # reference horizontal conductivity [m d⁻¹]
    top::Vector{T} | "m" # top of groundwater layer [m]
    bottom::Vector{T} | "m" # bottom of groundwater layer
    area::Vector{T} | "m2"
    specific_yield::Vector{T} | "m m-1" # [m m⁻¹]
    conductance::Vector{T} | "m2 d-1" #
    volume::Vector{T} | "m3" # total volume of water that can be released
    f::Vector{T} | "-" # factor controlling the reduction of reference horizontal conductivity
    # Unconfined aquifer conductance is computed with degree of saturation (only when
    # conductivity_profile is set to "exponential")
end

storativity(A::UnconfinedAquifer) = A.specific_yield
storativity(A::ConfinedAquifer) = A.storativity

"""
    harmonicmean_conductance(kH1, kH2, l1, l2, width)

The harmonic mean is the exact interblock transmissivity for steady-state
one-dimensional flow with no recharge if the transmissivity is assumed to be
spatially uniform over each finite difference block, changing abruptly at the
block interface.

Refer to:

    Goode, D. J., & Appel, C. A. (1992). Finite-Difference Interblock Transmissivity
    for Unconﬁned Aquifers and for Aquifers having Smoothly Varying Transmissivity.
    Water-resources investigations report, 92, 4124.
"""
function harmonicmean_conductance(kH1, kH2, l1, l2, width)
    if (kH1 * kH2) > 0.0
        return width * kH1 * kH2 / (kH1 * l2 + kH2 * l1)
    else
        return 0.0
    end
end

function saturated_thickness(aquifer::UnconfinedAquifer, index::Int)
    return min(aquifer.top[index], aquifer.head[index]) - aquifer.bottom[index]
end

function saturated_thickness(aquifer::ConfinedAquifer, index::Int)
    return aquifer.top[index] - aquifer.bottom[index]
end

function saturated_thickness(aquifer::UnconfinedAquifer)
    @. min(aquifer.top, aquifer.head) - aquifer.bottom
end

function saturated_thickness(aquifer::ConfinedAquifer)
    @. aquifer.top - aquifer.bottom
end

"""
    horizontal_conductance(i, j, nzi, aquifer, C)

Compute fully saturated horizontal conductance for a single connection between two cells
(indexed with `i` and `j`). Geometry characteristics are taken from the
connectivity struct `C`, using the non-zero index (nzi) of its CSC data
structure.
"""
function horizontal_conductance(
    i::Int,
    j::Int,
    nzi::Int,
    aquifer::A,
    connectivity::Connectivity,
) where {A <: Aquifer}
    k1 = aquifer.k[i]
    k2 = aquifer.k[j]
    H1 = aquifer.top[i] - aquifer.bottom[i]
    H2 = aquifer.top[j] - aquifer.bottom[j]
    length1 = connectivity.length1[nzi]
    length2 = connectivity.length2[nzi]
    width = connectivity.width[nzi]
    kH1 = k1 * H1
    kH2 = k2 * H2
    return harmonicmean_conductance(kH1, kH2, length1, length2, width)
end

"""
    initialize_conductance!(aquifer::A, connectivity::Connectivity) where A <: Aquifer

Conductance for a confined aquifer is constant, and only has to be set once.
For an unconfined aquifer, conductance is computed per timestep by multiplying by
degree of saturation [0.0 - 1.0].
"""
function initialize_conductance!(
    aquifer::A,
    connectivity::Connectivity,
) where {A <: Aquifer}
    for i in 1:(connectivity.ncell)
        # Loop over connections for cell j
        for nzi in connections(connectivity, i)
            j = connectivity.rowval[nzi]
            aquifer.conductance[nzi] =
                horizontal_conductance(i, j, nzi, aquifer, connectivity)
        end
    end
end

function conductance(
    aquifer::ConfinedAquifer,
    i,
    j,
    nzi,
    conductivity_profile::String,
    connectivity::Connectivity,
)
    return aquifer.conductance[nzi]
end

"""
    conductance(aquifer::UnconfinedAquifer, connectivity::Connectivity)

This computes the conductance for an unconfined aquifer using the "upstream
saturated fraction" as the MODFLOW documentation calls it. In this approach, the
saturated thickness of a cell-to-cell is approximated using the cell with the
highest head. This results in a consistent overestimation of the saturated
thickness, but it avoids complexities related with cell drying and rewetting,
such as having to define a "wetting threshold" or a "wetting factor".

See the documentation for MODFLOW-NWT or MODFLOW6 for more background:
Niswonger, R.G., Panday, Sorab, and Ibaraki, Motomu, 2011, MODFLOW-NWT, A Newton
formulation for MODFLOW-2005: U.S. Geological Survey Techniques and Methods
6-A37, 44 p.

Langevin, C.D., Hughes, J.D., Banta, E.R., Niswonger, R.G., Panday, Sorab, and
Provost, A.M., 2017, Documentation for the MODFLOW 6 Groundwater Flow Model:
U.S. Geological Survey Techniques and Methods, book 6, chap. A55, 197 p.,
https://doi.org/10.3133/tm6A55.

For background on drying and rewetting, see:
McDonald, M.G., Harbaugh, A.W., Orr, B.R., and Ackerman, D.J., 1991, A method of
converting no-flow cells to variable-head cells for the U.S. Geological Survey
modular finite-difference groundwater flow model: U.S. Geological Survey
Open-File Report 91-536, 99 p
"""
function conductance(
    aquifer::UnconfinedAquifer,
    i,
    j,
    nzi,
    conductivity_profile::String,
    connectivity::Connectivity,
)
    if conductivity_profile == "exponential"
        # Extract required variables
        zi1 = aquifer.top[i] - aquifer.head[i]
        zi2 = aquifer.top[j] - aquifer.head[j]
        thickness1 = aquifer.top[i] - aquifer.bottom[i]
        thickness2 = aquifer.top[j] - aquifer.bottom[j]
        # calculate conductivity values corrected for depth of water table
        k1 =
            (aquifer.k[i] / aquifer.f[i]) *
            (exp(-aquifer.f[i] * zi1) - exp(-aquifer.f[i] * thickness1))
        k2 =
            (aquifer.k[j] / aquifer.f[j]) *
            (exp(-aquifer.f[j] * zi2) - exp(-aquifer.f[j] * thickness2))
        return harmonicmean_conductance(
            k1,
            k2,
            connectivity.length1[nzi],
            connectivity.length2[nzi],
            connectivity.width[nzi],
        )
    elseif conductivity_profile == "uniform"
        head_i = aquifer.head[i]
        head_j = aquifer.head[j]
        if head_i >= head_j
            saturation =
                saturated_thickness(aquifer, i) / (aquifer.top[i] - aquifer.bottom[i])
        else
            saturation =
                saturated_thickness(aquifer, j) / (aquifer.top[j] - aquifer.bottom[j])
        end
        return saturation * aquifer.conductance[nzi]
    else
        error(
            """An unknown "conductivity_profile" is specified in the TOML file ($conductivity_profile).
            This should be "uniform" or "exponential".
            """,
        )
    end
end

function flux!(Q, aquifer, connectivity, conductivity_profile)
    for i in 1:(connectivity.ncell)
        # Loop over connections for cell j
        for nzi in connections(connectivity, i)
            # connection from i -> j
            j = connectivity.rowval[nzi]
            delta_head = aquifer.head[i] - aquifer.head[j]
            cond = conductance(aquifer, i, j, nzi, conductivity_profile, connectivity)
            Q[i] -= cond * delta_head
        end
    end
    return Q
end

@get_units @grid_loc struct ConstantHead{T}
    head::Vector{T} | "m"
    index::Vector{Int} | "-"
end

"""
    stable_timestep(aquifer)

Compute a stable timestep size given the forward-in-time, central in space scheme.
The following criterion can be found in Chu & Willis (1984)

Δt * k * H / (Δx * Δy * S) <= 1/4
"""
function stable_timestep(aquifer, conductivity_profile::String)
    dt_min = Inf
    for i in eachindex(aquifer.head)
        if conductivity_profile == "exponential"
            zi = aquifer.top[i] - aquifer.head[i]
            thickness = aquifer.top[i] - aquifer.bottom[i]
            value =
                (aquifer.k[i] / aquifer.f[i]) *
                (exp(-aquifer.f[i] * zi) - exp(-aquifer.f[i] * thickness))
        elseif conductivity_profile == "uniform"
            value = aquifer.k[i] * saturated_thickness(aquifer, i)
        end

        dt = aquifer.area[i] * storativity(aquifer)[i] / value
        dt_min = dt < dt_min ? dt : dt_min
    end
    return 0.25 * dt_min
end

minimum_head(aquifer::ConfinedAquifer) = aquifer.head
minimum_head(aquifer::UnconfinedAquifer) = max.(aquifer.head, aquifer.bottom)

function update!(gwf, Q, dt, conductivity_profile)
    Q .= 0.0  # TODO: Probably remove this when linking with other components
    flux!(Q, gwf.aquifer, gwf.connectivity, conductivity_profile)
    for boundary in gwf.boundaries
        flux!(Q, boundary, gwf.aquifer)
    end
    gwf.aquifer.head .+= (Q ./ gwf.aquifer.area .* dt ./ storativity(gwf.aquifer))
    # Set constant head (dirichlet) boundaries
    gwf.aquifer.head[gwf.constanthead.index] .= gwf.constanthead.head
    # Make sure no heads ends up below an unconfined aquifer bottom
    gwf.aquifer.head .= minimum_head(gwf.aquifer)
    gwf.aquifer.volume .=
        saturated_thickness(gwf.aquifer) .* gwf.aquifer.area .* storativity(gwf.aquifer)
    return nothing
end

Base.@kwdef struct GroundwaterFlow{A, C, CH, B}
    aquifer::A
    connectivity::C
    constanthead::CH
    boundaries::B
end

function GroundwaterFlow{T}(;
    aquifer::Aquifer,
    connectivity::Connectivity{T},
    constanthead::ConstantHead{T},
    boundaries::Vector{AquiferBoundaryCondition},
) where {T}
    initialize_conductance!(aquifer, connectivity)
    args = (aquifer, connectivity, constanthead, boundaries)
    GroundwaterFlow{typeof.(args)...}(args...)
end

function get_water_depth(
    gwf::GroundwaterFlow{A, C, CH, B},
) where {A <: UnconfinedAquifer, C, CH, B}
    gwf.aquifer.head .= min.(gwf.aquifer.head, gwf.aquifer.top)
    gwf.aquifer.head[gwf.constanthead.index] .= gwf.constanthead.head
    wtd = gwf.aquifer.top .- gwf.aquifer.head
    return wtd
end

function get_exfiltwater(
    gwf::GroundwaterFlow{A, C, CH, B},
) where {A <: UnconfinedAquifer, C, CH, B}
    exfiltwater =
        (gwf.aquifer.head .- min.(gwf.aquifer.head, gwf.aquifer.top)) .*
        storativity(gwf.aquifer)
    exfiltwater[gwf.constanthead.index] .= 0
    return exfiltwater
end