mutable struct Edge{T}
    vertex::T
    weight::Number
end

Edge(vertex::T) where T = Edge{T}(vertex, 0)
Edge(vertex::T, weight::Number) where T = Edge{T}(vertex, weight)

show(io::IO, edge::Edge) = print(io, "$(edge.vertex) $(edge.weight) |")
