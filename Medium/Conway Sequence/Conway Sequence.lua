local function generate_sequence(R, L)
    local current_line = { R }

    for i = 2, L do
        local next_line = {}
        local count = 1

        for j = 2, #current_line do
            if current_line[j] == current_line[j - 1] then
                count = count + 1
            else
                table.insert(next_line, count)
                table.insert(next_line, current_line[j - 1])
                count = 1
            end
        end

        table.insert(next_line, count)
        table.insert(next_line, current_line[#current_line])

        current_line = next_line
    end

    return current_line
end

local function main()
    local R = tonumber(io.read())
    local L = tonumber(io.read())
    
    local result = generate_sequence(R, L)

        print(table.concat(result, " "))
end

main()