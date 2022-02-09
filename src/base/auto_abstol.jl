# Taken from https://diffeq.sciml.ai/stable/features/callback_functions/#Example-3:-AutoAbstol
mutable struct AutoAbstolAffect{T}
    curmax::T
end

function (p::AutoAbstolAffect)(integrator)
    p.curmax = max(p.curmax, integrator.u)
    integrator.opts.abstol = p.curmax * integrator.opts.reltol
    u_modified!(integrator, false)
end

function AutoAbstol(save = true; init_curmax = 1e-6)
    affect! = AutoAbstolAffect(init_curmax)
    condtion = (u, t, integrator) -> true
    save_positions = (save, false)
    DiscreteCallback(condtion, affect!, save_positions = save_positions)
end
