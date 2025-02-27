def is_reachable_to_ocean(N, terrain):
    from collections import deque

    # Directions for moving: (up, down, left, right)
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    
    # Starting point (middle of the grid)
    start_x, start_y = N // 2, N // 2
    
    # Queue for BFS
    queue = deque([(start_x, start_y)])
    visited = set()
    visited.add((start_x, start_y))
    
    while queue:
        x, y = queue.popleft()
        
        # Check if we've reached the ocean (border)
        if x == 0 or x == N - 1 or y == 0 or y == N - 1:
            return "yes"
        
        # Explore neighbors
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            
            if 0 <= nx < N and 0 <= ny < N and (nx, ny) not in visited:
                # Check the elevation condition
                if abs(terrain[nx][ny] - terrain[x][y]) <= 1:
                    visited.add((nx, ny))
                    queue.append((nx, ny))
    
    return "no"

# Input reading
N = int(input().strip())
terrain = [list(map(int, input().strip().split())) for _ in range(N)]

# Output the result
print(is_reachable_to_ocean(N, terrain))
