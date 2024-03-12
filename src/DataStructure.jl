module DataStructure

export LinkedList, BinaryTree, BadOperationException, Graph, Heap

struct BadOperationException <: Exception
    message::String
end

include("heap/Heap.jl")
include("linkedlist/LinkedList.jl")
include("binarytree/BinaryTree.jl")
include("huffmantree/HuffmanTree.jl")
include("graph/Graph.jl")

end