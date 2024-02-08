mutable struct BinarySearchTree{T} <: AbstractBinaryTree
    root::Union{BinaryTreeNil, BinaryTreeNode{T}}
    compare::Function
    length::Int
end

BinarySearchTree(T::DataType, compare::Function) = BinarySearchTree{T}(treenil, compare, 0)

function insert!(tree::BinarySearchTree{T}, data::T) where T
    tree.root = insertNode!(tree.root, data, tree.compare)
    tree.length += 1
end