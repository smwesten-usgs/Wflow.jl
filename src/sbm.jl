@get_units @with_kw struct SBM{T,N,M}
    # Model time step [s]
    Δt::T | "s"
    # Maximum number of soil layers
    maxlayers::Int | "-"
    # number of cells
    n::Int | "-"
    # Number of soil layers
    nlayers::Vector{Int} | "-"
    # Number of unsaturated soil layers
    n_unsatlayers::Vector{Int} | "-"
    # Fraction of river [-]
    riverfrac::Vector{T} | "-"
    # Saturated water content (porosity) [-]
    θₛ::Vector{T} | "-"
    # Residual water content [-]
    θᵣ::Vector{T} | "-"
    # Vertical hydraulic conductivity [mm Δt⁻¹] at soil surface
    kv₀::Vector{T}
    # Muliplication factor [-] applied to kv_z (vertical flow)
    kvfrac::Vector{SVector{N,T}} | "-"
    # Air entry pressure [cm] of soil (Brooks-Corey)
    hb::Vector{T} | "cm"
    # Soil thickness [mm]
    soilthickness::Vector{T} | "mm"
    # Thickness of soil layers [mm]
    act_thickl::Vector{SVector{N,T}} | "mm"
    # Cumulative sum of soil layers [mm], starting at soil surface (0)
    sumlayers::Vector{SVector{M,T}} | "mm"
    # Infiltration capacity of the compacted areas [mm Δt⁻¹]
    infiltcappath::Vector{T}
    # Soil infiltration capacity [mm Δt⁻¹]
    infiltcapsoil::Vector{T}
    # Maximum leakage [mm Δt⁻¹] from saturated zone
    maxleakage::Vector{T}
    # Fraction of open water (excluding rivers) [-]
    waterfrac::Vector{T} | "-"
    # Fraction of compacted area  [-]
    pathfrac::Vector{T} | "-"
    # Rooting depth [mm]
    rootingdepth::Vector{T} | "mm"
    # Controls how roots are linked to water table [-]
    rootdistpar::Vector{T} | "-"
    # Parameter [mm] controlling capillary rise
    cap_hmax::Vector{T} | "mm"
    # Coefficient [-] controlling capillary rise
    cap_n::Vector{T} | "-"
    # Multiplication factor [-] to correct
    et_reftopot::Vector{T} | "-"
    # Brooks-Corey power coefﬁcient [-] for each soil layer
    c::Vector{SVector{N,T}} | "-"
    # Stemflow [mm Δt⁻¹]
    stemflow::Vector{T}
    # Throughfall [mm Δt⁻¹]
    throughfall::Vector{T}
    # A scaling parameter [mm⁻¹] (controls exponential decline of kv₀)
    f::Vector{T} | "mm-1"
    # Amount of water in the unsaturated store, per layer [mm]
    ustorelayerdepth::Vector{SVector{N,T}} | "mm"
    # Saturated store [mm]
    satwaterdepth::Vector{T} | "mm"
    # Pseudo-water table depth [mm] (top of the saturated zone)
    zi::Vector{T} | "mm"
    # Soilwater capacity [mm]
    soilwatercapacity::Vector{T} | "mm"
    # Canopy storage [mm]
    canopystorage::Vector{T} | "mm"
    # Maximum canopy storage [mm]
    cmax::Vector{T} | "mm"
    # Canopy gap fraction [-]
    canopygapfraction::Vector{T} | "-"
    # Gash interception model parameter, ratio of the average evaporation from the
    # wet canopy [mm Δt⁻¹] and the average precipitation intensity [mm Δt⁻¹] on a saturated canopy
    e_r::Vector{T} | "-"
    # Precipitation [mm Δt⁻¹]
    precipitation::Vector{T}
    # Temperature [ᵒC]
    temperature::Vector{T} | "°C"
    # Potential evapotranspiration [mm Δt⁻¹]
    potential_evaporation::Vector{T}
    # Potential transpiration, open water, river and soil evaporation (after subtracting interception from potential_evaporation)
    pottrans_soil::Vector{T}
    # Transpiration [mm Δt⁻¹]
    transpiration::Vector{T}
    # Actual evaporation from unsaturated store [mm Δt⁻¹]
    ae_ustore::Vector{T}
    # Interception [mm Δt⁻¹]
    interception::Vector{T}
    # Soil evaporation from unsaturated store [mm Δt⁻¹]
    soilevap::Vector{T}
    # Soil evaporation from saturated store [mm Δt⁻¹]
    soilevapsat::Vector{T}
    # Actual capillary rise [mm Δt⁻¹]
    actcapflux::Vector{T}
    # Actual transpiration from saturated store [mm Δt⁻¹]
    actevapsat::Vector{T}
    # Total actual evapotranspiration [mm Δt⁻¹]
    actevap::Vector{T}
    # Runoff from river based on riverfrac [mm Δt⁻¹]
    runoff_river::Vector{T}
    # Runoff from land based on waterfrac [mm Δt⁻¹]
    runoff_land::Vector{T}
    # Actual evaporation from open water (land) [mm Δt⁻¹]
    ae_openw_l::Vector{T}
    # Actual evaporation from river [mm Δt⁻¹]
    ae_openw_r::Vector{T}
    # Net runoff from river [mm Δt⁻¹]
    net_runoff_river::Vector{T}
    # Water available for infiltration [mm Δt⁻¹]
    avail_forinfilt::Vector{T}
    # Actual infiltration into the unsaturated zone [mm Δt⁻¹]
    actinfilt::Vector{T}
    # Actual infiltration non-compacted fraction [mm Δt⁻¹]
    actinfiltsoil::Vector{T}
    # Actual infiltration compacted fraction [mm Δt⁻¹]
    actinfiltpath::Vector{T}
    # Actual infiltration (compacted and the non-compacted areas) [mm Δt⁻¹]
    infiltsoilpath::Vector{T}
    # Infiltration excess water [mm Δt⁻¹]
    infiltexcess::Vector{T}
    # Water that cannot infiltrate due to saturated soil (saturation excess) [mm Δt⁻¹]
    excesswater::Vector{T}
    # Water exfiltrating during saturation excess conditions [mm Δt⁻¹]
    exfiltsatwater::Vector{T}
    # Water exfiltrating from unsaturated store because of change in water table [mm Δt⁻¹]
    exfiltustore::Vector{T}
    # Excess water for non-compacted fraction [mm Δt⁻¹]
    excesswatersoil::Vector{T}
    # Excess water for compacted fraction [mm Δt⁻¹]
    excesswaterpath::Vector{T}
    # Total surface runoff from infiltration and saturation excess [mm Δt⁻¹]
    runoff::Vector{T}
    # Volumetric water content [-] per soil layer (including θᵣ and saturated zone)
    vwc::Vector{SVector{N,T}} | "-"
    # Volumetric water content [%] per soil layer (including θᵣ and saturated zone)
    vwc_perc::Vector{SVector{N,T}} | "%"
    # Root water storage [mm] in unsaturated and saturated zone (excluding θᵣ)
    rootstore::Vector{T} | "mm"
    # Volumetric water content [-] in root zone (including θᵣ and saturated zone)
    vwc_root::Vector{T} | "-"
    # Volumetric water content [%] in root zone (including θᵣ and saturated zone)
    vwc_percroot::Vector{T} | "%"
    # Amount of available water in the unsaturated zone [mm]
    ustoredepth::Vector{T} | "mm"
    # Downward flux from unsaturated to saturated zone [mm Δt⁻¹]
    transfer::Vector{T}
    # Net recharge to saturated store [mm Δt⁻¹]
    recharge::Vector{T}
    # Actual leakage from saturated store [mm Δt⁻¹]
    actleakage::Vector{T}
    ### Snow parameters ###
    # Degree-day factor [mm ᵒC⁻¹ Δt⁻¹]
    cfmax::Vector{T} | "mm ᵒC-1 Δt-1"
    # Threshold temperature for snowfall [ᵒC]
    tt::Vector{T} | "ᵒC"
    # Threshold temperature interval length [ᵒC]
    tti::Vector{T} | "ᵒC"
    # Threshold temperature for snowmelt [ᵒC]
    ttm::Vector{T} | "ᵒC"
    # Water holding capacity as fraction of current snow pack [-]
    whc::Vector{T} | "-"
    # Soil temperature smooth factor [-]
    w_soil::Vector{T} | "-"
    # Controls soil infiltration reduction factor when soil is frozen [-]
    cf_soil::Vector{T} | "-"
    # Snow storage [mm]
    snow::Vector{T} | "mm"
    # Liquid water content in the snow pack [mm]
    snowwater::Vector{T} | "mm"
    # Snow melt + precipitation as rainfall [mm]
    rainfallplusmelt::Vector{T} | "mm"
    # Threshold temperature for snowfall above glacier [ᵒC]
    g_tt::Vector{T} | "ᵒC"
    # Degree-day factor [mm ᵒC⁻¹ Δt⁻¹] for glacier
    g_cfmax::Vector{T} | "mm ᵒC-1 Δt-1"
    # Fraction of the snowpack on top of the glacier converted into ice [Δt⁻¹]
    g_sifrac::Vector{T} | "Δt-1"
    # Water within the glacier [mm]
    glacierstore::Vector{T} | "mm"
    # Fraction covered by a glacier [-]
    glacierfrac::Vector{T} | "-"
    # Top soil temperature [ᵒC]
    tsoil::Vector{T} | "ᵒC"
    ## Interception related to leaf_area_index climatology ###
    # Specific leaf storage [mm]
    sl::Vector{T} | "mm"
    # Storage woody part of vegetation [mm]
    swood::Vector{T} | "mm"
    # Extinction coefficient [-] (to calculate canopy gap fraction)
    kext::Vector{T} | "-"
    # Leaf area index [m² m⁻²]
    leaf_area_index::Vector{T} | "m2 m-2"
    # Water level land [mm]
    waterlevel_land::Vector{T} | "mm"
    # Water level river [mm]
    waterlevel_river::Vector{T} | "mm"

    #function SBM{T,N,M}(args...) where {T,N,M}
    #    equal_size_vectors(args)
    #    return new(args...)
    #end
