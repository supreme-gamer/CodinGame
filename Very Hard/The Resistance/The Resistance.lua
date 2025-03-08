local Alphabet = {
    ".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....",
    "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.",
    "--.-", ".-.", "...", "-", "..-", "...-", ".--", "-..-",
    "-.--", "--.."
}

local function morse(s)
    local res = ""
    for i = 1, #s do
        local char = s:sub(i, i)
        local index = string.byte(char) - 64
        res = res .. Alphabet[index]
    end
    return res
end

local function solve(start, a, dp, words)
    if start == #a then
        return 1
    end

    if dp[start] then
        return dp[start]
    end

    local res = 0

    for i = 1, #words do
        local word = words[i]
        local end_pos = start + #word
        if end_pos <= #a and a:sub(start + 1, end_pos) == word then
            res = res + solve(end_pos, a, dp, words)
        end
    end

    dp[start] = res
    return res
end

local l = io.read()
local n = tonumber(io.read())
local words = {}

for i = 1, n do
    local word = io.read()
    table.insert(words, morse(word))
end

local dp = {}
print(solve(0, l, dp, words))