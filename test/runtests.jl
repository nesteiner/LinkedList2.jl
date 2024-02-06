using LinkedList

let list = List(Int)

    for i in 1:10
        push!(list, i)
    end

    println(list)

    for i in 1:10
        pop!(list)
        println(list)
    end
end

let list = List(Int)
    for i in 1:10
        pushfirst!(list, i)

        println(list)
    end
    
end

# test: pop at current