mutable struct BFSIterator{T}
    graph::AbstractGraph{T}
    start::Union{AdjList{T}, Nothing}
end

mutable struct DFSIterator{T}
    graph::AbstractGraph{T}
    start::Union{AdjList{T}, Nothing}
end

BFSIterator(graph::AbstractGraph{T}, start::Union{AdjList{T}, Nothing}) where T = BFSIterator(graph, start)
DFSIterator(graph::AbstractGraph{T}, start::Union{AdjList{T}, Nothing}) where T = DFSIterator(graph, start)

@enum Color begin
    White
    Grey
    Black
end

mutable struct BFSState{T}
    queue::List{T}
    visited::Dict{T, Color}
end

mutable struct DFSState{T}
    stack::List{T}
    visited::Dict{T, Color}
end

function iterate(iterator::BFSIterator{T}) where T
    state = BFSState{T}(List(T), Dict{T, Color}())

    if vertexCount(iterator.graph) == 0
        return nothing
    end

    for adjList in iterator.graph.adjLists
        vertex = adjList.vertex
        state.visited[vertex] = White
    end

    firstVertex = if isnothing(iterator.start)
        first(iterator.graph.adjLists).vertex
    else
        iterator.start.vertex
    end

    state.visited[firstVertex] = Black
    edges = findEdges(iterator.graph, firstVertex)

    for edge in edges
        push!(state.queue, edge.vertex)
        state.visited[edge.vertex] = Grey
    end
    
    return firstVertex, state
end

function iterate(iterator::BFSIterator{T}, state::BFSState{T}) where T
    isempty(state.queue) && return nothing

    vertex = popfirst!(state.queue)

    if state.visited[vertex] != Black
        edges = findEdges(iterator.graph, vertex)

        for edge in edges
            if state.visited[edge.vertex] == White
                push!(state.queue, edge.vertex)
                state.visited[edge.vertex] = Grey
            end
        end

        state.visited[vertex] = Black
    end

    return vertex, state
end

function iterate(iterator::DFSIterator{T}) where T
    state = DFSState{T}(List(T), Dict{T, Color}())

    if vertexCount(iterator.graph) == 0
        return nothing
    end

    firstVertex = if isnothing(iterator.start)
        first(iterator.graph.adjLists).vertex
    else
        iterator.start.vertex
    end

    for adjList in iterator.graph.adjLists
        vertex = adjList.vertex
        state.visited[vertex] = White
    end

    state.visited[firstVertex] = Black

    for edge in findEdges(iterator.graph, firstVertex)
        push!(state.stack, edge.vertex)
        state.visited[edge.vertex] = Grey
    end

    return firstVertex, state
end

function iterate(iterator::DFSIterator{T}, state::DFSState{T}) where T
    isempty(state.stack) && return nothing

    vertex = pop!(state.stack)

    for edge in findEdges(iterator.graph, vertex)
        if state.visited[edge.vertex] == White
            push!(state.stack, edge.vertex)
            state.visited[edge.vertex] = Grey
        end
    end

    return vertex, state
end