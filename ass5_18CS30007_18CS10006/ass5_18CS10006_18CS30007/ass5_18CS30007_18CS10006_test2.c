/*
Test File 2
Archit Agarwal and Aryaman Jain
*/

//2D Array Testing File
//includes nested loops and recursive function 

int fib(int n)
{
	if(n<=1)
	{	
		return n;
	}
	else
	{
		return fib(n-1)+fib(n-2);
	}
	return;
}

int main()
{
    int sum[10][10];
    int i=0,j=0;

    for(i=0;i<10;i++)
    {
        for(j=0;j<10;j++)
        {
            sum[i][j] = i+j;
        }
    }

    int n;
	n = 5;
	int ans;
	ans = fib(n);

    return 0;
}