"""
Package made by Elijah Fernandez, Raul Hernandez, and Insuh Na as
a solution for the Optimization Challenge in C25 (Fall 2022).
"""
module JuliaBoyz

using DataStructures
include("solutions.jl")
include("graph_representation.jl")
include("greedy_dfs.jl")
include("upper_bound.jl")
include("create_problem.jl")

"""
    JBStreet
Stores information about a street in a problem.

# Fields
- `endpointA::Int64`: index of the first junction of the street
- `endpointB::Int64`: index of the second junction of the street
- `bidirectional::Bool`: indicates whether the street is one-way or two-way
- `duration::Int64`: time to traverse the street in seconds
- `distance::Int64`: length of the street in meters
"""
struct JBStreet
    endpointA::Int64
    endpointB::Int64
    bidirectional::Bool
    duration::Int64
    distance::Int64
end

"""
    JBCity
Stores a problem, consisting of the streets (`JBStreet`(@ref)) that make up the city, additional
information about the constraints for solving.

# Fields
- `total_duration::Int64`: total time allotted for the cars' itineraries in seconds
- `nb_cars::Int64`: number of cars in the fleet
- `starting_junction::Int64`: index of the junction where all cars must start
- `num_junctions::Int64`: number of junctions in the city
- `streets::Vector{JBStreet}`: contains all streets in a city
"""
struct JBCity
    total_duration::Int64
    nb_cars::Int64
    starting_junction::Int64
    num_junctions::Int64
    streets::Vector{JBStreet}
end

"""
    JBSolution
Stores the solution corresponding to a `JBCity`(@ref). Consists of the problem as a `JBCity`(@ref), 
the itineraries of the cars, and the set of all streets visited in the solution.

# Fields
- `city::JBCity`: instance of the problem which the solution corresponds to
- `itineraries::Vector{Vector{Int64}}`: contains the itineraries of each of the cars in the fleet, represented as a vector of a vector of junction indices
- `visited_streets::Set{JBStreet}`: set of all streets visited across all itineraries
"""
struct JBSolution
    city::JBCity
    itineraries::Vector{Vector{Int64}}
    visited_streets::Set{JBStreet}
end

end
