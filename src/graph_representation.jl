"""
    generate_adjacency_list(city::JBCity)
Generates an adjacency list for the junctions of the currently loaded city to represent the graph.
Returns a `Dict` mapping each junction index to a `Set{Int64}` containing all adjacent junctions' indices.
"""
function generate_adjacency_list(city)

    # Stores templates for lists
    neighbors = Dict(vert => Set{Int64}() for vert in 1:(city.num_junctions))

    # Runs through each street and stores adjacency
    for street in city.streets
        push!(get(neighbors, street.endpointA, nothing), street.endpointB)
        if street.bidirectional
            push!(get(neighbors, street.endpointB, nothing), street.endpointA)
        end
    end

    return neighbors
end

"""
    get_adjacent_streets(city::JBCity)
Generates an adjacency list for the streets adjacent to all junctions of the currently loaded city to 
represent the graph. Returns a `Dict` mapping each junction index to a `Vector{Street}` containing
all its adjacent streets, with each vector sorted by distance, high to low. 
"""
function get_adjacent_streets(city)

    # Stores templates for lists
    neighbors = Dict{Int64,Vector{JBStreet}}()

    # Runs through each street and stores adjacency
    for street in city.streets
        push!(get!(neighbors, street.endpointA, Vector{JBStreet}()), street)
        if street.bidirectional
            push!(get!(neighbors, street.endpointB, Vector{JBStreet}()), street)
        end
    end

    # Sorts streets by 1/distance
    for junct in 1:(city.num_junctions)
        sort!(get(neighbors, junct, nothing); by=street -> 1 / street.distance)
    end

    return neighbors
end

"""
    shortest_path(from::Int64, to::Int64, neighbor_streets::Dict{Int64, Set{Int64}})
Computes the shortest path between two given junctions, specified by their indices, using Djikstra's
algorithm. Returns a `Tuple` containing the sequence of junctions (represented by their indices,
including the start/finish junctions) that give the shortest path and the duration of the path.
"""
function shortest_path(from, to, neighbor_streets)

    # Stores values for the function
    visited = Set{Int64}()
    queue = BinaryHeap(Base.By(last), [([from], 0)])

    # Iteratively runs search
    while length(queue) > 0

        # Finds and stores properties of the current junction being traversed
        current = pop!(queue)
        current_path = current[1]
        current_junction = current_path[length(current_path)]
        current_duration = current[2]

        # Checks if already visited
        if in(current_junction, visited)
            continue
        end

        # Checks if the current junction is the target junction
        if current_junction == to
            return (current_path, current_duration)
        end

        # Handles registering the junction as visited
        push!(visited, current_junction)

        # Adds neighbors to be checked
        for neighbor_street in get(neighbor_streets, current_junction, nothing)

            # Adds the neighbor if unvisited
            neighbor = JuliaBoyz.get_street_end(neighbor_street, current_junction)
            if !in(neighbor, visited)
                push!(
                    queue,
                    (
                        cat(current_path, [neighbor]; dims=1),
                        current_duration + neighbor_street.duration,
                    ),
                )
            end
        end
    end
end

"""
    get_street_end(street::JBStreet, start::Int64)
Given a `JBStreet`(@ref) and a junction index, returns the index of the junction at the other end
of the street.
"""
function get_street_end(street, start)
    if street.endpointA == start
        return street.endpointB
    end
    return street.endpointA
end
