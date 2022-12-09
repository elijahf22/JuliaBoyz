using Aqua
using Documenter
using JuliaBoyz
using JuliaFormatter
using Test

@testset verbose = true "JuliaBoyz.jl" begin
    @testset verbose = true "Code quality (Aqua.jl)" begin
        Aqua.test_all(JuliaBoyz; ambiguities=false)
    end

    @testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
        @test format(JuliaBoyz; verbose=true, overwrite=true)
    end

    @testset verbose = true "Doctests (Documenter.jl)" begin
        doctest(JuliaBoyz)
    end

    @testset verbose = true "JuliaBoyz.jl" begin
        paris_long = Main.JuliaBoyz.read_city("test_city_long.txt")
        paris_short = Main.JuliaBoyz.read_city("test_city_short.txt")

        long_start = time_ns()
        solution1 = JuliaBoyz.greedy_dfs_solution(paris_long)
        upper1 = JuliaBoyz.generate_upper_bound(solution1.city)
        long_end = time_ns()
        distance1 = JuliaBoyz.solution_distance(solution1)
        time1 = (long_end - long_start) / 10^9
        JuliaBoyz.write_solution(solution1, "test_solution_long.txt")

        short_start = time_ns()
        solution2 = JuliaBoyz.greedy_dfs_solution(paris_short)
        upper2 = JuliaBoyz.generate_upper_bound(solution2.city)
        short_end = time_ns()
        distance2 = JuliaBoyz.solution_distance(solution2)
        time2 = (short_end - short_start) / 10^9
        JuliaBoyz.write_solution(solution2, "test_solution_short.txt")

        @test JuliaBoyz.check_solution(solution1)
        @test JuliaBoyz.check_solution(solution2)
        @test upper1 > 0
        @test upper2 > 0
        @test distance1 <= upper1
        @test distance2 <= upper2

        println("\nDoctests:")
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
