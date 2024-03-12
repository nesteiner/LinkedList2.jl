mutable struct AdjList{T}
    vertex::T
    edges::List{Edge{T}}
end

AdjList(vertex::T, edges::List{Edge{T}}) where T = AdjList{T}(vertex, edges)

function show(io::IO, adjList::AdjList)
    println(io)
    print(io, "$(adjList.vertex)----|")

    for edge in adjList.edges
        print(io, edge, " ")
    end
end