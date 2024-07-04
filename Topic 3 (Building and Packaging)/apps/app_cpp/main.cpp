#include "matrix/matrix.h"
#include <iostream>

using namespace std;

int main()
{
    open_log();

    freopen("input.txt", "r", stdin);

    int n;
    cin >> n;

    matrix<double> a(n, n);
    cin >> a;
    try
    {
        cout << "Matrix Rank = " << a.getRank() << '\n';
        cout << "Matrix Trace = " << a.getTrace() << '\n';
        cout << "Matrix Determinant = " << a.getDeterminant() << '\n';
        cout << "Matrix in RREF:\n"
             << *new matrix<double>(a.getRREF());
        cout << "Matrix Transpose:\n"
             << *new matrix<double>(a.getTranspose());
        cout << "Matrix Inverse:\n"
             << *new matrix<double>(a.getInverse());
    }
    catch (error &e)
    {
        cout << e.what();
    }
    close_log();
}
