using System;

class Program
{
    static int CountClumps(string number, int baseValue)
    {
        int clumps = 0;
        int? prevRemainder = null;

        foreach (char digit in number)
        {
            int remainder = (digit - '0') % baseValue;

            if (prevRemainder == null || remainder != prevRemainder)
            {
                clumps++;
                prevRemainder = remainder;
            }
        }

        return clumps;
    }

    static object FindFirstDeviation(string N)
    {
        int? previousClumps = null;

        for (int B = 2; B <= 9; B++)
        {
            int clumps = CountClumps(N, B);

            if (previousClumps != null && clumps < previousClumps)
            {
                return B;
            }

            previousClumps = clumps;
        }

        return "Normal";
    }

    static void Main()
    {
        string N = Console.ReadLine().Trim();
        Console.WriteLine(FindFirstDeviation(N));
    }
}
