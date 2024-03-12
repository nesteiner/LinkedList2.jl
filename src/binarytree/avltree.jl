mutable struct AVLTree{T} <: AbstractBinaryTree
    root::Union{AVLTreeNode{T}, BinaryTreeNil}
    length::Int
    compare::Function
end

AVLTree(::Type{T}, compare::Function) where T = AVLTree{T}(treenil, 0, compare)

function insert!(tree::AVLTree{T}, data::T) where T
    tree.root = insertAVLNode!(tree.root, data, tree.compare)
    tree.length += 1
end

function popat!(tree::AVLTree{T}, data::T)::T where T
    if haskey(tree, data)
        tree.root = deleteAVLNode!(tree.root, data, tree.compare)
        tree.length -= 1

        return data
    else
        throw(BadOperationException("there is no such element in the tree"))
    end
end