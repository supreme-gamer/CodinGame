local function luhn_check(card_number)
    local digits = {}
    for d in card_number:gmatch("%d") do
        table.insert(digits, tonumber(d))
    end
    
    local n_digits = #digits
    local sum_modified = 0
    
    for i = n_digits, 1, -2 do
        local doubled = digits[i]
        if i > 1 then
            local prev = digits[i - 1] * 2
            if prev > 9 then
                prev = prev - 9
            end
            sum_modified = sum_modified + prev
        end
        sum_modified = sum_modified + doubled
    end
    
    return sum_modified % 10 == 0
end

local function main()
    local n = tonumber(io.read())
    if not n then return end
    
    local results = {}
    for i = 1, n do
        local card_number = io.read()
        if luhn_check(card_number) then
            table.insert(results, "YES")
        else
            table.insert(results, "NO")
        end
    end
        
    print(table.concat(results, "\n"))
end

main()
