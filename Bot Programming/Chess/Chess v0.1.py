import sys
import random
from copy import deepcopy

def parse_fen(fen):
    """Парсинг FEN-строки и представление доски в массиве."""
    board_part = fen.split()[0]
    rows = board_part.split("/")
    board = []
    
    for row in rows:
        expanded_row = []
        for char in row:
            if char.isdigit():
                expanded_row.extend(["."] * int(char))
            else:
                expanded_row.append(char)
        board.append(expanded_row)

    return board

def generate_moves(board, x, y, color):
    """Генерирует возможные ходы для фигуры на позиции (x, y)."""
    piece = board[y][x].lower()
    moves = []

    if piece == "p":
        direction = -1 if color == "white" else 1
        if board[y + direction][x] == ".":
        # Обычный ход пешки вперед
            if (y + direction == 0 and color == "white") or (y + direction == 7 and color == "black"):
            # Пешка достигла последней горизонтали, добавляем ходы с превращением в ферзя
                moves.append((x, y, x, y + direction, "q"))  # Превращение в ферзя
            else:
                moves.append((x, y, x, y + direction))
        # Двойной ход пешки из начальной позиции
            if (y == 6 and color == "white") or (y == 1 and color == "black"):
                if board[y + 2 * direction][x] == ".":
                    moves.append((x, y, x, y + 2 * direction))
    # Взятие фигур по диагонали
        for dx in [-1, 1]:
            nx, ny = x + dx, y + direction
            if 0 <= nx < 8 and 0 <= ny < 8:
                target = board[ny][nx]
                if target != "." and (target.islower() if color == "white" else target.isupper()):
                    if (ny == 0 and color == "white") or (ny == 7 and color == "black"):
                    # Пешка достигла последней горизонтали, добавляем ходы с превращением в ферзя
                        moves.append((x, y, nx, ny, "q"))  # Превращение в ферзя
                    else:
                        moves.append((x, y, nx, ny))
					
    elif piece == "n":
        knight_moves = [(2, 1), (2, -1), (-2, 1), (-2, -1), (1, 2), (1, -2), (-1, 2), (-1, -2)]
        for dx, dy in knight_moves:
            nx, ny = x + dx, y + dy
            if 0 <= nx < 8 and 0 <= ny < 8:
                target = board[ny][nx]
                if target == "." or (target.islower() if color == "white" else target.isupper()):
                    moves.append((x, y, nx, ny))

    elif piece == "b" or piece == "q":
        directions = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            while 0 <= nx < 8 and 0 <= ny < 8:
                target = board[ny][nx]
                if target == ".":
                    moves.append((x, y, nx, ny))
                elif target.islower() if color == "white" else target.isupper():
                    moves.append((x, y, nx, ny))
                    break
                else:
                    break
                nx += dx
                ny += dy

    if piece == "r" or piece == "q":
        directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            while 0 <= nx < 8 and 0 <= ny < 8:
                target = board[ny][nx]
                if target == ".":
                    moves.append((x, y, nx, ny))
                elif target.islower() if color == "white" else target.isupper():
                    moves.append((x, y, nx, ny))
                    break
                else:
                    break
                nx += dx
                ny += dy

    elif piece == "k":
        directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            if 0 <= nx < 8 and 0 <= ny < 8:
                target = board[ny][nx]
                if target == "." or (target.islower() if color == "white" else target.isupper()):
                    moves.append((x, y, nx, ny))

    return moves

def evaluate_capture(board, move):
    """Оценивает взятие фигуры на основе материальной стоимости."""
    x1, y1, x2, y2 = move
    captured_piece = board[y2][x2]
    piece_values = {"p": 1, "n": 3, "b": 3, "r": 5, "q": 9, "k": 1000}
    return piece_values.get(captured_piece.lower(), 0)

def is_square_attacked(board, x, y, color):
    """Проверяет, атакована ли клетка (x, y) вражескими фигурами."""
    opponent_color = "black" if color == "white" else "white"
    for ny in range(8):
        for nx in range(8):
            piece = board[ny][nx]
            if (piece.islower() if opponent_color == "black" else piece.isupper()):
                moves = generate_moves(board, nx, ny, opponent_color)
                for move in moves:
                    if move[2] == x and move[3] == y:
                        return True
    return False

