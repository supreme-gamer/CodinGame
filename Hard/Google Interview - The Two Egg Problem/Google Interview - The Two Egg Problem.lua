local N = tonumber(io.read())

local discriminant = 1 + 8 * N
local x = (-1 + math.sqrt(discriminant)) / 2

local result = math.ceil(x)

print(result)