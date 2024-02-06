module LinkedList

import Base: iterate, show, push!, pop!, popat!, pushfirst!, popfirst!,
    isempty, length,
    first, last,
    replace!, filter, keys, eltype

export ForwardList, List, ForwardNode, ListNode, AbstractLinkedList, AbstractListNode, AbstractConsNode,
    iterate, show, push!, popat!, pushfirst!, popfirst!,
    isempty, length, first, last, replace!, filter, keys, eltype,
    insertNext!, removeNext!, dataof
    
include("nodes.jl")
include("exceptioins.jl")
include("lists.jl")

end # module LinkedList
