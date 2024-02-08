abstract type AbstractListNode end
abstract type AbstractConsNode{T} <: AbstractListNode end

struct NilNode <: AbstractListNode end

nil = NilNode()

mutable struct DummyNode{T} <: AbstractListNode
    next::Union{NilNode, AbstractConsNode{T}}
end

mutable struct ForwardNode{T} <: AbstractConsNode{T}
    data::T
    next::Union{NilNode, ForwardNode{T}}
end

mutable struct ListNode{T} <: AbstractConsNode{T}
    data::T
    next::Union{NilNode, ListNode{T}}
    prev::Union{NilNode, DummyNode{T}, ListNode{T}}
end

convert(::Type{AbstractConsNode{T}}, node::E) where {T, E <: AbstractConsNode} = node

ForwardNode(data::T) where T = ForwardNode{T}(data, nil)
ListNode(data::T) where T = ListNode{T}(data, nil, nil)

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


#=
ATTENTION: 使用这个 insertNext! 的时候，前面的参数 node 必须是链表里的结点，如果是新结点的话，会出现错误
nextnode 必须是新结点
=#
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

    if nextOfDummy !== nil
        nextOfDummy.prev = nextnode
    end
end

function insertNext!(node::ForwardNode, nextnode::ForwardNode) 
    nextOfNode::Union{NilNode, ForwardNode} = node.next

    nextnode.next = nextOfNode
    node.next = nextnode
end

function insertNext!(node::ListNode, nextnode::ListNode)
    nextOfDummy::Union{NilNode, ListNode} = node.next

    if nextOfDummy !== nil
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

    unlinkNode::AbstractListNode = next(targetNode)

    if unlinkNode !== nil
        # insertNext!(node, unlinkNode)
        node.next = unlinkNode

        if isa(unlinkNode, ListNode)
            unlinkNode.prev = node
        end
    else 
        node.next = unlinkNode
    end
end

iterate(::NilNode) = nothing
iterate(node::AbstractConsNode) = node, next(node)
iterate(::AbstractConsNode, nextnode::AbstractConsNode) = nextnode, next(nextnode)

show(io, ::NilNode) = print(io, "nil")
show(io::IO, ::DummyNode) = print(io, "dummy ->")
show(io::IO, node::AbstractConsNode) = print(io, "$(dataof(node)) ->")

eltype(::DummyNode{T}) where T = T
eltype(::AbstractConsNode{T}) where T = T