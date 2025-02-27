def read_grid(n: int, l: int) -> list[list[int]]:
    grid = [[0 for _ in range(n)] for _ in range(n)]
    for x in range(n):
        line = input().split()
        for y in range(n):
            if line[y] == "C":
                grid[x][y] = l
    return grid

def dim_grid(grid: list[list[int]], n: int, l: int) -> list[list[int]]:
    for i in range(l - 1, 0, -1):
        for x in range(n):
            for y in range(n):
                max_surrounding_cell = 0
                for x_step in [-1, 0, 1]:
                    for y_step in [-1, 0, 1]:
                        if 0 <= x + x_step < n and 0 <= y + y_step < n:
                            max_surrounding_cell = max(max_surrounding_cell, grid[x + x_step][y + y_step])
                grid[x][y] = max(grid[x][y], max_surrounding_cell - 1)
    return grid

def count_dark_spots(grid: list[list[int]], n: int) -> int:
    dark_spots = 0
    for x in range(n):
        for y in range(n):
            if grid[x][y] == 0:
                dark_spots += 1
    return dark_spots

def main():
    n = int(input())
    l = int(input())
    grid = read_grid(n, l)
    grid = dim_grid(grid, n, l)
    dark_spots = count_dark_spots(grid, n)
    print(dark_spots)

if __name__ == "__main__":
    main()