def evaluate_position(board, color):
    """Оценивает позицию на доске, учитывая материальный баланс и позиционные факторы."""
    material_score = 0
    positional_score = 0

    # Материальный баланс
    piece_values = {"p": 1, "n": 3, "b": 3, "r": 5, "q": 9, "k": 1000}
    for y in range(8):
        for x in range(8):
            piece = board[y][x]
            if piece != ".":
                value = piece_values.get(piece.lower(), 0)
                if (piece.isupper() and color == "white") or (piece.islower() and color == "black"):
                    material_score += value
                else:
                    material_score -= value

    # Позиционные факторы
    # 1. Контроль центра
    center_squares = [(3, 3), (3, 4), (4, 3), (4, 4)]
    for x, y in center_squares:
        if board[y][x] != ".":
            if (board[y][x].isupper() and color == "white") or (board[y][x].islower() and color == "black"):
                positional_score += 0.1  # Бонус за контроль центра

    # 2. Безопасность короля
    king_pos = None
    for y in range(8):
        for x in range(8):
            piece = board[y][x]
            if piece.lower() == "k" and (piece.isupper() if color == "white" else piece.islower()):
                king_pos = (x, y)
                break
        if king_pos:
            break

    if king_pos:
        # Штраф за нахождение короля под шахом
        if is_in_check(board, color):
            positional_score -= 1

        # Штраф за открытые линии вокруг короля
        for dx, dy in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]:
            nx, ny = king_pos[0] + dx, king_pos[1] + dy
            if 0 <= nx < 8 and 0 <= ny < 8:
                if board[ny][nx] == ".":
                    positional_score -= 0.05  # Штраф за открытые клетки вокруг короля

    # 3. Активность фигур
    for y in range(8):
        for x in range(8):
            piece = board[y][x]
            if (piece.isupper() and color == "white") or (piece.islower() and color == "black"):
                if piece.lower() in ["n", "b", "r", "q"]:
                    # Бонус за фигуры, которые контролируют больше клеток
                    moves = generate_moves(board, x, y, color)
                    positional_score += len(moves) * 0.01

    # Итоговая оценка
    return material_score + positional_score	

def minimax(board, depth, alpha, beta, maximizing_player, color):
    """
    Алгоритм Minimax с альфа-бета отсечением.
    :param board: текущее состояние доски
    :param depth: глубина поиска (сколько ходов вперед считать)
    :param alpha: лучший ход для максимизирующего игрока
    :param beta: лучший ход для минимизирующего игрока
    :param maximizing_player: True, если это ход максимизирующего игрока (бота), False — минимизирующего (противника)
    :param color: цвет текущего игрока ("white" или "black")
    :return: лучшая оценка и лучший ход
    """
    if depth == 0 or is_checkmate(board, color):
        return evaluate_position(board, color), None

    legal_moves = []
    for y in range(8):
        for x in range(8):
            piece = board[y][x]
            if (piece.isupper() and color == "white") or (piece.islower() and color == "black"):
                legal_moves.extend(generate_moves(board, x, y, color))
    legal_moves = filter_legal_moves(board, legal_moves, color)

    if maximizing_player:
        max_eval = -float("inf")
        best_move = None
        for move in legal_moves:
            new_board = deepcopy(board)
            x1, y1, x2, y2 = move[:4]
            new_board[y2][x2] = new_board[y1][x1]
            new_board[y1][x1] = "."
            evaluation, _ = minimax(new_board, depth - 1, alpha, beta, False, "black" if color == "white" else "white")
            if evaluation > max_eval:
                max_eval = evaluation
                best_move = move
            alpha = max(alpha, evaluation)
            if beta <= alpha:
                break  # Альфа-бета отсечение
        return max_eval, best_move
    else:
        min_eval = float("inf")
        best_move = None
        for move in legal_moves:
            new_board = deepcopy(board)
            x1, y1, x2, y2 = move[:4]
            new_board[y2][x2] = new_board[y1][x1]
            new_board[y1][x1] = "."
            evaluation, _ = minimax(new_board, depth - 1, alpha, beta, True, "black" if color == "white" else "white")
            if evaluation < min_eval:
                min_eval = evaluation
                best_move = move
            beta = min(beta, evaluation)
            if beta <= alpha:
                break  # Альфа-бета отсечение
        return min_eval, best_move

