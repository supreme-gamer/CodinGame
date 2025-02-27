using System;

class Program
{
    static void Main(string[] args)
    {
        int w = int.Parse(Console.ReadLine().Trim());
        int h = int.Parse(Console.ReadLine().Trim());
        
        char[][] grid = new char[h][];
        for (int i = 0; i < h; i++)
        {
            grid[i] = Console.ReadLine().Trim().ToCharArray();
        }
       
        char[][] result = new char[h][];
        for (int i = 0; i < h; i++)
        {
            result[i] = new char[w];
            for (int j = 0; j < w; j++)
            {
                result[i][j] = '.';
            }
        }
        
        int[] dy = { -1, -1, -1, 0, 0, 1, 1, 1 };
        int[] dx = { -1, 0, 1, -1, 1, -1, 0, 1 };

        for (int y = 0; y < h; y++)
        {
            for (int x = 0; x < w; x++)
            {
                if (grid[y][x] == '.')
                {
                    int mineCount = 0;
                    for (int i = 0; i < 8; i++)
                    {
                        int ny = y + dy[i];
                        int nx = x + dx[i];

                        if (ny >= 0 && ny < h && nx >= 0 && nx < w && grid[ny][nx] == 'x')
                        {
                            mineCount++;
                        }
                    }
                    
                    if (mineCount > 0)
                    {
                        result[y][x] = mineCount.ToString()[0];
                    }
                }
                
                else
                {
                    result[y][x] = '.';
                }
            }
        }
        
        for (int i = 0; i < h; i++)
        {
            Console.WriteLine(new string(result[i]));
        }
    }
}