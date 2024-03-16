function topologicalSort(graph::DirectedGraph{T}) where T
    result = List(T)
    stack = List(T)

    if hasCycle(graph)
        @info "has cycle"
        return result
    end

    indegreeRecord = Dict{T, Int}()

    for adjList in graph.adjLists
        degree = indegree(graph, adjList.vertex)
        indegreeRecord[adjList.vertex] = degree

        if degree == 0
            pushfirst!(stack, adjList.vertex)
        end
    end

    while !isempty(stack)
        vertex = popfirst!(stack)
        push!(result, vertex)

        for edge in findEdges(graph, vertex)
            value = (indegreeRecord[edge.vertex] -= 1)

            if value == 0
                pushfirst!(stack, edge.vertex)
            end
        end
    end

    return result
end