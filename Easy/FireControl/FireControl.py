FOREST_SIZE = 6

def read_forest():
    return [input().strip() for _ in range(FOREST_SIZE)]

def count_fires_and_trees(forest):
    tree_need_cut = 0
    count_fire = 0
    count_not_tree_fire = 0

    offsets = [
        (-2, -2), (-2, -1), (-2, 0), (-2, 1), (-2, 2),
        (-1, -2), (-1, -1), (-1, 0), (-1, 1), (-1, 2),
        (0, -2), (0, -1), (0, 1), (0, 2),
        (1, -2), (1, -1), (1, 0), (1, 1), (1, 2),
        (2, -2), (2, -1), (2, 0), (2, 1), (2, 2)
    ]

    for i in range(FOREST_SIZE):
        for j in range(FOREST_SIZE):
            if forest[i][j] == '*':
                count_fire += 1
                for di, dj in offsets:
                    ni, nj = i + di, j + dj
                    if 0 <= ni < FOREST_SIZE and 0 <= nj < FOREST_SIZE:
                        if forest[ni][nj] == '#':
                            tree_need_cut += 1
                            forest[ni] = forest[ni][:nj] + '0' + forest[ni][nj+1:]
            elif forest[i][j] in {'=', 'o'}:
                count_not_tree_fire += 1

    return count_fire, tree_need_cut, count_not_tree_fire

def main():
    forest = read_forest()

    count_fire, tree_need_cut, count_not_tree_fire = count_fires_and_trees(forest)
    
    if count_fire == 0:
        print("RELAX")
    elif count_fire + tree_need_cut + count_not_tree_fire == FOREST_SIZE ** 2 or tree_need_cut == 0:
        print("JUST RUN")
    else:
        print(tree_need_cut)

if __name__ == "__main__":
    main()