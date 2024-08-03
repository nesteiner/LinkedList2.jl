abstract type AbstractBinaryTreeNode end
abstract type AbstractBinaryTreeConsNode{T} <: AbstractBinaryTreeNode end

struct BinaryTreeNil <: AbstractBinaryTreeNode end

treenil = BinaryTreeNil()

mutable struct BinaryTreeNode{T} <: AbstractBinaryTreeConsNode{T}
    data::T
    left::Union{BinaryTreeNode{T}, BinaryTreeNil}
    right::Union{BinaryTreeNode{T}, BinaryTreeNil}
end

mutable struct AVLTreeNode{T} <: AbstractBinaryTreeConsNode{T}
    data::T
    left::Union{AVLTreeNode{T}, BinaryTreeNil}
    right::Union{AVLTreeNode{T}, BinaryTreeNil}
    height::Int
end

BinaryTreeNode(data::T) where T = BinaryTreeNode{T}(data, treenil, treenil)
AVLTreeNode(data::T) where T = AVLTreeNode{T}(data, treenil, treenil, 1)

dataof(node::AbstractBinaryTreeConsNode) = node.data
left(node::AbstractBinaryTreeConsNode) = node.left
right(node::AbstractBinaryTreeConsNode) = node.right

==(leftnode::AbstractBinaryTreeConsNode, rightnode::AbstractBinaryTreeConsNode) = dataof(leftnode) == dataof(rightnode) &&
    left(leftnode) == left(rightnode) &&
    right(leftnode) == right(rightnode)

show(io::IO, ::BinaryTreeNil) = print(io, "treenil")
show(io::IO, node::AbstractBinaryTreeConsNode) = print(io, "treenode: ", dataof(node))

isleaf(node::AbstractBinaryTreeConsNode) = left(node) === treenil && right(node) === treenil
hasleft(node::AbstractBinaryTreeConsNode) = left(node) !== treenil
hasright(node::AbstractBinaryTreeConsNode) = right(node) !== treenil

insertNode!(::BinaryTreeNil, data::T, compare::Function) where T = BinaryTreeNode(data)
function insertNode!(node::AbstractBinaryTreeConsNode{T}, data::T, compare::Function) where T
    if compare(data, dataof(node)) < 0
        node.left = insertNode!(left(node), data, compare)
    else
        node.right = insertNode!(right(node), data, compare)
    end

    return node
end

iterate(::BinaryTreeNil) = nothing
function iterate(node::AbstractBinaryTreeConsNode{T}) where T
    queue = List(AbstractBinaryTreeNode{T})

    if hasleft(node)
        push!(queue, left(node))
    end

    if hasright(node)
        push!(queue, right(node))
    end

    return node, queue
end

function itearte(::AbstractBinaryTreeConsNode{T}, queue::List{<:AbstractBinaryTreeNode}) where T
    if isempty(queue)
        return nothing
    end

    current = popfirst!(queue)
    if hasleft(current)
        push!(queue, left(current))
    end

    if hasright(current)
        push!(queue, right(current))
    end

    return current, queue
end

function findNode(node::AbstractBinaryTreeConsNode, data::T, compare::Function)::AbstractBinaryTreeNode where T
    backfather = node
    status = 0
    result = compare(dataof(node), data)

    while node !== treenil
        if result== 0
            return backfather
        end

        backfather = node
        if result > 0
            node = left(node)
            status = -1
        else
            node = right(node)
            status = 1
        end
    end

    return treenil
end

height(::BinaryTreeNil) = 0
height(node::AVLTreeNode) = node.height
balanceFactor(::BinaryTreeNil) = 0
balanceFactor(node::AVLTreeNode) = height(left(node)) - height(right(node))

function rotateLeftLeft!(node::AVLTreeNode)::AVLTreeNode
    rightnode = right(node)
    leftnode = left(rightnode)
  
    rightnode.left = node
    node.right = leftnode
  
    node.height = max(height(left(node)), height(right(node))) + 1
    rightnode.height = max(height(left(rightnode)), height(right(rightnode))) + 1
  
    return rightnode
end

function rotateRightRight!(node::AVLTreeNode)::AVLTreeNode
    leftnode = left(node)
    rightnode = right(leftnode)
  
    leftnode.right = node
    node.left = rightnode
  
    node.height = max(height(left(node)), height(right(node))) + 1
    leftnode.height = max(height(left(leftnode)), height(right(leftnode))) + 1
  
    return leftnode
end

function rotateLeftRight!(node::AVLTreeNode)::AVLTreeNode
    node.left = rotateRightRight!(left(node))
    return rotateLeftLeft!(node)
end
  
function rotateRightLeft!(node::AVLTreeNode)::AVLTreeNode
    node.right = rotateLeftLeft!(right(node))
    return rotateRightRight!(node)
end

function rebalance!(node::AVLTreeNode)::AVLTreeNode
    factor = balanceFactor(node)
    if factor > 1 && balanceFactor(left(node)) > 0
        return rotateRightRight!(node)
    elseif factor > 1 && balanceFactor(left(node)) <= 0
        return rotateLeftRight!(node)
    elseif factor < -1 && balanceFactor(right(node)) <= 0
        return rotateLeftLeft!(node)
    elseif factor < -1 && balanceFactor(right(node)) > 0
        return rotateRightLeft!(node)
    else
        return node
    end
end

insertAVLNode!(::BinaryTreeNil, data::T, compare::Function) where T = AVLTreeNode(data)

function insertAVLNode!(node::AVLTreeNode{T}, data::T, compare::Function)::AVLTreeNode{T} where T
    result = compare(data, dataof(node))
    if result > 0
        node.right = insertAVLNode!(right(node), data, compare)
    elseif result < 0
        node.left = insertAVLNode!(left(node), data, compare)
    else
        return node
    end

    node.height = max(height(left(node)), height(right(node))) + 1
    node = rebalance!(node)
    return node
end

function deleteAVLNode!(node::Union{BinaryTreeNil, AVLTreeNode{T}}, data::T, compare::Function)::Union{BinaryTreeNil, AVLTreeNode{T}} where T
    result = compare(data, dataof(node))
    refnode = node

    if result < 0
        node.left = deleteAVLNode!(left(node), data, compare)
    elseif result > 0
        node.right = deleteAVLNode!(right(node), data, compare)
    else
        if !hasleft(refnode) || !hasright(refnode)
            temp = treenil
            if temp == left(refnode)
                temp = right(refnode)
            else
                temp = left(refnode)
            end

            if temp === treenil
                temp = refnode
                refnode = treenil
            else
                refnode = temp
            end
        else
            temp = minValueNode(right(refnode))
            refnode.data = dataof(temp)
            refnode.right = deleteAVLNode!(right(refnode), dataof(temp), compare)
        end
    end

    if refnode === treenil
        return refnode
    end

    refnode.height = max(height(left(refnode)), height(right(refnode))) + 1
    return rebalance!(refnode)
end

function minValueNode(node::Union{AVLTreeNode, BinaryTreeNil})
    current = node
    while current !== treenil && left(current) !== treenil
      current = left(current)
    end
  
    return current
end

eltype(::BinaryTreeNode{T}) where T = T
eltype(::AVLTreeNode{T}) where T = T