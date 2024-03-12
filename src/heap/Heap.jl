module Heap

import Base: push!, length, isempty, first, keys, getindex, show
import DataStructure: BadOperationException
export BinaryHeap, topn, extract!

mutable struct BinaryHeap{T}
    length::Int
    compare::Function
    treeArray::Vector{T}
end

BinaryHeap(::Type{T}, compare::Function) where T = BinaryHeap{T}(0, compare, T[])

parentIndex(index::Int) = floor(Int, index / 2)
leftIndex(index::Int) = 2 * index
rightIndex(index::Int) = leftIndex(index) + 1

function push!(heap::BinaryHeap{T}, data::T) where T
    ipos = heap.length + 1
    ppos = parentIndex(ipos)
    push!(heap.treeArray, data)

    while ipos > 1 && heap.compare(heap.treeArray[ppos], heap.treeArray[ipos]) > 0
        heap.treeArray[ipos], heap.treeArray[ppos] = heap.treeArray[ppos], heap.treeArray[ipos]

        ipos = ppos
        ppos = parentIndex(ipos)
    end

    heap.length += 1
end


function extract!(heap::BinaryHeap{T}) where T
    heap.length == 0 && throw(BadOperationException("cannot extract on a empty heap"))

    result = first(heap.treeArray)
    save = heap.treeArray[heap.length]

    heap.length -= 1
    heap.treeArray[1] = save

    ipos = 1
    mpos = 1

    while true
        lpos = leftIndex(ipos)
        rpos = rightIndex(ipos)

        if lpos <= heap.length && heap.compare(heap.treeArray[lpos], heap.treeArray[ipos]) < 0
            mpos = lpos
        else
            mpos = ipos
        end

        if rpos <= heap.length && heap.compare(heap.treeArray[rpos], heap.treeArray[mpos]) < 0
            mpos = rpos
        end

        if mpos == ipos
            break
        else
            heap.treeArray[mpos], heap.treeArray[ipos] = heap.treeArray[ipos], heap.treeArray[mpos]

            ipos = mpos
        end
    end

    pop!(heap.treeArray)
    return result
end

length(heap::BinaryHeap) = heap.length
isempty(heap::BinaryHeap) = length(heap) == 0

function topn(heap::BinaryHeap, n::Int)
    if n > length(heap)
        throw(BadOperationException("n cannot larger than heap size"))
    end

    return heap.treeArray[1:n]
end

function first(heap::BinaryHeap)
    isempty(heap) && throw(BadOperationException("heap is empty"))

    return first(heap.treeArray)
end

keys(heap::BinaryHeap) = keys(heap.treeArray[1:length(heap)])

function getindex(heap::BinaryHeap, index::Int)
    if index > length(heap)
        throw(BadOperationException("index out of range"))
    end

    return heap.treeArray[index]
end

function show(io::IO, heap::BinaryHeap{T}) where T
    for index in 1:heap.length
        print(io, heap.treeArray[index])
    end
end

end