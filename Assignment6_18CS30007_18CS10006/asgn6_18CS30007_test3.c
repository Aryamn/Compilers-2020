/* Test File 3
  Archit Agarwal & Aryaman Jain
*/

//Array Checking

int printStr(char *s);
int printInt(int n);
int readInt(int *x);
int main()
{
    int arr[10],i,sum=0;

 

    printStr("Sum of first 9 Natural Numbers is: ");
    for(i=0;i<10;i++)
    {
        arr[i] = i;
        sum = sum + arr[i];
    }

 

    printInt(sum);
    printStr("\n");
}