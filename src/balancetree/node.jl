@kwdef mutable struct BTreeNode{T}
    degree::Int
    keys::Vector{T} = T[]
    children::Vector{BTreeNode{T}} = BTreeNode{T}[]
    parent::Union{Nothing, BTreeNode{T}} = nothing
end

reachMaxKeys(node::BTreeNode) = length(node.keys) >= node.degree
isempty(node::BTreeNode) = length(node.keys) == 0
isleaf(node::BTreeNode) = length(node.children) == 0
isroot(node::BTreeNode) = isnothing(node.parent)

function rootof(node::BTreeNode)::BTreeNode
    current = node
    while !isroot(current)
        current = current.parent
    end

    return current
end

# TODO insert at root, return the root of node
# 在当前的 node 中插入数据
# data 表示要插入的数据
# nodeOfDataInRight 是在 split! 时不为空值，他这个时候表示分裂出的新节点
function insert!(node::BTreeNode{T}, data::T, nodeOfDataInRight::Union{Nothing, BTreeNode{T}})::BTreeNode{T} where T
    index = (Iterators.takewhile(x -> x < data, node.keys) |> collect |> length) + 1
    insert!(node.keys, index, data)
    
    if !isnothing(nodeOfDataInRight)
        insert!(node.children, index + 1, nodeOfDataInRight)
        nodeOfDataInRight.parent = node
    end

    root = if !reachMaxKeys(node)
        node
    else 
        split!(node)
    end
    
    return rootof(root)
end

# TODO split this node
# has been reachMaxKeys
function split!(node::BTreeNode{T})::BTreeNode{T} where T
    # 将 node.keys 分割成两部分，
    # 中间的元素是 upIndex, 我们取右边的 keys[upIndex + 1 : end] 来作为新节点的元素，
    # 将 children[upIndex + 2 : end] 来作为新节点的字节点元素
    upIndex = ceil(Int, node.degree / 2)
    up = node.keys[upIndex]

    rightKeys = node.keys[upIndex + 1 : end]
    rightChildren = node.children[upIndex + 2 : end]

    # 将冗余的数据去除
    deleteat!(node.keys, upIndex : length(node.keys))
    deleteat!(node.children, upIndex + 2 : length(node.children))

    # 新建一个节点作为新节点
    rightNode = BTreeNode{T}(degree = node.degree, keys = rightKeys, children = rightChildren)

    for child in rightChildren
        child.parent = rightNode
    end

    if isroot(node)    # 如果这个节点是根节点，新建一个节点作为新的根节点
        parent = BTreeNode{T}(degree = node.degree)
        push!(parent.keys, up)
        push!(parent.children, node, rightNode)

        node.parent = parent
        rightNode.parent = parent

        return parent
    else              # 不然的话，将 up 的值插入到 node.parent 中的 keys 中
        insert!(node.parent, up, rightNode)

        return node.parent
    end
end

function printnode(io::IO, node::BTreeNode, depth::Int)
    for _ in 1:depth
        print(io, "|    ")
    end

    if depth > 0
        print(io, "|-----")
    end

    print(io, node.keys)
    println(io)
    for child in node.children
        printnode(io, child, depth + 1)
    end
end

show(io::IO, node::BTreeNode) = printnode(io, node, 0)
print(io::IO, node::BTreeNode) = show(io, node)

function findnode(node::BTreeNode{T}, target::T)::BTreeNode{T} where T
    if isempty(node)
        return node
    end

    index = 1
    while index <= length(node.keys) && node.keys[index] <= target
        if node.keys[index] == target
            return node
        end

        index += 1
    end

    return if isleaf(node)
        node
    else
        findnode(node.children[index], target)
    end
end