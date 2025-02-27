def read_input():
    queen_color = input().strip()
    board = []
    queen_pos = None

    for i in range(8):
        row = input().strip()
        board.append(row)
        if 'Q' in row:
            queen_pos = (i, row.index('Q'))

    return queen_color, board, queen_pos

def count_controlled_squares(queen_color, board, queen_pos):
    if not queen_pos:
        return 0

    directions = [
        (1, 0), (0, 1), (-1, 0), (0, -1), 
        (1, 1), (1, -1), (-1, 1), (-1, -1)
    ]

    controlled_squares = 0

    for dr, dc in directions:
        row, col = queen_pos[0] + dr, queen_pos[1] + dc
        while 0 <= row < 8 and 0 <= col < 8:
            cell = board[row][col]
            if cell == '.':
                controlled_squares += 1
            elif (queen_color == "white" and cell == 'b') or (queen_color == "black" and cell == 'w'):
                controlled_squares += 1
                break  
            else:
                break  
            row += dr
            col += dc

    return controlled_squares

def main():
    queen_color, board, queen_pos = read_input()
    controlled_squares = count_controlled_squares(queen_color, board, queen_pos)
    print(controlled_squares)

if __name__ == "__main__":
    main()