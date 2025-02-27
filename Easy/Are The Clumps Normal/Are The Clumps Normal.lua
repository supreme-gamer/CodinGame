local function count_clumps(number, base_value)
    local clumps = 0
    local prev_remainder = nil

    for digit in number:gmatch(".") do
        local remainder = tonumber(digit) % base_value

        if prev_remainder == nil or remainder ~= prev_remainder then
            clumps = clumps + 1
            prev_remainder = remainder
        end
    end

    return clumps
end

local function find_first_deviation(number)
    local previous_clumps = nil

    for base = 2, 9 do
        local clumps = count_clumps(number, base)

        if previous_clumps ~= nil and clumps < previous_clumps then
            return base
        end

        previous_clumps = clumps
    end

    return "Normal"
end

local N = io.read("*l"):match("^%s*(.-)%s*$")
print(find_first_deviation(N))
