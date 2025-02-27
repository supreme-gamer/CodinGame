local FOREST_SIZE = 6

local function read_forest()
    local forest = {}
    for i = 1, FOREST_SIZE do
        forest[i] = io.read()
    end
    return forest
end

local function count_fires_and_trees(forest)
    local tree_need_cut = 0
    local count_fire = 0
    local count_not_tree_fire = 0

    local offsets = {
        {-2, -2}, {-2, -1}, {-2, 0}, {-2, 1}, {-2, 2},
        {-1, -2}, {-1, -1}, {-1, 0}, {-1, 1}, {-1, 2},
        {0, -2}, {0, -1}, {0, 1}, {0, 2},
        {1, -2}, {1, -1}, {1, 0}, {1, 1}, {1, 2},
        {2, -2}, {2, -1}, {2, 0}, {2, 1}, {2, 2}
    }

    for i = 1, FOREST_SIZE do
        for j = 1, FOREST_SIZE do
            if forest[i]:sub(j, j) == '*' then
                count_fire = count_fire + 1
                for _, offset in ipairs(offsets) do
                    local ni = i + offset[1]
                    local nj = j + offset[2]
                    if ni >= 1 and ni <= FOREST_SIZE and nj >= 1 and nj <= FOREST_SIZE then
                        if forest[ni]:sub(nj, nj) == '#' then
                            tree_need_cut = tree_need_cut + 1
                            forest[ni] = forest[ni]:sub(1, nj - 1) .. '0' .. forest[ni]:sub(nj + 1)
                        end
                    end
                end
            elseif forest[i]:sub(j, j) == '=' or forest[i]:sub(j, j) == 'o' then
                count_not_tree_fire = count_not_tree_fire + 1
            end
        end
    end

    return count_fire, tree_need_cut, count_not_tree_fire
end

local function print_result(count_fire, tree_need_cut, count_not_tree_fire)
    if count_fire == 0 then
        print("RELAX")
    elseif count_fire + tree_need_cut + count_not_tree_fire == FOREST_SIZE * FOREST_SIZE or tree_need_cut == 0 then
        print("JUST RUN")
    else
        print(tree_need_cut)
    end
end

local function main()
    local forest = read_forest()
    local count_fire, tree_need_cut, count_not_tree_fire = count_fires_and_trees(forest)
    print_result(count_fire, tree_need_cut, count_not_tree_fire)
end

main()