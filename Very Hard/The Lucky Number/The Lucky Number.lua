local function count_lucky_numbers(L, R)
    local L_str = tostring(L)
    local R_str = tostring(R)

    while #L_str < #R_str do
        L_str = "0" .. L_str
    end

    local memo = {}

    local function dp(pos, has_six, has_eight, tight_lower, tight_upper, num_str)
        if pos > #R_str then
            return (has_six or has_eight) and not (has_six and has_eight) and 1 or 0
        end

        local key = pos .. "_" .. tostring(has_six) .. "_" .. tostring(has_eight) .. "_" .. tostring(tight_lower) .. "_" .. tostring(tight_upper)
        if memo[key] ~= nil then
            return memo[key]
        end

        local lower_digit = tight_lower and tonumber(L_str:sub(pos, pos)) or 0
        local upper_digit = tight_upper and tonumber(R_str:sub(pos, pos)) or 9

        local count = 0
        for digit = lower_digit, upper_digit do
            local new_has_six = has_six or (digit == 6)
            local new_has_eight = has_eight or (digit == 8)
            local new_tight_lower = tight_lower and (digit == lower_digit)
            local new_tight_upper = tight_upper and (digit == upper_digit)

            count = count + dp(pos + 1, new_has_six, new_has_eight, new_tight_lower, new_tight_upper, num_str .. digit)
        end

        memo[key] = count
        return count
    end

    return dp(1, false, false, true, true, "")
end

local L, R = io.read("*n", "*n")

local result = count_lucky_numbers(L, R)
print(result)