Pixel = {}
Pixel.__index = Pixel

function Pixel:new(r, g, b)
    local self = setmetatable({}, Pixel)
    self.r = r
    self.g = g
    self.b = b
    return self
end

function Pixel:toString()
    return self.r .. " " .. self.g .. " " .. self.b
end

local inputs = {}
for word in io.read():gmatch("%S+") do
    table.insert(inputs, tonumber(word))
end
local rows = inputs[1]
local cols = inputs[2]

local dir = {
    { -1, 0 }, 
    { 1, 0 }, 
    { 0, -1 }, 
    { 0, 1 } 
}

local arr = {}
for i = 1, rows do
    arr[i] = {}
    for j = 1, cols do
        local inputs = {}
        for word in io.read():gmatch("%S+") do
            table.insert(inputs, tonumber(word))
        end
        local r = inputs[1]
        local g = inputs[2]
        local b = inputs[3]
        arr[i][j] = Pixel:new(r, g, b)
    end
end

local function blendPixel(x, y)
    local neighbor = { arr[y][x] }
    for i = 1, #dir do
        local _x = x + dir[i][1]
        local _y = y + dir[i][2]
        if _x >= 1 and _x <= cols and _y >= 1 and _y <= rows then
            table.insert(neighbor, arr[_y][_x])
        end
    end
    local r, g, b = 0, 0, 0
    for i = 1, #neighbor do
        local pixel = neighbor[i]
        r = r + pixel.r
        g = g + pixel.g
        b = b + pixel.b
    end
    r = math.floor(r / #neighbor)
    g = math.floor(g / #neighbor)
    b = math.floor(b / #neighbor)
    return Pixel:new(r, g, b)
end

for i = 1, rows do
    for j = 1, cols do
        local newPixel = blendPixel(j, i)
        print(newPixel:toString())
    end
end