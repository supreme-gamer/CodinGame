def main():
    import sys

    H, W = map(int, sys.stdin.readline().split())

    grid = []
    start_x = start_y = None

    for i in range(H):
        line = sys.stdin.readline().strip()
        grid.append(list(line))
        if 'X' in line:
            start_x, start_y = i, line.index('X')

    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    max_gold = [0]

    def dfs(x, y, current_gold, visited):
        if (x < 0 or x >= H or y < 0 or y >= W or
                grid[x][y] == '#' or (x, y) in visited):
            return

        visited.add((x, y))

        if grid[x][y].isdigit():
            current_gold += int(grid[x][y])

        max_gold[0] = max(max_gold[0], current_gold)

        for dx, dy in directions:
            dfs(x + dx, y + dy, current_gold, visited)

        visited.remove((x, y))
    
    dfs(start_x, start_y, 0, set())
    
    print(max_gold[0])

if __name__ == "__main__":
    main()
