using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        int valueToReach = int.Parse(Console.ReadLine());
        int N = int.Parse(Console.ReadLine());
        
        List<int> coinCounts = Console.ReadLine()
            .Split(' ', StringSplitOptions.RemoveEmptyEntries)
            .Select(int.Parse)
            .ToList();
        
        List<int> coinValues = Console.ReadLine()
            .Split(' ', StringSplitOptions.RemoveEmptyEntries)
            .Select(int.Parse)
            .ToList();

        var coins = new List<(int Value, int Count)>();
        int totalSum = 0;

        for (int i = 0; i < N; i++)
        {
            coins.Add((coinValues[i], coinCounts[i]));
            totalSum += coinValues[i] * coinCounts[i];
        }
        
        if (totalSum < valueToReach)
        {
            Console.WriteLine(-1);
            return;
        }
        
        coins.Sort((a, b) => a.Value.CompareTo(b.Value));
        
        int currentSum = 0;
        int totalCoins = 0;

        foreach (var coin in coins)
        {
            if (currentSum >= valueToReach)
            {
                break;
            }
            
            int maxValueWithCoin = coin.Value * coin.Count;
            if (currentSum + maxValueWithCoin >= valueToReach)
            {
                int needed = (int)Math.Ceiling((double)(valueToReach - currentSum) / coin.Value);
                totalCoins += needed;
                currentSum += needed * coin.Value;
            }
            else
            {
                totalCoins += coin.Count;
                currentSum += maxValueWithCoin;
            }
        }
        
        Console.WriteLine(totalCoins);
    }
}