using System;

class Program
{
    const int ForestSize = 6;

    static void Main(string[] args)
    {
        string[] forest = ReadForest();
        (int countFire, int treeNeedCut, int countNotTreeFire) = CountFiresAndTrees(forest);
        PrintResult(countFire, treeNeedCut, countNotTreeFire);
    }

    static string[] ReadForest()
    {
        string[] forest = new string[ForestSize];
        for (int i = 0; i < ForestSize; i++)
        {
            forest[i] = Console.ReadLine().Trim();
        }
        return forest;
    }
   
    static (int, int, int) CountFiresAndTrees(string[] forest)
    {
        int treeNeedCut = 0;
        int countFire = 0;
        int countNotTreeFire = 0;

        var offsets = new (int, int)[]
        {
            (-2, -2), (-2, -1), (-2, 0), (-2, 1), (-2, 2),
            (-1, -2), (-1, -1), (-1, 0), (-1, 1), (-1, 2),
            (0, -2), (0, -1), (0, 1), (0, 2),
            (1, -2), (1, -1), (1, 0), (1, 1), (1, 2),
            (2, -2), (2, -1), (2, 0), (2, 1), (2, 2)
        };

        for (int i = 0; i < ForestSize; i++)
        {
            for (int j = 0; j < ForestSize; j++)
            {
                if (forest[i][j] == '*')
                {
                    countFire++;
                    foreach (var (di, dj) in offsets)
                    {
                        int ni = i + di;
                        int nj = j + dj;
                        if (ni >= 0 && ni < ForestSize && nj >= 0 && nj < ForestSize)
                        {
                            if (forest[ni][nj] == '#')
                            {
                                treeNeedCut++;
                                forest[ni] = forest[ni].Remove(nj, 1).Insert(nj, "0");
                            }
                        }
                    }
                }
                else if (forest[i][j] == '=' || forest[i][j] == 'o')
                {
                    countNotTreeFire++;
                }
            }
        }

        return (countFire, treeNeedCut, countNotTreeFire);
    }
    
    static void PrintResult(int countFire, int treeNeedCut, int countNotTreeFire)
    {
        if (countFire == 0)
        {
            Console.WriteLine("RELAX");
        }
        else if (countFire + treeNeedCut + countNotTreeFire == ForestSize * ForestSize || treeNeedCut == 0)
        {
            Console.WriteLine("JUST RUN");
        }
        else
        {
            Console.WriteLine(treeNeedCut);
        }
    }
}