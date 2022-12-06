"""
Given the path for a file containing a text file of a problem in the specified format,
creates a `JBCity` instance with the relevant information. 
"""
function read_city(filename)
    lines = readlines(filename)
    num_junctions, num_streets, total_time, fleet_size, start = parse.(
        Int, convert(Vector{String}, split(lines[1]))
        )
    println(num_junctions)
    streets = []
    for i in 1:num_streets
        street_info = parse.(Int, convert(Vector{String}, split(lines[i + num_junctions + 1])))
        push!(streets, 
            JBStreet(street_info[1] + 1, street_info[2] + 1, street_info[3] == 2, street_info[4], street_info[5])
            )
    end
    return JBCity(total_time, fleet_size, start, num_junctions, streets)
end