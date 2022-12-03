# using adjacency list import 

function check_solution(city, sol)
    adj_list = generate_adjacency_list(city)
    for car_itin in sol
        for i in 1:length(car_itin)
            if !(car_itin[i + 1] ! adj_list[car_itin[i]])
                return false
            end
        end
    end
    return true
end


