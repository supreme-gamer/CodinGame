local function SWAP(phrase, input, swap)
    local result = ""
    for i = 1, #phrase do
        local c = phrase:sub(i, i)
        if table.contains(input, c) then
            result = result .. table.remove(swap, 1)
        else
            result = result .. c
        end
    end
    return result
end

local function DECODE1(phrase)
    local words = {}
    for word in phrase:gmatch("%S+") do
        table.insert(words, word)
    end
    
    for i = 1, math.floor(#words / 2) do
        words[i], words[#words - i + 1] = words[#words - i + 1], words[i]
    end
    
    phrase = phrase:gsub("%s", "")
    local result = ""
    for i = 1, #words do
        result = result .. phrase:sub(1, #words[i]) .. " "
        phrase = phrase:sub(#words[i] + 1)
    end
    return result:trim()
end

local function DECODE2(phrase)
    local fourth = {}
    for i = 0, 25 do
        if i % 4 == 3 then
            table.insert(fourth, string.char(i + 65))
        end
    end
    local swap = {}
    local swapLetters = {}
    for c in phrase:gmatch(".") do
        if table.contains(fourth, c) then
            table.insert(swapLetters, c)
        end
    end
    if #swapLetters >= 2 then
        table.insert(swap, swapLetters[#swapLetters])
        for i = 1, #swapLetters - 1 do
            table.insert(swap, swapLetters[i])
        end
    end
    return SWAP(phrase, fourth, swap)
end

local function DECODE3(phrase)
    local third = {}
    for i = 0, 25 do
        if i % 3 == 2 then
            table.insert(third, string.char(i + 65))
        end
    end
    local swap = {}
    local swapLetters = {}
    for c in phrase:gmatch(".") do
        if table.contains(third, c) then
            table.insert(swapLetters, c)
        end
    end
    if #swapLetters >= 2 then
        for i = 2, #swapLetters do
            table.insert(swap, swapLetters[i])
        end
        table.insert(swap, swapLetters[1])
    end
    return SWAP(phrase, third, swap)
end

local function DECODE4(phrase)
    local second = {}
    for i = 0, 25 do
        if i % 2 == 1 then
            table.insert(second, string.char(i + 65))
        end
    end
    local swap = {}
    local swapLetters = {}
    for c in phrase:reverse():gmatch(".") do
        if table.contains(second, c) then
            table.insert(swap, c)
        end
    end
    return SWAP(phrase, second, swap)
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function string.trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function main()
    local phrase = io.read()
    phrase = DECODE1(phrase)
    phrase = DECODE2(phrase)
    phrase = DECODE3(phrase)
    phrase = DECODE4(phrase)
    print(phrase)
end

main()