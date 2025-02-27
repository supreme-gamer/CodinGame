using System;
using System.Collections.Generic;

class Program
{
    static Dictionary<string, char> ReadPrefixCodes(int n)
    {
        var prefixCodes = new Dictionary<string, char>();
        for (int i = 0; i < n; i++)
        {
            string[] input = Console.ReadLine().Split();
            string code = input[0];
            char asciiChar = (char)int.Parse(input[1]);
            prefixCodes[code] = asciiChar;
        }
        return prefixCodes;
    }

    static string DecodeString(string encodedString, Dictionary<string, char> prefixCodes)
    {
        string decodedString = "";
        int i = 0;

        while (i < encodedString.Length)
        {
            bool found = false;

            foreach (var kvp in prefixCodes)
            {
                string code = kvp.Key;
                int codeLength = code.Length;

                if (i + codeLength <= encodedString.Length && 
                    encodedString.Substring(i, codeLength) == code)
                {
                    decodedString += kvp.Value;
                    i += codeLength;
                    found = true;
                    break;
                }
            }

            if (!found)
            {
                return $"DECODE FAIL AT INDEX {i}";
            }
        }

        return decodedString;
    }

    static void Main()
    {
        int n = int.Parse(Console.ReadLine());
        var prefixCodes = ReadPrefixCodes(n);
        string encodedString = Console.ReadLine().Trim();
        string result = DecodeString(encodedString, prefixCodes);

        Console.WriteLine(result);
    }
}