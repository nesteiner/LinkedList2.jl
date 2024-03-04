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

    println(tree)
    #= queue = List(AbstractBinaryTreeNode)
    root = tree.root
    push!(queue, root.right) =#
end

# TODO test if bs tree can insert Union type
let tree = BinarySearchTree(Number, -)
    for i in 1:10
        insert!(tree, i)
    end

    insert!(tree, 1.1)
    insert!(tree, 1.2)
    insert!(tree, 1.3)

    println(tree)
end

let tree = AVLTree(Int, -)
    for i in 1:10
        insert!(tree, i)
    end

    println(tree)
end

# iterate
let tree = AVLTree(Int, -)
    for i in 1:10
        insert!(tree, i)
    end

    println(collect(preorder(tree)))
    println(collect(inorder(tree)))
    println(collect(postorder(tree)))
    println(collect(levelorder(tree)))
end

# TODO test union type of binary search tree

# delete binarysearch tree
let tree = BinarySearchTree(Int, -)
    for i in 1:10
        insert!(tree, i)
    end

    node = search(4, tree)
    popat!(tree, node)

    for value in tree
        println(value)
    end
end