mutable struct DynamicLine{T <: PSY.ACBranch} <: PSY.Device
    branch_data::T
    n_states::Int64
    states::Any

    function DynamicLine(branch::T) where {T <: PSY.ACBranch}
        n_states = 2
        states = [
            :Il_R
            :Il_I
        ]
        new{T}(branch, n_states, states)
    end

end

"""Get Line name."""
IS.get_name(value::DynamicLine) = value.branch_data.name
"""Get Line available."""
PSY.get_available(value::DynamicLine) = value.branch_data.available
"""Get Line activepower_flow."""
PSY.get_active_power_flow(value::DynamicLine) = value.branch_data.activepower_flow
"""Get Line reactivepower_flow."""
PSY.get_reactive_power_flow(value::DynamicLine) = value.branch_data.reactivepower_flow
"""Get Line arc."""
PSY.get_arc(value::DynamicLine) = value.branch_data.arc
"""Get Line r."""
PSY.get_r(value::DynamicLine) = value.branch_data.r
"""Get Line x."""
PSY.get_x(value::DynamicLine) = value.branch_data.x
"""Get Line b."""
PSY.get_b(value::DynamicLine) = value.branch_data.b
"""Get Line rate."""
PSY.get_rate(value::DynamicLine) = value.branch_data.rate
"""Get Line anglelimits."""
PSY.get_angle_limits(value::DynamicLine) = value.branch_data.anglelimits
"""Get Line services."""
PSY.get_services(value::DynamicLine) = value.branch_data.services
"""Get Line ext."""
PSY.get_ext(value::DynamicLine) = value.branch_data.ext
"""Get Line _forecasts."""
IS.get_forecasts(value::DynamicLine) = value.branch_data.forecasts
"""Get Line internal."""
PSY.get_internal(value::DynamicLine) = value.branch_data.internal
PSY.get_states(value::DynamicLine) = value.states
PSY.get_n_states(value::DynamicLine) = value.n_states

function make_dynamic_branch!(branch::T, sys::PSY.System) where {T <: PSY.ACBranch}
    PSY.remove_component!(sys, branch)
    PSY.add_component!(sys, DynamicLine(branch))
    return
end

function branch!(
    x,
    dx,
    output_ode::Vector{T},
    V_r_from,
    V_i_from,
    V_r_to,
    V_i_to,
    current_r_from,
    current_i_from,
    current_r_to,
    current_i_to,
    ix_range::UnitRange{Int64},
    ode_range::UnitRange{Int64},
    branch::DynamicLine{PSY.Line},
    sys::PSY.System,
) where {T <: Real}

    #Obtain local device states
    n_states = PSY.get_n_states(branch)
    device_states = @view x[ix_range]

    #Obtain references
    Sbase = PSY.get_base_power(sys)
    sys_f = PSY.get_frequency(sys)

    mdl_line_ode!(
        device_states,
        view(output_ode, ode_range),
        V_r_from,
        V_i_from,
        V_r_to,
        V_i_to,
        current_r_from,
        current_i_from,
        current_r_to,
        current_i_to,
        sys_f,
        branch,
    )

    return
end
