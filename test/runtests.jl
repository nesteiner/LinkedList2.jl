#= using DataStructure.LinkedList

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

# test: pop at current =#

using DataStructure.BinaryTree
using DataStructure.LinkedList

let tree = BinarySearchTree(Int, -)
    for i in 1:10
        insert!(tree, i)
    end

    queue = List(AbstractBinaryTreeNode)
    root = tree.root
    push!(queue, root.right)
end