def select_best_capture_or_retreat(board, legal_moves, color):
    """Выбирает ход: либо выгодное взятие, либо отступление фигуры под боем, с учетом оценки позиции."""
    best_move = None
    best_score = -float("inf")

    for move in legal_moves:
        x1, y1, x2, y2 = move
        new_board = deepcopy(board)
        captured_piece = new_board[y2][x2]
        moving_piece = new_board[y1][x1]

        # Симулируем ход
        new_board[y2][x2] = moving_piece
        new_board[y1][x1] = "."

        # Оцениваем материальный выигрыш
        piece_values = {"p": 1, "n": 3, "b": 3, "r": 5, "q": 9, "k": 1000}
        material_gain = piece_values.get(captured_piece.lower(), 0)

        # Оцениваем позицию после хода
        positional_score = evaluate_position(new_board, color)

        # Общий счет
        total_score = material_gain + positional_score

        # Выбираем ход с максимальным счетом
        if total_score > best_score:
            best_score = total_score
            best_move = move

    return best_move if best_score > -float("inf") else None
	
def is_in_check(board, color):
    """Проверяет, находится ли король под шахом."""
    king_pos = None
    for y in range(8):
        for x in range(8):
            piece = board[y][x]
            if piece.lower() == "k" and (piece.isupper() if color == "white" else piece.islower()):
                king_pos = (x, y)
                break
        if king_pos:
            break

    if not king_pos:
        return False

    return is_square_attacked(board, king_pos[0], king_pos[1], color)

def filter_legal_moves(board, moves, color):
    """Фильтрует ходы, которые открывают короля для шаха."""
    legal_moves = []
    for move in moves:
        # Создаем копию доски и симулируем ход
        new_board = deepcopy(board)
        x1, y1, x2, y2 = move
        new_board[y2][x2] = new_board[y1][x1]
        new_board[y1][x1] = "."

        # Проверяем, не находится ли король под шахом после хода
        if not is_in_check(new_board, color):
            legal_moves.append(move)
    return legal_moves

def evaluate_material_after_capture(board, move, color):
    """Оценивает материальный баланс после взятия с учетом ответного взятия."""
    x1, y1, x2, y2 = move
    new_board = deepcopy(board)
    captured_piece = new_board[y2][x2]
    moving_piece = new_board[y1][x1]

    # Симулируем взятие
    new_board[y2][x2] = moving_piece
    new_board[y1][x1] = "."

    # Оцениваем материальный выигрыш от взятия
    piece_values = {"p": 1, "n": 3, "b": 3, "r": 5, "q": 9, "k": 1000}
    material_gain = piece_values.get(captured_piece.lower(), 0)

    # Проверяем, может ли враг побить нашу фигуру в ответ
    opponent_color = "black" if color == "white" else "white"
    if is_square_attacked(new_board, x2, y2, color):
        # Если да, учитываем потерю нашей фигуры
        material_loss = piece_values.get(moving_piece.lower(), 0)
        material_gain -= material_loss

    return material_gain

def select_safe_forward_move(board, legal_moves, color):
    """Выбирает ход вперед, который не подставляет фигуру под бой."""
    for move in legal_moves:
        x1, y1, x2, y2 = move
        # Проверяем, что ход ведет вперед (для пешек и других фигур)
        if (color == "white" and y2 < y1) or (color == "black" and y2 > y1):
            # Проверяем, не станет ли фигура под бой после хода
            if not is_square_attacked(board, x2, y2, color):
                return move
    return None

def find_attacker_position(board, king_pos, color):
    """Находит позицию фигуры, которая ставит шах королю."""
    opponent_color = "black" if color == "white" else "white"
    for y in range(8):
        for x in range(8):
            piece = board[y][x]
            if (piece.islower() if opponent_color == "black" else piece.isupper()):
                moves = generate_moves(board, x, y, opponent_color)
                for move in moves:
                    if move[2] == king_pos[0] and move[3] == king_pos[1]:
                        return (x, y)
    return None

def find_blocking_moves(board, king_pos, attacker_pos, color):
    """Находит ходы, которые могут закрыть короля от шаха."""
    blocking_moves = []
    dx = attacker_pos[0] - king_pos[0]
    dy = attacker_pos[1] - king_pos[1]
    if dx == 0 or dy == 0 or abs(dx) == abs(dy):  # Ладья, ферзь или слон
        step_x = dx // max(abs(dx), 1)
        step_y = dy // max(abs(dy), 1)
        x, y = king_pos[0] + step_x, king_pos[1] + step_y
        while (x, y) != attacker_pos:
            for ny in range(8):
                for nx in range(8):
                    piece = board[ny][nx]
                    if (piece.isupper() if color == "white" else piece.islower()):
                        moves = generate_moves(board, nx, ny, color)
                        for move in moves:
                            if move[2] == x and move[3] == y:
                                blocking_moves.append(move)
            x += step_x
            y += step_y
    return blocking_moves

