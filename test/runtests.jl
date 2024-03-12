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
using DataStructure.Graph

#= let tree = BinarySearchTree(Int, -)
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

# test graph
let graph = DirectedGraph(Int)
    for i in 1:13
        insertVertex!(graph, i)
    end

    for i in 2:4
        insertEdge!(graph, 1, i)
    end

    for i in 5:7
        insertEdge!(graph, 2, i)
    end

    for i in 8:10
        insertEdge!(graph, 3, i)
    end

    for i in 11:13
        insertEdge!(graph, 4, i)
    end

    for value in bfsIterate(graph)
        println(value)
    end
end

mutable struct Student
    name::String
    age::Int
end

let graph = DirectedGraph(Student)
    students = [
        Student("hello", 1),
        Student("world", 2),
        Student("fuck", 3),
        Student("you", 4),
        Student("holy", 5),
        Student("shit", 6)
    ]

    for student in students
        insertVertex!(graph, student)
    end

    for index in 2:6
        insertEdge!(graph, students[1], students[index])
    end

    for value in bfsIterate(graph)
        println(value)
    end

    students[1].name = "hello edit"
    println("after edit")
    for value in bfsIterate(graph)
        println(value)
    end

    students[2].name = "world edit"
    println("after edit")
    for value in bfsIterate(graph)
        println(value)
    end
end
 =#
let graph = UnDirectedGraph(Int)
    for i in 0:8
        insertVertex!(graph, i)
    end

    insertEdge!(graph, 0, 1, 3)
    insertEdge!(graph, 0, 5, 4)
    insertEdge!(graph, 1, 6, 6)
    insertEdge!(graph, 1, 2, 8)
    insertEdge!(graph, 1, 8, 5)
    insertEdge!(graph, 2, 8, 2)
    insertEdge!(graph, 2, 3, 12)
    insertEdge!(graph, 3, 8, 11)
    insertEdge!(graph, 3, 6, 14)
    insertEdge!(graph, 3, 7, 6)
    insertEdge!(graph, 3, 4, 10)

    insertEdge!(graph, 4, 7, 1)
    insertEdge!(graph, 4, 5, 18)
    insertEdge!(graph, 5, 6, 7)
    insertEdge!(graph, 6, 7, 9)

    println(kruskal(graph, nothing))
    println(prim(graph))
end

let graph = UnDirectedGraph(Char)
    for i in 'A':'G'
        insertVertex!(graph, i)
    end

    insertEdge!(graph, 'A', 'B', 7)
    insertEdge!(graph, 'A', 'D', 5)
    insertEdge!(graph, 'B', 'D', 9)
    insertEdge!(graph, 'B', 'C', 8)
    insertEdge!(graph, 'B', 'E', 7)
    insertEdge!(graph, 'C', 'E', 5)
    insertEdge!(graph, 'D', 'E', 15)
    insertEdge!(graph, 'D', 'F', 6)
    insertEdge!(graph, 'E', 'F', 8)
    insertEdge!(graph, 'E', 'G', 9)
    insertEdge!(graph, 'F', 'G', 11)

    println(kruskal(graph))
    println(prim(graph))
end

let graph = UnDirectedGraph(Char)
    insertVertex!(graph, 'A')
    insertVertex!(graph, 'B')
    insertVertex!(graph, 'D')
    insertVertex!(graph, 'E')

    insertEdge!(graph, 'A', 'B', 7)
    insertEdge!(graph, 'A', 'D', 5)
    insertEdge!(graph, 'B', 'D', 9)
    insertEdge!(graph, 'D', 'E', 15)
    insertEdge!(graph, 'B', 'E', 7)
    println(kruskal(graph))
    println(prim(graph))
end