end

statevars(::SBM; snow = false) =
    snow ? (:satwaterdepth, :snow, :tsoil, :ustorelayerdepth, :snowwater, :canopystorage) :
    (:satwaterdepth, :ustorelayerdepth, :canopystorage)

function initialize_canopy(nc, config, inds)
    n = length(inds)
    # if leaf area index climatology provided use sl, swood and kext to calculate cmax, e_r and canopygapfraction
    if haskey(config.input.vertical, "leaf_area_index")
        # TODO confirm if leaf area index climatology is present in the NetCDF
        sl = ncread(
            nc,
            config,
            "vertical.specific_leaf";
            optional = false,
            sel = inds,
            type = Float,
        )
        swood = ncread(
            nc,
            config,
            "vertical.storage_wood";
            optional = false,
            sel = inds,
            type = Float,
        )
        kext =
            ncread(nc, config, "vertical.kext"; optional = false, sel = inds, type = Float)
        cmax = fill(mv, n)
        e_r = fill(mv, n)
        canopygapfraction = fill(mv, n)
    else
        sl = fill(mv, n)
        swood = fill(mv, n)
        kext = fill(mv, n)
        # cmax, e_r, canopygapfraction only required when leaf area index climatology not provided
        cmax = ncread(nc, config, "vertical.cmax"; sel = inds, defaults = 1.0, type = Float)
        e_r =
            ncread(nc, config, "vertical.eoverr"; sel = inds, defaults = 0.1, type = Float)
        canopygapfraction = ncread(
            nc,
            config,
            "vertical.canopygapfraction";
            sel = inds,
            defaults = 0.1,
            type = Float,
        )
    end
    return cmax, e_r, canopygapfraction, sl, swood, kext
end

