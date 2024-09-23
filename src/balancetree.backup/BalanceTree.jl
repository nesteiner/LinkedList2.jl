module BalanceTree
import Base: isempty, insert!, print, show

export BTree, BTreeNode, printnode

abstract type AbstractBTreeNode{T} end
BTreeNodeType{T} = Union{Nothing, AbstractBTreeNode{T}}

include("btreenode.jl")
include("btree.jl")


end