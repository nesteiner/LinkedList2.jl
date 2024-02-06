abstract type AbstractListNode end
abstract type AbstractConsNode{T} <: AbstractListNode end

mutable struct DummyNode{T} <: AbstractListNode
    next::Union{Nothing, AbstractConsNode{T}}
end

mutable struct ForwardNode{T} <: AbstractConsNode{T}
    data::T
    next::Union{Nothing, ForwardNode{T}}
end

mutable struct ListNode{T} <: AbstractConsNode{T}
    data::T
    next::Union{Nothing, ListNode{T}}
    prev::Union{Nothing, DummyNode{T}, ListNode{T}}
end

ForwardNode(data::T) where T = ForwardNode{T}(data, nothing)
ListNode(data::T) where T = ListNode{T}(data, nothing, nothing)

next(node::AbstractListNode) = node.next
dataof(node::AbstractConsNode) = node.data
prev(node::ListNode, ::DummyNode) = node.prev

function prev(node::ForwardNode, start::DummyNode)::Union{DummyNode, ForwardNode}
    cursor = next(start)
    prev = start

    while cursor != node
        prev = cursor
        cursor = next(cursor)
    end

    return prev
end

function insertNext!(node::DummyNode, nextnode::ForwardNode)
    nextOfDummy = node.next
    node.next = nextnode
    nextnode.next = nextOfDummy
end

function insertNext!(node::DummyNode, nextnode::ListNode)
    nextOfDummy = node.next
    node.next = nextnode
    nextnode.next = nextOfDummy
    nextnode.prev = node

    if !isnothing(nextOfDummy)
        nextOfDummy.prev = nextnode
    end
end

function insertNext!(node::ForwardNode, nextnode::ForwardNode) 
    nextOfNode::Union{Nothing, ForwardNode} = node.next

    nextnode.next = nextOfNode
    node.next = nextnode
end

function insertNext!(node::ListNode, nextnode::ListNode)
    nextOfDummy::Union{Nothing, ListNode} = node.next

    if !isnothing(nextOfDummy)
        nextOfDummy.prev = nextnode
    end

    nextnode.next = nextOfDummy

    node.next = nextnode
    nextnode.prev = node
end

function removeNext!(node::AbstractListNode)
    targetNode = next(node)

    if isnothing(targetNode)
        throw(BadOperationException("there is no more nodes to remove"))
    end

    unlinkNode::Union{Nothing, AbstractListNode} = next(targetNode)

    if !isnothing(unlinkNode)
        insertNext!(node, unlinkNode)
    else 
        node.next = unlinkNode
    end
end

iterate(node::AbstractListNode) = node, next(node)
iterate(::AbstractConsNode, nextnode::AbstractConsNode) = nextnode, next(nextnode)

show(io::IO, ::DummyNode) = print(io, "dummy ->")
show(io::IO, node::AbstractConsNode) = print(io, "$(dataof(node)) ->")

eltype(::DummyNode{T}) where T = T
eltype(::AbstractConsNode{T}) where T = T