function initialize_sbm(nc, config, riverfrac, inds)

    Δt = Second(config.timestepsecs)
    config_thicknesslayers = get(config.model, "thicknesslayers", Float[])
    if length(config_thicknesslayers) > 0
        thicknesslayers = SVector(Tuple(push!(Float.(config_thicknesslayers), mv)))
        sumlayers = pushfirst(cumsum(thicknesslayers), 0.0)
        maxlayers = length(thicknesslayers) # max number of soil layers
    else
        maxlayers = 1
    end

    n = length(inds)

    cfmax =
        ncread(
            nc,
            config,
            "vertical.cfmax";
            sel = inds,
            defaults = 3.75653,
            type = Float,
        ) .* (Δt / basetimestep)
    tt = ncread(nc, config, "vertical.tt"; sel = inds, defaults = 0.0, type = Float)
    tti = ncread(nc, config, "vertical.tti"; sel = inds, defaults = 1.0, type = Float)
    ttm = ncread(nc, config, "vertical.ttm"; sel = inds, defaults = 0.0, type = Float)
    whc = ncread(nc, config, "vertical.whc"; sel = inds, defaults = 0.1, type = Float)
    w_soil =
        ncread(
            nc,
            config,
            "vertical.w_soil";
            sel = inds,
            defaults = 0.1125,
            type = Float,
        ) .* (Δt / basetimestep)
    cf_soil =
        ncread(nc, config, "vertical.cf_soil"; sel = inds, defaults = 0.038, type = Float)
    # glacier parameters
    g_tt = ncread(
        nc,
        config,
        "vertical.g_tt";
        sel = inds,
        defaults = 0.0,
        type = Float,
        fill = 0.0,
    )
    g_cfmax =
        ncread(
            nc,
            config,
            "vertical.g_cfmax";
            sel = inds,
            defaults = 3.0,
            type = Float,
            fill = 0.0,
        ) .* (Δt / basetimestep)
    g_sifrac =
        ncread(
            nc,
            config,
            "vertical.g_sifrac";
            sel = inds,
            defaults = 0.001,
            type = Float,
            fill = 0.0,
        ) .* (Δt / basetimestep)
    glacierfrac = ncread(
        nc,
        config,
        "vertical.glacierfrac";
        sel = inds,
        defaults = 0.0,
        type = Float,
        fill = 0.0,
    )
    glacierstore = ncread(
        nc,
        config,
        "vertical.glacierstore";
        sel = inds,
        defaults = 5500.0,
        type = Float,
        fill = 0.0,
    )
    # soil parameters
    θₛ = ncread(
        nc,
        config,
        "vertical.theta_s";
        alias = "vertical.θₛ",
        sel = inds,
        defaults = 0.6,
        type = Float,
    )
    θᵣ = ncread(
        nc,
        config,
        "vertical.theta_r";
        alias = "vertical.θᵣ",
        sel = inds,
        defaults = 0.01,
        type = Float,
    )
    kv₀ =
        ncread(
            nc,
            config,
            "vertical.kv_0";
            alias = "vertical.kv₀",
            sel = inds,
            defaults = 3000.0,
            type = Float,
        ) .* (Δt / basetimestep)
    f = ncread(nc, config, "vertical.f"; sel = inds, defaults = 0.001, type = Float)
    hb = ncread(nc, config, "vertical.hb"; sel = inds, defaults = 10.0, type = Float)
    soilthickness = ncread(
        nc,
        config,
        "vertical.soilthickness";
        sel = inds,
        defaults = 2000.0,
        type = Float,
    )
    infiltcappath =
        ncread(
            nc,
            config,
            "vertical.infiltcappath";
            sel = inds,
            defaults = 10.0,
            type = Float,
        ) .* (Δt / basetimestep)
    infiltcapsoil =
        ncread(
            nc,
            config,
            "vertical.infiltcapsoil";
            sel = inds,
            defaults = 100.0,
            type = Float,
        ) .* (Δt / basetimestep)
    maxleakage =
        ncread(
            nc,
            config,
            "vertical.maxleakage";
            sel = inds,
            defaults = 0.0,
            type = Float,
        ) .* (Δt / basetimestep)

    c = ncread(
        nc,
        config,
        "vertical.c";
        sel = inds,
        defaults = 10.0,
        type = Float,
        dimname = :layer,
    )
    if size(c, 1) != maxlayers
        parname = param(config.input.vertical, "c")
        size1 = size(c, 1)
        error("$parname needs a layer dimension of size $maxlayers, but is $size1")
    end
    kvfrac = ncread(
        nc,
        config,
        "vertical.kvfrac";
        sel = inds,
        defaults = 1.0,
        type = Float,
        dimname = :layer,
    )
    if size(kvfrac, 1) != maxlayers
        parname = param(config.input, "vertical.kvfrac")
        size1 = size(kvfrac, 1)
        error("$parname needs a layer dimension of size $maxlayers, but is $size1")
    end

    # fraction open water and compacted area (land cover)
    waterfrac =
        ncread(nc, config, "vertical.waterfrac"; sel = inds, defaults = 0.0, type = Float)
    pathfrac =
        ncread(nc, config, "vertical.pathfrac"; sel = inds, defaults = 0.01, type = Float)

    # vegetation parameters
    rootingdepth = ncread(
        nc,
        config,
        "vertical.rootingdepth";
        sel = inds,
        defaults = 750.0,
        type = Float,
    )
    rootdistpar = ncread(
        nc,
        config,
        "vertical.rootdistpar";
        sel = inds,
        defaults = -500.0,
        type = Float,
    )
    cap_hmax =
        ncread(nc, config, "vertical.cap_hmax"; sel = inds, defaults = 2000.0, type = Float)
    cap_n = ncread(nc, config, "vertical.cap_n"; sel = inds, defaults = 2.0, type = Float)
    et_reftopot =
        ncread(nc, config, "vertical.et_reftopot"; sel = inds, defaults = 1.0, type = Float)

    cmax, e_r, canopygapfraction, sl, swood, kext = initialize_canopy(nc, config, inds)

    # these are filled in the loop below
    # TODO see if we can replace this approach
    nlayers = zeros(Int, n)
    act_thickl = zeros(Float, maxlayers, n)
    s_layers = zeros(Float, maxlayers + 1, n)

    for i = 1:n
        if length(config_thicknesslayers) > 0
            act_thickl_, nlayers_ =
                set_layerthickness(soilthickness[i], sumlayers, thicknesslayers)
            s_layers_ = pushfirst(cumsum(act_thickl_), 0.0)

            nlayers[i] = nlayers_
            act_thickl[:, i] = act_thickl_
            s_layers[:, i] = s_layers_
        else
            nlayers[i] = 1
            act_thickl[:, i] = SVector(soilthickness[i])
            s_layers[:, i] = pushfirst(cumsum(SVector(soilthickness[i])), 0.0)
        end
    end

    # needed for derived parameters below
    act_thickl = svectorscopy(act_thickl, Val{maxlayers}())
    θₑ = θₛ .- θᵣ
    soilwatercapacity = soilthickness .* θₑ
    satwaterdepth = 0.85 .* soilwatercapacity # cold state value for satwaterdepth
    zi = max.(0.0, soilthickness .- satwaterdepth ./ θₑ) # cold state value for zi

    # copied to array of sarray below
    vwc = fill(mv, maxlayers, n)
    vwc_perc = fill(mv, maxlayers, n)

    # fill namedtuple sbm with all fields of SBM struct
    sbm = (
        Δt = tosecond(Δt),
        maxlayers = maxlayers,
        n = n,
        nlayers = nlayers,
        n_unsatlayers = fill(0, n),
        riverfrac = riverfrac,
        θₛ = θₛ,
        θᵣ = θᵣ,
        kv₀ = kv₀,
        kvfrac = svectorscopy(kvfrac, Val{maxlayers}()),
        hb = hb,
        soilthickness = soilthickness,
        act_thickl = act_thickl,
        sumlayers = svectorscopy(s_layers, Val{maxlayers + 1}()),
        infiltcappath = infiltcappath,
        infiltcapsoil = infiltcapsoil,
        maxleakage = maxleakage,
        waterfrac = max.(waterfrac .- riverfrac, Float(0.0)),
        pathfrac = pathfrac,
        rootingdepth = rootingdepth,
        rootdistpar = rootdistpar,
        cap_hmax = cap_hmax,
        cap_n = cap_n,
        et_reftopot = et_reftopot,
        c = svectorscopy(c, Val{maxlayers}()),
        stemflow = fill(mv, n),
        throughfall = fill(mv, n),
        f = f,
        ustorelayerdepth = zero(act_thickl),
        satwaterdepth = satwaterdepth,
        zi = zi,
        soilwatercapacity = soilwatercapacity,
        canopystorage = zeros(Float, n),
        cmax = cmax,
        canopygapfraction = canopygapfraction,
        e_r = e_r,
        precipitation = fill(mv, n),
        temperature = fill(mv, n),
        potential_evaporation = fill(mv, n),
        pottrans_soil = fill(mv, n),
        transpiration = fill(mv, n),
        ae_ustore = fill(mv, n),
        interception = fill(mv, n),
        soilevap = fill(mv, n),
        soilevapsat = fill(mv, n),
        actcapflux = fill(mv, n),
        actevapsat = fill(mv, n),
        actevap = fill(mv, n),
        runoff_river = fill(mv, n),
        runoff_land = fill(mv, n),
        ae_openw_l = fill(mv, n),
        ae_openw_r = fill(mv, n),
        avail_forinfilt = fill(mv, n),
        actinfilt = fill(mv, n),
        actinfiltsoil = fill(mv, n),
        actinfiltpath = fill(mv, n),
        infiltsoilpath = fill(mv, n),
        infiltexcess = fill(mv, n),
        excesswater = fill(mv, n),
        exfiltsatwater = fill(mv, n),
        exfiltustore = fill(mv, n),
        excesswatersoil = fill(mv, n),
        excesswaterpath = fill(mv, n),
        runoff = fill(mv, n),
        net_runoff_river = fill(mv, n),
        vwc = svectorscopy(vwc, Val{maxlayers}()),
        vwc_perc = svectorscopy(vwc_perc, Val{maxlayers}()),
        rootstore = fill(mv, n),
        vwc_root = fill(mv, n),
        vwc_percroot = fill(mv, n),
        ustoredepth = fill(mv, n),
        transfer = fill(mv, n),
        recharge = fill(mv, n),
        actleakage = fill(mv, n),
        # snow parameters
        cfmax = cfmax,
        tt = tt,
        tti = tti,
        ttm = ttm,
        whc = whc,
        w_soil = w_soil,
        cf_soil = cf_soil,
        snow = zeros(Float, n),
        snowwater = zeros(Float, n),
        rainfallplusmelt = fill(mv, n),
        tsoil = fill(Float(10.0), n),
        # glacier parameters
        g_tt = g_tt,
        g_sifrac = g_sifrac,
        g_cfmax = g_cfmax,
        glacierstore = glacierstore,
        glacierfrac = glacierfrac,
        # Interception related to climatology (leaf_area_index)
        sl = sl,
        swood = swood,
        kext = kext,
        leaf_area_index = fill(mv, n),
        waterlevel_land = fill(mv, n),
        waterlevel_river = zeros(Float, n), #set to zero to account for cells outside river domain
    )

    return sbm

