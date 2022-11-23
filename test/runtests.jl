using JuliaBoyz
using Test

@testset "JuliaBoyz.jl" begin
    city_long = HashCode2014.read_city()
    city_short = HashCode2014.read_city()
    city_short.total_duration = 18000
    
    solution1 = JuliaBoyz.generate_greedy_random_solution(city_long)
    upper_long = JuliaBoyz.generate_upper_bound(city_long)
    solution2 = JuliaBoyz.generate_greedy_random_solution(city_short)
    upper_short = JuliaBoyz.generate_upper_bound(city_short)
    
    @test HashCode2014.is_feasible(solution1, city_long)
    @test HashCode2014.is_feasible(solution2, city_short)
    @test upper_long > 0
    @test upper_short > 0
    @test HashCode2014.total_distance(solution1, city_long) <= upper_long
    @test HashCode2014.total_distance(solution2, city_short) <= upper_short
    
    println(HashCode2014.total_distance(solution1, city_long))
    println(upper_long)
    println(HashCode2014.total_distance(solution2, city_short))
    println(upper_short)
    
end
