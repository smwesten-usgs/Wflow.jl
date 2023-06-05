# Basic Model Interface (BMI) implementation based on
# https://github.com/Deltares/BasicModelInterface.jl


# For the different Wflow model types the BMI is quite loosely implemented. For example all
# struct fields can be exchanged and there is no distinction between input and output
# variables. The BMI grid identifier has been added to the Wflow structs (metadata). 
# TODO: Check if it is worthwile to extend this (for example input or output variable etc.).

# BMI grid type based on grid identifier
const gridtype = Dict{Int,String}(
    0 => "unstructured",
    1 => "unstructured",
    2 => "unstructured",
    3 => "unstructured",
    4 => "unstructured",
    5 => "scalar",
    6 => "none",
)

# Mapping of component to grid identifier function
const grid_id_func = Dict{String,Function}(
    "land" => bmi_land_grid,
    "vertical" => bmi_land_grid,
    "aquifer" => bmi_land_grid,
    "recharge" => bmi_land_grid,
    "river" => bmi_river_grid,
    "lake" => bmi_lake_grid,
    "reservoir" => bmi_res_grid,
    "drain" => bmi_drain_grid,
)

# Mapping of grid identifier to a key, to get the active indices of the model domain for
# unstuctured grid types. See also function active_indices(network, key::Tuple).
const grids =
    Dict{Int,String}(0 => "reservoir", 1 => "lake", 2 => "river", 3 => "drain", 4 => "land")

"""
    BMI.initialize(::Type{<:Wflow.Model}, config_file)

Initialize the model. Reads the input settings and data as defined in the Config object
generated from the configuration file `config_file`. Will return a Model that is ready to
run.
"""
function BMI.initialize(::Type{<:Model}, config_file)
    config = Config(config_file)
    modeltype = config.model.type
    model = if modeltype == "sbm"
        initialize_sbm_model(config)
    elseif modeltype == "sbm_gwf"
        initialize_sbm_gwf_model(config)
    elseif modeltype == "hbv"
        initialize_hbv_model(config)
    elseif modeltype == "sediment"
        initialize_sediment_model(config)
    elseif modeltype == "flextopo"
        initialize_flextopo_model(config)
    else
        error("unknown model type")
    end
    load_fixed_forcing(model)
    return model
end

"""
    BMI.update(model::Model; run = nothing)

Update the model for a single timestep.
# Arguments
- `run = nothing`: to update a model partially.
"""
function BMI.update(model::Model; run = nothing)
    @unpack clock, network, config = model
    if isnothing(run)
        model = run_timestep(model)
    elseif run == "sbm_until_recharge"
        model = run_timestep(
            model,
            update_func = update_until_recharge,
            write_model_output = false,
        )
    elseif run == "sbm_after_subsurfaceflow"
        model = run_timestep(model, update_func = update_after_subsurfaceflow)
    end
    return model
end

function BMI.update_until(model::Model, time::Float64)
    @unpack clock, network, config = model
    curtime = BMI.get_current_time(model)
    n = Int(max(0, (time - curtime) / model.clock.Δt.value))
    for _ = 1:n
        model = run_timestep(model)
    end
    return model
end

"Write state output to netCDF and close files."
function BMI.finalize(model::Model)
    @unpack config, writer, clock = model
    write_netcdf_timestep(model, writer.state_dataset, writer.state_parameters)
    reset_clock!(model.clock, config)
    close_files(model, delete_output = false)
end

function BMI.get_component_name(model::Model)
    @unpack config = model
    return config.model.type
end

function BMI.get_input_item_count(model::Model)
    length(BMI.get_input_var_names(model))
end

function BMI.get_output_item_count(model::Model)
    length(BMI.get_output_var_names(model))
end

"""
    BMI.get_input_var_names(model::Model)

Returns model input variables, based on the `API` section in the model configuration file.
This `API` sections contains a list of `Model` components for which variables can be
exchanged.
"""
function BMI.get_input_var_names(model::Model)
    @unpack config = model
    if haskey(config, "API")
        var_names = Vector{String}()
        for c in config.API.components
            append!(
                var_names,
                collect(string.(c, ".", fieldnames(typeof(param(model, c))))),
            )
        end
        # delete entries where field is nothing (e.g. for model without lakes or reservoirs)
        deleteat!(var_names, findall(x -> isnothing(Wflow.param(model, x)), var_names))
        return var_names
    else
        @warn("TOML file does not contain section [API] to extract model var names")
        return []
    end
end

"Returns input variables from `BMI.get_input_var_names(model::Model)`, there is no
distinction between input - and output variables."
function BMI.get_output_var_names(model::Model)
    BMI.get_input_var_names(model)
end

function BMI.get_var_grid(model::Model, name::String)
    if name in BMI.get_input_var_names(model)
        s = split(name, ".")
        component = s[end-1]
        grid_id_func[component](param(model, join(s[1:end-1], ".")), Symbol(s[end]))
    else
        error("Model variable $name not listed as input or output variable")
    end
end

function BMI.get_var_type(model::Model, name::String)
    string(typeof(param(model, name)))
end

