using System;
using System.Collections.Generic;

class Program
{
    static int SumOfDigits(int num)
    {
        int sum = 0;
        while (num > 0)
        {
            sum += num % 10;
            num /= 10;
        }
        return sum;
    }

    static bool CanVisit(int row, int col, int threshold)
    {
        return SumOfDigits(row) + SumOfDigits(col) <= threshold;
    }

    static void Main(string[] args)
    {
        int R = int.Parse(Console.ReadLine());
        int C = int.Parse(Console.ReadLine());
        int T = int.Parse(Console.ReadLine());

        bool[,] visited = new bool[R, C];
        Queue<(int, int)> queue = new Queue<(int, int)>();
        queue.Enqueue((0, 0));
        visited[0, 0] = true;
        int reachableCount = 0;

        (int, int)[] directions = { (1, 0), (-1, 0), (0, 1), (0, -1) };

        while (queue.Count > 0)
        {
            var cell = queue.Dequeue();
            int row = cell.Item1;
            int col = cell.Item2;
            reachableCount++;

            foreach (var direction in directions)
            {
                int newRow = row + direction.Item1;
                int newCol = col + direction.Item2;

                if (newRow >= 0 && newRow < R && newCol >= 0 && newCol < C && !visited[newRow, newCol] && CanVisit(newRow, newCol, T))
                {
                    visited[newRow, newCol] = true;
                    queue.Enqueue((newRow, newCol));
                }
            }
        }
        
        Console.WriteLine(reachableCount);
    }
}