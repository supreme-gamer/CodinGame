local c = tonumber(io.read())
local candidate = {}
for i = 1, c do
    candidate[i] = io.read()
end

local v = tonumber(io.read())
local votes = {}
for i = 1, v do
    local vote = {}
    for x in io.read():gmatch("%d+") do
        table.insert(vote, tonumber(x))
    end
    table.insert(votes, vote)
end

local remaining_candidates = c
while remaining_candidates > 1 do
    local count_votes = {}
    for i = 1, c do
        count_votes[i] = 0
    end

    for _, vote in ipairs(votes) do
        if vote[1] then
            count_votes[vote[1]] = count_votes[vote[1]] + 1
        end
    end

    local min_votes = math.huge
    local l_id = 0
    for id, _ in pairs(candidate) do
        local v = count_votes[id]
        if v < min_votes then
            min_votes = v
            l_id = id
        end
    end

    if l_id > 0 then
        print(candidate[l_id])
        candidate[l_id] = nil
        remaining_candidates = remaining_candidates - 1
    end

    for _, vote in ipairs(votes) do
        for i = #vote, 1, -1 do
            if vote[i] == l_id then
                table.remove(vote, i)
            end
        end
    end
end

local winner = next(candidate)
if winner then
    print("winner:" .. candidate[winner])
else
    print("No winner found.")
end