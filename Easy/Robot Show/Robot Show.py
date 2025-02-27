def main():
    import sys
    
    L = int(sys.stdin.readline().strip())
    
    N = int(sys.stdin.readline().strip())
    
    bots = list(map(int, sys.stdin.readline().split()))
   
    max_time = max(max(pos, L - pos) for pos in bots)
    
    print(max_time)

if __name__ == "__main__":
    main()
