local function parse_time(time_str)
    local pattern = "(%d+):(%d+):(%d+)"
    local hour, min, sec = time_str:match(pattern)
    if not hour or not min or not sec then
        error("Invalid time format. Expected HH:MM:SS, got: " .. time_str)
    end
    return {
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec)
    }
end

local function compare_times(time1, time2)
    if time1.hour < time2.hour then
        return true
    elseif time1.hour == time2.hour then
        if time1.min < time2.min then
            return true
        elseif time1.min == time2.min then
            return time1.sec < time2.sec
        end
    end
    return false
end

local function main()
    local N = tonumber(io.read())
    if not N then
        error("Invalid input for N. Expected a number.")
    end

    local inputs = {}
    local earliest_time = { hour = math.huge, min = math.huge, sec = math.huge }
    local answer = 0

    for i = 1, N do
        inputs[i] = io.read()
        if not inputs[i] then
            error("Invalid input for time " .. i)
        end

        local current_time = parse_time(inputs[i])
        if compare_times(current_time, earliest_time) then
            earliest_time = current_time
            answer = i
        end
    end

    print(inputs[answer])
end

main()