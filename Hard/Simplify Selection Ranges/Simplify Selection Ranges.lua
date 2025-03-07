local function format_ranges(numbers)
    table.sort(numbers)
    local unique_numbers = {}
    local last = nil
    for _, num in ipairs(numbers) do
        if num ~= last then
            table.insert(unique_numbers, num)
            last = num
        end
    end

    local result = {}
    local start_index = 1

    for i = 1, #unique_numbers do
        if i == #unique_numbers or unique_numbers[i + 1] - unique_numbers[i] ~= 1 then
            if i - start_index + 1 >= 3 then
                table.insert(result, string.format("%d-%d", unique_numbers[start_index], unique_numbers[i]))
            else
                for j = start_index, i do
                    table.insert(result, tostring(unique_numbers[j]))
                end
            end
            start_index = i + 1
        end
    end

    return table.concat(result, ",")
end

local input = io.read()
local numbers = {}
for num in input:gmatch("%d+") do
    table.insert(numbers, tonumber(num))
end

local answer = format_ranges(numbers)
print(answer)