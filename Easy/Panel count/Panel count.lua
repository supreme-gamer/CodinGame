
function split(str, sep)
    local result = {}
    for part in str:gmatch("([^" .. sep .. "]+)") do
        table.insert(result, part)
    end
    return result
end


local P = tonumber(io.read())
local properties = {}


for i = 1, P do
    properties[i] = io.read()
end


local N = tonumber(io.read())
local persons = {}

for i = 1, N do
    local line = io.read()
    local name, rest = line:match("^(%S+)%s+(.+)$")
    local person = {name = name}
    local values = split(rest, " ")
    for j, value in ipairs(values) do
        person[properties[j]] = value
    end
    table.insert(persons, person)
end

local F = tonumber(io.read())

local function parse_formula(formula)
    local conditions = {}
    for property, value in formula:gmatch("(%w+)=(%w+)") do
        conditions[property] = value
    end
    return conditions
end

for i = 1, F do
    local formula = io.read()
    local conditions = parse_formula(formula)
    local count = 0

    for _, person in ipairs(persons) do
        local matches = true
        for property, value in pairs(conditions) do
            if person[property] ~= value then
                matches = false
                break
            end
        end
        if matches then
            count = count + 1
        end
    end

    print(count)
end
