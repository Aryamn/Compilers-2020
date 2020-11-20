/* Test File 4
  Archit Agarwal & Aryaman Jain
*/

//Complex Programm

int printStr(char *s);
int printInt(int n);
int readInt(int *x);
int main()
{
    int n;
    printStr("Enter a Number\n");
    readInt(&n);
    int ans = 1,i=1;
    for(i=1;i<=n;i++)
    {
        ans = ans*i;
    } 
    printStr("Factorial of the given number is : ");
    printInt(ans);
    printStr("\n");
}