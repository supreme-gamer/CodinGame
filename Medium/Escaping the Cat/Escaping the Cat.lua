local function main()
    local cat_speed = tonumber(io.read())

    local mouse_speed = 10.0
    local radius = 500.0
    local pi = math.pi
    local circumference = 2.0 * radius * pi

    local cat_speed_ratio = cat_speed / circumference

    circumference = mouse_speed / cat_speed_ratio

    local radius_mouse = circumference / (2.0 * pi)

    local ratio = (radius_mouse - 5.0) / radius

    local escaping = false
    local dist_to_escape = 0.0

    while true do
        local inputs = {}
        for input in io.read():gmatch("%S+") do
            table.insert(inputs, tonumber(input))
        end
        local mouseX, mouseY, catX, catY = inputs[1], inputs[2], inputs[3], inputs[4]

        local point_x = math.floor(-catX * ratio)
        local point_y = math.floor(-catY * ratio)

        if escaping then
            print(math.ceil(mouseX * 2.0) .. " " .. math.ceil(mouseY * 2.0))
        else
            print(point_x .. " " .. point_y)
        end

        dist_to_escape = math.sqrt(math.pow(point_x - mouseX, 2) + math.pow(point_y - mouseY, 2))

        if ratio < 0.5 then
            if dist_to_escape < 10.0 then
                escaping = true
            end
        else
            if dist_to_escape < 80.0 then
                escaping = true
            end
        end
    end
end

main()