mutable struct BTree{T}
    level::Int
    root::BTreeNodeType{T}
end

BTree(T::Union{DataType, UnionAll}, level::Int) = BTree{T}(level, nothing)

function insert!(tree::BTree{T}, data::T) where T 
    if isnothing(tree.root)
        tree.root = BTreeNode(T, tree.level)
    end

    tree.root = insert!(tree.root, data)
end

function printnode(io::IO, node::BTreeNode{T}, depth = 0) where T
    for _ in 1:depth
        print(io, "|    ")
    end

    if depth > 0
        print(io, "|-----")
    end

    print(io, node.keys)
    println(io)
    for child in node.children
        printnode(io, child, depth + 1)
    end
end