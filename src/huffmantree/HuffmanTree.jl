module HuffmanTree

abstract type AbstractHuffmanTree end

struct HuffmanLeaf <: AbstractHuffmanTree
    symbol::Char
    frequency::Int
end

struct HuffmanNode <: AbstractHuffmanTree
    frequency::Int
    left::AbstractHuffmanTree
    right::AbstractHuffmanTree
end

tableRecurse!(leaf::HuffmanLeaf, code::String, dict::Dict{Char, String}) = dict[leaf.symbol] = code

function tableRecurse!(node::HuffmanNode, code::String, dict::Dict{Char, String})
    tableRecurse!(node.left, string(code, "1"), dict)
    tableRecurse!(node.right, string(code, "0"), dict)
end

function countmap(phrase::AbstractString)::Dict{Char, Int} 
    dict = Dict{Char, Int}()

    # question here
    for index in eachindex(phrase)
        ch = phrase[index]
        if !haskey(dict, ch)
            dict[ch] = 1
        else
            dict[ch] += 1
        end
    end

    return dict
end

function buildTable(node::AbstractHuffmanTree)::Dict{Char, String}
    dict = Dict{Char, String}()

    if isa(node, HuffmanLeaf)
        dict[node.symbol] = "0"
    else
        tableRecurse!(node, "", dict)
    end

    return dict
end

function buildTree(ftable::Dict{Char, Int})::AbstractHuffmanTree
    trees::Vector{AbstractHuffmanTree} = map(pair -> HuffmanLeaf(pair[1], pair[2]), collect(ftable))
    while length(trees) > 1
        sort!(trees, lt = (x, y) -> x.freq < y.freq, rev = true)
        least = pop!(trees)
        nextLeast = pop!(trees)
        push!(trees, HuffmanNode(least.frequency + nextLeast.frequency, least, nextLeast))
    end

    return first(trees)
end

encode(phrase::AbstractString, table::Dict{Char, String}) = reduce(string, map(value -> table[value], collect(phrase)))

function decode(huffmantree::AbstractHuffmanTree, bitstring::AbstractString)::AbstractString
    current = huffmantree
    finalString = ""

    for index in eachindex(bitstring)
        value = bitstring[index]
        if isa(huffmantree, HuffmanNode)
            if value == "1"
                current = current.left
            else
                current = current.right
            end

            if !isa(current, HuffmanNode)
                finalString += string(current.symbol)
                current = huffmantree
            end
        else
            finalString += string(huffmantree.symbol)
        end
    end

    return finalString
end
    
function huffmanCompress(phrase::AbstractString, huffmanTree::AbstractHuffmanTree)::AbstractString
    table = buildTable(huffmanTree)
    bitString = encode(phrase, table)
    return bitString
end

function huffmanUncompress(compressed::AbstractString, huffmanTree::AbstractHuffmanTree)::AbstractString
    finalString = decode(huffmanTree, compressed)
    return finalString
end

end