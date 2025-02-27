using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void FindOddQuadrant(int sideSize, string[] table)
    {
        int half = sideSize / 2;
        int[] quadSums = new int[4];

        for (int r = 0; r < sideSize; r++)
        {
            for (int c = 0; c < sideSize; c++)
            {
                if (table[r][c] != '.')
                {
                    int num = int.Parse(table[r][c].ToString());
                    if (r < half && c < half)
                    {
                        quadSums[0] += num;
                    }
                    else if (r < half && c >= half)
                    {
                        quadSums[1] += num;
                    }
                    else if (r >= half && c < half)
                    {
                        quadSums[2] += num;
                    }
                    else if (r >= half && c >= half)
                    {
                        quadSums[3] += num;
                    }
                }
            }
        }
        
        var count = quadSums.GroupBy(x => x).ToDictionary(g => g.Key, g => g.Count());
        int standardValue = count.OrderByDescending(x => x.Value).First().Key;
        int oddValue = quadSums.First(x => x != standardValue);
        int oddQuad = Array.IndexOf(quadSums, oddValue) + 1;
        
        Console.WriteLine($"Quad-{oddQuad} is Odd-Quad-Out");
        Console.WriteLine($"It has value of {oddValue}");
        Console.WriteLine($"Others have value of {standardValue}");
    }

    static void Main(string[] args)
    {
        int sideSize = int.Parse(Console.ReadLine().Trim());
        
        string[] table = new string[sideSize];
        for (int i = 0; i < sideSize; i++)
        {
            table[i] = Console.ReadLine().Trim();
        }
        
        FindOddQuadrant(sideSize, table);
    }
}