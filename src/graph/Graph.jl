module Graph

import Base:show, iterate, keys, copy
using DataStructure:BadOperationException
export DirectedGraph, UnDirectedGraph, vertexCount, edgeCount, insertVertex!, insertEdge!, Edge,
    removeVertex!, removeEdge!, replaceWeight!, bfsIterate, dfsIterate, hasCycle, kruskal, prim, hasVertex, hasEdge,
    DijkstraShortestPath, FolydShortestPath

using DataStructure.LinkedList, DataStructure.Heap

abstract type AbstractGraph{T} end

include("edge.jl")
include("adjlist.jl")
include("iterate.jl")


mutable struct DirectedGraph{T} <: AbstractGraph{T}
    vertexCount::Int
    edgeCount::Int
    adjLists::List{AdjList{T}}    
end

DirectedGraph(::Type{T}) where T = DirectedGraph(0, 0, List(AdjList{T}))

mutable struct UnDirectedGraph{T} <: AbstractGraph{T}
    vertexCount::Int
    edgeCount::Int
    adjLists::List{AdjList{T}}
end

UnDirectedGraph(::Type{T}) where T = UnDirectedGraph(0, 0, List(AdjList{T}))

vertexCount(graph::AbstractGraph) = graph.vertexCount
edgeCount(graph::AbstractGraph) = graph.edgeCount

function findEdges(graph::AbstractGraph{T}, vertex::T) where T
    node = findfirst(adjList -> adjList.vertex == vertex, graph.adjLists)
    return if !isnothing(node)
        node.data.edges
    else
        List(Edge{T})
    end
end

function insertVertex!(graph::AbstractGraph{T}, data::T) where T
    exist = !isnothing(findfirst(adjList -> adjList.vertex == data, graph.adjLists))
    if exist
        throw(BadOperationException("cannot insert a duplicate node"))
    end

    adjList = AdjList(data, List(Edge{T}))
    push!(graph.adjLists, adjList)
    graph.vertexCount += 1
end

function insertEdge!(graph::DirectedGraph{T}, vertex::T, otherVertex::T, weight::Number = 0) where T
    if vertex == otherVertex
        throw(BadOperationException("cannot insert a self cycle"))
    end

    nodeLeft = findfirst(adjList -> adjList.vertex == vertex, graph.adjLists)
    nodeRight = findfirst(adjList -> adjList.vertex == otherVertex, graph.adjLists)

    if isnothing(nodeLeft) || isnothing(nodeRight)
        throw(BadOperationException("cannot insert edge on a non-exist vertex"))
    end

    edges = dataof(nodeLeft).edges
    exist = !isnothing(findfirst(edge -> edge.vertex == vertex, edges))

    if exist 
        throw(BadOperationException("cannot insert a duplicate edge"))
    end

    exist = !isnothing(findfirst(edge -> edge.vertex == otherVertex, edges))
    
    if exist
        throw(BadOperationException("cannot insert duplicate edge"))
    end
    
    push!(edges, Edge(otherVertex, weight))
    graph.edgeCount += 1
end

function insertEdge!(graph::UnDirectedGraph{T}, vertex::T, otherVertex::T, weight::Number = 0) where T
    if vertex == otherVertex
        throw(BadOperationException("cannot insert a self cycle"))
    end

    nodeLeft = findfirst(adjList -> adjList.vertex == vertex, graph.adjLists)
    nodeRight = findfirst(adjList -> adjList.vertex == otherVertex, graph.adjLists)

    if isnothing(nodeLeft) || isnothing(nodeRight)
        throw(BadOperationException("cannot insert edge on a non-exist vertex"))
    end

    edges = dataof(nodeLeft).edges

    exist = !isnothing(findfirst(edge -> edge.vertex == vertex, edges))
    
    if exist
        throw(BadOperationException("cannot insert a duplicate edge"))
    end

    exist = !isnothing(findfirst(edge -> edge.vertex == otherVertex, edges))
    
    if exist
        throw(BadOperationException("cannot insert duplicate edge"))
    end
    
    push!(edges,  Edge(otherVertex, weight))

    edges = dataof(nodeRight).edges
    push!(edges, Edge(vertex, weight))

    graph.edgeCount += 1
end
    
function removeVertex!(graph::AbstractGraph{T}, vertex::T) where T
    node = findfirst(adjList -> adjList.vertex == vertex, graph.adjLists)
    if isnothing(node)
        throw(BadOperationException("cannot delete on a non-exist vertex"))
    end

    popat!(graph.adjList, node)
    graph.vertexCount -= 1

    for adjList in graph.adjLists
        edges = adjList.edges
        pos = findfirst(edge -> edge.vertex == vertex, edges)
        if !isnothing(pos)
            popat!(edges, pos)
        end
    end
end

function removeEdge!(graph::DirectedGraph{T}, vertex::T, otherVertex::T) where T
    nodeLeft = findfirst(adjList -> adjList.vertex == vertex, graph.adjLists)
    nodeRight = findfirst(adjList -> adjList.vertex == otherVertex, graph.adjLists)

    if isnothing(nodeLeft) || isnothing(nodeRight)
        throw(BadOperationException("cannot delete edge on a non-exist vertex"))
    end

    edges = findEdges(graph, vertex)
    node = findfirst(edge -> edge.vertex == otherVertex, edges)

    popat!(edges, node)
    graph.edgeCount -= 1
end

