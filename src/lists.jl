abstract type AbstractLinkedList end

mutable struct ForwardList{T} <: AbstractLinkedList
    dummy::DummyNode{T}
    current::Union{DummyNode{T}, ForwardNode{T}}
    length::Int
    nodeConstructor::Function
end

function ForwardList(::Type{T}) where T
    dummy = DummyNode{T}(nothing)

    return ForwardList{T}(dummy, dummy, 0, (data::T) -> ForwardNode(data))
end

mutable struct List{T} <: AbstractLinkedList
    dummy::DummyNode{T}
    current::Union{DummyNode{T}, ListNode{T}}
    length::Int
    nodeConstructor::Function
end

function List(::Type{T}) where T
    dummy = DummyNode{T}(nothing)
    return List{T}(dummy, dummy, 0, (data::T) -> ListNode(data))
end

dummy(list::AbstractLinkedList) = list.dummy
current(list::AbstractLinkedList) = list.current
length(list::AbstractLinkedList) = list.length

keys(list::AbstractLinkedList) = next(dummy(list))
isempty(list::AbstractLinkedList) = length(list) == 0

nodeConstructor(list::AbstractLinkedList) = list.nodeConstructor

function push!(list::AbstractLinkedList, data::T) where T
    list.length += 1
    newnode = nodeConstructor(list)(data)

    insertNext!(list.current, newnode)
    list.current = next(list.current)
end

function pushfirst!(list::ForwardList, data::T) where T
    # TODO
end

function pushfirst!(list::List, data::T) where T
    list.length += 1
    newnode::ListNode = nodeConstructor(list)(data)
    unlink::Union{Nothing, ListNode} = next(dummy(list))

    if !isnothing(unlink)
        insertNext!(newnode, unlink)
    else
        newnode.next = nothing
        newnode.prev = dummy(list)
        list.current = newnode
    end

    insertNext!(dummy(list), newnode)
end

function pop!(list::T) where T <: AbstractLinkedList
    if isempty(list)
        throw(BadOperationException("the list is empty"))
    end

    list.length -= 1
    
    prevnode = prev(current(list), dummy(list))
    target = next(prevnode)
    removeNext!(prevnode)
    list.current = prevnode

    return dataof(target)
end

function popfirst!(list::T) where T <: AbstractLinkedList
    if isempty(list)
        throw(BadOperationException("the list is emtpy"))
    end

    list.length -= 1
    prevnode = dummy(list)
    target = next(prevnode)
    removeNext!(prevnode)

    if isempty(list)
        list.current = dummy(list)
    end

    return dataof(target)
end

function popat!(list::L, position::T) where {L <: AbstractLinkedList, T <: AbstractConsNode}
    list.length -= 1

    prevnode = prev(position, dummy(list))
    removeNext!(prevnode)

    if isempty(list)
        list.current = dummy(list)
    end

    dataof(position)
end

function pushnext!(list::L, position::E, data::T) where {L <: AbstractLinkedList, E <: AbstractConsNode, T}
    list.length += 1
    newnode = nodeConstructor(list)(data)
    unlink = next(position)
    insertNext!(newnode, unlink)
    insertNext!(position, newnode)
end

function iterate(list::T) where T <: AbstractLinkedList
    firstNode = next(dummy(list))
    return if isnothing(firstNode)
        firstNode
    else
        dataof(firstNode), next(firstNode)
    end
end

function iterate(::T, state::E) where {T <: AbstractLinkedList, E <: Union{AbstractConsNode, Nothing}}
    return if isnothing(state)
        nothing
    else
        dataof(state), next(state)
    end
end

replace!(node::Union{ForwardNode{T}, ListNode{T}}, data::T) where T = node.data = data

function first(list::AbstractLinkedList)
    firstnode = next(dummy(list))

    if isnothing(firstnode)
        throw(BadOperationException("there is no elements in the list"))
    end

    return dataof(firstnode)
end

function last(list::AbstractLinkedList)
    lastnode = current(list)

    if isnothing(lastnode)
        throw(BadOperationException("there is no elements in the list"))
    end

    return dataof(lastnode)
end

function contains(list::AbstractLinkedList, data::T)::Bool where T
    for value in list
        if value == data
            return true
        end
    end

    return false
end

function show(io::IO, list::AbstractLinkedList)
    print(io, "list: ")

    for value in list
        print(io, value, ' ')
    end
end

function filter(pred::Function, list::ForwardList{T})::ForwardList{T} where T
    result = ForwardList(T)

    for value in list
        if pred(value)
            push!(result)
        end
    end

    result
end

function filter(pred::Function, list::List{T})::List{T} where T
    result = ForwardList(T)

    for value in list
        if pred(value)
            push!(result)
        end
    end

    result
end