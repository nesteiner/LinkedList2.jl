module LinkedList

import Base: iterate, show, push!, pop!, popat!, pushfirst!, popfirst!,
    isempty, length,
    first, last,
    replace!, filter, keys, eltype, convert

export ForwardList, List, ForwardNode, ListNode, AbstractLinkedList, AbstractListNode, AbstractConsNode,
    iterate, show, push!, popat!, pushfirst!, popfirst!,
    isempty, length, first, last, replace!, filter, keys, eltype,
    insertNext!, removeNext!, dataof, NilNode
    
include("nodes.jl")
include("lists.jl")

end # module LinkedList
