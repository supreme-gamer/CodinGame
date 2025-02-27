def read_grid(width: int, height: int) -> list[str]:
    return [input().strip() for _ in range(height)]

def extract_start_symbols(first_row: str) -> list[str]:
    return [char for char in first_row if char != ' ']

def follow_path(grid: list[str], start_char: str, start_index: int) -> str:
   
    current_index = start_index
    for row in grid:
        if current_index - 1 >= 0 and row[current_index - 1] == '-':
            current_index -= 3
        elif current_index + 1 < len(row) and row[current_index + 1] == '-':
            current_index += 3
    return f"{start_char}{grid[-1][current_index]}"


def main():
    width, height = map(int, input().split())
    
    grid = read_grid(width, height)
    
    start_symbols = extract_start_symbols(grid[0])
    
    for symbol in start_symbols:
        start_index = grid[0].index(symbol)
        result = follow_path(grid, symbol, start_index)
        print(result)


if __name__ == "__main__":
    main()