end

function set_sbm(sbm, maxlayers, indices, comm, rank, nprocs)

    sbm = SBM{Float,maxlayers,maxlayers + 1}(
        Δt = broadcast_to_ranks(sbm.Δt, comm),
        maxlayers = maxlayers,
        n = nprocs == 1 ? sbm.n : length(indices[rank+1]),
        nlayers = scatter_to_ranks(sbm.nlayers, indices, nprocs, comm, rank),
        n_unsatlayers = scatter_to_ranks(sbm.n_unsatlayers, indices, nprocs, comm, rank),
        riverfrac = scatter_to_ranks(sbm.riverfrac, indices, nprocs, comm, rank),
        θₛ = scatter_to_ranks(sbm.θₛ, indices, nprocs, comm, rank),
        θᵣ = scatter_to_ranks(sbm.θᵣ, indices, nprocs, comm, rank),
        kv₀ = scatter_to_ranks(sbm.kv₀, indices, nprocs, comm, rank),
        kvfrac = scatter_to_ranks(sbm.kvfrac, indices, nprocs, comm, rank),
        hb = scatter_to_ranks(sbm.hb, indices, nprocs, comm, rank),
        soilthickness = scatter_to_ranks(sbm.soilthickness, indices, nprocs, comm, rank),
        act_thickl = scatter_to_ranks(sbm.act_thickl, indices, nprocs, comm, rank),
        sumlayers = scatter_to_ranks(sbm.sumlayers, indices, nprocs, comm, rank),
        infiltcappath = scatter_to_ranks(sbm.infiltcappath, indices, nprocs, comm, rank),
        infiltcapsoil = scatter_to_ranks(sbm.infiltcapsoil, indices, nprocs, comm, rank),
        maxleakage = scatter_to_ranks(sbm.maxleakage, indices, nprocs, comm, rank),
        waterfrac = scatter_to_ranks(sbm.waterfrac, indices, nprocs, comm, rank),
        pathfrac = scatter_to_ranks(sbm.pathfrac, indices, nprocs, comm, rank),
        rootingdepth = scatter_to_ranks(sbm.rootingdepth, indices, nprocs, comm, rank),
        rootdistpar = scatter_to_ranks(sbm.rootdistpar, indices, nprocs, comm, rank),
        cap_hmax = scatter_to_ranks(sbm.cap_hmax, indices, nprocs, comm, rank),
        cap_n = scatter_to_ranks(sbm.cap_n, indices, nprocs, comm, rank),
        et_reftopot = scatter_to_ranks(sbm.et_reftopot, indices, nprocs, comm, rank),
        c = scatter_to_ranks(sbm.c, indices, nprocs, comm, rank),
        stemflow = scatter_to_ranks(sbm.stemflow, indices, nprocs, comm, rank),
        throughfall = scatter_to_ranks(sbm.stemflow, indices, nprocs, comm, rank),
        f = scatter_to_ranks(sbm.f, indices, nprocs, comm, rank),
        ustorelayerdepth = scatter_to_ranks(sbm.ustorelayerdepth, indices, nprocs, comm, rank),
        satwaterdepth = scatter_to_ranks(sbm.satwaterdepth, indices, nprocs, comm, rank),
        zi = scatter_to_ranks(sbm.zi, indices, nprocs, comm, rank),
        soilwatercapacity = scatter_to_ranks(sbm.soilwatercapacity, indices, nprocs, comm, rank),
        canopystorage =  scatter_to_ranks(sbm.canopystorage, indices, nprocs, comm, rank),
        cmax = scatter_to_ranks(sbm.cmax, indices, nprocs, comm, rank),
        canopygapfraction = scatter_to_ranks(sbm.canopygapfraction, indices, nprocs, comm, rank),
        e_r = scatter_to_ranks(sbm.e_r, indices, nprocs, comm, rank),
        precipitation = scatter_to_ranks(sbm.precipitation, indices, nprocs, comm, rank),
        temperature = scatter_to_ranks(sbm.temperature, indices, nprocs, comm, rank),
        potential_evaporation = scatter_to_ranks(sbm.potential_evaporation, indices, nprocs, comm, rank),
        pottrans_soil = scatter_to_ranks(sbm.pottrans_soil, indices, nprocs, comm, rank),
        transpiration = scatter_to_ranks(sbm.transpiration, indices, nprocs, comm, rank),
        ae_ustore = scatter_to_ranks(sbm.ae_ustore, indices, nprocs, comm, rank),
        interception = scatter_to_ranks(sbm.interception, indices, nprocs, comm, rank),
        soilevap = scatter_to_ranks(sbm.soilevap, indices, nprocs, comm, rank),
        soilevapsat = scatter_to_ranks(sbm.soilevapsat, indices, nprocs, comm, rank),
        actcapflux = scatter_to_ranks(sbm.actcapflux, indices, nprocs, comm, rank),
        actevapsat = scatter_to_ranks(sbm.actevapsat, indices, nprocs, comm, rank),
        actevap = scatter_to_ranks(sbm.actevap, indices, nprocs, comm, rank),
        runoff_river = scatter_to_ranks(sbm.runoff_river, indices, nprocs, comm, rank),
        runoff_land = scatter_to_ranks(sbm.runoff_land, indices, nprocs, comm, rank),
        ae_openw_l = scatter_to_ranks(sbm.ae_openw_l, indices, nprocs, comm, rank),
        ae_openw_r = scatter_to_ranks(sbm.ae_openw_r, indices, nprocs, comm, rank),
        avail_forinfilt = scatter_to_ranks(sbm.avail_forinfilt, indices, nprocs, comm, rank),
        actinfilt = scatter_to_ranks(sbm.actinfilt, indices, nprocs, comm, rank),
        actinfiltsoil = scatter_to_ranks(sbm.actinfiltsoil, indices, nprocs, comm, rank),
        actinfiltpath = scatter_to_ranks(sbm.actinfiltpath, indices, nprocs, comm, rank),
        infiltsoilpath = scatter_to_ranks(sbm.infiltsoilpath, indices, nprocs, comm, rank),
        infiltexcess = scatter_to_ranks(sbm.infiltexcess, indices, nprocs, comm, rank),
        excesswater = scatter_to_ranks(sbm.excesswater, indices, nprocs, comm, rank),
        exfiltsatwater = scatter_to_ranks(sbm.exfiltsatwater, indices, nprocs, comm, rank),
        exfiltustore = scatter_to_ranks(sbm.exfiltustore, indices, nprocs, comm, rank),
        excesswatersoil = scatter_to_ranks(sbm.excesswatersoil, indices, nprocs, comm, rank),
        excesswaterpath = scatter_to_ranks(sbm.excesswaterpath, indices, nprocs, comm, rank),
        runoff = scatter_to_ranks(sbm.runoff, indices, nprocs, comm, rank),
        net_runoff_river = scatter_to_ranks(sbm.net_runoff_river, indices, nprocs, comm, rank),
        vwc = scatter_to_ranks(sbm.vwc, indices, nprocs, comm, rank),
        vwc_perc = scatter_to_ranks(sbm.vwc_perc, indices, nprocs, comm, rank),
        rootstore = scatter_to_ranks(sbm.rootstore, indices, nprocs, comm, rank),
        vwc_root = scatter_to_ranks(sbm.vwc_root, indices, nprocs, comm, rank),
        vwc_percroot = scatter_to_ranks(sbm.vwc_percroot, indices, nprocs, comm, rank),
        ustoredepth = scatter_to_ranks(sbm.ustoredepth, indices, nprocs, comm, rank),
        transfer = scatter_to_ranks(sbm.transfer, indices, nprocs, comm, rank),
        recharge = scatter_to_ranks(sbm.recharge, indices, nprocs, comm, rank),
        actleakage = scatter_to_ranks(sbm.actleakage, indices, nprocs, comm, rank),
        # snow parameters
        cfmax = scatter_to_ranks(sbm.cfmax, indices, nprocs, comm, rank),
        tt = scatter_to_ranks(sbm.tt, indices, nprocs, comm, rank),
        tti = scatter_to_ranks(sbm.tti, indices, nprocs, comm, rank),
        ttm = scatter_to_ranks(sbm.ttm, indices, nprocs, comm, rank),
        whc = scatter_to_ranks(sbm.whc, indices, nprocs, comm, rank),
        w_soil = scatter_to_ranks(sbm.w_soil, indices, nprocs, comm, rank),
        cf_soil = scatter_to_ranks(sbm.cf_soil, indices, nprocs, comm, rank),
        snow = scatter_to_ranks(sbm.snow, indices, nprocs, comm, rank),
        snowwater = scatter_to_ranks(sbm.snowwater, indices, nprocs, comm, rank),
        rainfallplusmelt = scatter_to_ranks(sbm.rainfallplusmelt, indices, nprocs, comm, rank),
        tsoil = scatter_to_ranks(sbm.tsoil, indices, nprocs, comm, rank),
        # glacier parameters
        g_tt = scatter_to_ranks(sbm.g_tt, indices, nprocs, comm, rank),
        g_sifrac = scatter_to_ranks(sbm.g_sifrac, indices, nprocs, comm, rank),
        g_cfmax = scatter_to_ranks(sbm.g_cfmax, indices, nprocs, comm, rank),
        glacierstore = scatter_to_ranks(sbm.glacierstore, indices, nprocs, comm, rank),
        glacierfrac = scatter_to_ranks(sbm.glacierfrac, indices, nprocs, comm, rank),
        # Interception related to climatology (leaf_area_index)
        sl = scatter_to_ranks(sbm.sl, indices, nprocs, comm, rank),
        swood = scatter_to_ranks(sbm.swood, indices, nprocs, comm, rank),
        kext = scatter_to_ranks(sbm.kext, indices, nprocs, comm, rank),
        leaf_area_index = scatter_to_ranks(sbm.leaf_area_index, indices, nprocs, comm, rank),
        waterlevel_land = scatter_to_ranks(sbm.waterlevel_land, indices, nprocs, comm, rank),
        waterlevel_river = scatter_to_ranks(sbm.waterlevel_river, indices, nprocs, comm, rank), #set to zero to account for cells outside river domain
        )

    return sbm
