"""
    generate_upper_bound(city::JBCity)
Naively generates an upper bound on the possible distance by sorting all available streets by 
duration to distance ratio, and adding until all time is used up (across all cars), or all 
streets are traversed.
"""
function generate_upper_bound(city)

    # Prepares values for the function
    streets = sort(city.streets; by=street -> street.duration/street.distance)
    time = 0
    dist = 0

    # Runs through each street in the city
    for street in streets

        # Registers the effect of traversing this street if possible
        if time < city.nb_cars * city.total_duration
            time += street.duration
            dist += street.distance

        # Time has run out
        else
            break
        end
    end
    
    return dist
end