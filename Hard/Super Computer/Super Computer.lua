local function readNumbers()
    local line = io.read()
    local numbers = {}
    for num in line:gmatch("%S+") do
        table.insert(numbers, tonumber(num))
    end
    return numbers
end

local n = tonumber(io.read())

local needs = {}
for i = 1, n do
    local start, dur = table.unpack(readNumbers())
    local endTime = start + dur - 1
    table.insert(needs, {start, endTime})
end

table.sort(needs, function(a, b)
    return a[2] < b[2]
end)

local calendar = 1
local occIndex = 1

for i = 2, n do
    local freeDate = needs[occIndex][2]
    local start = needs[i][1]
    if start > freeDate then
        calendar = calendar + 1
        occIndex = i
    end
end

print(calendar)