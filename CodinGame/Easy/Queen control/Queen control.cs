using System;

class Program
{
    static void Main(string[] args)
    {
        string queenColor = Console.ReadLine().Trim();
        char[,] board = new char[8, 8];
        (int row, int col) queenPos = (-1, -1);

        for (int i = 0; i < 8; i++)
        {
            string row = Console.ReadLine().Trim();
            for (int j = 0; j < 8; j++)
            {
                board[i, j] = row[j];
                if (row[j] == 'Q')
                {
                    queenPos = (i, j);
                }
            }
        }

        int controlledSquares = CountControlledSquares(queenColor, board, queenPos);

        Console.WriteLine(controlledSquares);
    }
    
    static int CountControlledSquares(string queenColor, char[,] board, (int row, int col) queenPos)
    {
        if (queenPos.row == -1 || queenPos.col == -1)
        {
            return 0;
        }
        
        var directions = new (int dr, int dc)[]
        {
            (1, 0), (0, 1), (-1, 0), (0, -1),
            (1, 1), (1, -1), (-1, 1), (-1, -1)
        };

        int controlledSquares = 0;

        foreach (var (dr, dc) in directions)
        {
            int row = queenPos.row + dr;
            int col = queenPos.col + dc;

            while (row >= 0 && row < 8 && col >= 0 && col < 8)
            {
                char cell = board[row, col];
                if (cell == '.')
                {
                    controlledSquares++;
                }
                else if ((queenColor == "white" && cell == 'b') || (queenColor == "black" && cell == 'w'))
                {
                    controlledSquares++;
                    break;
                }
                else
                {
                    break;
                }

                row += dr;
                col += dc;
            }
        }

        return controlledSquares;
    }
}