module DataStructure

export LinkedList, BinaryTree, BadOperationException, Graph, Heap, Sort, BalanceTree

struct BadOperationException <: Exception
    message::String
end

include("heap/Heap.jl")
include("linkedlist/LinkedList.jl")
include("binarytree/BinaryTree.jl")
include("huffmantree/HuffmanTree.jl")
include("graph/Graph.jl")
include("balancetree/BalanceTree.jl")
include("sort/Sort.jl")
if false
    include("../test/runtests.jl")
end

end