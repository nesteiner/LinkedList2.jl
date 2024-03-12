module LinkedList

import Base: iterate, show, push!, pop!, popat!, pushfirst!, popfirst!,
    isempty, length,
    first, last,
    replace!, filter, keys, eltype, convert, copy
import DataStructure: BadOperationException

export ForwardList, List, ForwardNode, ListNode,
    iterate, show, push!, popat!, pushfirst!, popfirst!,
    isempty, length, first, last, replace!, filter, keys, eltype,
    insertNext!, removeNext!, dataof, NilNode, dataof
    
include("nodes.jl")
include("lists.jl")

function copy(list::ForwardList{T}) where T
    result = ForwardList(T)

    for value in list
        push!(result, value)
    end

    return result
end

function copy(list::List{T}) where T
    result = List(T)

    for value in list
        push!(result, value)
    end

    return result
end

end # module LinkedList
