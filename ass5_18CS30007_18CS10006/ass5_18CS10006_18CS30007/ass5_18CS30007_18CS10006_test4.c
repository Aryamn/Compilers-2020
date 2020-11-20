/*
Test File 4
Archit Agarwal and Aryaman Jain
*/

//Nested function calling and Conditional statements Testing File

int lesser_of(int x, int y) 
{
   int ans;
   ans = x>y ? y:x; // ternery
   return ans;
}

int greater_of(int x, int y) 
{
   int ans;
   if(x>y)  // if-else
   	ans=x;
   else
   	ans=y;
   return ans;
}

int distance(int x, int y)
{
	int i,j,dis;
	i = greater_of(x,y);	// nested function calls
	j = lesser_of(x,y);
	dis=i-j;
	return dis;
}

int main() 
{
	int a,b,dist;
	a=10;
	b=5;
	dist=difference(a,b);
	return 0;
}