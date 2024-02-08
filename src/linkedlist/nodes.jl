abstract type AbstractListNode end
abstract type AbstractListNextNode{T} <: AbstractListNode end
abstract type AbstractListConsNode{T} <: AbstractListNextNode{T} end
abstract type AbstractListConsDoubleNode{T} <: AbstractListConsNode{T} end

struct NilNode <: AbstractListNode end
nil = NilNode()

mutable struct ForwardDummyNode{T} <: AbstractListNextNode{T}
    next::Union{NilNode, AbstractListConsNode{T}}
end

mutable struct ListDummyNode{T} <: AbstractListNextNode{T}
    next::Union{NilNode, AbstractListConsDoubleNode{T}}
end

mutable struct ForwardNode{T} <: AbstractListConsNode{T}
    data::T
    next::Union{NilNode, ForwardNode{T}}
end

mutable struct ListNode{T} <: AbstractListConsDoubleNode{T}
    data::T
    next::Union{NilNode, ListNode{T}}
    prev::Union{ListDummyNode{T}, ListNode{T}}
end

next(node::AbstractListNextNode) = node.next
prev(node::ListNode, ::AbstractListNextNode) = node.prev
function prev(node::ForwardNode, start::AbstractListNextNode) 
    cursor = next(start)
    prev = start

    while cursor !== node
        prev = cursor
        cursor = next(cursor)
    end

    return prev
end

dataof(node::AbstractListConsNode) = node.data

function insertNext!(node::AbstractListNextNode, nextnode::AbstractListNode)
    node.next = nextnode
end

function insertNext!(node::AbstractListNextNode, nextnode::ListNode) 
    node.next = nextnode
    nextnode.prev = node
end

function removeNext!(node::AbstractListNextNode)
    target = next(node)
    unlink = next(target)

    insertNext!(node, unlink)
end

iterate(node::AbstractListConsNode) = node, next(node)
iterate(::AbstractListConsNode, nextnode::AbstractListConsNode) = nextnode, next(nextnode)
iterate(::AbstractListConsNode, ::NilNode) = nothing
iterate(::NilNode) = nothing

show(io::IO, node::AbstractListConsNode) = print(io, dataof(node))
show(io::IO, ::NilNode) = print(io, "nil")
show(io::IO, ::ForwardDummyNode) = print(io, "dummy")
show(io::IO, ::ListDummyNode) = print(io, "dummy")




