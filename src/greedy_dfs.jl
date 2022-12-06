"""
    greedy_dfs_solution(city::JBCity)
Given a problem instance (as a `JBCity`), returns a `JBSolution` object containing the itineraries of
the cars. Works by running a depth-first search, keeping track of visited streets for all cars. If a car
finishes a branch of the DFS, it takes the shortest path back to the next node with unvisited children
in its DFS tree.
"""
function greedy_dfs_solution(city)

    # Stores values for the function
    visited_streets = Set{JBStreet}()
    neighbor_streets = get_adjacent_streets(city)
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
        current_to = JuliaBoyz.get_street_end(current_street, current_from)

        # Checks if this street has already been visited
        if in(current_street, visited_streets)
            continue
        end

        # Checks if backtracking/using new car
        if last_junction != current_from
            short_path = shortest_path(last_junction, current_from, neighbor_streets)
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

    return JBSolution(city, itinerary, visited_streets)
end