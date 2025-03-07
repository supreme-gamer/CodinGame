local function readNumber()
    return tonumber(io.read())
end

local n = readNumber()
local c = readNumber()

local budgets = {}
for i = 1, n do
    budgets[i] = readNumber()
end
table.sort(budgets)

local totalBudget = 0
for _, budget in ipairs(budgets) do
    totalBudget = totalBudget + budget
end

if totalBudget < c then
    print("IMPOSSIBLE")
else
    local contributions = {}
    for i = 1, n do
        contributions[i] = 0
    end

    local remainingAmount = c

    for i = 1, n do
        local maxContribution = math.min(budgets[i], remainingAmount // (n - i + 1))
        contributions[i] = maxContribution
        remainingAmount = remainingAmount - maxContribution
    end

    for _, contribution in ipairs(contributions) do
        print(contribution)
    end
end