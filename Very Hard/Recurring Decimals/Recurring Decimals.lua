local function fractionToDecimal(numr, denr)
    local res = ""
    local mp = {}
    local rem = numr % denr
    local aaa = tostring(math.floor(numr / denr)) .. "."

    while rem ~= 0 and not mp[rem] do
        mp[rem] = #res
        rem = rem * 10
        local res_part = math.floor(rem / denr)
        aaa = aaa .. tostring(res_part)
        res = res .. tostring(res_part)
        rem = rem % denr
    end

    if rem == 0 then
        return aaa
    else
        local start_pos = mp[rem] + 1
        local period = res:sub(start_pos)
        return aaa:sub(1, #aaa - #period) .. "(" .. period .. ")"
    end
end

local n = tonumber(io.read())

print(fractionToDecimal(1, n))