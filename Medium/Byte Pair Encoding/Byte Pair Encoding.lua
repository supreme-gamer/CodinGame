local cacheCountPair = {}

local function countPair(s, pair)
    local key = s .. ':' .. pair
    if cacheCountPair[key] then
        return cacheCountPair[key]
    end

    local count = 0
    local i = 1
    while i <= #s - 1 do
        if s:sub(i, i) == pair:sub(1, 1) and s:sub(i + 1, i + 1) == pair:sub(2, 2) then
            count = count + 1
            i = i + 2
        else
            i = i + 1
        end
    end

    cacheCountPair[key] = count
    return count
end

local function getMostCommonPair(s)
    local maxCount = -1
    local pair = ""

    for i = 1, #s - 1 do
        local _pair = s:sub(i, i + 1)
        local count = countPair(s, _pair)
        if count > maxCount then
            maxCount = count
            pair = _pair
        end
    end

    return pair, maxCount
end

local function replace(s, pair, bit)
    local result = ""
    local i = 1

    while i <= #s do
        if s:sub(i, i) == pair:sub(1, 1) and s:sub(i + 1, i + 1) == pair:sub(2, 2) then
            result = result .. bit
            i = i + 2
        else
            result = result .. s:sub(i, i)
            i = i + 1
        end
    end

    return result
end

local function main()
    local s = ""
    local transmutation = {}
    local n, m = io.read("*n", "*n")
    io.read()

    for _ = 1, n do
        local line = io.read()
        s = s .. line
    end

    local pair, count = getMostCommonPair(s)

    local i = 0
    while count > 1 do
        local c = string.char(string.byte('Z') - i)
        s = replace(s, pair, c)
        table.insert(transmutation, c .. " = " .. pair)
        pair, count = getMostCommonPair(s)
        i = i + 1
    end

    print(s)
    for _, t in ipairs(transmutation) do
        print(t)
    end
end

main()