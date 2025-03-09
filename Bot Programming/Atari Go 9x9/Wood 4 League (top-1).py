import sys
from collections import deque

class AtariGoBot:
    def __init__(self, myColor, boardSize):
        self.myColor = myColor
        self.opponentColor = 'W' if myColor == 'B' else 'B'
        self.boardSize = boardSize
        self.board = [['.' for _ in range(boardSize)] for _ in range(boardSize)]
        self.ko_position = None

    def update_board(self, x, y, color):
        if x != -1 and y != -1:
            self.board[y][x] = color

    def is_valid_move(self, x, y):
        if self.board[y][x] != '.':
            return False
        # Check for suicidal move
        self.board[y][x] = self.myColor
        if self.count_liberties(x, y) == 0:
            self.board[y][x] = '.'
            return False
        self.board[y][x] = '.'
        return True

    def count_liberties(self, x, y):
        visited = set()
        queue = deque()
        queue.append((x, y))
        liberties = 0
        while queue:
            cx, cy = queue.popleft()
            if (cx, cy) in visited:
                continue
            visited.add((cx, cy))
            for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                nx, ny = cx + dx, cy + dy
                if 0 <= nx < self.boardSize and 0 <= ny < self.boardSize:
                    if self.board[ny][nx] == '.':
                        liberties += 1
                    elif self.board[ny][nx] == self.board[y][x] and (nx, ny) not in visited:
                        queue.append((nx, ny))
        return liberties

    def get_possible_moves(self):
        moves = []
        for y in range(self.boardSize):
            for x in range(self.boardSize):
                if self.is_valid_move(x, y):
                    moves.append((x, y))
        return moves

    def evaluate_move(self, x, y):
        # Simulate the move
        self.board[y][x] = self.myColor
        captured = self.capture_stones(x, y)
        # Evaluate the move based on captured stones, liberties, and central control
        score = len(captured) * 10  # Weight for captured stones
        # Add weight for central control
        center_x, center_y = self.boardSize // 2, self.boardSize // 2
        distance_to_center = abs(x - center_x) + abs(y - center_y)
        score += (self.boardSize - distance_to_center)  # Closer to center = higher score
        # Restore the board
        self.board[y][x] = '.'
        for cx, cy in captured:
            self.board[cy][cx] = self.opponentColor
        return score

    def capture_stones(self, x, y):
        captured = set()
        for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            nx, ny = x + dx, y + dy
            if 0 <= nx < self.boardSize and 0 <= ny < self.boardSize:
                if self.board[ny][nx] == self.opponentColor:
                    if self.count_liberties(nx, ny) == 0:
                        self.remove_group(nx, ny, captured)
        return captured

    def remove_group(self, x, y, captured):
        queue = deque()
        queue.append((x, y))
        while queue:
            cx, cy = queue.popleft()
            if (cx, cy) in captured:
                continue
            captured.add((cx, cy))
            for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                nx, ny = cx + dx, cy + dy
                if 0 <= nx < self.boardSize and 0 <= ny < self.boardSize:
                    if self.board[ny][nx] == self.opponentColor:
                        queue.append((nx, ny))

    def make_move(self):
        possible_moves = self.get_possible_moves()
        if not possible_moves:
            return "PASS"
        # Evaluate all possible moves and choose the best one
        best_move = None
        best_score = -1
        for x, y in possible_moves:
            if (x, y) == self.ko_position:
                continue
            score = self.evaluate_move(x, y)
            if score > best_score:
                best_score = score
                best_move = (x, y)
        if best_move:
            self.ko_position = None
            return f"{best_move[0]} {best_move[1]}"
        else:
            return "PASS"

def main():
    myColor = input().strip()
    boardSize = int(input().strip())
    bot = AtariGoBot(myColor, boardSize)

    while True:
        x, y = map(int, input().split())
        myScore, opponentScore = map(int, input().split())
        for i in range(boardSize):
            line = input().strip()
            for j in range(boardSize):
                bot.board[i][j] = line[j]
        bot.update_board(x, y, bot.opponentColor)
        move = bot.make_move()
        print(move)

if __name__ == "__main__":
    main()