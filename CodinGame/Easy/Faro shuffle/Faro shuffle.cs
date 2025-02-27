using System;

class Program
{
    static void Main()
    {
        // Read the number of shuffles
        int N = int.Parse(Console.ReadLine());
        
        // Read the cards from input
        string[] cards = Console.ReadLine().Split(' ');

        // Perform the Faro shuffle N times
        for (int shuffleCount = 0; shuffleCount < N; shuffleCount++)
        {
            // Calculate the size of the two halves
            int halfSize = (cards.Length + 1) / 2; // First half has one more if odd
            
            // Split the cards into two halves
            string[] firstHalf = new string[halfSize];
            string[] secondHalf = new string[cards.Length - halfSize];

            Array.Copy(cards, 0, firstHalf, 0, halfSize);
            Array.Copy(cards, halfSize, secondHalf, 0, cards.Length - halfSize);
            
            // Merge the two halves
            string[] shuffledDeck = new string[cards.Length];
            for (int i = 0; i < halfSize; i++)
            {
                shuffledDeck[2 * i] = firstHalf[i]; // Card from first half
                if (i < secondHalf.Length)
                {
                    shuffledDeck[2 * i + 1] = secondHalf[i]; // Card from second half
                }
            }

            // Update the cards for the next shuffle
            cards = shuffledDeck;
        }

        // Output the final shuffled deck
        Console.WriteLine(string.Join(" ", cards));
    }
}
