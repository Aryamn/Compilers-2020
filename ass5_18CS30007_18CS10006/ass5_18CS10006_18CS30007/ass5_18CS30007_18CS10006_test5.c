/*
Test File 5
Archit Agarwal and Aryaman Jain
*/

//Complex Code Testing File 1

// A function to print all prime factors of a given number n 

int sqrt(int a)
{
	int i;
	for(i=0;i<a;i++)
	{
		if(i*i==a)
			return i;
		else if(i*i>a)
			return i-1;
	}
	return 0;
}

void primeFactors(int n) 
{ 
    // Print the number of 2s that divide n 
    while (n % 2 == 0) { 
        n = n / 2; 
    } 
  
    // n must be odd at this point. So we can skip 
    // one element (Note i = i +2) 
    int i;
    for (i = 3; i <= sqrt(n); i = i + 2) { 
        // While i divides n, print i and divide n 
        while (n % i == 0) { 
            n = n / i; 
        } 
    } 
  
    // This condition is to handle the case when n 
    // is a prime number greater than 2 
    if (n > 2)  
    	return;
} 
  
/* Driver program to test above function */
int main() 
{ 
    int n = 315; 
    primeFactors(n); 
    return 0; 
}