function BMI.get_var_units(model::Model, name::String)
    s = split(name, ".")
    get_units(param(model, join(s[1:end-1], ".")), Symbol(s[end]))
end

function BMI.get_var_itemsize(model::Model, name::String)
    sizeof(param(model, name)[1])
end

function BMI.get_var_nbytes(model::Model, name::String)
    sizeof(param(model, name))
end

function BMI.get_var_location(model::Model, name::String)
    if name in BMI.get_input_var_names(model)
        return "node"
    else
        error("$name not in get_input_var_names")
    end
end

function BMI.get_current_time(model::Model)
    0.001 * Dates.value(model.clock.time - model.config.starttime)
end

function BMI.get_start_time(model::Model)
    0.0
end

function BMI.get_end_time(model::Model)
    0.001 * Dates.value(model.config.endtime - model.config.starttime)
end

function BMI.get_time_units(model::Model)
    "s"
end

function BMI.get_time_step(model::Model)
    Float64(model.config.timestepsecs)
end

function BMI.get_value(model::Model, name::String)
    copy(BMI.get_value_ptr(model, name))
end

function BMI.get_value_ptr(model::Model, name::String)
    if name in BMI.get_input_var_names(model)
        return param(model, name)
    else
        error("$name not defined as an output BMI variable")
    end
end

"""
    BMI.get_value_at_indices(model::Model, name::String, inds::Vector{Int})

Returns values of a model variable `name` at indices `inds`.
"""
function BMI.get_value_at_indices(model::Model, name::String, inds::Vector{Int})
    BMI.get_value_ptr(model, name)[inds]
end

"""
    BMI.set_value(model::Model, name::String, src::Vector{T}) where T<:AbstractFloat

Set a model variable `name` to the values in vector `src`, overwriting the current contents.
The type and size of `src` must match the model’s internal array.
"""
function BMI.set_value(model::Model, name::String, src::Vector{T}) where {T<:AbstractFloat}
    BMI.get_value_ptr(model, name) .= src
end

"""
    BMI.set_value_at_indices(model::Model, name::String, inds::Vector{Int}, src::Vector{T})
    where T<:AbstractFloat

    Set a model variable `name` to the values in vector `src`, at indices `inds`.
"""
function BMI.set_value_at_indices(
    model::Model,
    name::String,
    inds::Vector{Int},
    src::Vector{T},
) where {T<:AbstractFloat}
    BMI.get_value_ptr(model, name)[inds] .= src
end

function BMI.get_grid_type(model::Model, grid::Int)
    gridtype[grid]
end

function BMI.get_grid_rank(model::Model, grid::Int)
    if grid in keys(gridtype)
        if gridtype[grid] == "unstructured"
            2
        elseif gridtype[grid] == "scalar"
            0
        else
            error("rank is not defined for grid type $grid ($gridtype[grid])")
        end
    else
        error("unknown grid type $grid")
    end
end

function BMI.get_grid_shape(model::Model, grid::Int)
    if grid in keys(gridtype)
        if gridtype[grid] == "unstructured"
            size(active_indices(model.network, symbols(grids[grid])), 1)
        elseif gridtype[grid] == "scalar"
            0
        else
            error("shape is not defined for grid type $grid ($gridtype[grid])")
        end
    else
        error("unknown grid type $grid")
    end
end

function BMI.get_grid_size(model::Model, grid::Int)
    BMI.get_grid_shape(model, grid)
end

function BMI.get_grid_x(model::Model, grid::Int)
    @unpack reader, config = model
    @unpack dataset = reader
    if grid in keys(gridtype)
        if gridtype[grid] == "unstructured"
            sel = active_indices(model.network, symbols(grids[grid]))
            inds = [sel[i][1] for i in eachindex(sel)]
            x_nc = read_x_axis(dataset)
            return x_nc[inds]
        else
            error("grid_x is not defined for grid type $grid ($gridtype[grid])")
        end
    else
        error("unknown grid type $grid")
    end
end

function BMI.get_grid_y(model::Model, grid::Int)
    @unpack reader, config = model
    @unpack dataset = reader
    if grid in keys(gridtype)
        if gridtype[grid] == "unstructured"
            sel = active_indices(model.network, symbols(grids[grid]))
            inds = [sel[i][2] for i in eachindex(sel)]
            y_nc = read_y_axis(dataset)
            return y_nc[inds]
        else
            error("grid_y is not defined for grid type $grid ($gridtype[grid])")
        end
    else
        error("unknown grid type $grid")
    end
end

function BMI.get_grid_node_count(model::Model, grid::Int)
    BMI.get_grid_size(model, grid)
end

# extension of BMI functions (load_state and save_state), required for OpenDA coupling. May
# also be useful for other external software packages.
function load_state(model::Model)
    model = set_states(model)
    return model
end

function save_state(model::Model)
    @unpack config, writer, clock = model

    rewind!(clock)
    if haskey(config, "state") && haskey(config.state, "path_output")
        @info "Write output states to NetCDF file `$(model.writer.state_nc_path)`."
    end
    write_netcdf_timestep(model, writer.state_dataset, writer.state_parameters)
end
