local GRID_SIZE = 9
local SQUARE_SIZE = 3
local EMPTY = 0

local Point = {x = 0, y = 0}

local Sudoku = {}
Sudoku.__index = Sudoku

function Sudoku:new(grid)
    local obj = {
        grid = grid,
        history = {}
    }
    setmetatable(obj, Sudoku)
    return obj
end

function Sudoku:updateCase(x, y, value)
    self.grid[y][x] = value
    table.insert(self.history, {x = x, y = y})
end

function Sudoku:undo()
    local lastPlay = self.history[#self.history]
    self.grid[lastPlay.y][lastPlay.x] = EMPTY
    table.remove(self.history)
end

function Sudoku:firstEmpty()
    for y = 1, GRID_SIZE do
        for x = 1, GRID_SIZE do
            if self.grid[y][x] == EMPTY then
                return {x = x, y = y}
            end
        end
    end
    return {x = -1, y = -1}
end

function Sudoku:checkRow(index)
    local checked = {}
    for i = 1, GRID_SIZE do
        checked[i] = false
    end

    for x = 1, GRID_SIZE do
        local number = self.grid[index][x]
        if number ~= EMPTY then
            if checked[number] then
                return false
            end
            checked[number] = true
        end
    end
    return true
end

function Sudoku:checkCol(index)
    local checked = {}
    for i = 1, GRID_SIZE do
        checked[i] = false
    end

    for y = 1, GRID_SIZE do
        local number = self.grid[y][index]
        if number ~= EMPTY then
            if checked[number] then
                return false
            end
            checked[number] = true
        end
    end
    return true
end

function Sudoku:checkSquare(index)
    local checked = {}
    for i = 1, GRID_SIZE do
        checked[i] = false
    end

    local rowOffset = math.floor((index - 1) / SQUARE_SIZE) * SQUARE_SIZE
    local colOffset = ((index - 1) % SQUARE_SIZE) * SQUARE_SIZE

    for y = 1, SQUARE_SIZE do
        for x = 1, SQUARE_SIZE do
            local _y = y + rowOffset
            local _x = x + colOffset

            local number = self.grid[_y][_x]
            if number ~= EMPTY then
                if checked[number] then
                    return false
                end
                checked[number] = true
            end
        end
    end
    return true
end

function Sudoku:isValid()
    for i = 1, GRID_SIZE do
        if not self:checkRow(i) or not self:checkCol(i) or not self:checkSquare(i) then
            return false
        end
    end
    return true
end

function Sudoku:isEnd()
    local pos = self:firstEmpty()
    return pos.x == -1 and pos.y == -1
end

function Sudoku:getPossibleNumber(x, y)
    local checked = {}
    for i = 1, GRID_SIZE do
        checked[i] = false
    end

    for _x = 1, GRID_SIZE do
        local number = self.grid[y][_x]
        if number ~= EMPTY then
            checked[number] = true
        end
    end

    for _y = 1, GRID_SIZE do
        local number = self.grid[_y][x]
        if number ~= EMPTY then
            checked[number] = true
        end
    end

    local indexSquare = math.floor((y - 1) / SQUARE_SIZE) * SQUARE_SIZE + math.floor((x - 1) / SQUARE_SIZE) + 1
    local rowOffset = math.floor((indexSquare - 1) / SQUARE_SIZE) * SQUARE_SIZE
    local colOffset = ((indexSquare - 1) % SQUARE_SIZE) * SQUARE_SIZE

    for _y = 1, SQUARE_SIZE do
        for _x = 1, SQUARE_SIZE do
            local __y = _y + rowOffset
            local __x = _x + colOffset

            local number = self.grid[__y][__x]
            if number ~= EMPTY then
                checked[number] = true
            end
        end
    end

    local result = {}
    for i = 1, GRID_SIZE do
        if not checked[i] then
            table.insert(result, i)
        end
    end
    return result
end

local function solve(sudoku)
    if sudoku:isEnd() then
        return sudoku:isValid()
    end

    local pos = sudoku:firstEmpty()
    local possibleNumber = sudoku:getPossibleNumber(pos.x, pos.y)

    if #possibleNumber == 0 then
        sudoku:undo()
        return false
    end

    for _, n in ipairs(possibleNumber) do
        sudoku:updateCase(pos.x, pos.y, n)
        if solve(sudoku) then
            return true
        end
    end
    sudoku:undo()
    return false
end

local function main()
    local grid = {}
    for y = 1, GRID_SIZE do
        grid[y] = {}
        local line = io.read()
        for x = 1, GRID_SIZE do
            grid[y][x] = tonumber(line:sub(x, x))
        end
    end

    local s = Sudoku:new(grid)
    solve(s)

    for y = 1, GRID_SIZE do
        for x = 1, GRID_SIZE do
            io.write(s.grid[y][x])
        end
        io.write('\n')
    end
end

main()