end


function update_until_snow(sbm::SBM, config)

    do_lai = haskey(config.input.vertical, "leaf_area_index")
    modelglacier = get(config.model, "glacier", false)::Bool
    modelsnow = get(config.model, "snow", false)::Bool

    @threads for i = 1:sbm.n
        if do_lai
            cmax = sbm.sl[i] * sbm.leaf_area_index[i] + sbm.swood[i]
            canopygapfraction = exp(-sbm.kext[i] * sbm.leaf_area_index[i])
            ewet =
                (1.0 - exp(-sbm.kext[i] * sbm.leaf_area_index[i])) *
                sbm.potential_evaporation[i]
            e_r =
                sbm.precipitation[i] > 0.0 ?
                min(0.25, ewet / max(0.0001, sbm.precipitation[i])) : 0.0
        else
            cmax = sbm.cmax[i]
            canopygapfraction = sbm.canopygapfraction[i]
            e_r = sbm.e_r[i]
        end

        potential_evaporation = sbm.potential_evaporation[i] * sbm.et_reftopot[i]
        # should we include tempcor in SBM?
        # potential_evaporation = PotenEvap #??

        if Second(sbm.Δt) >= Hour(23)
            throughfall, interception, stemflow, canopystorage = rainfall_interception_gash(
                cmax,
                e_r,
                canopygapfraction,
                sbm.precipitation[i],
                sbm.canopystorage[i],
                potential_evaporation,
            )
            pottrans_soil = max(0.0, potential_evaporation - interception) # now in mm
        else
            netinterception, throughfall, stemflow, leftover, interception, canopystorage =
                rainfall_interception_modrut(
                    sbm.precipitation[i],
                    potential_evaporation,
                    sbm.canopystorage[i],
                    canopygapfraction,
                    cmax,
                )
            pottrans_soil = max(0.0, leftover)  # now in mm
            interception = netinterception
        end

        if modelsnow
            tsoil = sbm.tsoil[i] + sbm.w_soil[i] * (sbm.temperature[i] - sbm.tsoil[i])
            snow, snowwater, snowmelt, rainfallplusmelt, snowfall = snowpack_hbv(
                sbm.snow[i],
                sbm.snowwater[i],
                throughfall + stemflow,
                sbm.temperature[i],
                sbm.tti[i],
                sbm.tt[i],
                sbm.ttm[i],
                sbm.cfmax[i],
                sbm.whc[i],
            )
        end
        # update the outputs and states
        sbm.e_r[i] = e_r
        sbm.cmax[i] = cmax
        sbm.canopygapfraction[i] = canopygapfraction
        sbm.canopystorage[i] = canopystorage
        sbm.interception[i] = interception
        sbm.stemflow[i] = stemflow
        sbm.throughfall[i] = throughfall
        sbm.pottrans_soil[i] = pottrans_soil
        if modelsnow
            sbm.snow[i] = snow
            sbm.snowwater[i] = snowwater
            sbm.tsoil[i] = tsoil
            sbm.rainfallplusmelt[i] = rainfallplusmelt
        end
    end