def handle_check(board, legal_moves, color):
    """Обрабатывает шах: пытается побить атакующую фигуру, закрыть короля или уйти."""
    king_pos = None
    for y in range(8):
        for x in range(8):
            piece = board[y][x]
            if piece.lower() == "k" and (piece.isupper() if color == "white" else piece.islower()):
                king_pos = (x, y)
                break
        if king_pos:
            break

    if not king_pos:
        return None

    # Находим фигуру, которая ставит шах
    attacker_pos = find_attacker_position(board, king_pos, color)
    if not attacker_pos:
        return None

    # 1. Пытаемся побить атакующую фигуру
    for move in legal_moves:
        if move[2] == attacker_pos[0] and move[3] == attacker_pos[1]:
            return move

    # 2. Пытаемся закрыть короля от шаха
    blocking_moves = find_blocking_moves(board, king_pos, attacker_pos, color)
    if blocking_moves:
        return random.choice(blocking_moves)

    # 3. Пытаемся увести короля из-под шаха
    king_moves = [move for move in legal_moves if board[move[1]][move[0]].lower() == "k"]
    safe_king_moves = []
    for move in king_moves:
        x1, y1, x2, y2 = move
        # Проверяем, не находится ли клетка (x2, y2) под боем
        if not is_square_attacked(board, x2, y2, color):
            safe_king_moves.append(move)
    
    if safe_king_moves:
        return random.choice(safe_king_moves)

    return None

def opening_moves(board, color, move_history):
    """Функция для реализации дебютных ходов."""
    # Определяем начальные ходы для белых и черных
    if color == "white":
        pawn_moves = [((3, 6), (3, 4)), ((4, 6), (4, 4))]  # d2-d4, e2-e4
        knight_moves = [((1, 7), (2, 5)), ((6, 7), (5, 5))]  # Nc3, Nf3
    else:
        pawn_moves = [((3, 1), (3, 3)), ((4, 1), (4, 3))]  # d7-d5, e7-e5
        knight_moves = [((1, 0), (2, 2)), ((6, 0), (5, 2))]  # Nc6, Nf6

    # Проверяем, сделаны ли уже ходы пешками
    pawn_moves_done = all((move in move_history) for move in pawn_moves)
    
    # Если ходы пешками не сделаны, возвращаем первый доступный ход пешкой
    if not pawn_moves_done:
        for move in pawn_moves:
            x1, y1 = move[0]
            x2, y2 = move[1]
            if board[y1][x1].lower() == "p" and board[y2][x2] == ".":
                return (x1, y1, x2, y2)
    
    # Если ходы пешками сделаны, проверяем, сделаны ли ходы конями
    knight_moves_done = all((move in move_history) for move in knight_moves)
    
    # Если ходы конями не сделаны, возвращаем первый доступный ход конем
    if not knight_moves_done:
        for move in knight_moves:
            x1, y1 = move[0]
            x2, y2 = move[1]
            if board[y1][x1].lower() == "n" and board[y2][x2] == ".":
                return (x1, y1, x2, y2)
    
    # Если все дебютные ходы сделаны, возвращаем None
    return None

def is_checkmate(board, color):
    """Проверяет, является ли текущая позиция матом для цвета color."""
    # Проверяем, находится ли король под шахом
    if not is_in_check(board, color):
        return False
    
    # Генерируем все возможные ходы для цвета color
    legal_moves = []
    for y in range(8):
        for x in range(8):
            piece = board[y][x]
            if (piece.isupper() and color == "white") or (piece.islower() and color == "black"):
                legal_moves.extend(generate_moves(board, x, y, color))
    
    # Фильтруем ходы, которые не оставляют короля под шахом
    legal_moves = filter_legal_moves(board, legal_moves, color)
    
    # Если нет легальных ходов, это мат
    return len(legal_moves) == 0

def find_mating_moves(board, color):
    """Ищет ходы, которые ставят мат."""
    mating_moves = []
    for y in range(8):
        for x in range(8):
            piece = board[y][x]
            if (piece.isupper() and color == "white") or (piece.islower() and color == "black"):
                moves = generate_moves(board, x, y, color)
                for move in moves:
                    # Создаем копию доски и симулируем ход
                    new_board = deepcopy(board)
                    x1, y1, x2, y2 = move[:4]
                    new_board[y2][x2] = new_board[y1][x1]
                    new_board[y1][x1] = "."
                    
                    # Проверяем, является ли новая позиция матом для противника
                    opponent_color = "black" if color == "white" else "white"
                    if is_checkmate(new_board, opponent_color):
                        mating_moves.append(move)
    
    return mating_moves

