@kwdef struct RecordItem{T}
    start::T
    endat::T
    weight::Number    
end

function kruskal(graph::AbstractGraph{T}, start::Union{T, Nothing} = nothing) where T
    startVertex = if isnothing(start)
        if graph.vertexCount == 0
            nothing
        else
            first(graph.adjLists).vertex
        end
    else
        findfirst(adjList -> adjList.vertex == start, graph.adjLists)
    end

    if isnothing(startVertex)
        throw(BadOperationException("cannot start from a non-exist vertex"))
    end

    record = RecordItem{T}[]
    visited = Dict{T, Color}()

    for adjList in graph.adjLists
        visited[adjList.vertex] = White
    end

    for adjList in graph.adjLists
        vertex = adjList.vertex

        if visited[vertex] == Black
            continue
        end
        
        edges = adjList.edges

        visited[vertex] = Grey

        start = vertex
        
        for edge in edges
            endat = edge.vertex
            visited[endat] = Grey

            push!(record, RecordItem(start = start, endat = endat, weight = edge.weight))
        end

        visited[vertex] = Black
    end

    sort!(record, by = item -> item.weight)

    result = if isa(graph, DirectedGraph)
        DirectedGraph(T)
    else
        UnDirectedGraph(T)
    end

    for adjList in graph.adjLists
        insertVertex!(result, adjList.vertex)
    end

    index = 1
    len = length(record)

    while result.edgeCount != graph.vertexCount - 1 && index <= len
        item = record[index]

        if !hasEdge(result, item.start, item.endat)
            insertEdge!(result, item.start, item.endat, item.weight)
        end

        if hasCycle(result)
            removeEdge!(result, item.start, item.endat)
        end

        index += 1
    end

    return result
end

function prim(graph::AbstractGraph{T}, start::Union{T, Nothing} = nothing) where T
    startVertex = if isnothing(start)
        if graph.vertexCount == 0
            nothing
        else
            first(graph.adjLists).vertex
        end
    else
        findfirst(adjList -> adjList.vertex == start, graph.adjLists)
    end

    if isnothing(startVertex)
        throw(BadOperationException("cannot start from a non-exist vertex"))
    end

    result::AbstractGraph{T} = if isa(graph, UnDirectedGraph) 
        UnDirectedGraph(T)
    else
        DirectedGraph(T)
    end

    # 标记点集，被标记的相当于加入了点集中    
    visited = Dict{T, Bool}()
    parents = Dict{T, Union{T, Nothing}}()
    for adjList in graph.adjLists
        visited[adjList.vertex] = false
        parents[adjList.vertex] = nothing
        insertVertex!(result, adjList.vertex)
    end

    visited[startVertex] = true
    
    while !all(values(visited))
        minVertex, minWeight = nothing, Inf
        # 所有未访问过的点集
        for adjList in graph.adjLists
            if visited[adjList.vertex]
                continue
            end

            for edge in adjList.edges
                # 未访问过的点集和已访问过的点集之间的边
                if visited[edge.vertex]
                    if minWeight > edge.weight
                        # minVertex, minWeight = edge.vertex, edge.weight
                        minVertex = edge.vertex
                        minWeight = edge.weight
                        parents[edge.vertex] = adjList.vertex
                    end
                end
            end

            #= insertEdge!(result, adjList.vertex, minVertex, minWeight)
            visited[adjList.vertex] = true =#
        end

        insertEdge!(result, parents[minVertex], minVertex, minWeight)
        visited[parents[minVertex]] = true
    end

    return result
end