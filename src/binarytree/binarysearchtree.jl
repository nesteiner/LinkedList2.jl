mutable struct BinarySearchTree{T} <: AbstractBinaryTree
    root::Union{BinaryTreeNil, BinaryTreeNode{T}}
    compare::Function
    length::Int
end

BinarySearchTree(T::DataType, compare::Function) = BinarySearchTree{T}(treenil, compare, 0)

function insert!(tree::BinarySearchTree{T}, data::T) where T
    tree.root = insertNode!(tree.root, data, tree.compare)
    tree.length += 1
end

function popat!(tree::BinarySearchTree{T}, node::BinaryTreeNode{T}) where T
    if isempty(tree)
        throw(BadOperation("cannot pop on a empty tree"))
    end

    parent = treenil
    current = tree.root
    delnode = current

    while current !== treenil && dataof(current) != dataof(node)
        result = tree.compare(dataof(current), dataof(node))
        if result > 0
            parent = current;
            current = left(current)
        elseif result < 0
            parent = current
            current = right(current)
        end
    end

    if current === treenil
        throw(BadOperation("no such node in the tree"))
    end

    if left(current) === treenil
        if current === tree.root
            tree.root = right(current)
        elseif current === left(parent)
            parent.left = right(current)
        else
            parent.right = right(current)
        end

    elseif right(current) === treenil
        if current === tree.root
            tree.root = left(current)
        elseif left(parent) === current
            parent.left = left(current)
        else
            parent.right = left(current)
            delnode = current
        end
    else
        leftNode = right(current)
        parent = current
        while left(leftNode) !== treenil
            parent = leftNode
            leftNode = left(leftNode)
        end

        delnode = leftNode
        current.data = dataof(leftNode)
        if left(parent) === leftNode
            parent.left = right(leftNode)
        else
            parent.right = right(leftNode)
        end
    end

    tree.length -= 1
    return dataof(delnode)
end