function removeEdge!(graph::UnDirectedGraph{T}, vertex::T, otherVertex::T) where T
    nodeLeft::Union{Nothing, ListNode{AdjList{T}}} = findfirst(adjList -> adjList.vertex == vertex, graph.adjLists)
    nodeRight::Union{Nothing, ListNode{AdjList{T}}} = findfirst(adjList -> adjList.vertex == otherVertex, graph.adjLists)

    if isnothing(nodeLeft) || isnothing(nodeRight)
        throw(BadOperationException("cannot delete edge on a non-exist vertex"))
    end

    edges = nodeLeft.data.edges
    node = findfirst(edge -> edge.vertex == otherVertex, edges)

    if isnothing(node)
        throw(BadOperationException("there is no edge with vertex $otherVertex"))
    end

    popat!(edges, node)

    edges = nodeRight.data.edges
    node = findfirst(edge -> edge.vertex == vertex, edges)

    if isnothing(node)
        throw(BadOperationException("there is no edge with vertex $otherVertex"))
    end
    
    popat!(edges, node)

    #= edges = findEdges(graph, vertex)
    node = findfirst(edge -> edge.vertex == otherVertex, edges)
    popat!(edges, node)

    edges = findEdges(graph, otherVertex)
    node = findfirst(edge -> edge.vertex == vertex, edges)
    popat!(edges, node) =#

    graph.edgeCount -= 1
end

function replaceWeight!(graph::DirectedGraph{T}, vertex::T, otherVertex::T, weight::Number) where T
    nodeLeft = findfirst(adjList -> adjList.vertex == vertex, graph.adjLists)
    nodeRight = findfirst(adjList -> adjList.vertex == otherVertex, graph.adjLists)

    if isnothing(nodeLeft) || isnothing(nodeRight)
        throw(BadOperationException("cannot delete edge on a non-exist vertex"))
    end

    edges = findEdges(graph, vertex)
    node = findfirst(edge -> edge.vertex == otherVertex, edges)
    dataof(node).weight = weight
end

function replaceWeight!(graph::UnDirectedGraph{T}, vertex::T, otherVertex::T, weight::Number) where T
    nodeLeft = findfirst(adjList -> adjList.vertex == vertex, graph.adjLists)
    nodeRight = findfirst(adjList -> adjList.vertex == otherVertex, graph.adjLists)

    if isnothing(nodeLeft) || isnothing(nodeRight)
        throw(BadOperationException("cannot delete edge on a non-exist vertex"))
    end

    edges = findEdges(graph, vertex)
    node = findfirst(edge -> edge.vertex == otherVertex, edges)
    dataof(node).weight = weight

    edges = findEdges(graph, otherVertex)
    node = findfirst(edge -> edge.vertex == vertex, edges)
    dataof(node).weight = weight
end

function isCyclicUntil(graph::AbstractGraph{T}; start::T, visited::Dict{T, Bool}, parent::Union{T, Nothing}) where T
    visited[start] = true
    for edge in findEdges(graph, start)
        if !visited[edge.vertex] 
            if isCyclicUntil(graph, start = edge.vertex, visited = visited, parent = start)
                return true
            end
        elseif edge.vertex != parent
            return true
        end
    end

    return false
end

function hasCycle(graph::AbstractGraph{T}) where T
    visited = Dict{T, Bool}()

    for adjList in graph.adjLists
        visited[adjList.vertex] = false
    end

    for adjList in graph.adjLists
        vertex = adjList.vertex

        if !visited[vertex] && isCyclicUntil(graph, start = vertex, visited = visited, parent = nothing)
            return true
        end
    end

    return false
end

bfsIterate(graph::AbstractGraph{T}) where T = BFSIterator{T}(graph, nothing)
dfsIterate(graph::AbstractGraph{T}) where T = DFSIterator{T}(graph, nothing)
function bfsIterate(graph::AbstractGraph{T}, start::T) where T
    node = findfirst(adjList -> adjList.vertex == start, graph.adjLists)
    isnothing(node) && throw(BadOperationException("cannot iterate from a non-exist vertex"))

    return BFSIterator{T}(graph, node)
end

function dfsIterate(graph::AbstractGraph{T}, start::T) where T
    node = findfirst(adjList -> adjList.vertex == start, graph.adjLists)
    isnothing(node) && throw(BadOperationException("cannot iterate from a non-exist vertex"))

    return DFSIterator{T}(graph, node)
end

keys(graph::AbstractGraph) = BFSIterator(graph, nothing)

include("mst.jl")

function copy(graph::AbstractGraph{T}) where T
    result = if isa(graph, UnDirectedGraph)
        UnDirectedGraph(T)
    else
        DirectedGraph(T)
    end

    for adjList in graph.adjLists
        insertVertex!(result, adjList.vertex)
    end

    for (leftAdjList, rightAdjList) in Iterators.zip(graph.adjLists, result.adjLists)
        edges = leftAdjList.edges
        rightAdjList.edges = copy(edges)
    end

    return result
end

hasVertex(graph::AbstractGraph{T}, data::T) where T = !isnothing(findfirst(adjList -> adjList.vertex == data, graph.adjLists))

function hasEdge(graph::AbstractGraph{T}, vertex::T, otherVertex::T) where T
    if vertex == otherVertex
        throw(BadOperationException("there is no self cycle edge"))
    end

    nodeLeft = findfirst(adjList -> adjList.vertex == vertex, graph.adjLists)
    nodeRight = findfirst(adjList -> adjList.vertex == otherVertex, graph.adjLists)

    if isnothing(nodeLeft) || isnothing(nodeRight)
        throw(BadOperationException("find non-exist vertex"))
    end
    
    return !isnothing(findfirst(edge -> edge.vertex == otherVertex, dataof(nodeLeft).edges))
end

include("shortest_path.jl")

end