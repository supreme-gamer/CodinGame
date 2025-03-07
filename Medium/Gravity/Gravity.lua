local function readNumbers()
    local line = io.read()
    local numbers = {}
    for num in line:gmatch("%S+") do
        table.insert(numbers, tonumber(num))
    end
    return numbers
end

local dimensions = readNumbers()
local width, height = dimensions[1], dimensions[2]

local stacks = {}
for i = 1, width do
    stacks[i] = 0
end

for i = 1, height do
    local line = io.read()
    for a = 1, width do
        if line:sub(a, a) == '#' then
            stacks[a] = stacks[a] + 1
        end
    end
end

for i = 1, height do
    for a = 1, width do
        if stacks[a] >= height - i + 1 then
            io.write("#")
        else
            io.write(".")
        end
    end
    io.write("\n")
end