end

function update_until_recharge(sbm::SBM, config)

    # start dummy variables (should be generated from model reader and from Config.jl TOML)
    soilinfreduction = get(config.model, "soilinfreduction", false)::Bool
    modelglacier = get(config.model, "glacier", false)::Bool
    modelsnow = get(config.model, "snow", false)::Bool
    transfermethod = get(config.model, "transfermethod", false)::Bool
    ust = get(config.model, "whole_ust_available", false)::Bool # should be removed from optional setting and code?

    @threads for i = 1:sbm.n
        if modelsnow
            rainfallplusmelt = sbm.rainfallplusmelt[i]
            if modelglacier
                # Run Glacier module and add the snowpack on-top of it.
                # Estimate the fraction of snow turned into ice (HBV-light).
                # Estimate glacier melt.

                snow, _, glacierstore, glaciermelt = glacier_hbv(
                    sbm.glacierfrac[i],
                    sbm.glacierstore[i],
                    sbm.snow[i],
                    sbm.temperature[i],
                    sbm.g_tt[i],
                    sbm.g_cfmax[i],
                    sbm.g_sifrac[i],
                    Second(sbm.Δt),
                )
                # Convert to mm per grid cell and add to snowmelt
                glaciermelt = glaciermelt * sbm.glacierfrac[i]
                rainfallplusmelt = rainfallplusmelt + glaciermelt

            end
        else
            rainfallplusmelt = sbm.stemflow[i] + sbm.throughfall[i]
        end

        avail_forinfilt = rainfallplusmelt
        ustoredepth = sum(@view sbm.ustorelayerdepth[i][1:sbm.nlayers[i]])

        runoff_river = min(1.0, sbm.riverfrac[i]) * avail_forinfilt
        runoff_land = min(1.0, sbm.waterfrac[i]) * avail_forinfilt
        avail_forinfilt = max(avail_forinfilt - runoff_river - runoff_land, 0.0)

        rootingdepth = min(sbm.soilthickness[i] * 0.99, sbm.rootingdepth[i])

        ae_openw_r = min(
            sbm.waterlevel_river[i] * sbm.riverfrac[i],
            sbm.riverfrac[i] * sbm.pottrans_soil[i],
        )
        ae_openw_l = min(
            sbm.waterlevel_land[i] * sbm.waterfrac[i],
            sbm.waterfrac[i] * sbm.pottrans_soil[i],
        )

        restevap = sbm.pottrans_soil[i] - ae_openw_r - ae_openw_l

        # evap available for soil evaporation and transpiration
        potsoilevap = restevap * sbm.canopygapfraction[i]
        pottrans = restevap * (1.0 - sbm.canopygapfraction[i])

        # Calculate the initial capacity of the unsaturated store
        ustorecapacity = sbm.soilwatercapacity[i] - sbm.satwaterdepth[i] - ustoredepth

        # Calculate the infiltration flux into the soil column
        infiltsoilpath, infiltsoil, infiltpath, soilinf, pathinf, infiltexcess =
            infiltration(
                avail_forinfilt,
                sbm.pathfrac[i],
                sbm.cf_soil[i],
                sbm.tsoil[i],
                sbm.infiltcapsoil[i],
                sbm.infiltcappath[i],
                ustorecapacity,
                modelsnow,
                soilinfreduction,
            )


        usl, n_usl = set_layerthickness(sbm.zi[i], sbm.sumlayers[i], sbm.act_thickl[i])
        z = cumsum(usl)
        usld = sbm.ustorelayerdepth[i]

        ast = 0.0
        soilevapunsat = 0.0
        if n_usl > 0
            # Using the surface infiltration rate, calculate the flow rate between the
            # different soil layers that contain unsaturated storage assuming gravity
            # based flow only, estimate the gravity based flux rate to the saturated zone
            # (ast) and the updated unsaturated storage for each soil layer.
            if transfermethod && sbm.maxlayers == 1
                ustorelayerdepth = sbm.ustorelayerdepth[i][1] + infiltsoilpath
                kv_z = sbm.kvfrac[i][1] * sbm.kv₀[i] * exp(-sbm.f[i] * sbm.zi[i])
                ustorelayerdepth, ast = unsatzone_flow_sbm(
                    ustorelayerdepth,
                    sbm.soilwatercapacity[i],
                    sbm.satwaterdepth[i],
                    kv_z,
                    usl[1],
                    sbm.θₛ[i],
                    sbm.θᵣ[i],
                )
                usld = setindex(usld, ustorelayerdepth, 1)
            else
                for m = 1:n_usl
                    l_sat = usl[m] * (sbm.θₛ[i] - sbm.θᵣ[i])
                    kv_z = sbm.kvfrac[i][m] * sbm.kv₀[i] * exp(-sbm.f[i] * z[m])
                    ustorelayerdepth =
                        m == 1 ? sbm.ustorelayerdepth[i][m] + infiltsoilpath :
                        sbm.ustorelayerdepth[i][m] + ast
                    ustorelayerdepth, ast =
                        unsatzone_flow_layer(ustorelayerdepth, kv_z, l_sat, sbm.c[i][m])
                    usld = setindex(usld, ustorelayerdepth, m)
                end
            end

            # then evapotranspiration from layers
            # Calculate saturation deficit
            saturationdeficit = sbm.soilwatercapacity[i] - sbm.satwaterdepth[i]

            # First calculate the evaporation of unsaturated storage into the
            # atmosphere from the upper layer.
            if sbm.maxlayers == 1
                soilevapunsat =
                    potsoilevap * min(1.0, saturationdeficit / sbm.soilwatercapacity[i])
            else
                # In case only the most upper soil layer contains unsaturated storage
                if n_usl == 1
                    # Check if groundwater level lies below the surface
                    soilevapunsat =
                        potsoilevap *
                        min(1.0, usld[1] / (sbm.zi[i] * (sbm.θₛ[i] - sbm.θᵣ[i])))
                else
                    # In case first layer contains no saturated storage
                    soilevapunsat =
                        potsoilevap *
                        min(1.0, usld[1] / (usl[1] * ((sbm.θₛ[i] - sbm.θᵣ[i]))))
                end
            end
            # Ensure that the unsaturated evaporation rate does not exceed the
            # available unsaturated moisture
            soilevapunsat = min(soilevapunsat, usld[1])
            # Update the additional atmospheric demand
            potsoilevap = potsoilevap - soilevapunsat
            usld = setindex(usld, usld[1] - soilevapunsat, 1)
        end
        transfer = ast

        if sbm.maxlayers == 1
            soilevapsat = 0.0
        else
            if n_usl == 0 || n_usl == 1
                soilevapsat =
                    potsoilevap *
                    min(1.0, (sbm.act_thickl[i][1] - sbm.zi[i]) / sbm.act_thickl[i][1])
                soilevapsat = min(
                    soilevapsat,
                    (sbm.act_thickl[i][1] - sbm.zi[i]) * (sbm.θₛ[i] - sbm.θᵣ[i]),
                )
            else
                soilevapsat = 0.0
            end
        end
        soilevap = soilevapunsat + soilevapsat
        satwaterdepth = sbm.satwaterdepth[i] - soilevapsat

        # transpiration from saturated store
        wetroots = scurve(sbm.zi[i], rootingdepth, Float(1.0), sbm.rootdistpar[i])
        actevapsat = min(pottrans * wetroots, satwaterdepth)
        satwaterdepth = satwaterdepth - actevapsat
        restpottrans = pottrans - actevapsat

        # actual transpiration from ustore
        actevapustore = 0.0
        for k = 1:n_usl
            ustorelayerdepth, actevapustore, restpottrans = acttransp_unsat_sbm(
                rootingdepth,
                usld[k],
                sbm.sumlayers[i][k],
                restpottrans,
                actevapustore,
                sbm.c[i][k],
                usl[k],
                sbm.θₛ[i],
                sbm.θᵣ[i],
                sbm.hb[i],
                ust,
            )
            usld = setindex(usld, ustorelayerdepth, k)
        end

        # check soil moisture balance per layer
        du = 0.0
        for k = n_usl:-1:1
            du = max(0.0, usld[k] - usl[k] * (sbm.θₛ[i] - sbm.θᵣ[i]))
            usld = setindex(usld, usld[k] - du, k)
            if k > 1
                usld = setindex(usld, usld[k-1] + du, k - 1)
            end
        end

        actinfilt = infiltsoilpath - du
        excesswater = avail_forinfilt - infiltsoilpath - infiltexcess + du

        # Separation between compacted and non compacted areas (correction with the satflow du)
        # This is required for D-Emission/Delwaq
        if infiltsoil + infiltpath > 0.0
            actinfiltsoil = infiltsoil - du * infiltsoil / (infiltpath + infiltsoil)
            actinfiltpath = infiltpath - du * infiltpath / (infiltpath + infiltsoil)
        else
            actinfiltsoil = 0.0
            actinfiltpath = 0.0
        end
        excesswatersoil = max(soilinf - actinfiltsoil, 0.0)
        excesswaterpath = max(pathinf - actinfiltpath, 0.0)

        actcapflux = 0.0
        if n_usl > 0
            ksat = sbm.kvfrac[i][n_usl] * sbm.kv₀[i] * exp(-sbm.f[i] * sbm.zi[i])
            ustorecapacity =
                sbm.soilwatercapacity[i] - satwaterdepth - sum(@view usld[1:sbm.nlayers[i]])
            maxcapflux = max(0.0, min(ksat, actevapustore, ustorecapacity, satwaterdepth))

            if sbm.zi[i] > rootingdepth
                capflux =
                    maxcapflux * pow(
                        1.0 - min(sbm.zi[i], sbm.cap_hmax[i]) / (sbm.cap_hmax[i]),
                        sbm.cap_n[i],
                    )
            else
                capflux = 0.0
            end

            netcapflux = capflux
            for k = n_usl:-1:1
                toadd =
                    min(netcapflux, max(usl[k] * (sbm.θₛ[i] - sbm.θᵣ[i]) - usld[k], 0.0))
                usld = setindex(usld, usld[k] + toadd, k)
                netcapflux = netcapflux - toadd
                actcapflux = actcapflux + toadd
            end
        end
        deepksat = sbm.kv₀[i] * exp(-sbm.f[i] * sbm.soilthickness[i])
        deeptransfer = min(satwaterdepth, deepksat)
        actleakage = max(0.0, min(sbm.maxleakage[i], deeptransfer))

        # recharge (mm) for saturated zone
        recharge = (transfer - actcapflux - actleakage - actevapsat - soilevapsat)
        transpiration = actevapsat + actevapustore
        actevap = soilevap + transpiration + ae_openw_r + ae_openw_l

        # update the outputs and states
        sbm.n_unsatlayers[i] = n_usl
        sbm.net_runoff_river[i] = runoff_river - ae_openw_r
        sbm.avail_forinfilt[i] = avail_forinfilt
        sbm.actinfilt[i] = actinfilt
        sbm.infiltexcess[i] = infiltexcess
        sbm.recharge[i] = recharge
        sbm.transpiration[i] = transpiration
        sbm.soilevap[i] = soilevap
        sbm.soilevapsat[i] = soilevapsat
        sbm.ae_openw_r[i] = ae_openw_r
        sbm.ae_openw_l[i] = ae_openw_l
        sbm.runoff_land[i] = runoff_land
        sbm.runoff_river[i] = runoff_river
        sbm.actevapsat[i] = actevapsat
        sbm.actevap[i] = actevap
        sbm.ae_ustore[i] = actevapustore
        sbm.ustorelayerdepth[i] = usld
        sbm.transfer[i] = transfer
        sbm.actcapflux[i] = actcapflux
        sbm.actleakage[i] = actleakage
        sbm.actinfiltsoil[i] = actinfiltsoil
        sbm.actinfiltpath[i] = actinfiltpath
        sbm.excesswater[i] = excesswater
        sbm.excesswatersoil[i] = excesswatersoil
        sbm.excesswaterpath[i] = excesswaterpath
        sbm.rainfallplusmelt[i] = rainfallplusmelt
        sbm.infiltsoilpath[i] = infiltsoilpath
        sbm.satwaterdepth[i] = satwaterdepth
        if modelsnow
            if modelglacier
                sbm.snow[i] = snow
                sbm.glacierstore[i] = glacierstore
            end
        end
    end
