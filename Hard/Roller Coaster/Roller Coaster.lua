local places, rides, group_nm = io.read("*n"), io.read("*n"), io.read("*n")

local groups = {}
for _ = 1, group_nm do
    table.insert(groups, io.read("*n"))
end

local profits = {}
local groups_after = {}

for i = 1, group_nm do
    local current_index = i
    profits[i] = 0

    while true do
        local next_grp = groups[current_index]

        if profits[i] + next_grp > places then
            break
        end

        profits[i] = profits[i] + next_grp

        current_index = current_index + 1

        if current_index > group_nm then
            current_index = 1
        end

        if current_index == i then
            break
        end
    end

    groups_after[i] = current_index
end

local total = 0
local current_index = 1

for _ = 1, rides do
    total = total + profits[current_index]
    current_index = groups_after[current_index]
end

print(total)