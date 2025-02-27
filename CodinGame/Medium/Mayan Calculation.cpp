#include <iostream>
#include <vector>
#include <string>
#include <cmath>

using namespace std;

int main() {
    int L, H;
    cin >> L >> H;
    cin.ignore();

    // Read the 20 Mayan numerals
    vector<vector<string>> numerals(20, vector<string>(H));
    for (int i = 0; i < H; ++i) {
        string numeralLine;
        getline(cin, numeralLine);
        for (int j = 0; j < 20; ++j) {
            numerals[j][i] = numeralLine.substr(j * L, L);
        }
    }

    // Read the first Mayan number
    int S1;
    cin >> S1;
    cin.ignore();
    int n1cif = S1 / H;
    vector<int> n1(n1cif);

    for (int i = 0; i < n1cif; ++i) {
        vector<string> num1Line(H);
        for (int j = 0; j < H; ++j) {
            getline(cin, num1Line[j]);
        }
        // Find the digit
        for (int k = 0; k < 20; ++k) {
            bool match = true;
            for (int j = 0; j < H; ++j) {
                if (num1Line[j] != numerals[k][j]) {
                    match = false;
                    break;
                }
            }
            if (match) {
                n1[i] = k;
                break;
            }
        }
    }

    // Read the second Mayan number
    int S2;
    cin >> S2;
    cin.ignore();
    int n2cif = S2 / H;
    vector<int> n2(n2cif);

    for (int i = 0; i < n2cif; ++i) {
        vector<string> num2Line(H);
        for (int j = 0; j < H; ++j) {
            getline(cin, num2Line[j]);
        }
        // Find the digit
        for (int k = 0; k < 20; ++k) {
            bool match = true;
            for (int j = 0; j < H; ++j) {
                if (num2Line[j] != numerals[k][j]) {
                    match = false;
                    break;
                }
            }
            if (match) {
                n2[i] = k;
                break;
            }
        }
    }

    // Read the operation
    char operation;
    cin >> operation;

    // Convert Mayan numbers to decimal
    long long n1des = 0;
    for (int i = 0; i < n1cif; ++i) {
        n1des += n1[i] * pow(20, n1cif - 1 - i);
    }

    long long n2des = 0;
    for (int i = 0; i < n2cif; ++i) {
        n2des += n2[i] * pow(20, n2cif - 1 - i);
    }

    // Perform the operation
    long long ResDes = 0;
    switch (operation) {
        case '+':
            ResDes = n1des + n2des;
            break;
        case '-':
            ResDes = n1des - n2des;
            break;
        case '*':
            ResDes = n1des * n2des;
            break;
        case '/':
            ResDes = n1des / n2des;
            break;
    }

    // Handle the case when the result is zero
    if (ResDes == 0) {
        for (int j = 0; j < H; ++j) {
            cout << numerals[0][j] << endl;
        }
        return 0;
    }

    // Convert the result back to Mayan representation
    vector<int> Rema;
    while (ResDes > 0) {
        int remainder = ResDes % 20;
        Rema.push_back(remainder);
        ResDes /= 20;
    }

    // Output the result
    for (int i = Rema.size() - 1; i >= 0; --i) {
        for (int j = 0; j < H; ++j) {
            cout << numerals[Rema[i]][j] << endl;
        }
    }

    return 0;
}