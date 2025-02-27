local function find_minimal_base(equation)
    local parts = {}
    for part in string.gmatch(equation, "[^=+]+") do
        table.insert(parts, part)
    end
    local x_str, y_str, z_str = parts[1], parts[2], parts[3]

    local max_char = string.char(math.max(string.byte(x_str .. y_str .. z_str, 1, #x_str + #y_str + #z_str)))
    local min_base
    if '0' <= max_char and max_char <= '9' then
        min_base = tonumber(max_char) + 1
    else
        min_base = string.byte(max_char) - string.byte('A') + 11
    end

    local function to_decimal(num_str, base)
        local result = 0
        for i = 1, #num_str do
            local char = num_str:sub(i, i)
            local value
            if '0' <= char and char <= '9' then
                value = tonumber(char)
            else
                value = string.byte(char) - string.byte('A') + 10
            end
            result = result * base + value
        end
        return result
    end

    for base = min_base, 36 do
        local x = to_decimal(x_str, base)
        local y = to_decimal(y_str, base)
        local z = to_decimal(z_str, base)
        if x + y == z then
            return base
        end
    end

    return -1
end

local equation = io.read()

print(find_minimal_base(equation))