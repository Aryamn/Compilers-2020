/* Test File 5
    Archit Agarwal & Aryaman Jain
*/

//Nested Function Calling

int printStr(char *s);
int printInt(int n);
int readInt(int *x);

int max(int a, int b) 
{ 
    if(a > b)
        return a;
    return b;
} 

int func(int price[], int n) 
{ 
    int val[100]; 
    val[0] = 0; 
    int i, j; 
    int max_val = 0;   
    for (i = 1; i<=n; i++) 
    { 
        int max_val = 0;   
        for (j = 0; j < i; j++) 
            max_val = max(max_val, price[j] + val[i-j-1]); 
        val[i] = max_val; 
    } 
    return val[n]; 
} 

int main()
{
    int arr[100]; 
    int i,n,ans;
    printStr("------------Rod Cutting Problem------------\n");
    printStr("Input the size of array:\n");
    int n;
    readInt(&n);
    for(i=0;i<n;i++)
    {
        arr[i]=i+1;
    }
    ans = func(arr, n);
    printStr("The maximum value obtainable for rod cutting problem is:");
    printInt(ans);
    printStr("\n");
    return 0;
}