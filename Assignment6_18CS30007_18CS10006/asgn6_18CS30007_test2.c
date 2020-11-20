/* Test File 2
	Archit Agarwal & Aryaman Jain
*/

//Function Calling

int printStr(char *s);
int printInt(int n);
int readInt(int *x);

int find_sum(int a,int b)
{
    int ans = a+b;
    return ans;
}

 

int find_diff(int a,int b)
{
    int ans = a-b;
    return ans;
}

 

int main()
{
    int num1,num2,c,d;
    printStr("Input first integer\n");
    readInt(&num1);
    printStr("Input second integer\n");
    readInt(&num2);
    c = find_sum(num1,num2);
    printStr("Sum of numbers is \n");
    printInt(c);
    printStr("\n");
    d = find_diff(num1,num2);
    printStr("Difference of numbers is \n");
    printInt(d);
    printStr("\n");
    return 0;
}