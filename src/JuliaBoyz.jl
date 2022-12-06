module JuliaBoyz

using DataStructures
include("check_sol.jl")
include("graph_representation.jl")
include("greedy_dfs.jl")
include("upper_bound.jl")
include("create_problem.jl")

struct JBStreet
    endpointA::Int64
    endpointB::Int64
    bidirectional::Bool
    duration::Int64
    distance::Int64
end

struct JBCity
    total_duration::Int64
    nb_cars::Int64
    starting_junction::Int64
    num_junctions::Int64
    streets::Vector{JBStreet}
end

struct JBSolution
    city::JBCity
    itineraries::Vector{Vector{Int64}}
    visited_streets::Set{JBStreet}
end

end
