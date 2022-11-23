module JuliaBoyz
using HashCode2014
using SparseArrays


# Stores the city data
city = HashCode2014.read_city()

"""
Generates an adjacency matrix for the junctions of the currently loaded city to represent the graph.
"""
function generate_adjacency_matrix()

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
function generate_adjacency_list()

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
function get_adjacent_streets()

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
function generate_greedy_random_solution()

    # Stores values for the function
    start_point = city.starting_junction
    itinerary = [[start_point] for car in 1:city.nb_cars]
    neighbor_streets = get_adjacent_streets()
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
duration to distance ratio, and adding until all time is used up, or all streets are traversed.
"""
function generate_upper_bound()
    streets = sort(city.streets; by=street -> street.duration/street.distance)
    time = 0
    dist = 0
    for street in streets
        if time < 8 * city.total_duration
            time += street.duration
            dist += street.distance
        else
            break
        end
    end
    return dist
end

# POSSIBLE IMPROVEMENTS:
# Run the cars in parallel rather than serially

# println(city.starting_junction)
# generate_greedy_random_solution()
# println(generate_greedy_random_solution())

# println(city.total_duration)
# before = time_ns()
# solu = Solution(generate_greedy_random_solution())
# after = time_ns()
# print("Computation time: ")
# println((after-before)*(10^(-9)))
# println(HashCode2014.total_distance(solu, city))
# println(HashCode2014.is_feasible(solu, city; verbose=true))
# HashCode2014.write_solution(solu, "sol.txt")
# HashCode2014.plot_streets(city, solu; path="testsol.html")
# println(generate_upper_bound())


end