def format_move(move):
    """Преобразует ход из координат в строковый формат (например, 'e2e4')."""
    x1, y1, x2, y2 = move
    return f"{chr(ord('a') + x1)}{8 - y1}{chr(ord('a') + x2)}{8 - y2}"

def main():
    constants_count = int(sys.stdin.readline().strip())
    for _ in range(constants_count):
        sys.stdin.readline()

    print("fen moves", flush=True)

    move_history = []  # Список для хранения истории ходов

    while True:
        fen = sys.stdin.readline().strip()
        moves_count = int(sys.stdin.readline().strip())
        moves = [sys.stdin.readline().strip() for _ in range(moves_count)]
        
        board = parse_fen(fen)
        color = "white" if fen.split()[1] == "w" else "black"
        legal_moves = []

        for y in range(8):
            for x in range(8):
                piece = board[y][x]
                if (piece.isupper() and color == "white") or (piece.islower() and color == "black"):
                    legal_moves.extend(generate_moves(board, x, y, color))

        # Фильтруем ходы, которые открывают короля для шаха
        legal_moves = filter_legal_moves(board, legal_moves, color)

        # Используем Minimax для выбора лучшего хода
        depth = 1  # Глубина поиска (например, 3 хода вперед)
        _, best_move = minimax(board, depth, -float("inf"), float("inf"), True, color)

        if best_move:
            # Проверяем, есть ли превращение пешки в ферзя
            if len(best_move) == 5:  # Если ход содержит превращение
                x1, y1, x2, y2, promotion = best_move
                print(format_move((x1, y1, x2, y2)))  # Отправляем ход без превращения
                print("promote", promotion, flush=True)  # Отправляем команду на превращение
            else:
                print(format_move(best_move), flush=True)
            continue  # Переходим к следующему ходу

        # Если Minimax не нашел хода, продолжаем с текущей логикой

        # 1. Проверяем, есть ли матовые ходы
        mating_moves = find_mating_moves(board, color)
        if mating_moves:
            # Выбираем первый матовый ход
            print(format_move(mating_moves[0]), flush=True)
            continue

        # 2. Проверяем, находится ли король под шахом
        if is_in_check(board, color):
            move = handle_check(board, legal_moves, color)
            if move:
                print(format_move(move), flush=True)
            else:
                # Если король не может уйти, сдаемся
                print("resign", flush=True)
            continue

        # 3. Проверяем, есть ли дебютные ходы
        opening_move = opening_moves(board, color, move_history)
        if opening_move:
            print(format_move(opening_move), flush=True)
            move_history.append(opening_move)  # Добавляем ход в историю
            continue

        # 4. Выбираем между выгодным взятием и отступлением фигуры под боем
        best_move = select_best_capture_or_retreat(board, legal_moves, color)
        if best_move:
            # Проверяем, есть ли превращение пешки в ферзя
            if len(best_move) == 5:  # Если ход содержит превращение
                x1, y1, x2, y2, promotion = best_move
                print(format_move((x1, y1, x2, y2)))  # Отправляем ход без превращения
                print("promote", promotion, flush=True)  # Отправляем команду на превращение
            else:
                print(format_move(best_move), flush=True)
        else:
            # 5. Проверяем, есть ли безопасный ход вперед
            safe_forward_move = select_safe_forward_move(board, legal_moves, color)
            if safe_forward_move:
                # Проверяем, есть ли превращение пешки в ферзя
                if len(safe_forward_move) == 5:  # Если ход содержит превращение
                    x1, y1, x2, y2, promotion = safe_forward_move
                    print(format_move((x1, y1, x2, y2)))  # Отправляем ход без превращения
                    print("promote", promotion, flush=True)  # Отправляем команду на превращение
                else:
                    print(format_move(safe_forward_move), flush=True)
            else:
                # 6. Если ничего нет, делаем случайный ход (кроме короля)
                non_king_moves = [move for move in legal_moves if board[move[1]][move[0]].lower() != "k"]
                if non_king_moves:
                    random_move = random.choice(non_king_moves)
                    # Проверяем, есть ли превращение пешки в ферзя
                    if len(random_move) == 5:  # Если ход содержит превращение
                        x1, y1, x2, y2, promotion = random_move
                        print(format_move((x1, y1, x2, y2)))  # Отправляем ход без превращения
                        print("promote", promotion, flush=True)  # Отправляем команду на превращение
                    else:
                        print(format_move(random_move), flush=True)
                else:
                    print("resign", flush=True)

if __name__ == "__main__":
    main()