local function split(str, delimiter)
    local result = {}
    for token in string.gmatch(str, "[^" .. delimiter .. "]+") do
        table.insert(result, token)
    end
    return result
end

local function binaryToDecimal(binary)
    local decimal = 0
    local power = 1

    for i = 7, 1, -1 do
        if binary[i] == 1 then
            decimal = decimal + power
        end
        power = power * 2
    end

    return decimal
end

local function invalidInput()
    print("INVALID")
    os.exit(0)
end

local function main()
    local encrypt = io.read()
    local splitedEncrypt = split(encrypt, ' ')
    local bytes = {0, 0, 0, 0, 0, 0, 0}
    local countByte = 0
    local answer = ""

    while #splitedEncrypt >= 2 do
        local digit = table.remove(splitedEncrypt, 1)
        local nbOccurrence = table.remove(splitedEncrypt, 1)

        if digit ~= "00" and digit ~= "0" then
            invalidInput()
        end

        for i = 1, #nbOccurrence do
            if nbOccurrence:sub(i, i) ~= '0' then
                invalidInput()
            end

            bytes[countByte + 1] = (digit == "00") and 0 or 1
            countByte = countByte + 1

            if countByte == 7 then
                answer = answer .. string.char(binaryToDecimal(bytes))
                countByte = 0
            end
        end
    end

    if #splitedEncrypt ~= 0 or countByte ~= 0 then
        invalidInput()
    end

    print(answer)
end

main()