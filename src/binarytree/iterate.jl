abstract type BinaryTreeIterator{T} end

struct LevelOrderIterator{T} <: BinaryTreeIterator{T} 
    node::Union{BinaryTreeNil, AbstractBinaryTreeConsNode{T}}
    length::Int
end

struct PreOrderIterator{T} <: BinaryTreeIterator{T}
    node::Union{BinaryTreeNil, AbstractBinaryTreeConsNode{T}}
    length::Int
end

mutable struct InOrderIterator{T} <: BinaryTreeIterator{T}
    node::Union{BinaryTreeNil, AbstractBinaryTreeConsNode{T}}
    length::Int
end

struct PostOrderIterator{T} <: BinaryTreeIterator{T}
    node::Union{BinaryTreeNil, AbstractBinaryTreeConsNode{T}}
    length::Int
end

length(iterator::BinaryTreeIterator) = iterator.length
levelorder(tree::AbstractBinaryTree) = LevelOrderIterator(tree.root, size(tree))
preorder(tree::AbstractBinaryTree) = PreOrderIterator(tree.root, size(tree))
postorder(tree::AbstractBinaryTree) = PostOrderIterator(tree.root, size(tree))
inorder(tree::AbstractBinaryTree) = InOrderIterator(tree.root, size(tree))

function iterate(iterator::LevelOrderIterator{T}) where T
    node = iterator.node
    node === treenil && return nothing

    queue = List(AbstractBinaryTreeNode)
    if hasleft(node)
        push!(queue, left(node))
    end

    if hasright(node)
        push!(queue, right(node))
    end

    return node, queue
end

function iterate(::LevelOrderIterator{T}, queue::List{<:AbstractBinaryTreeNode}) where T
    isempty(queue) && return nothing

    current = popfirst!(queue)

    if hasleft(current)
        push!(queue, left(current))
    end

    if hasright(current)
        push!(queue, right(current))
    end

    return current, queue
end

function iterate(iterator::PreOrderIterator{T}) where T
    node = iterator.node

    node === treenil && return nothing

    stack = List(AbstractBinaryTreeNode)
    push!(stack, node)
    current = pop!(stack)

    if hasright(current)
        push!(stack, right(current))
    end
       
    if hasleft(current)
        push!(stack, left(current))
    end

    return current, stack
end

function iterate(::PreOrderIterator{T}, stack::List{<:AbstractBinaryTreeNode}) where T
    isempty(stack) && return nothing

    current = pop!(stack)

    if hasright(current)
        push!(stack, right(current))
    end

    if hasleft(current)
        push!(stack, left(current))
    end

    return current, stack
end

function iterate(iterator::PostOrderIterator{T}) where T
    node = iterator.node
    node === treenil && return nothing

    stack = List(AbstractBinaryTreeNode)
    push!(stack, node)
    current = pop!(stack)

    if hasleft(current)
        push!(stack, left(current))
    end

    if hasright(current)
        push!(stack, right(current))
    end

    return current, stack
end

function iterate(::PostOrderIterator{T}, stack::List{<:AbstractBinaryTreeNode}) where T
    isempty(stack) && return nothing
    
    current = pop!(stack)

    if hasleft(current)
        push!(stack, left(current))
    end

    if hasright(current)
        push!(stack, right(current))
    end

    return current, stack
end

function iterate(iterator::InOrderIterator{T}) where T
    current = iterator.node
    current === treenil && return nothing

    stack = List(AbstractBinaryTreeNode)
    while current !== treenil
        push!(stack, current)
        current = left(current)
    end

    result = pop!(stack)

    iterator.node = right(result)

    return result, stack
end

function iterate(iterator::InOrderIterator{T}, stack::List{<:AbstractBinaryTreeNode}) where T
    current = iterator.node
    current === treenil && isempty(stack) && return nothing

    while current !== treenil
        push!(stack, current)
        current = left(current)
    end

    result = pop!(stack)
    iterator.node = right(result)

    return result, stack
end