mutable struct BinarySearchTree{T} <: AbstractBinarySearchTree
    root::Union{BinaryTreeNil, BinaryTreeNode{T}}
    compare::Function
    size::Int
end

BinarySearchTree(::Type{T}, compare::Function) where T = BinarySearchTree{T}(treenil, compare, 0)

function insert!(tree::BinarySearchTree{T}, data::T) where T
    tree.root = insertNode!(tree.root, data, tree.compare)
    tree.size += 1
end

function popat!(tree::BinarySearchTree{T}, node::BinaryTreeNode{T}) where T
    isempty(tree) && throw(BadOperationException("cannot pop on a empty tree"))

    parent = treenil
    current = tree.root

    while current !== treenil && current !== node
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
        throw(BadOperationException("no such value in the tree"))
    end

    if !hasleft(current) && !hasright(current)
        if current === tree.root
            tree.root = treenil
        elseif parent.left === current
            parent.left = treenil
            updateHeight(parent)
        else
            parent.right = treenil
            updateHeight(parent)
        end
    elseif hasleft(current) && !hasright(current)
        if current === tree.root
            tree.root = left(current)
            updateHeight(tree.root)
        elseif current === left(parent)
            parent.left = left(current)
            updateHeight(parent)
        else
            parent.right = left(current)
            updateHeight(parent)
        end
    elseif !hasleft(current) && hasright(current)
        if current === tree.root
            tree.root = right(current)
            updateHeight(tree.root)
        elseif current === left(parent)
            parent.left = right(current)
            updateHeight(parent)
        else
            parent.right = right(current)
            updateHeight(parent)
        end
    else
        iterator = InOrderIterator(right(current), 0) # it seems we never used length
        parent = right(current)
        node = first(iterator)
        current, node = node, current
        parent.left = treenil
    end

    tree.size -= 1
    return dataof(node)
end

keys(tree::BinarySearchTree) = levelorder(tree)