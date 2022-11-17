using JuliaBoyz
using Documenter

DocMeta.setdocmeta!(JuliaBoyz, :DocTestSetup, :(using JuliaBoyz); recursive=true)

makedocs(;
    modules=[JuliaBoyz],
    authors="elijahf22 <elijahf@mit.edu> and contributors",
    repo="https://github.com/elijahf22/JuliaBoyz.jl/blob/{commit}{path}#{line}",
    sitename="JuliaBoyz.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://elijahf22.github.io/JuliaBoyz.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/elijahf22/JuliaBoyz.jl",
    devbranch="master",
)
