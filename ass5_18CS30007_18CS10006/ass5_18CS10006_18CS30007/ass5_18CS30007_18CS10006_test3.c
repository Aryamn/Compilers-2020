/*
Test File 3
Archit Agarwal and Aryaman Jain
*/

//Pointer Testing File

void swap(int *a , int *b)
{
	int temp;
	temp = *a;
	*a = *b;
	*b = temp;
}

int find_greater(int a,int b)
{
	if(a<b)
	{
		return b;
	}
	else
	{	
		return a;
	}
}

int find_smaller(int a,int b)
{
	if(a<b)
	{	
		return a;
	}

	else
	{	
		return b;
	}
}

int main()
{
	int num1=5,num2=10,c,d;
	swap(&num1,&num2);
	c = find_greater(a,b);
	d = find_smaller(a,b);
	return 0;
}