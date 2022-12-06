using JuliaBoyz
using Test
using Aqua
using HashCode2014
using Accessors
using DataStructures


println(city.starting_junction)
generate_greedy_random_solution()
println(generate_greedy_random_solution())

println(city.total_duration)
before = time_ns()
solu = Solution(generate_greedy_random_solution())
after = time_ns()
print("Computation time: ")
println((after-before)*(10^(-9)))
println(HashCode2014.total_distance(solu, city))
println(HashCode2014.is_feasible(solu, city; verbose=true))
HashCode2014.write_solution(solu, "sol.txt")
HashCode2014.plot_streets(city, solu; path="testsol.html")
println(generate_upper_bound())