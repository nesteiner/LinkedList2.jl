@kwdef mutable struct BTreeNode{T} <: AbstractBTreeNode{T}
    level::Int
    keys::Vector{T}
    children::Vector{BTreeNodeType{T}}
    parent::BTreeNodeType{T}
end

BTreeNode(T::Union{DataType, UnionAll}, level::Int) = BTreeNode{T}(
    level = level, 
    keyNumber = 0, 
    childrenNumber = 0, 
    keys = T[], 
    children = BTreeNodeType{T}[], 
    parent = nothing)

reachMaxKeys(node::BTreeNode{T}) where T = length(node.keys) >= node.level
isempty(node::BTreeNode{T}) where T = length(node.keys) == 0

isroot(node::BTreeNode{T}) where T = isnothing(node.parent)
function root(node::BTreeNode{T})::BTreeNodeType{T} where T
    current = node
    while !isroot(current)
        current = current.parent
    end

    return current
end

function insert!(node::BTreeNode{T}, data::T)::BTreeNode{T} where T
    if isempty(node)
        push!(node.keys, data)
        child1 = BTreeNode(T, node.level)
        child1.parent = node

        child2 = BTreeNode(T, node.level)
        child2.parent = node

        push!(node.children, child1, child2)
        return node
    end

    otherNode = findnode(root(node), data)

    if !isempty(otherNode)
        throw(ErrorException("cannot insert duplicate key to btree, the key is $data"))
    end

    insertNode!(otherNode.parent, data, BTreeNode(T, otherNode.level))
    return root(node)
end

function insertNode!(parent::BTreeNode{T}, data::T, rightOfDataNode::BTreeNode{T}) where T
    index = 1
    while index <= length(parent.keys) && parent.keys[index] < data
        index += 1
    end

    insert!(parent.keys, index, data)
    rightOfDataNode.parent = parent
    insert!(parent.children, index + 1, rightOfDataNode)

    if !reachMaxKeys(parent)
        return
    end

    upIndex = ceil(Int, parent.level / 2)
    up = parent.keys[upIndex]

    rightNode = BTreeNode(T, parent.level)
    rightNode.keys = parent.keys[upIndex + 1 : parent.level]
    rightNode.children = parent.children[upIndex + 1 : parent.level + 1]

    for child in rightNode.children
        child.parent = rightNode
    end

    parent.keys = parent.keys[1 : upIndex - 1]
    parent.children = parent.children[1 : upIndex]

    if isnothing(parent.parent)
        parent.parent = BTreeNode(T, parent.level)
        push!(parent.parent.keys, up)
        push!(parent.parent.children, parent)
        push!(parent.parent.children, rightNode)
        rightNode.parent = parent.parent
    else
        insertNode!(parent.parent, up, rightNode)
    end
end

function findnode(node::BTreeNode{T}, target::T)::BTreeNode{T} where T
    if isempty(node)
        return node
    end

    index = 1
    while index <= length(node.keys) && node.keys[index] <= target
        if node.keys[index] == target
            return node
        end

        index += 1
    end

    return findnode(node.children[index], target)
end