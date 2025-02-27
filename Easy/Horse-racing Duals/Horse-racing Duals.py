def read_input():
    n = int(input())
    array = [int(input()) for _ in range(n)]
    array.sort()
    return n, array

def find_min_diff(array):
    min_diff = float('inf') 
    for i in range(1, len(array)):
        diff = array[i] - array[i - 1]
        if diff < min_diff:
            min_diff = diff
    return min_diff

def main():
    n, array = read_input()
    min_diff = find_min_diff(array)
    print(min_diff)

if __name__ == "__main__":
    main()