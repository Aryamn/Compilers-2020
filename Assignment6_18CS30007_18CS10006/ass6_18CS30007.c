#include "myl.h"

// Function to print the string of characters terminated by '\0' and returns the characters printed
int printStr(char *str) 
{
    int i=0;
    char temp[1000];
    for(;str[i] != '\0';i++) // Copy the string to the temp array and count the characteres
        temp[i] = str[i];
    
    /* inline assembly line commands for system call to print "temp" to STDOUT*/
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(temp),"d"(i)
        );

    return i; // return length
}


int readInt(int *n) 
{
    char ep[100];
    int fl = 0;
    int val = 0;
    int i = 0;
    ep[0] = 'a';
       
    // Read the input into the array ep
    __asm__ __volatile__ (
          "movl $0, %%eax \n\t"
          "movq $1, %%rdi \n\t"
          "syscall \n\t"
          :
          :"S"(ep), "d"(sizeof(ep))
    ) ;
 
    // If negative, mark flag
    if (ep[0] == '-'){
        fl = 1;
        i++;
    }
 
    // Go through the array until no newline occurs
    while(ep[i] != '\n' && ep[i] != ' ' && ep[i] != '\t')
    {
        if (( ((int)ep[i]-'0' > 9) || ((int)ep[i]-'0' < 0) ))
            return ERR;
        
        // Convert the array into integer
        val *= 10;
        val += (ep[i] - '0');
        i++;
    }
 
    if( fl) val *= -1;
    *n = val; // Point to the integer
    return OK; // Return
}



// Function to print an int to STDOUT

int printInt(int n)
{
	char temp[100];
	int i=0,fl=0;

    if(!n) temp[i++]='0'; // If the integer is 0
    
    else
    {
        if(n < 0) // If the number is negative
        {
            fl=1;
            n*=-1;
        }

        // Store the digits of the number as a reverse array
        while(n)
        {
            temp[i++] = n%10 + '0';
            n/=10;
        }
        if(fl) temp[i++]='-';
        
        // Reverse the array
        for(int j=0,k=i-1;j<k;j++,k--)
        {
            char swa = temp[j];
            temp[j] = temp[k];
            temp[k] = swa;
        }
    }

	/* inline assembly line commands for system call to print "temp" to STDOUT*/
	__asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(temp),"d"(i)
        );

    return i; // Return the number of characters printed
}
