module BinaryTree
import Base:(==), iterate, eltype, show, insert!, 
    keys, contains, length, popat!, replace!, filter, haskey,
    convert

import DataStructure: BadOperationException    

export BinarySearchTree, AVLTree, search, AbstractBinaryTreeNode, AbstractBinaryTree, BinaryTreeNode, AVLTreeNode
export levelorder, preorder, inorder, postorder, dataof, left, right, isleaf, search, insert!, popat!, dataof
using DataStructure.LinkedList

abstract type AbstractBinaryTree end

include("treenodes.jl")
include("binarysearchtree.jl")
include("avltree.jl")
include("iterate.jl")
eltype(::BinarySearchTree{T}) where T = T
eltype(::Type{Base.Iterators.Filter{F, V}}) where {F, V} = eltype(V)

length(tree::AbstractBinaryTree) = tree.length

function iterate(tree::AbstractBinaryTree)
    node = tree.root

    if node === treenil
        return nothing
    end

    queue = List(AbstractBinaryTreeNode)

    if hasleft(node)
        push!(queue, left(node))
    end

    if hasright(node)
        push!(queue, right(node))
    end

    return dataof(node), queue
end

function iterate(::AbstractBinaryTree, queue::List{<:AbstractBinaryTreeNode})
    isempty(queue) && return nothing

    current = first(queue)
    if hasleft(current)
        push!(queue, left(current))
    end

    if hasright(current)
        push!(queue, right(current))
    end

    popfirst!(queue)
    return dataof(current), queue
end

function show(io::IO, tree::AbstractBinaryTree)
    for value in tree
        print(io, value, " ")
    end
end

function filter(pred::Function, tree::AbstractBinaryTree) 
    Iterators.filter(pred, tree) |> collect
end

function search(value::T, tree::AbstractBinaryTree)::AbstractBinaryTreeNode where T
    compare = tree.compare
    current = tree.root
    while current !== treenil
        result = compare(value, dataof(current))
        if result > 0
            current = right(current)
        elseif result < 0
            current = left(current)
        else
            break
        end
    end

    return if current === treenil
        treenil
    else
        current
    end
end

function haskey(tree::AbstractBinaryTree, data::T)::Bool where T
    tree.root === treenil && return false

    node = search(data, tree)
    return node === treenil
end

convert(::Type{BinaryTreeNode{T}}, node::BinaryTreeNode{E}) where {T, E <: T} = BinaryTreeNode{T}(node.data, node.left, node.right)
convert(::Type{Union{BinaryTreeNil, BinaryTreeNode{T}}}, node::BinaryTreeNode{E}) where {T, E <: T} = BinaryTreeNode{T}(node.data, node.left, node.right)
convert(::Type{AVLTreeNode{T}}, node::AVLTreeNode{E}) where {T, E <: T} = AVLTreeNode{T}(node.data, node.left, node.right, node.height)
convert(::Type{Union{BinaryTreeNil, AVLTreeNode{T}}}, node::AVLTreeNode{E}) where {T, E <: T} = AVLTreeNode{T}(node.data, node.left, node.right, node.height)
end