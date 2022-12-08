var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = JuliaBoyz","category":"page"},{"location":"#JuliaBoyz","page":"Home","title":"JuliaBoyz","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for JuliaBoyz.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [JuliaBoyz]","category":"page"},{"location":"#JuliaBoyz.JuliaBoyz","page":"Home","title":"JuliaBoyz.JuliaBoyz","text":"Package made by Elijah Fernandez, Raul Hernandez, and Insuh Na as a solution for the Optimization Challenge in C25 (Fall 2022).\n\n\n\n\n\n","category":"module"},{"location":"#JuliaBoyz.JBCity","page":"Home","title":"JuliaBoyz.JBCity","text":"JBCity\n\nStores a problem, consisting of the streets (JBStreet(@ref)) that make up the city, additional information about the constraints for solving.\n\nFields\n\ntotal_duration::Int64: total time allotted for the cars' itineraries in seconds\nnb_cars::Int64: number of cars in the fleet\nstarting_junction::Int64: index of the junction where all cars must start\nnum_junctions::Int64: number of junctions in the city\nstreets::Vector{JBStreet}: contains all streets in a city\n\n\n\n\n\n","category":"type"},{"location":"#JuliaBoyz.JBSolution","page":"Home","title":"JuliaBoyz.JBSolution","text":"JBSolution\n\nStores the solution corresponding to a JBCity(@ref). Consists of the problem as a JBCity(@ref),  the itineraries of the cars, and the set of all streets visited in the solution.\n\nFields\n\ncity::JBCity: instance of the problem which the solution corresponds to\nitineraries::Vector{Vector{Int64}}: contains the itineraries of each of the cars in the fleet, represented as a vector of a vector of junction indices\nvisited_streets::Set{JBStreet}: set of all streets visited across all itineraries\n\n\n\n\n\n","category":"type"},{"location":"#JuliaBoyz.JBStreet","page":"Home","title":"JuliaBoyz.JBStreet","text":"JBStreet\n\nStores information about a street in a problem.\n\nFields\n\nendpointA::Int64: index of the first junction of the street\nendpointB::Int64: index of the second junction of the street\nbidirectional::Bool: indicates whether the street is one-way or two-way\nduration::Int64: time to traverse the street in seconds\ndistance::Int64: length of the street in meters\n\n\n\n\n\n","category":"type"},{"location":"#JuliaBoyz.check_solution-Tuple{Any}","page":"Home","title":"JuliaBoyz.check_solution","text":"check_solution(sol::JBSolution)\n\nGiven a city and a potential solution, checks the validity of the solution.\n\nWorks by beginning at the first junction in an itinerary and check if the next junction  is in the adjacency list of the current node, returning false if it is not, and continuing on otherwise. Repeat until the end of the itinerary, and do this for all itineraries in the potential solution.\n\n\n\n\n\n","category":"method"},{"location":"#JuliaBoyz.generate_adjacency_list-Tuple{Any}","page":"Home","title":"JuliaBoyz.generate_adjacency_list","text":"generate_adjacency_list(city::JBCity)\n\nGenerates an adjacency list for the junctions of the currently loaded city to represent the graph. Returns a Dict mapping each junction index to a Set{Int64} containing all adjacent junctions' indices.\n\n\n\n\n\n","category":"method"},{"location":"#JuliaBoyz.generate_upper_bound-Tuple{Any}","page":"Home","title":"JuliaBoyz.generate_upper_bound","text":"generate_upper_bound(city::JBCity)\n\nNaively generates an upper bound on the possible distance by sorting all available streets by  duration to distance ratio, and adding until all time is used up (across all cars), or all  streets are traversed.\n\n\n\n\n\n","category":"method"},{"location":"#JuliaBoyz.get_adjacent_streets-Tuple{Any}","page":"Home","title":"JuliaBoyz.get_adjacent_streets","text":"get_adjacent_streets(city::JBCity)\n\nGenerates an adjacency list for the streets adjacent to all junctions of the currently loaded city to represent the graph. Returns a Dict mapping each junction index to a Vector{Street} containing all its adjacent streets.\n\n\n\n\n\n","category":"method"},{"location":"#JuliaBoyz.greedy_dfs_solution-Tuple{Any}","page":"Home","title":"JuliaBoyz.greedy_dfs_solution","text":"greedy_dfs_solution(city::JBCity)\n\nGiven a problem instance (as a JBCity), returns a JBSolution object containing the itineraries of the cars. Works by running a depth-first search, keeping track of visited streets for all cars. If a car finishes a branch of the DFS, it takes the shortest path back to the next node with unvisited children in its DFS tree.\n\n\n\n\n\n","category":"method"},{"location":"#JuliaBoyz.read_city-Tuple{String}","page":"Home","title":"JuliaBoyz.read_city","text":"read_city(filename::String)\n\nGiven the path for a file containing a text file of a problem in the specified format, creates a JBCity instance with the relevant information. \n\n\n\n\n\n","category":"method"},{"location":"#JuliaBoyz.shortest_path-Tuple{Any, Any, Any}","page":"Home","title":"JuliaBoyz.shortest_path","text":"shortest_path(from::Int64, to::Int64, neighbor_streets::Dict{Int64, Set{Int64}})\n\nComputes the shortest path between two given junctions using Djikstra's algorithm. Returns a Tuple containing the sequence of junctions (represented by their indices,  including the start/finish junctions) that give the shortest path and the duration of the path.\n\n\n\n\n\n","category":"method"},{"location":"#JuliaBoyz.solution_distance-Tuple{Any}","page":"Home","title":"JuliaBoyz.solution_distance","text":"solution_distance(sol::JBSolution)\n\nComputes the distance covered by all 8 cars.\n\n\n\n\n\n","category":"method"},{"location":"#JuliaBoyz.write_solution-Tuple{Any, Any}","page":"Home","title":"JuliaBoyz.write_solution","text":"write_solution(sol::JBSolution, filename::String)\n\nWrites a JBSolution(@ref) to a text file of the Google specified format, named using the provided file name.\n\n\n\n\n\n","category":"method"}]
}
