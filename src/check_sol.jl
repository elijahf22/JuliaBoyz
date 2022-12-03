"""
    Given a city and a potential solution, checks the validity of the solution.
    
    Works by beginning at the first junction in an itinerary and check if the next junction 
    is in the adjacency list of the current node, returning false if it is not, and continuing
    on otherwise. Repeat until the end, and do this for all itineraries in the potential
    solution.
"""
function check_solution(city, sol)
    adj_list = generate_adjacency_list(city)  # Dictionary representation of the junctions adjacent to a specified junction
    for car_itin in sol
        for i in 1:(length(car_itin) - 1)
            if !(car_itin[i + 1] ! adj_list[car_itin[i]])
                return false
            end
        end
    end
    return true
end


