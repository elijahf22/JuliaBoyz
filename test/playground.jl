using Main.JuliaBoyz

problem = JuliaBoyz.read_city("test_city_long.txt")
s1 = JuliaBoyz.greedy_dfs_solution(problem)
JuliaBoyz.write_solution(s1, "test_solution1.txt")