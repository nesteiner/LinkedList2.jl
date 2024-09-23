@enum HeapType begin
    MaxHeap
    MinHeap
end

function heapsort(array::AbstractVector{T}, type::HeapType)::Vector{T} where T
    adjustHeap!(array, type)
    result = T[]

    while !isempty(array)
        push!(result, extractHeap!(array, type))
    end

    return result
end

function adjustHeap!(array::AbstractVector, type::HeapType)
    parentindex = parentof(length(array))
    
    while parentindex >= 1
        leftindex = leftChild(parentindex)
        rightindex = rightChild(parentindex)

        # 更换策略
        # 先考虑左子节点
        # 再考虑右子节点
        if type == MaxHeap
            if leftindex <= length(array) && array[leftindex] > array[parentindex]
                swap!(array, leftindex, parentindex)
            end

            if rightindex <= length(array) && array[rightindex] > array[parentindex]
                swap!(array, rightindex, parentindex)
            end
        else
            if leftindex <= length(array) && array[leftindex] < array[parentindex]
                swap!(array, leftindex, parentindex)
            end
            
            if rightindex <= length(array) && array[rightindex] < array[parentindex]
                swap!(array, rightindex, parentindex)
            end
        end

        # parentindex 左移一位，下一次循环中处理相邻节点
        parentindex -= 1;
    end
end

function extractHeap!(array::AbstractVector{T}, type::HeapType)::T where T
    if isempty(array)
        throw(ErrorException("cannot operate on a empty array"))
    end
    
    result = array[1]
    swap!(array, 1, length(array))

    pop!(array)
    adjustHeap!(array, type)

    return result
end

leftChild(index::Int) = 2 * index
rightChild(index::Int) = 2 * index + 1
parentof(index::Int) = if index % 2 == 0
    floor(Int, index / 2)
else
    floor(Int, (index - 1) / 2)
end

swap!(array::AbstractVector, left::Int, right::Int) = array[left], array[right] = array[right], array[left]
