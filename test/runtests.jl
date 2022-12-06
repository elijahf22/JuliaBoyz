using Aqua
using Documenter
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
        city_long = JuliaBoyz.read_city("test_city_long.txt")
        city_short = JuliaBoyz.read_city("test_city_short.txt")
        
        long_start = time_ns()
        solution1 = JuliaBoyz.greedy_dfs_solution(city_long)
        upper1 = JuliaBoyz.genestarate_upper_bound(solution1.city)
        long_end = time_ns()
        distance1 = JuliaBoyz.solution_distance(solution1)
        time1 = (long_end - long_start)/10^9

        short_start = time_ns()
        solution2 = JuliaBoyz.greedy_dfs_solution(city_short)
        upper2 = JuliaBoyz.generate_upper_bound(solution2.city)
        short_end = time_ns()
        distance2 = JuliaBoyz.solution_distance(solution2)
        time2 = (short_end - short_start) / 10^9

        @test JuliaBoyz.check_solution(solution1)
        @test JuliaBoyz.check_solution(solution2)
        @test upper1 > 0
        @test upper2 > 0
        @test distance1 <= upper1
        @test distance2 <= upper2
        
        print("54000s distance: ")
        println(distance1)
        print("54000s upper bound: ")
        println(upper1)
        print("54000s time: ")
        println(time1)
        println()
        print("18000s distance: ")
        println(distance2)
        print("18000s upper bound: ")
        println(upper2)
        print("18000s time: ")
        println(time2)
        println()
        
    end
end
