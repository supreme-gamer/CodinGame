
local function read_grid(width, height)
    local grid = {}
    for i = 1, height do
        grid[i] = io.read()
    end
    return grid
end

local function extract_start_symbols(first_row)
    local symbols = {}
    for i = 1, #first_row do
        local char = first_row:sub(i, i)
        if char ~= ' ' then
            table.insert(symbols, char)
        end
    end
    return symbols
end

local function follow_path(grid, start_char, start_index)
    local current_index = start_index
    for _, row in ipairs(grid) do
        if current_index - 1 >= 1 and row:sub(current_index - 1, current_index - 1) == '-' then
            current_index = current_index - 3
        elseif current_index + 1 <= #row and row:sub(current_index + 1, current_index + 1) == '-' then
            current_index = current_index + 3
        end
    end
    return start_char .. grid[#grid]:sub(current_index, current_index)
end

local function main()
    local width, height = io.read("*n", "*n")
    io.read()
    
    local grid = read_grid(width, height)
    
    local start_symbols = extract_start_symbols(grid[1])
        for _, symbol in ipairs(start_symbols) do
        local start_index = grid[1]:find(symbol, 1, true)
        local result = follow_path(grid, symbol, start_index)
        print(result)
    end
end

main()