end

function update_after_subsurfaceflow(sbm::SBM, zi, exfiltsatwater)

    @threads for i = 1:sbm.n
        usl, n_usl = set_layerthickness(zi[i], sbm.sumlayers[i], sbm.act_thickl[i])
        # exfiltration from ustore
        usld = sbm.ustorelayerdepth[i]
        exfiltustore = 0.0
        for k = sbm.n_unsatlayers[i]:-1:1
            if k <= n_usl
                exfiltustore = max(0, usld[k] - usl[k] * (sbm.θₛ[i] - sbm.θᵣ[i]))
            else
                exfiltustore = usld[k]
            end
            usld = setindex(usld, usld[k] - exfiltustore, k)
            if k > 1
                usld = setindex(usld, usld[k-1] + exfiltustore, k - 1)
            end
        end

        ustoredepth = sum(@view usld[1:n_usl])

        runoff = max(
            exfiltustore +
            exfiltsatwater[i] +
            sbm.excesswater[i] +
            sbm.runoff_land[i] +
            sbm.infiltexcess[i] - sbm.ae_openw_l[i],
            0.0,
        )

        # volumetric water content per soil layer and root zone
        vwc = sbm.vwc[i]
        vwc_perc = sbm.vwc_perc[i]
        for k = 1:sbm.nlayers[i]
            if k <= n_usl
                vwc = setindex(
                    vwc,
                    (usld[k] + (sbm.act_thickl[i][k] - usl[k]) * (sbm.θₛ[i] - sbm.θᵣ[i])) / sbm.act_thickl[i][k] + sbm.θᵣ[i],
                    k,
                )
            else
                vwc = setindex(vwc, sbm.θₛ[i], k)
            end
            vwc_perc = setindex(vwc_perc, (vwc[k] / sbm.θₛ[i]) * 100.0, k)
        end

        rootstore_unsat = 0
        for k = 1:n_usl
            rootstore_unsat =
                rootstore_unsat +
                min(1.0, (max(0.0, sbm.rootingdepth[i] - sbm.sumlayers[i][k]) / usl[k])) *
                usld[k]
        end

        rootstore_sat = max(0.0, sbm.rootingdepth[i] - zi[i]) * (sbm.θₛ[i] - sbm.θᵣ[i])
        rootstore = rootstore_sat + rootstore_unsat
        vwc_root = rootstore / sbm.rootingdepth[i] + sbm.θᵣ[i]
        vwc_percroot = (vwc_root / sbm.θₛ[i]) * 100.0

        satwaterdepth = (sbm.soilthickness[i] - zi[i]) * (sbm.θₛ[i] - sbm.θᵣ[i])

        # update the outputs and states
        sbm.n_unsatlayers[i] = n_usl
        sbm.ustorelayerdepth[i] = usld
        sbm.ustoredepth[i] = ustoredepth
        sbm.satwaterdepth[i] = satwaterdepth
        sbm.exfiltsatwater[i] = exfiltsatwater[i]
        sbm.exfiltustore[i] = exfiltustore
        sbm.runoff[i] = runoff
        sbm.vwc[i] = vwc
        sbm.vwc_perc[i] = vwc_perc
        sbm.rootstore[i] = rootstore
        sbm.vwc_root[i] = vwc_root
        sbm.vwc_percroot[i] = vwc_percroot
        sbm.zi[i] = zi[i]
    end
end
