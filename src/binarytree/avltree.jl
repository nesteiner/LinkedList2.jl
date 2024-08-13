mutable struct AVLTree{T} <: AbstractBinarySearchTree
    root::Union{AVLTreeNode{T}, BinaryTreeNil}
    size::Int
    compare::Function
end

AVLTree(::Type{T}, compare::Function) where T = AVLTree{T}(treenil, 0, compare)

function insert!(tree::AVLTree{T}, data::T) where T
    tree.root = insertAVLNode!(tree.root, data, tree.compare)
    tree.size += 1
end

function popat!(tree::AVLTree{T}, node::AVLTreeNode{T})::T where T
    isempty(tree) && throw(BadOperationException("cannot pop on a empty tree"))

    savedNode = node
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
            tree.size = 0
        elseif parent.left === current
            parent.left = treenil
        else
            parent.right = treenil
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
        updateHeight(parent)
    end

    tree.size -= 1

    if parentOf(savedNode, tree) === treenil
        return dataof(node)
    end

    nodez = parentOf(parentOf(savedNode, tree), tree)

    if nodez === treenil
        return dataof(node)
    end

    nodey = if height(left(nodez)) > height(right(nodez))
        left(nodez)
    else
        right(nodez)
    end

    if nodey === treenil
        return dataof(node)
    end

    rebalance!(nodez)
    
    return dataof(node)
end

keys(tree::AVLTree) = levelorder(tree)