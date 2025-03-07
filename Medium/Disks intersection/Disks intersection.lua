local function calculateDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

local function calculateIntersectionArea(d, r1, r2)
    local a = (r1^2 - r2^2 + d^2) / (2 * d)
    local _a = d - a
    local h = math.sqrt(r1^2 - a^2)

    local area1 = r1^2 * math.acos(a / r1) - a * h
    local area2 = r2^2 * math.acos(_a / r2) - _a * h

    return area1 + area2
end

local inputs1 = io.read()
local x1, y1, r1 = inputs1:match("(%S+)%s+(%S+)%s+(%S+)")
x1, y1, r1 = tonumber(x1), tonumber(y1), tonumber(r1)

local inputs2 = io.read()
local x2, y2, r2 = inputs2:match("(%S+)%s+(%S+)%s+(%S+)")
x2, y2, r2 = tonumber(x2), tonumber(y2), tonumber(r2)

local distance = calculateDistance(x1, y1, x2, y2)

if distance > r1 + r2 or distance == r1 + r2 then
    print("0.00")
elseif distance < math.abs(r1 - r2) then
    local smallerRadius = math.min(r1, r2)
    local area = math.pi * smallerRadius^2
    print(string.format("%.2f", area))
else
    local intersectionArea = calculateIntersectionArea(distance, r1, r2)
    print(string.format("%.2f", intersectionArea))
end