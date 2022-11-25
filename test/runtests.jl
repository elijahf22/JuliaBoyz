using Accessors
using Aqua
using Documenter
using HashCode2014
using JuliaBoyz
using JuliaFormatter
using Test


@testset verbose = true "JuliaBoyz.jl" begin

    #=
    @testset verbose = true "Code quality (Aqua.jl)" begin
        Aqua.test_all(JuliaBoyz; ambiguities=false)
    end

    @testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
        @test format(JuliaBoyz; verbose=true, overwrite=false)
    end

    @testset verbose = true "Doctests (Documenter.jl)" begin
        doctest(JuliaBoyz)
    end
    =#

    @testset verbose = true "JuliaBoyz.jl" begin
        city_long = HashCode2014.read_city()
        city_short = @set city_long.total_duration = 18000
        
        long_start = time_ns()
        solution1 = Solution(JuliaBoyz.generate_greedy_random_solution(city_long))
        upper_long = JuliaBoyz.generate_upper_bound(city_long)
        long_end = time_ns()
        long_time = (long_end - long_start)/10^9

        short_start = time_ns()
        solution2 = Solution(JuliaBoyz.generate_greedy_random_solution(city_short))
        upper_short = JuliaBoyz.generate_upper_bound(city_short)
        short_end = time_ns()
        short_time = (short_end - short_start) / 10^9

        @test HashCode2014.is_feasible(solution1, city_long)
        @test HashCode2014.is_feasible(solution2, city_short)
        @test upper_long > 0
        @test upper_short > 0
        @test HashCode2014.total_distance(solution1, city_long) <= upper_long
        @test HashCode2014.total_distance(solution2, city_short) <= upper_short
        
        print("54000s distance: ")
        println(HashCode2014.total_distance(solution1, city_long))
        print("54000s upper bound: ")
        println(upper_long)
        print("54000s time: ")
        println(long_time)
        println()
        print("18000s distance: ")
        println(HashCode2014.total_distance(solution2, city_short))
        print("18000s upper bound: ")
        println(upper_short)
        print("18000s time: ")
        println(short_time)
        println()
        
    end
end
