function partition!(array::AbstractVector{T}, left::Int, right::Int)::Int where T
    leftIndex = left
    rightIndex = right

    pivot = array[left]

    while leftIndex < rightIndex
        while leftIndex < rightIndex && array[rightIndex] >= pivot
            rightIndex -= 1
        end

        while leftIndex < rightIndex && array[leftIndex] <= pivot
            leftIndex += 1
        end

        array[leftIndex], array[rightIndex] = array[rightIndex], array[leftIndex]
    end

    array[leftIndex], array[left] = array[left], array[leftIndex]

    return leftIndex
end

function quicksort!(array::AbstractVector{T}) where T
    left = 1
    right = length(array)

    if left < right
        middle = partition!(array, left, right)
        quicksort!(@view(array[left : middle - 1]))
        quicksort!(@view(array[middle + 1 : right]))
    end
end