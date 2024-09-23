digitat(number::Int, n::Int)::Int = (number ÷ 10^(n - 1)) % 10

function radixsort!(array::AbstractVector{Int})
    buckets = map(_ -> Int[], 1:10)
    bucketCounts = zeros(Int, 10)

    maxvalue = reduce(max, array)
    maxposition = ceil(Int, log10(maxvalue)) + 1
    
    for index in 1:maxposition
        # 一轮循环中，将数组中的元素放入对应的桶中，groupby digitat(value, index)
        for value in array
            digit = digitat(value, index)
            insert!(buckets[digit + 1], bucketCounts[digit + 1] + 1, value)
            bucketCounts[digit + 1] += 1
        end


        # 放置完成后，将桶中的元素，平铺到原来的数组中
        position = 1
        for (index, bucket) in Iterators.enumerate(buckets)
            if bucketCounts[index] == 0
                continue
            end

            for count in 1:bucketCounts[index]
                array[position] = bucket[count]
                position += 1
            end

            bucketCounts[index] = 0
        end
    end
end