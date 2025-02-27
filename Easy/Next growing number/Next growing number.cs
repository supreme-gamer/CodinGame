using System;

class Program
{
    static bool IsGrowing(string num)
    {
        for (int i = 1; i < num.Length; i++)
        {
            if (num[i] < num[i - 1])
            {
                return false;
            }
        }
        return true;
    }

    static string NextGrowingNumber(string n)
    {
        if (IsGrowing(n))
        {
            n = (long.Parse(n) + 1).ToString();
        }
        else
        {
            char[] digits = n.ToCharArray();
            int i = 0;

            while (i < digits.Length - 1)
            {
                if (digits[i + 1] < digits[i])
                {
                    for (int j = i + 1; j < digits.Length; j++)
                    {
                        digits[j] = digits[i];
                    }
                    break;
                }
                i++;
            }

            n = new string(digits);
        }

        while (!IsGrowing(n))
        {
            n = (long.Parse(n) + 1).ToString();
        }

        return n;
    }

    static void Main(string[] args)
    {
        string input = Console.ReadLine();
        Console.WriteLine(NextGrowingNumber(input));
    }
}