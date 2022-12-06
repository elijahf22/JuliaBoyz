"""
Generates an adjacency matrix for the junctions of the currently loaded city to represent the graph.
Returns a `Tuple` of two sparse matrices containing all the durations and distances, respectively, of streets between a starting junction (rows) and an ending junction (columns).
"""
function generate_adjacency_matrix(city)

    # Stores the starting junction indices to be rows of the adjacency matrices
    street_starts1 = [street.endpointA for street in city.streets]
    street_starts2 = [street.endpointB for street in city.streets if street.bidirectional] # Stores opposite order if bidirectional
    street_starts = cat(street_starts1, street_starts2; dims=1)

    # Stores the ending junction indices to be columns of the adjacency matrices
    street_ends1 = [street.endpointB for street in city.streets]
    street_ends2 = [street.endpointA for street in city.streets if street.bidirectional] # Stores opposite order if bidirectional
    street_ends = cat(street_ends1, street_ends2; dims=1)

    # Stores the street duration values to be entries of the duration adjacency matrix
    street_durations1 = [street.duration for street in city.streets]
    street_durations2 = [street.duration for street in city.streets if street.bidirectional] # Stores opposite order if bidirectional
    street_durations = cat(street_durations1, street_durations2; dims=1)

    # Stores the street distance values to be entries of the distance adjacency matrix
    street_distances1 = [street.distance for street in city.streets]
    street_distances2 = [street.distance for street in city.streets if street.bidirectional] # Stores opposite order if bidirectional
    street_distances = cat(street_distances1, street_distances2; dims=1)

    # Stores the sparse matrix data
    durations = sparse(street_starts, street_ends, street_durations)
    distances = sparse(street_starts, street_ends, street_distances)

    return (durations, distances)
end

"""
Generates an adjacency list for the junctions of the currently loaded city to represent the graph.
Returns a `Dict` mapping each junction index to a `Set{Int64}` containing all adjacent junctions' indices.
"""
function generate_adjacency_list(city)

    # Stores templates for lists
    neighbors = Dict(vert => Set{Int64}() for vert in 1:length(city.junctions))

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
Generates an adjacency list for the streets adjacent to all junctions of the currently loaded city to represent the graph.
Returns a `Dict` mapping each junction index to a `Vector{Street}` containing all its adjacent streets.
"""
function get_adjacent_streets(city)

    # Stores templates for lists
    neighbors = Dict{Int64, Vector{JBStreet}}()

    # Runs through each street and stores adjacency
    for street in city.streets
        push!(get!(neighbors, street.endpointA, Vector{Street}()), street)
        if street.bidirectional
            push!(get!(neighbors, street.endpointB, Vector{Street}()), street)
        end
    end

    # Sorts streets by 1/distance
    for junct in 1:length(city.junctions)
        sort!(get(neighbors, junct, nothing); by = street -> 1/street.distance)
    end

    return neighbors
end

"""
Computes the shortest path between two given junctions using Djikstra's algorithm.
Returns a `Tuple` containing the sequence of junctions (represented by their indices, including the start/finish junctions) that give the shortest path and the duration of the path.
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
                push!(queue, (cat(current_path, [neighbor]; dims=1), current_duration+neighbor_street.duration))
            end
        end
    end

    return nothing
end

function get_street_end(street, start)
    if street.endpointA == start
        return street.endpointB
    end
    return street.endpointA
end