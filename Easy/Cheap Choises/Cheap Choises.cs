using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        int c = int.Parse(Console.ReadLine());
        int p = int.Parse(Console.ReadLine());

        var inventory = new Dictionary<string, Dictionary<string, SortedSet<int>>>();

        for (int i = 0; i < c; i++)
        {
            string[] parts = Console.ReadLine().Split();
            string category = parts[0];
            string size = parts[1];
            int price = int.Parse(parts[2]);

            if (!inventory.ContainsKey(category))
            {
                inventory[category] = new Dictionary<string, SortedSet<int>>();
            }
            if (!inventory[category].ContainsKey(size))
            {
                inventory[category][size] = new SortedSet<int>();
            }

            inventory[category][size].Add(price);
        }

        for (int i = 0; i < p; i++)
        {
            string[] parts = Console.ReadLine().Split();
            string category = parts[0];
            string size = parts[1];

            if (inventory.ContainsKey(category) && inventory[category].ContainsKey(size) && inventory[category][size].Count > 0)
            {
                int price = inventory[category][size].Min;
                inventory[category][size].Remove(price);
                Console.WriteLine(price);
            }
            else
            {
                Console.WriteLine("NONE");
            }
        }
    }
}