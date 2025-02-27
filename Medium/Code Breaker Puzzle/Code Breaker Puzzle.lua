local function findWord(s, word)
    return string.find(s, word) ~= nil
end

local function findPos(alphabet, c)
    return string.find(alphabet, c, 1, true) or 0
end

local function main()
    local alphabet = io.read()
    local message = io.read()
    local word = io.read()

    local alphabetLength = #alphabet
    local messageLength = #message

    for A = 0, alphabetLength - 1 do
        for B = 1, alphabetLength - 1 do
            local s = ""
            for i = 1, messageLength do
                local pos = findPos(alphabet, message:sub(i, i))
                pos = ((pos + A) * B) % alphabetLength
                s = s .. alphabet:sub(pos + 1, pos + 1)
            end

            if findWord(s, word) then
                print(s)
                return
            end
        end
    end
end

main()