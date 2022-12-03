module JuliaBoyz
using HashCode2014
using SparseArrays
using StreetGraph
using GraphUpperBound

"""
Generates an adjacency matrix for the junctions of the currently loaded city to represent the graph.
"""
function generate_adjacency_matrix(city)

    # Stores the duration/distance sparse matrix vectors
    starts = cat([street.endpointA for street in city.streets], [street.endpointB for street in city.streets if street.bidirectional]; dims=1)
    ends = cat([street.endpointB for street in city.streets], [street.endpointA for street in city.streets if street.bidirectional]; dims=1)
    duration_vals = cat([street.duration for street in city.streets], [street.duration for street in city.streets if street.bidirectional]; dims=1)
    distance_vals = cat([street.distance for street in city.streets], [street.distance for street in city.streets if street.bidirectional]; dims=1)

    # Stores the sparse matrix data
    durations = sparse(starts, ends, duration_vals)
    distances = sparse(starts, ends, distance_vals)

    return (durations, distances)
end


"""
Generates an adjacency list for the junctions of the currently loaded city to represent the graph.
"""
function generate_adjacency_list(city)

    # Stores templates for lists
    neighbors = Dict(vert => Vector{Int64}() for vert in 1:length(city.junctions))

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
Perhaps best of both worlds? Stores the street, and therefore, both the adjacent junctions 
and the properties of the street.
"""
function get_adjacent_streets(city)

    # Stores templates for lists
    neighbors = Dict{Int64, Vector{Street}}()

    # Runs through each street and stores adjacency
    for street in city.streets
        push!(get!(neighbors, street.endpointA, Vector{Street}()), street)
        if street.bidirectional
            push!(get!(neighbors, street.endpointB, Vector{Street}()), street)
        end
    end

    # Sorts streets from highest to lowest distance/duration ratio (for greedy algorithm purposes)
    for junct in 1:length(city.junctions)
        sort!(get(neighbors, junct, nothing); by = street -> street.duration/street.distance) # Reciprocate to get sorting from high to low
    end

    return neighbors
end


"""
Uses a greedy algorithm to generate itineraries for the cars in the currently loaded city.
    
For each car, we look at the adjacency lists of the current node and choose the one with the highest
distance to duration ratio, which is done by choosing the first street in the adjacency list of the 
current node. After traversing a street, add it to a list of already traversed streets.
 If a street has already been traversed, we skip it, and go to the next one in the adjacency list.
If all adjacent streets from a node are already traveresd, choose a random one.
"""
function generate_greedy_random_solution(city)

    # Stores values for the function
    start_point = city.starting_junction
    itinerary = [[start_point] for car in 1:city.nb_cars]
    neighbor_streets = get_adjacent_streets(city)
    visited_streets = Set{Street}()

    # Runs each car
    for car in 1:city.nb_cars

        # Stores starting conditions for car traversal
        current_node = start_point
        time = 0

        # Traverses the graph while there is time remaining
        while time < city.total_duration

            target_street = nothing

            # Tries each street in greedy order
            neighbors = get(neighbor_streets, current_node, nothing)
            # println(current_node)
            # println(neighbors)
            # println()
            for street in neighbors

                # Skips street if already visited
                if in(street, visited_streets)
                    continue
                end

                # Stores this street as the street to traverse and moves on
                target_street = street
                break
            end

            # Chooses a random street if no street is unvisited
            if target_street === nothing
                target_street = rand(neighbors)
            end

            # Computes the effect of taking this street
            current_node = HashCode2014.get_street_end(current_node, target_street)
            push!(itinerary[car], current_node)
            push!(visited_streets, target_street)
            time += target_street.duration
        end
        pop!(itinerary[car]) # Ensures that the street that made the time go over is removed
    end
    return itinerary
end


"""
Naively generates an upper bound on the possible distance by sorting all available streets by 
duration to distance ratio, and adding until all time is used up (across all cars), or all 
streets are traversed.
"""
function generate_upper_bound(city)
    streets = sort(city.streets; by=street -> street.duration/street.distance)
    time = 0
    dist = 0
    for street in streets
        if time < city.nb_cars * city.total_duration
            time += street.duration
            dist += street.distance
        else
            break
        end
    end
    return dist
end

function greedy_dfs_solution()

    # Stores values for the function
    visited_streets = Set{Street}()
    queue = [(city.starting_junction, street) for street in neighbor_streets[city.starting_junction]] # (From, Street)
    itinerary = [[city.starting_junction] for _ in 1:city.nb_cars]
    current_car = 1
    current_duration = 0
    last_junction = city.starting_junction

    # Runs the search iteratively
    while length(queue) > 0 && current_car <= city.nb_cars

        # Stores the current traversal's properties
        current = popfirst!(queue)
        current_from = current[1]
        current_street = current[2]
        current_to = HashCode2014.get_street_end(current_from, current_street)

        # Checks if this street has already been visited
        if in(current_street, visited_streets)
            continue
        end

        # Checks if backtracking/using new car
        if last_junction != current_from
            short_path = shortest_path(last_junction, current_from)
            current_duration += short_path[2]

            # Checks if movement does not make car go over its duration
            if current_duration <= city.total_duration
                itinerary[current_car] = cat(itinerary[current_car], short_path[1][2:length(short_path[1])]; dims=1)
            end
        end

        # Checks whether this traversal sends the car over its limit
        if current_duration + current_street.duration > city.total_duration
            pushfirst!(queue, current)
            current_car += 1
            current_duration = 0
            last_junction = city.starting_junction
            continue
        end

        # Registers this street as traversed
        push!(visited_streets, current_street)
        push!(itinerary[current_car], current_to)
        current_duration += current_street.duration
        last_junction = current_to

        # Queues every valid street adjacent to the junction currently being traversed to
        valid_neighbors = [(current_to, neighbor_street) for neighbor_street in neighbor_streets[current_to] if !in(neighbor_street, visited_streets)]
        sort!(valid_neighbors; by = x -> 1/x[2].distance)
        queue = cat(valid_neighbors, queue; dims=1)
    end

    return itinerary
end




end
