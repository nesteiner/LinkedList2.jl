mutable struct DijkstraShortestPath{T}
    graph::AbstractGraph{T}
    start::T
    distancesMap::Dict{T, Number}
    parents::Dict{T, Union{T, Nothing}}
    visited::Dict{T, Bool}
end

mutable struct FolydShortestPath{T}
    graph::AbstractGraph{T}
    start::T
    distanceMap::Dict{T, Dict{T, Number}}
end

function DijkstraShortestPath(graph::AbstractGraph{T}, start::T) where T
    result = DijkstraShortestPath(graph, start, Dict{T, Number}(), Dict{T, Union{T, Nothing}}(), Dict{T, Bool}())

    distancesMap = result.distancesMap
    parents = result.parents
    graph = result.graph
    visited = result.visited

    for adjList in graph.adjLists
        distancesMap[adjList.vertex] = Inf
        parents[adjList.vertex] = nothing
        visited[adjList.vertex] = false
    end

    distancesMap[start] = 0

    while !all(values(visited))
        minAdjList = reduce(
            (left, right) -> distancesMap[left.vertex] < distancesMap[right.vertex] ? left : right,
            filter(adjList -> !visited[adjList.vertex], graph.adjLists)
        )

        minVertex = minAdjList.vertex
        edges = minAdjList.edges
        visited[minVertex] = true

        for edge in edges
            if distancesMap[edge.vertex] > distancesMap[minVertex] + edge.weight
                distancesMap[edge.vertex] = distancesMap[minVertex] + edge.weight
                parents[edge.vertex] = minVertex
            end
        end
        
    end

    return result
end

function FolydShortestPath(graph::AbstractGraph{T}, start::T) where T
    result = FolydShortestPath(graph, start, Dict{T, Dict{T, Number}}())
    distanceMap = result.distanceMap

    for adjList in graph.adjLists
        distanceMap[adjList.vertex] = Dict{T, Number}(adjList.vertex => 0)

        for edge in adjList.edges
            distanceMap[adjList.vertex][edge.vertex] = edge.weight
        end
    end

    for adjList1 in graph.adjLists
        for adjList2 in graph.adjLists
            for adjList3 in graph.adjLists
                # if distance[adjList2.vertex][adjList1.vertex] != Inf && distance[adjList1.vertex][adjList3.vertex] != Inf && distance
                value1 = get(distanceMap[adjList2.vertex], adjList1.vertex, Inf)
                value2 = get(distanceMap[adjList1.vertex], adjList3.vertex, Inf)

                if !isinf(value1) && !isinf(value2) && value1 + value2 < get(distanceMap[adjList2.vertex], adjList3.vertex, Inf)
                    distanceMap[adjList2.vertex][adjList3.vertex] = value1 + value2
                end
            end
        end
    end

    return result
end