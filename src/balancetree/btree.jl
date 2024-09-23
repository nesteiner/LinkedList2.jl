@kwdef mutable struct BTree{T}
    root::BTreeNode{T}
    degree::Int
end

function BTree(T::Union{DataType, UnionAll}, degree::Int)
    if degree <= 2
        throw(ErrorException("cannot create a btree which degree <= 2"))
    end

    return BTree{T}(degree = degree, root = BTreeNode{T}(degree = degree))
end

function insert!(tree::BTree{T}, data::T) where T
    node = findnode(tree.root, data)
    tree.root = insert!(node, data, nothing)
end

show(io::IO, tree::BTree) = printnode(io, tree.root, 0)
print(io::IO, tree::BTree) = show(io, tree)