local Node = {}
Node.__index = Node

function Node.new(frequency)
    local self = setmetatable({}, Node)
    self.frequency = frequency
    self.child = {}
    return self
end

local function dfs(node, code)
    local size = 0
    for i, child in ipairs(node.child) do
        local childCode = code .. (i % 2 == 1 and "0" or "1")
        size = size + dfs(child, childCode)
    end
    if #node.child == 0 then
        return #code * node.frequency
    end
    return size
end

local n = tonumber(io.read())
local inputs = io.read()
local frequencies = {}
for w in inputs:gmatch("%S+") do
    table.insert(frequencies, tonumber(w))
end

local tree = {}
for i = 1, n do
    table.insert(tree, Node.new(frequencies[i]))
end

if #tree == 1 then
    print(tree[1].frequency)
else
    while #tree > 1 do
        table.sort(tree, function(a, b)
            return a.frequency < b.frequency
        end)

        local node1 = table.remove(tree, 1)
        local node2 = table.remove(tree, 1)

        local newNode = Node.new(node1.frequency + node2.frequency)
        table.insert(newNode.child, node1)
        table.insert(newNode.child, node2)

        table.insert(tree, newNode)
    end

    print(dfs(tree[1], ""))
end